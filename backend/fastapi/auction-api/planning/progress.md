# 진행 상황 (핸드오프 노트)

새 세션은 이 파일 → `plan.md` → 해당 단계의 `plan-step-NN.md` 순으로 읽는다.

## 현재 상태

- **완료**: 1단계 (2026-08-25) — `guides/01-skeleton.html`, `guides/index.html`. 가이드의 코드 블록만 추출해 빈 디렉터리에서 재현 → 가이드에 적힌 출력과 전부 일치.
- **완료**: 2단계 (2026-08-25) — `guides/02-models-alembic.html`, `planning/plan-step-02.md`. solution 태그 `step-02`(4 passed, alembic check clean). replay: `git archive step-01` → 가이드 블록만 적용 → RED(2 failed) → autogenerate → upgrade → 4 passed → downgrade/upgrade 왕복 전부 일치.
- **완료**: 3단계 (2026-08-25) — `guides/03-tests-auth.html`, `planning/plan-step-03.md`. solution 태그 `step-03`(13 passed, 경고 0). replay: `git archive step-02` → 가이드 블록만 적용 → RED(`app.core.security` 없음) → 13 passed → ruff → curl 시나리오(201/409/200/401/200/401+WWW-Authenticate/200/401/204/401) → Redis 키 생성·삭제 전부 일치.
- **완료**: 4단계 (2026-08-25) — `guides/04-auction-crud.html`, `planning/plan-step-04.md`. solution 태그 `step-04`(28 passed, 경고 0). replay: `git archive step-03` → `alembic upgrade head` → 가이드 블록만 적용 → RED(`15 failed, 13 passed`, 라우트 없어 404) → 28 passed → ruff → run.sh 시나리오(201/200/PATCH 200 v1/403/401/422×2/취소 200 v2/409/404/`/nope` 404 껍데기/잘못된 UUID 422/DELETE 2) 전부 일치.
- **완료**: 5단계 (2026-08-25) — `guides/05-list-pagination.html`, `planning/plan-step-05.md`. solution 태그 `step-05`(42 passed, 경고 0). replay: `git archive step-04` → `alembic upgrade head` → 28 passed 기준선 → 가이드 블록만 적용 → RED(`14 failed, 28 passed`, GET 없어 405) → 42 passed → ruff → run.sh(시드 12건 / limit=5 세 장 5·5·2 / 커서 디코드 / 필터·newest / 422 네 가지 / echo SQL 두 문장 / DELETE 2) 전부 일치.
- **완료**: 6단계 (2026-08-25) — `guides/06-bids-concurrency.html`, `planning/plan-step-06.md`. solution 태그 `step-06`(59 passed, ruff clean). 검증: 가이드의 파일 블록 10개 ↔ solution 파일 byte 단위 일치 + `#run` curl 시나리오(422/201/403, 스나이핑 +30초, 201×3→429×5, 최종 current_price 40000·bid_count 5·version 5, DELETE 3) 실제 실행 결과가 가이드 주석과 일치. (fork가 replay 도중 두 번 stall → 마무리는 메인 세션이 수행. 원인은 100KB HTML 단일 출력으로 추정 → `step-workflow.md` "stall 방지" 참고.)
- **완료**: 7단계 (2026-08-25) — `guides/07-realtime-ws.html`, `planning/plan-step-07.md`. solution 태그 `step-07`(64 passed, 경고 0, ruff clean). replay: `git archive step-06` → `alembic upgrade head` → 59 passed 기준선 → 가이드 블록만 적용 → RED(`5 failed`, `InvalidStatus … HTTP 403`) → `5 passed` / `64 passed` → ruff → run.sh(워커 2개 · 리스너 4개가 pid 두 값으로 갈려도 전원 `bid_placed` 2건 + `[note]` 수신 · `PUBLISH`→2 · `NUMPAT`→1 · `/static/ws-demo.html` 200 · DELETE 3) 전부 일치. 가이드는 `scratchpad/gen_step07_a.py`+`gen_step07_b.py`(2파일 생성기, stall 방지)로 조립.
- **완료**: 8단계 (2026-08-26) — `guides/08-closer-worker.html`, `planning/plan-step-08.md`. solution 태그 `step-08`(71 passed, 경고 0, ruff clean). replay: `git archive step-07` → `alembic upgrade head` → 64 passed 기준선 → 가이드 블록만 적용 → RED(`ImportError: cannot import name 'closer'`) → 설정 `1.0 100 24` → `7 passed` / `71 passed` → ruff → run.sh(워커 기동 · 45초 마감 경매 입찰 2건 → 리스너 `auction_closed` · GET `ended`+winner · payments `pending` 1행 · `[notify] 낙찰!` · 5초 뒤 시작 경매 `scheduled→active` · 워커 2개+경매 40개 → 두 pid 교차, `40 1` · DELETE 3) 전부 일치(워커별 비율 21:19 는 가이드에 "매번 다르다"고 명시). 가이드는 `scratchpad/gen_step08_a.py`+`gen_step08_b.py`(2파일 생성기), replay 는 `replay08.py`.
- **완료**: 9단계 (2026-08-26) — `guides/09-payment-webhook.html`, `planning/plan-step-09.md`. solution 태그 `step-09`(87 passed, 경고 0, ruff clean, `alembic check` clean). replay: `git archive step-08` → `alembic upgrade head` → 71 passed 기준선 → 가이드 블록만 적용 → `uv add httpx`/`respx` → RED(`ImportError: cannot import name 'sign_payload'`) → 설정 `http://localhost:8001 3.0 2 http://localhost:8000` → autogenerate(rev id 는 다름, `alembic check` clean) → `16 passed` / `87 passed` → ruff → run.sh(mock_pg 200 · 45초 경매 입찰 → 낙찰 → checkout `pending`+`pg_…` → 3초 뒤 `paid` · mockpg.log `webhook paid → 200 duplicate:false` · 리스너 `auction_closed`→`payment_completed` · 같은 웹훅 재전송 `duplicate:true` · 본문 변조 401 · 서명 없음 401 · `webhook_events` 1행 · DELETE 2 / DELETE 1) 전부 일치. 가이드는 `scratchpad/gen_step09_a.py`+`gen_step09_b.py`(+`run09_blocks.py`), replay 는 `replay09.py`.
- **완료**: 10단계 (2026-08-26) — `guides/10-deploy.html`(159KB), `planning/plan-step-10.md`. solution 태그 `step-10`(97 passed, 경고 0, ruff clean, `alembic check` clean). replay: `git archive step-09` → 가이드 블록만 적용 → run.sh 전부 통과 — 캐시 hit/miss, request-id 발급/유지, locust(블로킹 sleep 켬: p50 747ms·41.8 RPS → 끔: p50 19ms·145 RPS), Docker 이미지 빌드, prod compose 5개 컨테이너 healthy, 컨테이너 e2e(경매 ended·낙찰자 → checkout → mock_pg 웹훅 200 → payment paid), 워커 SIGTERM graceful, CI 동일 명령(ruff·alembic upgrade/check·97 passed) 통과. (fork가 replay 완료 후 마무리하지 못해 메인 세션이 결과 확인·태그.) 가이드는 `scratchpad/gen_step10_a.py`+`gen_step10_b.py`, replay 는 `replay10.py`+`replay10.sh`.
- **전체 완료** — 가이드 11개(`index.html` + 01~10), 테스트 97개, 컨테이너 5개(app·worker·mock_pg·db·redis)로 e2e(가입→경매→입찰→마감→checkout→웹훅 paid) 통과. 사용자가 할 일: 가이드를 따라 `auction-api/` 안에 코드를 만들고 단계마다 커밋, `ci.yml` 은 `til/.github/workflows/auction-api-ci.yml` 로, `README.md` 회고 채우기.
  - 정리: solution 디렉터리(`~/Documents/auction-api-solution`)는 정답지로 남겨도 되고 지워도 된다. 컨테이너는 `docker compose down -v`(solution 쪽), 이미지는 `docker rmi auction-api:local`, 스크래치 replay 는 세션 종료 시 사라진다.
