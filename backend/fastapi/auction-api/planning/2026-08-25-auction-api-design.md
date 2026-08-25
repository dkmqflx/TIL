# 실시간 경매 API — 설계 문서

> self-study 10주 커리큘럼(`../../self-study/`)에서 배운 것을 **실무 형태로 옮기는 캡스톤**.
> 10단계 가이드(`guides/step-NN-*.html`)를 순서대로 따라가면 단계마다 실제로 동작하는 기능이 하나씩 쌓인다.

작성일: 2026-08-25

---

## 1. 목표와 제약

**목표** — JSON REST + WebSocket으로 동작하는 실시간 경매 백엔드를 10단계로 완성한다. 각 단계는 (1) 커리큘럼의 특정 주차를 실무 코드로 옮기고 (2) 커리큘럼에 없던 실무 필수 요소 하나를 보탠다.

**핵심 학습 포인트** — 동시성(입찰 경합), 실시간(입찰 현황 브로드캐스트), 시간 기반 처리(경매 마감·결제 만료), 외부 연동(결제 웹훅), 그리고 그 모든 것의 테스트.

**제약**
- 위치: `til/backend/fastapi/auction-api/`. 별도 레포가 아니며 **git 작업(add/commit/tag)은 전부 사용자가 직접** 한다. Claude는 커밋하지 않는다.
- 루트 `.gitignore`가 `docs/`를 무시하므로 이 프로젝트 안에서 `docs/`라는 폴더명은 쓰지 않는다. 가이드는 `guides/`, 설계·계획은 `planning/`.
- 호스트 포트 5432·5434는 다른 프로젝트가 점유 중 → Postgres **5435**, Redis **6380**, 앱 8000, 모의 PG 8001.
- Python 3.13(설치돼 있음), `requires-python >= 3.12`.
- 프론트엔드 UI는 만들지 않는다. WebSocket 확인용 최소 정적 HTML 한 장만 둔다.
- 실제 PG·이메일 발송은 붙이지 않는다. 결제는 모의 PG 서버, 알림은 로그 출력으로 대체한다.

---

## 2. 기술 스택

| 항목 | 선택 |
|------|------|
| 패키지 관리 | uv (`pyproject.toml`, `uv.lock`) |
| 웹 | FastAPI + Uvicorn |
| DB | PostgreSQL 16 (Docker), SQLAlchemy 2.0 async + asyncpg |
| 마이그레이션 | Alembic (async env) |
| 캐시·세션·Pub/Sub·rate limit | Redis 7 (Docker), redis-py asyncio |
| 인증 | PyJWT, pwdlib[bcrypt] |
| 외부 HTTP | httpx (테스트는 respx) |
| 테스트 | pytest, pytest-asyncio, httpx AsyncClient |
| 부하 테스트 | locust |
| 린트/포맷 | ruff |
| 컨테이너·CI | Docker(멀티스테이지), docker compose, GitHub Actions |

---

## 3. 폴더 구조

```
auction-api/
├── README.md                # 프로젝트 소개 + 아키텍처 다이어그램 (10단계에서 완성)
├── pyproject.toml  uv.lock  .python-version  .env.example  .gitignore
├── docker-compose.yml       # postgres(5435) + redis(6380)
├── docker-compose.prod.yml  # 10단계: app + worker + mock_pg 포함
├── Dockerfile               # 10단계
├── alembic.ini  alembic/
├── app/
│   ├── main.py              # create_app(), lifespan, 라우터·핸들러·미들웨어 등록
│   ├── core/
│   │   ├── config.py        # pydantic-settings (Settings)
│   │   ├── db.py            # async engine, session factory, get_db
│   │   ├── redis.py         # redis client, get_redis
│   │   ├── security.py      # 해싱, JWT 생성/검증
│   │   ├── exceptions.py    # 도메인 예외 계층 + 표준 에러 핸들러
│   │   ├── logging.py       # JSON 로깅, request-id (10단계)
│   │   └── events.py        # 도메인 이벤트 발행 (7단계)
│   ├── models/              # SQLAlchemy 모델: user, auction, bid, payment
│   ├── schemas/             # Pydantic 요청/응답 모델
│   ├── repositories/        # DB 접근 (select/insert, 락)
│   ├── services/            # 비즈니스 규칙 — HTTP를 모른다
│   ├── routers/             # health, auth, users, auctions, bids, payments, webhooks
│   ├── ws/                  # ConnectionManager, Redis 구독 브리지, /ws 라우터
│   └── workers/closer.py    # 경매 활성화·마감·결제 만료 워커 (별도 프로세스)
├── mock_pg/main.py          # 모의 결제 서버 (9단계)
├── static/ws-demo.html      # WebSocket 확인용 (7단계)
├── loadtest/locustfile.py   # 10단계
├── tests/
│   ├── conftest.py          # 테스트 DB, 롤백 세션, 클라이언트, 팩토리
│   ├── factories.py
│   └── test_*.py            # 단계별
├── .github/workflows/ci.yml # 10단계 (til 루트 기준 경로 필터 + working-directory)
├── guides/                  # 10단계 HTML 가이드
│   ├── index.html
│   └── step-01-skeleton.html … step-10-deploy.html
└── planning/                # 이 문서 + 구현 계획
```

