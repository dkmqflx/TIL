# 1단계 — 뼈대와 설정: 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** uv 프로젝트 + 레이어드 폴더 + 환경별 Settings + Docker(Postgres 5435, Redis 6380) + lifespan + `GET /health`가 DB·Redis 연결을 실제로 확인하는 출발점을 만들고, 그 과정을 `guides/01-skeleton.html`로 만든다.

**Architecture:** 모듈 수준에서 async engine과 Redis 클라이언트를 만들고(둘 다 첫 사용 전까지 연결하지 않는 lazy 객체), lifespan에서 정리한다. `/health`는 `SELECT 1`과 `PING`을 직접 날려 부분 장애를 `503 + {"status":"degraded"}`로 드러낸다.

**Tech Stack:** uv, FastAPI, uvicorn, SQLAlchemy[asyncio], asyncpg, redis, pydantic-settings, ruff, pytest, httpx(TestClient용)

**Spec:** `planning/2026-08-25-auction-api-design.md` 6절 1단계

## Global Constraints

- 작업 위치: `~/Documents/auction-api-solution/` (검증용). 가이드는 `til/backend/fastapi/auction-api/guides/`.
- git 커밋 금지. 포트 5435/6380/8000. Python 3.13.

---

## 파일 구조

```
auction-api-solution/
├── .python-version          3.13
├── pyproject.toml           의존성 + ruff 설정
├── .gitignore
├── .env.example  .env
├── docker-compose.yml       db(5435) + redis(6380)
├── app/__init__.py
├── app/main.py              create_app(), lifespan
├── app/core/__init__.py
├── app/core/config.py       Settings, get_settings()
├── app/core/db.py           engine, SessionLocal, get_db()
├── app/core/redis.py        redis_client, get_redis()
├── app/routers/__init__.py
├── app/routers/health.py    GET /health
├── app/{models,schemas,repositories,services,ws,workers}/__init__.py   (빈 자리)
└── tests/__init__.py, tests/test_health.py
```

---

### Task 1: 프로젝트 초기화

**Files:** Create `.python-version`, `pyproject.toml`, `.gitignore`, 패키지 폴더

- [ ] **Step 1: uv 프로젝트 생성과 의존성 설치**

```bash
mkdir -p ~/Documents/auction-api-solution && cd ~/Documents/auction-api-solution
uv python pin 3.13      # 먼저! --bare 는 .python-version 을 만들지 않아 3.14 venv 가 잡힌다
uv init --bare
uv add fastapi "uvicorn[standard]" "sqlalchemy[asyncio]" asyncpg redis pydantic-settings
uv add --dev ruff pytest httpx2   # Starlette 1.6+ TestClient 는 httpx 대신 httpx2 (httpx 면 Deprecation 경고)
```

검증에서 확인된 버전: fastapi 0.141.1 · starlette 1.6.0 · sqlalchemy 2.0.52 · asyncpg 0.31.0 · redis 8.1.0 · pydantic-settings 2.15.0 · uvicorn 0.52.4 · httpx2 2.12.0 · pytest 9.1.1 · ruff 0.16.4

- [ ] **Step 2: pyproject.toml에 ruff·pytest 설정 추가**

```toml
[tool.ruff]
target-version = "py313"
line-length = 100

[tool.ruff.lint]
select = ["E", "F", "I", "UP", "B"]

[tool.pytest.ini_options]
testpaths = ["tests"]
```

- [ ] **Step 3: .gitignore**

```
.venv/
__pycache__/
*.pyc
.env
.pytest_cache/
.ruff_cache/
```

- [ ] **Step 4: 패키지 폴더**

```bash
mkdir -p app/core app/routers app/models app/schemas app/repositories app/services app/ws app/workers tests
touch app/__init__.py app/core/__init__.py app/routers/__init__.py app/models/__init__.py \
      app/schemas/__init__.py app/repositories/__init__.py app/services/__init__.py \
      app/ws/__init__.py app/workers/__init__.py tests/__init__.py
```