## 가이드 코드 블록 헤더 규약 (replay 스크립트가 의존)

- `code-filename` 첫 토큰이 **경로**(`app/models/base.py`)면 → 파일 전체로 쓴다.
- `(수정) <경로>` 로 시작하면 **그 파일 전체를 교체**(replay 드라이버가 파일로 쓴다). 예외는 `(수정) pyproject.toml — [섹션] …` — 그 섹션 헤더부터 다음 `[` 헤더 직전까지만 교체(3단계 드라이버가 일반화).
- `#run` 의 bash 블록은 드라이버가 `run.sh` 하나로 이어 붙인다(셸 변수가 블록을 넘나들므로). `uv run uvicorn …` 줄은 백그라운드 기동 + health 대기로 치환, 끝에 kill.
- `(참고) …`로 시작하면 실행/복사하지 않는 참고 블록(자동 생성 파일, 디렉터리 트리).
- `bash` 블록은 `#` 주석 줄을 제외하고 실행. `docker compose exec db …`는 replay에서 `-T` 추가.
- replay 드라이버: 세션 스크래치 `replay_step.py` (가이드 경로, 대상 루트 인자). 다음 단계 fork가 같은 방식으로 재작성해 쓰면 된다.

## 재검증 방법 (매 단계 반복)

가이드 `#impl`·`#run` 섹션의 `<pre><code>` 블록을 정규식으로 추출 → 스크래치 `replay/auction-api/`에서 순서대로 실행. 실행 전 solution 쪽 컨테이너를 `docker compose down`(이름 충돌), 끝나면 `down -v` 후 solution 쪽 다시 `up -d`.

