# 4단계 — 경매 등록·조회·수정·취소: 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 로그인한 판매자가 경매를 등록·수정·취소하고 누구나 조회할 수 있으며, 소유권·상태 머신·입찰 유무 규칙이 도메인 예외로 표현되고 모든 에러가 `{"code","message"}` 표준 껍데기로 나가는 상태. `tests/test_auctions.py` 전부 통과. 과정을 `guides/04-auction-crud.html`로.

**Architecture:** 3단계 계층 그대로. `schemas/auction.py`가 입력 모양(422)을, `services/auction.py`가 규칙(403/404/409/422 도메인 예외)을, `routers/auctions.py`가 HTTP만 담당. `core/exceptions.py`는 범용 4종(NotFound/Forbidden/Conflict/InvalidState) + 경매 전용 예외를 계층으로 두고, FastAPI `RequestValidationError`도 같은 껍데기(`VALIDATION_ERROR` + `errors`)로 감싼다.

**Tech Stack:** FastAPI, Pydantic v2 (`field_validator`/`model_validator`), SQLAlchemy 2.0 async, pytest-asyncio (3단계 fixture)

**Spec:** `planning/2026-08-25-auction-api-design.md` §4 상태·규칙, §5 API 표면 4단계·표준 에러, §6 4단계

## Global Constraints

- solution `~/Documents/auction-api-solution/` 태그 `step-03` → `step-04`. til 레포 git 금지.
- 서비스는 `HTTPException`·`fastapi` import 금지. 라우터는 규칙 판단 금지.
- 시각은 전부 timezone-aware(UTC). naive datetime 입력은 422.

---

## 파일 구조

```
(수정) app/core/exceptions.py   범용 4종 + 경매 전용 5종, RequestValidationError 핸들러
app/schemas/auction.py          AuctionCreate / AuctionUpdate / AuctionRead
app/repositories/auction.py     get, add
app/services/auction.py         create, get, update, cancel  (+ _ensure_seller/_ensure_editable)
app/routers/auctions.py         POST /auctions, GET /auctions/{id}, PATCH, POST /cancel
(수정) app/main.py              auctions 라우터 등록
(수정) tests/factories.py       create_auction(db, seller, **overrides)
tests/test_auctions.py          14개 테스트
```

## Interfaces

- 예외: `NotFoundError(404)`, `ForbiddenError(403)`, `ConflictError(409)`, `InvalidStateError(409, ConflictError 자식)`, `UnprocessableError(422)`
  경매 전용: `AuctionNotFoundError(NotFoundError, "AUCTION_NOT_FOUND")`, `NotAuctionSellerError(ForbiddenError, "NOT_AUCTION_SELLER")`, `AuctionHasBidsError(ConflictError, "AUCTION_HAS_BIDS")`, `AuctionClosedError(InvalidStateError, "AUCTION_CLOSED")`, `InvalidPeriodError(UnprocessableError, "INVALID_PERIOD")`
- 422 껍데기: `{"code": "VALIDATION_ERROR", "message": "요청 값이 올바르지 않습니다", "errors": [...]}`
- `services.auction.create(db, seller: User, data: AuctionCreate) -> Auction` — `starts_at` 없으면 now, `starts_at <= now`면 `active` 아니면 `scheduled`, `current_price = starting_price`
- `get(db, auction_id) -> Auction` (없으면 `AuctionNotFoundError`)
- `update(db, user, auction_id, data: AuctionUpdate) -> Auction` — 판매자만, `scheduled|active`만, `bid_count == 0`만, `ends_at > starts_at`; `version += 1`
- `cancel(db, user, auction_id) -> Auction` — 판매자만, `ended|cancelled`면 `AuctionClosedError`, 입찰 있으면 `AuctionHasBidsError`; `status = cancelled`, `version += 1`
- `tests.factories.create_auction(db, seller, **overrides) -> Auction` — 기본 active, 시작 1분 전, 마감 1일 후, 시작가 10_000

---

### Task 1: 실패 테스트 + 팩토리
- [ ] `tests/factories.py`에 `create_auction` 추가, `tests/test_auctions.py` 14개 작성
- [ ] 검증(RED): `uv run pytest -q` → `ModuleNotFoundError: No module named 'app.schemas.auction'`, `1 error`

### Task 2: 예외 계층 + 422 핸들러
- [ ] `app/core/exceptions.py` 확장(범용 4+1, 경매 5, `validation_error_handler`, `register_exception_handlers`에 등록)
- [ ] 검증: `uv run python -c "from app.core.exceptions import AuctionHasBidsError as E; print(E.code, E.status_code)"` → `AUCTION_HAS_BIDS 409`

### Task 3: 스키마 → 리포지토리 → 서비스 → 라우터 → main
- [ ] `schemas/auction.py`(tz-aware 검증, `ends_at > starts_at` 모델 검증), `repositories/auction.py`, `services/auction.py`, `routers/auctions.py`, `main.py` 등록
- [ ] 검증(GREEN): `uv run pytest -q` → `27 passed`; ruff check/format 통과

### Task 4: 수동 시나리오 (run.sh)
- [ ] alice·bob 가입/로그인 → alice 경매 등록 201 → 조회 200(토큰 없이) → alice PATCH 200(version 1) → bob PATCH 403 → 마감 ≤ 시작 422(VALIDATION_ERROR) → alice 취소 200 → 재취소 409(AUCTION_CLOSED) → 없는 id 404
- [ ] solution 커밋 + 태그 `step-04`

### Task 5: 가이드 + 재검증 + 동기화
- [ ] `guides/04-auction-crud.html` (03 템플릿, 섹션 id 고정, 전체 파일 블록, 실제 출력)
- [ ] replay: `git archive step-03` → `alembic upgrade head` → 가이드 블록만 적용 → 출력 일치
- [ ] 사이드바 동기화(index, 01, 02, 03), `progress.md` 갱신