계층 규칙(self-study Week 6·02 그대로): 라우터는 요청/응답만, 서비스는 규칙만(HTTPException import 금지, 도메인 예외만 던짐), 리포지토리는 쿼리만. 예외 핸들러가 도메인 예외를 HTTP로 번역한다.

---

## 4. 도메인 모델

```
User      id(UUID) email(unique) password_hash nickname created_at
Auction   id(UUID) seller_id→User title description category(enum)
          starting_price current_price min_increment(기본 1000)
          starts_at ends_at status(enum) bid_count winner_id→User?
          version(int, 낙관적 락 비교용) created_at updated_at
Bid       id(UUID) auction_id→Auction bidder_id→User amount created_at
Payment   id(UUID) auction_id→Auction(unique) payer_id→User amount
          status(enum) external_id? expires_at paid_at? created_at
WebhookEvent  event_id(PK, PG가 준 id) received_at   ← 멱등성 기록(9단계)
```

**상태**
- `AuctionStatus`: `scheduled → active → ended | cancelled`
  - 생성 시 `starts_at`이 현재 이하면 바로 `active`, 미래면 `scheduled`(8단계 워커가 활성화)
  - `cancelled`는 입찰이 0건일 때만 판매자가 가능
- `PaymentStatus`: `pending → paid | expired`

**규칙**
1. 본인 경매에는 입찰 불가
2. `active` 상태에서만 입찰 가능
3. 입찰액 ≥ `current_price + min_increment` (첫 입찰은 `starting_price` 이상)
4. 마감 30초 이내에 입찰이 들어오면 `ends_at`을 30초 연장(스나이핑 방지, 설정값)
5. 마감 시 최고 입찰자가 낙찰자 → `Payment(pending, expires_at = +24h)` 생성. 입찰 0건이면 낙찰자 없이 `ended`
6. 결제 기한 내 미결제 시 `expired` (차순위 승계는 하지 않는다 — 비목표)

**제약(DB 수준)** — 금액 양수 CHECK, `ends_at > starts_at` CHECK, `bids(auction_id, amount desc)` 인덱스, `auctions(status, ends_at)` 인덱스, `payments.auction_id` unique.

---

## 5. API 표면 (누적)

| 단계 | 엔드포인트 |
|------|-----------|
| 1 | `GET /health` — DB·Redis ping 포함 |
| 3 | `POST /auth/signup` `POST /auth/login` `POST /auth/refresh` `POST /auth/logout` `GET /users/me` |
| 4 | `POST /auctions` `GET /auctions/{id}` `PATCH /auctions/{id}` `POST /auctions/{id}/cancel` |
| 5 | `GET /auctions?status&category&min_price&max_price&sort=ending_soon\|newest&cursor&limit` |
| 6 | `POST /auctions/{id}/bids` `GET /auctions/{id}/bids` |
| 7 | `WS /ws/auctions/{id}?token=` |
| 9 | `POST /payments/{id}/checkout` `GET /payments/{id}` `POST /webhooks/payments`; mock_pg: `POST /pg/payments` |

**표준 에러 응답** (4단계부터): `{"code": "AUCTION_NOT_FOUND", "message": "..."}`. 422는 FastAPI 기본을 유지하되 같은 껍데기로 감싼다.

**인증** — access 토큰(JWT, 15분)은 헤더 `Authorization: Bearer`, refresh 토큰(7일)은 Redis에 `refresh:{jti}` 로 저장하고 로그아웃 시 삭제. WebSocket은 query `token=`으로 access 토큰 전달.

**커서 페이지네이션** — keyset. `ending_soon`은 `(ends_at, id)`, `newest`는 `(created_at desc, id)`. 커서는 정렬 키 튜플을 base64로 인코딩한 불투명 문자열. 응답 `{"items": [...], "next_cursor": "..." | null}`.

---

## 6. 10단계 정의

각 단계는 **완료 기준**(가이드 마지막 체크리스트)이 곧 검증 명령이다. 가이드에 적힌 명령을 그대로 실행해 적힌 출력이 나와야 한다.

### 1단계 — 뼈대와 설정 (W1, W3·03, W6·02/03)
uv 프로젝트, ruff, `Settings`(pydantic-settings, `.env`), 레이어드 폴더, compose(postgres·redis), lifespan에서 engine·redis 준비/정리, `/health`.
보태는 실무 요소: `APP_ENV=dev|test|prod` 분리, `.env.example`.
완료 기준: `docker compose up -d` 후 `uv run uvicorn app.main:app` → `GET /health` = `{"status":"ok","db":true,"redis":true}`; `uv run ruff check .` 통과.