## 검증 코드 위치

`~/Documents/auction-api-solution/` — 레포 밖. 각 단계의 정답 코드를 여기서 TDD로 만들고 가이드에 싣는다. 사용자는 `til/backend/fastapi/auction-api/`에서 가이드를 보고 직접 만든다. 두 곳이 같은 상태여야 다음 단계 가이드가 이어진다.

컨테이너: `docker compose up -d` (auction-db 5435, auction-redis 6380). compose 프로젝트명은 디렉터리명(`auction-api-solution`)을 따르므로 사용자 쪽(`auction-api`)과 컨테이너 이름이 같아 **동시에 띄우면 이름 충돌**한다 — 검증할 때는 한쪽만 띄운다.

## 10단계에서 배운 것

- `alembic/env.py` 의 `fileConfig()` 기본값 `disable_existing_loggers=True` 가 이미 만들어진 앱 로거(`app.access` 등)를 꺼 버린다 → 같은 프로세스에서 마이그레이션을 돌리는 테스트에서 caplog 가 비어 보인다. `disable_existing_loggers=False`.
- pydantic-settings 의 `list[str]` 필드는 환경변수를 JSON 으로 해석하려 한다 → `Annotated[list[str], NoDecode]` + `field_validator(mode="before")` 로 콤마 분리.
- bcrypt `hash/verify` 가 각 ~200ms 동기 호출 — 3단계부터 이벤트 루프를 막고 있었다. `asyncio.to_thread` 로 고침. 부하 테스트(locust A/B: 44.6→146 req/s, p50 790→5ms)가 찾아냄.
- 블로킹 호출이 있으면 SQLAlchemy 커서 이벤트로 잰 "느린 쿼리" 도 오탐(221ms) — 결과를 받아 처리할 차례가 안 와서. 가이드에 명시.
- request-id contextvar 는 httpx 라이브러리 자체 로그에도 붙는다(compose e2e 에서 확인). CORS 는 안쪽, request-id 미들웨어는 바깥(나중에 add).
- zsh 에서 `P="docker compose -f x.yml"; $P up` 은 단어 분리가 안 돼 "command not found" — 가이드 명령은 전부 풀어 쓴다.
- prod compose 는 `name: auction-prod` 로 개발 compose 와 분리, DB/Redis 미노출, app 만 `alembic upgrade head && exec uvicorn`, worker 는 `depends_on app healthy`. 이미지 337MB.
- setup-uv 최신 major 는 v10(2026-08 기준), actions/checkout v4 유지.

## 9단계에서 배운 것

