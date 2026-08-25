# 단계 작업 공통 지침 (2~10단계 fork용)

한 단계(N)를 맡은 작업자는 이 문서를 그대로 따른다. 입력: `2026-08-25-auction-api-design.md` 6절의 N단계, `plan.md`의 N행, `progress.md`, 직전 가이드 `guides/(N-1)-*.html`(마크업 관례의 기준).

## 절대 규칙

- `til` 레포에서 **git 명령 금지**(add/commit/tag/stash 전부). 커밋은 사용자가 한다.
- 검증 코드는 `~/Documents/auction-api-solution/`(레포 밖). 이 디렉터리는 **자체 git 저장소**로 관리한다 — 단계가 끝나면 `git add -A && git commit -m "step-NN: ..." && git tag step-NN`. (여기 git은 작업 도구이며 사용자 레포와 무관하다.)
- 레포 안에 `app/` 코드를 넣지 않는다. 산출물은 `guides/NN-*.html`, `planning/plan-step-NN.md`, `progress.md` 갱신뿐.
- 폴더명 `docs/` 금지. 포트 Postgres 5435 · Redis 6380 · 앱 8000 · 모의 PG 8001. Python 3.13. TestClient는 `httpx2`, 앱의 외부 HTTP는 `httpx`(respx로 모킹).
- 시간 의존 로직(스나이핑 창, 결제 기한, 워커 주기)은 **Settings 값으로 주입**해 테스트에서 짧게 줄일 수 있게 한다.

## 멈춤(stall) 방지 — 6단계에서 fork가 두 번 죽은 뒤 추가

- **큰 HTML을 한 번에 출력하지 않는다.** 가이드는 solution 파일을 읽어 **생성 스크립트**(`scratchpad/gen_stepNN.py`)로 조립한다: 섹션별 문자열을 파이썬에서 합치고 코드 블록은 파일에서 읽어 `html.escape`. 직접 Write로 쓰더라도 20KB 이하 조각으로 나눠 append.
- **오래 걸리거나 멈출 수 있는 명령은 전부 `timeout N`** 으로 감싼다: `timeout 300 uv run pytest -q`, `timeout 120 bash run.sh`, `timeout 180 uv sync`. uvicorn·워커는 `nohup … &`로 띄우고 curl 뒤 `kill`.
- 여러 블록을 이어 실행할 때는 블록 사이에 개행을 넣는다(블록 끝에 개행이 없어 `}echo …`로 붙는 사고가 있었다).
- 한 번의 Bash 호출은 5분 이내로 끝나게 쪼갠다.

## 작업 순서

1. **계획** — `planning/plan-step-NN.md`. 파일 구조, 인터페이스(함수 시그니처), 태스크별 "실패 테스트 → 구현 → 검증 명령". 코드 전문은 가이드에 실으므로 계획엔 핵심 코드/시그니처와 검증 명령만.
2. **코드(TDD)** — solution 디렉터리에서 실패 테스트를 먼저 쓰고 구현. `uv run pytest -q`와 `uv run ruff check .`, `uv run ruff format --check .` 통과. 스펙의 완료 기준에 있는 curl/수동 시나리오도 실제로 실행해 **출력을 그대로 캡처**한다(가이드에 싣는다).
3. **가이드** — `guides/NN-<slug>.html`. `01-skeleton.html`의 head·사이드바·섹션 마크업을 그대로 복사해 쓴다.
   - 섹션 순서·id 고정: `#goal #why #analogy #design #impl #run #done #pitfalls #refs #self-check`. 사이드바의 현재 단계 그룹은 이 앵커들.
   - 사이드바: 현재 단계는 `<div class="nav-week active">`, N 이하 단계는 활성 링크, N 초과는 `aria-disabled="true"` + `예정` 배지.
   - **생성·수정되는 모든 파일은 전문**을 싣는다. 수정 파일은 헤더에 `(수정)`을 붙이고 바로 위 `callout-tip`에 "무엇이 바뀌었는지" 2~3문장. 코드 헤더는 `<span class="code-lang">python</span><span class="code-filename">app/core/db.py</span>` 형식 — `code-filename`의 **첫 토큰이 정확한 상대 경로**여야 재검증 스크립트가 파일로 쓸 수 있다. 명령 블록은 `code-filename`을 `bash`/`터미널 1`처럼 경로가 아닌 값으로.
   - 명령 블록에는 기대 출력을 `# ` 주석으로 붙인다(실제 캡처한 것만).
   - 톤: 왕초보 서술형 + 비유. 인라인 SVG 설계 그림 1~2개(직전 가이드의 색 변수 사용). self-study 정본이 있는 개념은 설명 대신 링크(앵커 id가 실제 존재하는지 grep으로 확인). 코드 한 줄 100자 이내.
   - `#done`은 체크박스 목록 + "여기까지 됐으면 커밋하세요" 안내.