### 2단계 — 모델링 + Alembic (W5, W7·01, W10·02)
4개 모델 + enum + 제약·인덱스, async engine/session, Alembic async env, 첫 마이그레이션.
보태는 요소: **처음부터 마이그레이션**, `alembic check`로 모델-마이그레이션 정합성.
완료 기준: `uv run alembic upgrade head` 성공, `\d auctions`에 제약·인덱스 존재, `alembic check` 변경 없음.

### 3단계 — 테스트 인프라 + 인증 (W6·03, W8·01/02, W10·01)
테스트 DB(`auction_test`) 자동 생성, 테스트마다 트랜잭션 롤백 세션, `AsyncClient`, 팩토리. 회원가입·로그인·refresh·로그아웃·`/users/me`, `get_current_user` 의존성.
보태는 요소: access/refresh 분리와 Redis 기반 refresh 회전·폐기.
완료 기준: `uv run pytest tests/test_auth.py` 전부 통과(회원가입 중복 409, 잘못된 비번 401, 만료 토큰 401, 로그아웃 후 refresh 401 포함).

### 4단계 — 경매 등록·조회·수정·취소 (W2, W3, W6·01)
판매자 소유권, 상태 머신, 도메인 예외 계층(`NotFound`, `Forbidden`, `InvalidState`) + 표준 에러 핸들러. 이 단계부터 **TDD**.
완료 기준: `tests/test_auctions.py` 통과(타인 수정 403, 입찰 있는 경매 취소 409, 마감 ≤ 시작 422, 표준 에러 형태).

### 5단계 — 목록 조회 실무화 (W3·02, W5·03)
커서 페이지네이션, 필터, 정렬, `selectinload(seller)`로 N+1 제거.
보태는 요소: **쿼리 카운트 테스트**(SQLAlchemy 이벤트로 실행된 SELECT 수 세기) — 20건 조회가 2쿼리로 끝나는지 증명.
완료 기준: `tests/test_auction_list.py` 통과(커서 이어받기 중복·누락 없음, 필터 조합, 쿼리 수 ≤ 2).

### 6단계 — 입찰과 동시성 (W4, W5·03) ⭐
`SELECT … FOR UPDATE`로 경매 행을 잠그고 규칙 1~4 검증, `current_price`·`bid_count`·`version` 갱신. Redis `INCR`+TTL로 사용자당 입찰 rate limit(초당 5회).
보태는 요소: **동시성 테스트** — 50개 코루틴이 동시에 입찰, 최종 `current_price`가 최댓값이고 `bid_count`가 정확한지. 이 테스트는 롤백 세션이 아니라 실제 커밋 + 뒷정리(TRUNCATE) 방식.
가이드에서 다루는 개념: 비관적 락 vs 낙관적 락(`version`), 격리 수준, 데드락 회피(항상 경매 행만 잠금).
완료 기준: `tests/test_bids.py` 통과(규칙 위반 각각 4xx, 동시 50건 정합성, 스나이핑 연장, rate limit 429).

### 7단계 — 실시간 (W9·01/02)
`ConnectionManager`(경매별 소켓 집합), 서비스가 `events.publish(auction_id, payload)` → Redis Pub/Sub 채널 `auction:{id}` → 각 워커 프로세스의 구독 태스크가 자기 소켓에 브로드캐스트. 토큰 없는 소켓은 4401로 close.
보태는 요소: uvicorn `--workers 2`로 띄워도 다른 워커에 붙은 클라이언트에 전달되는지 확인.
완료 기준: `tests/test_ws.py` 통과(입찰 → 구독자 수신, 인증 실패 close), `static/ws-demo.html` 두 탭 동시 수신.

### 8단계 — 마감과 시간 기반 처리 (W4·01 이벤트 루프, W5·03 락) ⭐
`app/workers/closer.py`: 1초 주기 루프. `scheduled→active` 활성화, `active` 중 `ends_at ≤ now`를 `FOR UPDATE SKIP LOCKED`로 잠가 `ended` + 낙찰자 확정 + Payment 생성, 낙찰/유찰 이벤트 발행, 알림은 BackgroundTasks 대신 워커 안에서 로그. 워커 두 개를 동시에 돌려도 한 경매는 한 번만 처리.
보태는 요소: **멱등한 배치 처리**, graceful shutdown(SIGTERM).
완료 기준: `tests/test_closer.py` 통과(마감 처리, 0건 유찰, 두 워커 동시 실행 시 중복 없음), 실제 워커 프로세스 실행 로그 확인.