- httpx(앱 클라이언트)와 httpx2(테스트 클라이언트)는 별개 패키지로 공존. respx 0.23 은 httpx 0.28 과 호환, ASGI 로 도는 httpx2 요청은 건드리지 않고 앱이 보내는 httpx 요청만 가로챈다. `route.call_count` 로 재시도 횟수 검증.
- 웹훅 라우터는 `data: PgWebhook` 로 받지 않는다 — `await request.body()` 원문 바이트 → `verify_signature`(compare_digest) → `model_validate_json`. 파싱 후 재직렬화로 서명하면 절대 안 맞는다.
- 멱등 장부는 DB 테이블 + `insert(...).on_conflict_do_nothing(...).returning(...)`(postgresql dialect). IntegrityError 를 잡는 방식은 트랜잭션이 깨진다. 처리 실패 시 예외 → 롤백이라 장부 기록도 같이 취소(PG 재전송 때 재검토).
- checkout 은 결제 행 `FOR UPDATE` 를 쥔 채 PG 를 부른다 → 웹훅이 먼저 와도 락이 순서를 맞춘다(트래픽 크면 두 단계 커밋으로). `external_id` 있으면 PG 재호출 없이 반환(멱등).
- pg_client 재시도는 `httpx.TransportError`·5xx 만, 4xx 는 즉시 502. 5xx 는 `httpx.HTTPStatusError(msg, request=, response=)` 로 감싸 `last` 에 보관. backoff `0.1*attempt`.
- failed 웹훅은 pending 일 때만 `external_id` 를 비운다(이미 paid 면 무시) — 첫 구현에서 paid 뒤 failed 가 external_id 를 지우는 버그를 잡음.
- ruff E501: 한글 주석 100자 초과가 대량으로 나온다 → 주석을 두 줄로. 테스트 파라미터 줄은 `from respx import MockRouter` 로 줄여 해결.
- run.sh 에서 `docker compose exec -T db psql -tA -c` 로 payment_id 를 셸 변수에 담는다(`-T` 없으면 TTY 로 `\r` 섞임). 재전송은 mockpg.log 의 `sig=`·`body=` 를 그대로 `curl -d "$BODY"` — 바이트가 같아야 서명이 맞는다.
- 리스너를 입찰 *뒤에* 붙이면 `bid_placed` 는 없고 snapshot 에 `bid_count 1` 로 보인다 — 기대 출력에 그대로 적음.

## 8단계에서 배운 것

- 시간 규칙은 `now` 인자 + Settings(`closer_interval_seconds`·`closer_batch_size`·`payment_deadline_hours`). 테스트는 `NOW` 고정, 45초를 기다리는 테스트 없음(7개 3초).
- 마감은 "후보 id(락 없음) → 한 건씩 `get_for_update(skip_locked=True)` → 잠근 뒤 재검사 → commit → publish". `SKIP LOCKED` 는 대기 회피, 정확성은 재검사, 최후 안전망은 `payments.auction_id UNIQUE`.
- 활성화·만료는 `update().where().values().returning(id)` 한 문장 + commit (UPDATE 가 스스로 잠근다).
- 워커 루프: `asyncio.wait_for(stop.wait(), timeout=interval)`(sleep 대신), `loop.add_signal_handler(SIGINT/SIGTERM, stop.set)`, 틱 실패는 `logger.exception` 만. 워커는 자기 Redis 클라이언트(`Redis.from_url`).
- 실행·확인 함정: 15초 뒤 마감 + 즉시 입찰은 스나이핑 창(30초) 안이라 45초로 연장됨 → 시나리오는 45초 마감. 두 워커 증명은 같은 설정(0.3s·batch 5) + 같은 순간 마감 40건이어야 교차가 보인다(주기가 다르면 빠른 쪽이 다 가져간다).
- ruff E501 은 한글 주석도 100자 기준 — 문서 줄을 나눈다.

## 7단계에서 배운 것

- Starlette `TestClient`(websocket_connect)는 별도 스레드·루프라 세션 루프에 묶인 DB 풀과 충돌 → WS 테스트는 **uvicorn 자식 프로세스**(`live_server` fixture) + `websockets` 클라이언트. conftest의 `os.environ` 덮어쓰기를 자식이 물려받아 테스트 DB를 본다.
- `accept()` 전에 `close()`하면 HTTP 403 핸드셰이크 거절(클라이언트는 `InvalidStatus`) → accept 뒤 `close(code=4401/4404)`.
- WS 라우트에서 `Depends(get_db)` 금지(소켓 수명 내내 커넥션 점유) → `SessionLocal()`로 짧게.
- bridge는 lifespan에서 프로세스마다 `create_task` 하나, `get_message(timeout=1.0)` 루프로 cancel 가능하게, 종료 순서 bridge cancel → redis aclose → engine dispose.
- `PUBSUB NUMPAT`은 패턴 종류 수(=1), 구독자 수는 `PUBLISH` 반환값(=워커 수)으로 본다.
- run.sh에서 백그라운드 리스너를 기다릴 땐 `wait "${L[@]}"`(pid 명시) — 맨 `wait`는 replay 드라이버가 띄운 uvicorn까지 기다려 멈춘다.
- 커밋 뒤 publish, payload는 증분이 아닌 현재 값(유실 무해화). 이벤트 type은 사건 단위(연장은 `extended` 플래그).