- [ ] **Step 5: 검증** — `uv run ruff check .` → `All checks passed!`

---

### Task 2: Docker compose + 환경 파일

**Files:** Create `docker-compose.yml`, `.env.example`, `.env`

- [ ] **Step 1: docker-compose.yml**

```yaml
services:
  db:
    image: postgres:16-alpine
    container_name: auction-db
    environment:
      POSTGRES_USER: auction
      POSTGRES_PASSWORD: auction_pw
      POSTGRES_DB: auction
    ports:
      - "5435:5432"
    volumes:
      - auction-pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U auction -d auction"]
      interval: 5s
      timeout: 3s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: auction-redis
    ports:
      - "6380:6379"
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 5

volumes:
  auction-pgdata:
```

- [ ] **Step 2: .env.example (그대로 복사해 .env)**

```
APP_ENV=dev
DATABASE_URL=postgresql+asyncpg://auction:auction_pw@localhost:5435/auction
REDIS_URL=redis://localhost:6380/0
DEBUG=true
```

- [ ] **Step 3: 검증** — `docker compose up -d && sleep 6 && docker compose ps` → 두 서비스 `healthy`

---

### Task 3: Settings

**Files:** Create `app/core/config.py`

**Interfaces:** Produces `get_settings() -> Settings` (`app_env`, `database_url`, `redis_url`, `debug`)

- [ ] **Step 1: 구현**

```python
from functools import lru_cache
from typing import Literal

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    app_env: Literal["dev", "test", "prod"] = "dev"
    database_url: str = "postgresql+asyncpg://auction:auction_pw@localhost:5435/auction"
    redis_url: str = "redis://localhost:6380/0"
    debug: bool = False


@lru_cache
def get_settings() -> Settings:
    return Settings()
```

- [ ] **Step 2: 검증** — `uv run python -c "from app.core.config import get_settings; print(get_settings().model_dump())"` → `.env` 값이 찍힘. `APP_ENV=prod uv run python -c ...` → `app_env='prod'` (환경변수가 .env보다 우선)

---

### Task 4: DB·Redis 연결 + /health (TDD)

**Files:** Create `app/core/db.py`, `app/core/redis.py`, `app/routers/health.py`, `app/main.py`, `tests/test_health.py`

**Interfaces:** Produces `get_db() -> AsyncIterator[AsyncSession]`, `get_redis() -> Redis`, `engine`, `redis_client`, `app`

- [ ] **Step 1: 실패하는 테스트**

```python
from fastapi.testclient import TestClient

from app.main import app


def test_health_reports_db_and_redis():
    with TestClient(app) as client:
        res = client.get("/health")
    assert res.status_code == 200
    assert res.json() == {"status": "ok", "db": True, "redis": True}
```

- [ ] **Step 2: 실패 확인** — `uv run pytest -q` → `ModuleNotFoundError: No module named 'app.main'`

- [ ] **Step 3: app/core/db.py**

```python
from collections.abc import AsyncIterator

from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine

from app.core.config import get_settings

engine = create_async_engine(get_settings().database_url, pool_pre_ping=True)
SessionLocal = async_sessionmaker(engine, expire_on_commit=False)


async def get_db() -> AsyncIterator[AsyncSession]:
    async with SessionLocal() as session:
        yield session
```

- [ ] **Step 4: app/core/redis.py**

```python
from redis.asyncio import Redis

from app.core.config import get_settings

redis_client: Redis = Redis.from_url(get_settings().redis_url, decode_responses=True)


def get_redis() -> Redis:
    return redis_client
```

- [ ] **Step 5: app/routers/health.py**

