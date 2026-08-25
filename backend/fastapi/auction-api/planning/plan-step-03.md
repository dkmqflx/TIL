# 3단계 — 테스트 인프라 + 인증: 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 테스트마다 롤백되는 격리된 테스트 DB 위에서, 회원가입·로그인(JWT access/refresh)·refresh 회전·로그아웃·`/users/me`가 동작하고 `tests/test_auth.py`가 전부 통과하는 상태를 만든다. 그 과정을 `guides/03-tests-auth.html`로 만든다.

**Architecture:** `tests/conftest.py`가 앱을 import하기 전에 환경변수(`DATABASE_URL`→`auction_test`, `REDIS_URL`→DB 15)를 바꿔 앱 전체가 테스트 인프라를 보게 한다. 세션당 한 번 DB 생성 + `alembic upgrade head`, 테스트마다 커넥션 트랜잭션 + SAVEPOINT 세션(`join_transaction_mode="create_savepoint"`), `get_db` override, httpx2 `AsyncClient(ASGITransport)`. 인증은 `security.py`(순수 계산) → `services/auth.py`(규칙, 도메인 예외만) → `routers/auth.py`(HTTP). refresh 토큰은 `jti`를 키로 Redis에 TTL 저장, 사용 시 `DEL`(원자적)로 회전.

**Tech Stack:** pytest-asyncio 1.4 (session loop scope), httpx2, PyJWT, pwdlib[bcrypt], pydantic[email]

**Spec:** `planning/2026-08-25-auction-api-design.md` §5 인증, §6 3단계, §8 테스트 전략

## Global Constraints

- solution: `~/Documents/auction-api-solution/` (태그 `step-02` → `step-03`). til 레포 git 금지.
- 포트 5435/6380. Python 3.13. TestClient 대신 httpx2 `AsyncClient`로 통일(세션 루프 하나).

---

## 파일 구조

```
(수정) pyproject.toml          [tool.pytest.ini_options] asyncio_mode/loop scope
(수정) .env.example / .env     JWT_SECRET
(수정) app/core/config.py      jwt_secret, access_token_minutes, refresh_token_days
tests/conftest.py              env 바꿔치기, DB 생성+마이그레이션, db_session, redis, client
tests/factories.py             create_user, login_headers
tests/test_auth.py             9개 테스트
app/core/exceptions.py         AppError, UnauthorizedError, EmailAlreadyExistsError, 핸들러
app/core/security.py           hash/verify, create_token/access/refresh, decode_token, TokenError
app/schemas/user.py            UserRead
app/schemas/auth.py            SignupRequest, LoginRequest, RefreshRequest, TokenPair
app/repositories/user.py       get_by_email, get_by_id, create
app/services/auth.py           signup, login, refresh, logout
app/core/deps.py               DbSession, RedisClient, get_current_user, CurrentUser
app/routers/auth.py            /auth/signup·login·refresh·logout
app/routers/users.py           /users/me
(수정) app/main.py             핸들러 등록, 라우터 3개
(수정) tests/test_health.py    AsyncClient 로 전환
(수정) tests/test_models.py    db_session fixture 로 전환
```

## Interfaces

- `create_token(subject: str, token_type: "access"|"refresh", expires_delta: timedelta) -> tuple[str, str]` (token, jti)
- `create_access_token(user_id: UUID) -> str`, `create_refresh_token(user_id) -> tuple[str, str, int]` (token, jti, ttl초)
- `decode_token(token, expected_type) -> dict` / raises `TokenError`
- `services.auth.signup(db, SignupRequest) -> User`, `login(db, redis, LoginRequest) -> TokenPair`, `refresh(redis, str) -> TokenPair`, `logout(redis, str) -> None`
- `deps.CurrentUser = Annotated[User, Depends(get_current_user)]`, `DbSession`, `RedisClient`
- 표준 에러: `{"code": "...", "message": "..."}`; 401엔 `WWW-Authenticate: Bearer`

---

### Task 1: 의존성 + 설정
- [ ] `uv add pyjwt "pwdlib[bcrypt]" "pydantic[email]"`, `uv add --dev pytest-asyncio`
- [ ] pyproject `[tool.pytest.ini_options]`에 `asyncio_mode="auto"`, `asyncio_default_fixture_loop_scope="session"`, `asyncio_default_test_loop_scope="session"`
- [ ] `.env.example`에 `JWT_SECRET=`(32바이트 이상 — PyJWT `InsecureKeyLengthWarning` 회피), `Settings`에 세 필드
- [ ] 검증: `uv run python -c "from app.core.config import get_settings; print(get_settings().access_token_minutes)"` → `15`

### Task 2: 테스트 인프라 + 실패 테스트
- [ ] `tests/conftest.py`, `tests/factories.py`, `tests/test_auth.py` 작성
- [ ] 검증(RED): `uv run pytest -q` → `ModuleNotFoundError: No module named 'app.core.security'`, `1 error`

### Task 3: 인증 구현
- [ ] exceptions → security → schemas → repository → service → deps → routers → main 순으로 작성
- [ ] `tests/test_health.py`·`tests/test_models.py`를 새 fixture로 전환
- [ ] 검증(GREEN): `uv run pytest -q` → `13 passed`, 경고 0; `uv run ruff check .` / `ruff format --check .` 통과

### Task 4: 수동 시나리오
- [ ] uvicorn 띄우고 curl: signup 201 → 중복 409 → login 200 → 틀린 비번 401 → me 200 → 토큰 없이 401(+`WWW-Authenticate`) → refresh 200 → 옛 refresh 401 → logout 204 → refresh 401. Redis `keys 'refresh:*'` 로 저장·삭제 확인.
- [ ] solution 커밋 + 태그 `step-03`

### Task 5: 가이드 + 재검증 + 동기화
- [ ] `guides/03-tests-auth.html` (02 템플릿, 섹션 id 고정, 전체 파일 블록)
- [ ] replay: `git archive step-02` → 가이드 블록만 적용 → 출력 일치
- [ ] 사이드바 동기화(index, 01, 02), `progress.md` 갱신