## 6단계에서 배운 것

- 롤백 세션 하나로는 동시성을 못 본다(커넥션 1개·트랜잭션 1개). `@pytest.mark.commits` + 세션마다 `SessionLocal()` + `asyncio.gather`, 끝나면 TRUNCATE.
- `with_for_update()`는 UPDATE와 같은 트랜잭션 안에서만 의미가 있다. 항상 경매 행 하나만 잠가 데드락을 피한다.
- rate limit 키 `bid:rl:{user_id}:{unix_second}` + `EXPIRE 2`. 초 경계에 걸치면 201이 더 나올 수 있음을 가이드에 명시.
- 시간 의존 로직은 `_now()` 제공자 + Settings로 주입해 테스트를 결정적으로.

## 5단계에서 배운 것

- 쿼리스트링은 `params: Annotated[AuctionListParams, Query()]`로 Pydantic 모델 하나에 받는다. `model_validator` 실패 시 `loc: ["query"]`, 필드 제약은 `["query","limit"]`.
- keyset 커서: `[sort, key.isoformat(), str(id)]` → JSON → base64url(패딩 제거). 정렬 기준을 커서에 넣어 다른 정렬의 커서를 422로 거부. `tuple_(key, Auction.id) > (dt, uuid)` 행 비교가 asyncpg에서 그대로 동작(`ORDER BY`도 같은 두 컬럼·같은 방향 필수). `limit+1`로 다음 페이지 유무.
- N+1 증명: `event.listen(engine.sync_engine, "before_cursor_execute", ...)`로 SELECT 수 세기. async 세션은 lazy load가 `MissingGreenlet`으로 막혀 있어 N+1 재현은 `db.expunge_all()` 후 `await db.run_sync(lambda s: a.seller.nickname)` 반복(판매자 20명 각각 → 1+20). 판매자가 겹치면 identity map이 쿼리를 아끼므로 시드는 판매자를 모두 다르게.
- `created_at`은 팩토리에서 명시값으로 덮어써야 정렬 테스트가 된다(같은 트랜잭션 안 `now()`는 전부 같은 값).
- GET이 없는 경로에 GET → 405(`METHOD_NOT_ALLOWED` 껍데기). RED 설명에 404라고 쓰면 틀린다.
- `AuctionPage(items=<ORM 객체 리스트>)`는 중첩 모델의 `from_attributes=True` 덕에 그대로 검증된다.

## 4단계에서 배운 것

- 예외 계층: `AppError` 아래 status 별 부모(`UnauthorizedError`·`ForbiddenError`·`NotFoundError`·`ConflictError`⊃`InvalidStateError`·`UnprocessableError`), 그 아래 도메인 자식(`AuctionNotFoundError`·`NotAuctionSellerError`·`AuctionHasBidsError`·`AuctionClosedError`·`InvalidPeriodError`). 새 예외는 부모만 고르면 status·껍데기 자동. 다음 단계 입찰 예외(`BidTooLowError` 등)도 여기 추가.
- 422 껍데기는 `RequestValidationError` 핸들러가 `errors`에 `loc/msg/type`만 남김(`input`·`ctx` 제거 — ctx 에 파이썬 예외 객체가 들어와 JSON 불가). 없는 라우트 404/405는 **Starlette** `HTTPException`을 등록해야 잡힌다(FastAPI 자식 클래스로 등록하면 라우터 404가 안 잡힘).
- Pydantic: naive datetime은 `field_validator`로 거부(asyncpg 가 UTC 로 간주해 9시간 오차). 필드 둘을 함께 보는 검증은 `model_validator(mode="after")`, `loc` 가 `["body"]` 로 나온다.
- 부분 수정은 `model_dump(exclude_unset=True)`. `AuctionUpdate` 에 `null` 을 보내면 NOT NULL 컬럼에 걸려 500 — 가이드 셀프 체크에 빈틈으로 명시(수정 안 함).
- `@router.post("")` + prefix 로 trailing slash 307 회피. `version` 은 update/cancel 마다 +1 (6단계 낙관적 락 재료).
- RED 가 `ModuleNotFoundError` 가 아니라 `15 failed`(404) — 테스트가 HTTP 만 두드리면 라우트 부재로 실패한다. 가이드에 그대로 적음.