### 9단계 — 결제 웹훅과 외부 연동 (W7·02, W8·03) ⭐
`mock_pg/`: `POST /pg/payments` 로 결제 생성 → **BackgroundTasks**(W8·03)로 응답 후 `callback_url`에 웹훅 POST(`X-PG-Signature: HMAC-SHA256`). 앱: `POST /payments/{id}/checkout`이 httpx로 PG 호출(타임아웃 3s, 재시도 2회), `POST /webhooks/payments`가 서명 검증 + `WebhookEvent`로 멱등 처리 + `paid` 전환. 워커가 `expires_at` 지난 pending을 `expired`로.
보태는 요소: **웹훅 서명 검증과 멱등성**, respx로 외부 호출 모킹.
완료 기준: `tests/test_payments.py` 통과(서명 불일치 401, 같은 event_id 두 번 → 한 번만 처리, PG 타임아웃 시 502, 만료 처리), mock_pg 실제 연동 curl 시나리오.

### 10단계 — 성능·관측성·배포 (W4, W7·03, W9·03, W10·03)
목록 조회 Redis 캐시(TTL 5s + 경매 변경 시 무효화), locust 시나리오로 병목 확인(일부러 넣은 동기 `time.sleep` 찾아내기), request-id 미들웨어 + JSON 로깅, CORS, 멀티스테이지 Dockerfile(uv), `docker-compose.prod.yml`(app·worker·mock_pg·db·redis), GitHub Actions(ruff → pytest → `alembic check`), README 아키텍처 다이어그램과 회고.
완료 기준: `docker compose -f docker-compose.prod.yml up --build`로 전체 기동 후 end-to-end 시나리오(가입→경매→입찰→마감→결제) curl 통과, CI 워크플로 파일이 `act` 없이도 문법상 유효(로컬에서 동일 명령 통과).

---

## 7. 가이드 HTML 형식

`guides/step-NN-*.html`은 self-study 강의 자료와 같은 디자인 시스템을 쓴다(`../../self-study/assets/style.css`, `script.js` 링크). 톤은 왕초보 기준 서술형 + 비유. 사이드바에는 10단계 전체 nav를 넣고, 각 파일은 같은 순서의 섹션을 갖는다.

1. **이 단계의 목표** — 끝내면 무엇이 되는가 (한 줄) + 전제 단계
2. **왜 필요한가** — 실무 맥락
3. **비유** — 개념 하나를 일상 비유로
4. **설계 그림** — 인라인 SVG/CSS 흐름도
5. **구현** — 파일별 전체 코드. 잘라낸 스니펫이 아니라 붙여넣으면 도는 코드. 새 파일은 전체, 수정 파일은 변경 블록 + 위치 설명
6. **실행·확인** — docker/uv/curl/pytest 명령과 기대 출력
7. **완료 기준 체크리스트** — 이 명령이 이 출력을 내면 끝
8. **함정 & 실무 팁**
9. **self-study 정본 링크** — 이미 설명된 개념은 다시 쓰지 않고 `../../self-study/weekNN-…/0X-….html#id` 로 연결
10. **셀프 체크** — 면접식 질문 2~3개

`guides/index.html`은 로드맵·의존 관계·진행 체크리스트 랜딩.

---

## 8. 테스트 전략

- **격리**: `conftest.py`가 세션 시작 시 `auction_test` DB를 만들고 `alembic upgrade head`. 테스트마다 connection-level 트랜잭션을 열고 세션을 그 안에 바인딩, 종료 시 롤백. `get_db`를 override.
- **커밋이 필요한 테스트**(6단계 동시성, 8단계 워커): `@pytest.mark.commits` 마커, 실제 커밋 후 `TRUNCATE … CASCADE`로 정리.
- **Redis**: 테스트는 실제 Redis의 DB 15 사용, 테스트마다 `FLUSHDB`.
- **외부 호출**: respx로 httpx 모킹. mock_pg와의 실제 연동은 수동 curl 시나리오.
- **검증 책임**: Claude가 각 단계 코드 작성 후 `uv run pytest`와 가이드의 curl 명령을 실제로 실행해 출력을 확인한다. 통과 못 하면 그 단계는 미완료.

---

## 9. 진행 방식

1. 이 문서 승인 → `planning/plan.md`(writing-plans)에 단계별 태스크·검증 명령 작성
2. 세션당 1~2단계: 코드(TDD) → 실행 검증 → 가이드 HTML → 가이드 명령 재실행 검증 → 사용자가 커밋
3. 각 세션 시작 시 `planning/progress.md`로 현재 단계 확인(핸드오프 노트)

---

## 10. 비목표

React/Next 프론트, 실제 PG·이메일·푸시, 이미지 업로드, 차순위 낙찰 승계, 관리자 화면, 다국어, 배포 대상 클라우드 선택(컨테이너 이미지까지만).