4. **재검증(replay)** — 가이드만으로 재현되는지 확인한다.
   - solution 저장소에서 `git archive step-(N-1) | tar -x -C <scratch>/replay/auction-api` 로 직전 상태를 꺼내고 `.env`를 복사, `uv sync`.
   - solution 쪽 `docker compose down`(컨테이너 이름 충돌 방지) → replay 쪽 `docker compose up -d`.
   - 가이드 `#impl`·`#run`의 `<pre><code>` 블록을 정규식으로 추출(1단계 때 쓴 방식: 헤더의 `code-filename` 첫 토큰이 경로면 파일로 쓰고, 아니면 명령으로 실행). uvicorn·워커는 백그라운드로 띄우고 curl 후 종료.
   - pytest·ruff·curl 출력이 가이드에 적힌 것과 일치해야 한다. 불일치 → 가이드 수정 후 다시.
   - 끝나면 replay `docker compose down -v` → solution `docker compose up -d`.
5. **사이드바 동기화** — `guides/index.html`과 `01`~`(N-1)` 가이드에서 `NN-*.html` 링크의 `aria-disabled`·`예정` 배지를 제거. `index.html`의 N번 카드에서 `pending` 클래스 제거.
6. **핸드오프** — `progress.md`: N 완료 체크, "배운 것/함정" 갱신, 다음 단계 시작 조건. solution 저장소 커밋 + 태그 `step-NN`.
7. **보고** — 파일 목록·크기, 통과한 테스트 수, 재검증 결과, 스펙과 달라진 점을 짧게.

## 단계별 힌트

- **02**: `uv add alembic`. `alembic init -t async alembic`. `env.py`는 `app.core.config.get_settings().database_url`과 `Base.metadata`. `alembic check`는 모델-마이그레이션 정합성 확인. UUID PK는 `uuid.uuid4` 기본값, `DateTime(timezone=True)`. Enum은 Python `enum.StrEnum` + SQLAlchemy `Enum(..., native_enum=False)` 또는 native — 하나로 정하고 이유를 가이드에.
- **03**: `uv add pyjwt "pwdlib[bcrypt]"`, `uv add --dev pytest-asyncio`. 테스트 DB `auction_test`: 세션 fixture가 없으면 `CREATE DATABASE`, `alembic upgrade head`. 롤백 세션: connection + `begin()` + `async_sessionmaker(bind=conn, join_transaction_mode="create_savepoint")`. `app.dependency_overrides[get_db]`. 로그인은 JSON 바디(`python-multipart` 불필요). refresh는 `refresh:{jti}` 키, 회전 시 옛 키 삭제.
- **04**: 도메인 예외 `app/core/exceptions.py`(`AppError(code, status)` 계층) + `@app.exception_handler`. 서비스는 `HTTPException` import 금지. 상태 전이는 서비스에 한 곳.
- **05**: 커서 = `base64(json([sort_key, id]))`. `selectinload(Auction.seller)`. 쿼리 카운트: `event.listen(engine.sync_engine, "before_cursor_execute", ...)` fixture.
- **06**: `select(Auction).where(...).with_for_update()`. 동시성 테스트는 `@pytest.mark.commits` — 실제 커밋, 세션 여러 개, `asyncio.gather`, 끝나면 TRUNCATE. rate limit은 Redis `INCR` + `EXPIRE`.
- **07**: 이벤트 발행은 서비스에서 `events.publish(...)` (Redis `PUBLISH auction:{id}`). 앱 프로세스마다 lifespan에서 구독 태스크 1개. WebSocket 테스트는 TestClient `websocket_connect`.
- **08**: `python -m app.workers.closer`. 루프 주기 `Settings.closer_interval_seconds`. `FOR UPDATE SKIP LOCKED`. 두 워커 동시 실행 테스트는 두 코루틴이 같은 틱을 동시에 처리해도 중복 없음.
- **09**: `mock_pg/main.py`는 별도 FastAPI 앱(8001). 서명 `hmac.new(secret, body, sha256).hexdigest()`, 헤더 `X-PG-Signature`. 멱등은 `webhook_events` 테이블 PK 충돌로. `uv add httpx`, `uv add --dev respx`.
- **10**: 캐시 키에 쿼리 파라미터 정규화. 무효화는 `auction:list:version` 키 증가. Dockerfile은 `ghcr.io/astral-sh/uv` 멀티스테이지. CI는 til 루트 기준 `paths: backend/fastapi/auction-api/**`, `defaults.run.working-directory`.