## 3단계에서 배운 것

- pytest-asyncio 1.4: `asyncio_mode=auto` + `asyncio_default_fixture_loop_scope`/`asyncio_default_test_loop_scope = "session"` 필수 — 기본(테스트마다 새 루프)이면 asyncpg/redis 커넥션이 "different loop" 에러. 같은 이유로 sync `TestClient`는 쓰지 않고 httpx2 `AsyncClient(ASGITransport)`로 통일(1단계 health 테스트도 이사).
- 테스트 DB 전환은 `conftest.py` 맨 위에서 `os.environ` 교체 후 앱 import(`noqa: E402`). `Settings()` 인스턴스로 .env 를 읽어 `auction_test`/Redis 15 파생. `alembic upgrade head`는 세션 **동기** fixture에서(`env.py`가 `asyncio.run`을 쓰므로 async fixture 불가).
- 롤백 세션: `engine.connect()` + `conn.begin()` + `async_sessionmaker(bind=conn, join_transaction_mode="create_savepoint")`. 서비스의 `commit()`은 SAVEPOINT. `IntegrityError` 후 `session.rollback()`은 SAVEPOINT만 되돌림.
- PyJWT 2.10+: HS256 키 32바이트 미만이면 `InsecureKeyLengthWarning` → `.env.example`/기본값을 길게. bcrypt 72바이트 → `max_length=72`.
- `HTTPBearer(auto_error=False)` + `UnauthorizedError`로 401 통일(`WWW-Authenticate: Bearer` 헤더는 핸들러가 붙임). 로그인은 JSON 바디(`python-multipart` 불필요).
- refresh 회전은 Redis `DEL` 반환값(1/0)으로 원자적 판정. 로그아웃은 멱등.
- replay 시 dev DB 는 새 볼륨이라 `alembic upgrade head`를 step-(N-1) 상태 복원의 일부로 실행해야 한다. `docker compose exec` 는 `-T` 필요. `redis-cli keys`는 tty 아닐 때 `1) "..."` 포맷 없이 출력.

## 2단계에서 배운 것

- `alembic/` 폴더가 있으면 ruff가 `alembic` 패키지를 1st-party로 오인 → `known-third-party = ["alembic"]`, `extend-exclude = ["alembic/versions"]`.
- 믹스인 컬럼은 `sort_order`로 순서 고정(id -100, created_at 100). enum은 `native_enum=False` + `values_callable=enum_values`.
- `Bid.amount.desc()` 복합 인덱스는 클래스 밖 `Index(...)`; autogenerate가 `sa.literal_column('amount DESC')`로 정확히 잡는다.
- 스모크 테스트는 `asyncio.run` + `engine.dispose()`(루프 닫기 전 커넥션 정리) + `rollback`. 커밋 없음.
- 마이그레이션 rev id는 머신마다 다름 → 가이드는 파일을 복사시키지 않고 생성시킨다.

## 1단계에서 배운 것 (가이드·다음 단계에 반영됨)

- `uv init --bare`는 `.python-version`을 안 만든다 → `uv python pin 3.13`을 먼저.
- Starlette 1.6+ `TestClient`는 `httpx2` 필요(`httpx`면 DeprecationWarning). 3단계 AsyncClient/9단계 respx 호환은 그때 확인.
- 모듈 수준 `create_async_engine`/`Redis.from_url`은 lazy라 안전. lifespan은 정리만.
- 검증된 버전: fastapi 0.141.1 · starlette 1.6.0 · sqlalchemy 2.0.52 · asyncpg 0.31.0 · redis 8.1.0 · pydantic-settings 2.15.0 · uvicorn 0.52.4 · httpx2 2.12.0 · pytest 9.1.1 · ruff 0.16.4

## 단계 체크

- [x] 01 뼈대와 설정
- [x] 02 모델링 + Alembic
- [x] 03 테스트 인프라 + 인증
- [x] 04 경매 CRUD
- [x] 05 목록·페이지네이션
- [x] 06 입찰과 동시성
- [x] 07 실시간
- [x] 08 마감 워커
- [x] 09 결제 웹훅
- [x] 10 성능·관측성·배포
