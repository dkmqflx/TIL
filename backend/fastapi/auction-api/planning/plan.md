# 실시간 경매 API — 마스터 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 사용자가 `guides/01-*.html` … `10-*.html`을 순서대로 따라 하면 단계마다 동작하는 실시간 경매 백엔드가 쌓이도록, 검증된 HTML 가이드 10개를 만든다.

**Architecture:** 산출물은 가이드 HTML이다. 코드는 사용자가 가이드를 보고 직접 만든다. Claude는 각 단계의 코드를 레포 밖 작업 공간(`~/Documents/auction-api-solution/`)에 TDD로 구현·검증한 뒤, 그 코드를 가이드에 싣고, 가이드의 명령을 그대로 재실행해 재검증한다.

**Tech Stack:** Python 3.13, uv, FastAPI, SQLAlchemy 2.0 async + asyncpg, Alembic, Redis, PyJWT, pwdlib, httpx/respx, pytest + pytest-asyncio, ruff, Docker compose, GitHub Actions.

**Spec:** `planning/2026-08-25-auction-api-design.md`

## Global Constraints

- 레포 위치 `til/backend/fastapi/auction-api/`. **git add/commit/tag는 사용자가 직접** — Claude는 커밋하지 않는다.
- 폴더명 `docs/` 금지(루트 `.gitignore`가 무시). 가이드 `guides/`, 계획 `planning/`.
- 포트: Postgres 5435, Redis 6380, 앱 8000, 모의 PG 8001.
- Python 3.13, `requires-python >= 3.12`.
- 가이드 스타일: `../../self-study/assets/style.css` 링크, 사이드바에 10단계 전체 nav, 왕초보 서술형 + 비유, 파일별 **전체 코드**, 실행 명령과 **기대 출력**, 완료 기준 체크리스트. 이미 self-study에 정본이 있는 개념은 링크만.
- 검증 코드 위치: `~/Documents/auction-api-solution/` (레포 밖, 세션 간 유지).

---

## 단계별 공통 작업 순서

각 단계 N은 `planning/plan-step-NN.md`에 상세 계획을 두고, 아래 순서로 진행한다.

1. **코드** — `~/Documents/auction-api-solution/`에서 TDD로 구현. 스펙 6절의 "완료 기준" 테스트가 통과할 때까지.
2. **실행 검증** — 완료 기준의 curl/pytest/ruff 명령을 실제로 실행해 출력 확보.
3. **가이드 작성** — `guides/NN-<slug>.html`. 검증된 코드와 실제 출력을 그대로 싣는다.
4. **가이드 재검증** — 빈 디렉터리에서 가이드의 명령·코드만으로 처음부터 재현. 실패하면 가이드 수정.
5. **핸드오프** — `planning/progress.md`에 완료 단계·다음 단계·주의점 갱신. 사용자가 커밋.

## 단계 목록

| N | 파일 | 요약 | 완료 기준 (스펙 6절) |
|---|------|------|---------------------|
| 01 | `guides/01-skeleton.html` | uv·ruff·Settings·compose·lifespan·`/health` | `GET /health` = `{"status":"ok","db":true,"redis":true}`, ruff 통과 |
| 02 | `guides/02-models-alembic.html` | 4개 모델·제약·Alembic async | `alembic upgrade head`, `alembic check` 무변경 |
| 03 | `guides/03-tests-auth.html` | 테스트 인프라 + 회원가입/로그인/refresh/로그아웃 | `tests/test_auth.py` 통과 |
| 04 | `guides/04-auction-crud.html` | 경매 등록·조회·수정·취소, 도메인 예외, 표준 에러 | `tests/test_auctions.py` 통과 |
| 05 | `guides/05-list-pagination.html` | 커서 페이지네이션·필터·정렬·N+1 | `tests/test_auction_list.py` 통과(쿼리 ≤ 2) |
| 06 | `guides/06-bids-concurrency.html` | `FOR UPDATE` 입찰, 동시 50건 테스트, rate limit | `tests/test_bids.py` 통과 |
| 07 | `guides/07-realtime-ws.html` | WebSocket + Redis Pub/Sub 브로드캐스트 | `tests/test_ws.py` 통과, 두 워커 간 전달 |
| 08 | `guides/08-closer-worker.html` | 마감 워커, 낙찰·Payment 생성, 멱등 | `tests/test_closer.py` 통과 |
| 09 | `guides/09-payment-webhook.html` | 모의 PG, httpx 결제 요청, HMAC 웹훅, 멱등 | `tests/test_payments.py` 통과 |
| 10 | `guides/10-deploy.html` | 캐시·부하·로깅·Dockerfile·CI·README | prod compose로 e2e 시나리오 통과 |

`guides/index.html`은 01단계와 함께 만들고, 이후 단계마다 진행 체크만 갱신한다.

## 진행 상태

`planning/progress.md` 참조.