```python
from typing import Annotated

from fastapi import APIRouter, Depends, Response, status
from redis.asyncio import Redis
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_db
from app.core.redis import get_redis

router = APIRouter(tags=["health"])


@router.get("/health")
async def health(
    response: Response,
    db: Annotated[AsyncSession, Depends(get_db)],
    redis: Annotated[Redis, Depends(get_redis)],
) -> dict[str, str | bool]:
    db_ok = False
    redis_ok = False
    try:
        await db.execute(text("SELECT 1"))
        db_ok = True
    except Exception:
        pass
    try:
        redis_ok = bool(await redis.ping())
    except Exception:
        pass

    ok = db_ok and redis_ok
    if not ok:
        response.status_code = status.HTTP_503_SERVICE_UNAVAILABLE
    return {"status": "ok" if ok else "degraded", "db": db_ok, "redis": redis_ok}
```

- [ ] **Step 6: app/main.py**

```python
from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

from fastapi import FastAPI

from app.core.config import get_settings
from app.core.db import engine
from app.core.redis import redis_client
from app.routers import health


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    yield
    await redis_client.aclose()
    await engine.dispose()


def create_app() -> FastAPI:
    settings = get_settings()
    app = FastAPI(title="Auction API", debug=settings.debug, lifespan=lifespan)
    app.include_router(health.router)
    return app


app = create_app()
```

- [ ] **Step 7: 통과 확인** — `uv run pytest -q` → `1 passed`; `uv run ruff check .` → 통과

- [ ] **Step 8: 수동 확인**

```bash
uv run uvicorn app.main:app --reload            # 별도 터미널
curl -s localhost:8000/health                    # {"status":"ok","db":true,"redis":true}
docker compose stop redis && curl -i -s localhost:8000/health   # 503, "redis":false
docker compose start redis
```

---

### Task 5: 가이드 작성 `guides/01-skeleton.html` + `guides/index.html`

**Files:** Create `til/backend/fastapi/auction-api/guides/01-skeleton.html`, `guides/index.html`

- [ ] **Step 1: 템플릿 확인** — `self-study/week06-json-api-structure/02-dependency-injection-mvc.html`의 head·sidebar·section 구조를 그대로 쓰되, 사이드바 nav는 10단계 전체(`index.html`, `01-skeleton.html` … `10-deploy.html`). css/js는 `../../self-study/assets/`.
- [ ] **Step 2: 섹션** — 스펙 7절 순서: 목표 → 왜 필요한가 → 비유 → 설계 그림(SVG: 클라이언트→FastAPI→(Postgres 5435, Redis 6380), lifespan 타임라인) → 구현(Task 1~4의 파일별 전체 코드, 순서대로) → 실행·확인(Task 4 Step 8의 명령과 출력) → 완료 기준 체크리스트 → 함정 & 팁(포트 충돌, `.env` 커밋 금지, engine은 lazy, 헬스체크 503 의미, `extra="ignore"`) → 정본 링크(W6·02 `#yield-dependency` `#annotated`, W7·01 lifespan, W5·01 docker) → 셀프 체크 3문항.
- [ ] **Step 3: index.html** — 로드맵 10단계 카드(`.card-grid`), 의존 관계 흐름, 진행 체크리스트, 사전 준비(uv, docker, python 3.13).
- [ ] **Step 4: 링크 검증** — 사이드바 href와 `../../self-study/...#id` 앵커가 실제 존재하는지 스크립트로 확인.

---

### Task 6: 가이드 재검증 + 핸드오프

- [ ] **Step 1: 빈 디렉터리에서 가이드만 보고 재현** — `~/Documents/auction-api-solution`을 잠시 옮기고 가이드의 명령·코드 블록만으로 처음부터 실행. `/health` 결과와 `pytest` 결과가 가이드에 적힌 출력과 일치해야 한다.
- [ ] **Step 2: `planning/progress.md` 작성** — 1단계 완료, 검증 코드 위치, 다음은 2단계, 주의점.
- [ ] **Step 3: 사용자에게 커밋 요청** (Claude는 커밋하지 않는다)
