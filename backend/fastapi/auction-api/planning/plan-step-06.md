# 6단계 — 입찰과 동시성: 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `POST /auctions/{id}/bids` 가 규칙 1~4(본인 금지·active 만·최소 금액·스나이핑 연장)를 지키고, 50명이 동시에 입찰해도 `current_price`·`bid_count` 가 정확히 맞는 것을 테스트로 증명한다. 가이드 `guides/06-bids-concurrency.html`.

**Architecture:** 서비스가 `SELECT … FOR UPDATE` 로 경매 행을 잠근 뒤 규칙 검사 → 갱신 → 커밋을 한 트랜잭션에서 한다(비관적 락). rate limit 은 락을 잡기 전에 Redis `INCR` 로. 시간 규칙(스나이핑 창·연장·한도)은 Settings. 동시성 테스트는 롤백 fixture 대신 실제 커밋 세션 50개 + `asyncio.gather` + TRUNCATE.

**Tech Stack:** SQLAlchemy `with_for_update()` + `populate_existing`, Redis `INCR/EXPIRE`, pytest `-m commits` 마커

**Spec:** `planning/2026-08-25-auction-api-design.md` §4 규칙 1~4, §5 6단계, §6 6단계, §8

## Global Constraints

- 시작 상태: solution `step-05`(42 passed). 끝 상태: `step-06`(59 passed).
- 표준 에러 껍데기·예외 계층 유지. 서비스는 HTTP 를 모른다.
- 커밋은 서비스가 한다(3~5단계와 동일). 락은 커밋 순간 풀린다.

---

## 파일 구조

```
app/core/config.py          (수정) snipe_window_seconds·snipe_extend_seconds·bid_rate_limit_per_second
app/core/exceptions.py      (수정) TooManyRequestsError(429) 부모 + AuctionNotActiveError·OwnAuctionBidError·BidTooLowError·BidRateLimitedError
app/repositories/auction.py (수정) get_for_update()
app/repositories/bid.py     add(), list_by_auction()
app/schemas/bid.py          BidCreate, BidRead, BidResult
app/services/bid.py         _now(), _check_rate_limit(), minimum_bid(), place_bid(), list_bids()
app/routers/bids.py         POST/GET /auctions/{auction_id}/bids
app/main.py                 (수정) bids 라우터 등록
pyproject.toml              (수정) markers = ["commits: ..."]
tests/test_bids.py          규칙별 15개 (롤백 세션)
tests/test_bids_concurrency.py  동시 50건 2개 (@pytest.mark.commits)
```

**Interfaces**
- `auction_repo.get_for_update(db, auction_id) -> Auction | None` — `select(...).with_for_update().execution_options(populate_existing=True)`
- `bid_service.place_bid(db, redis, bidder: User, auction_id, amount) -> tuple[Bid, Auction]`
- `bid_service.list_bids(db, auction_id) -> list[Bid]` (없는 경매 → `AuctionNotFoundError`)
- `bid_service._now()` — 테스트가 monkeypatch 로 시계를 멈춘다
- 8단계 워커는 같은 `get_for_update` 를 `SKIP LOCKED` 버전으로 확장해 쓴다

---

### Task 1: 테스트 먼저 (RED)

- [ ] `pyproject.toml` `[tool.pytest.ini_options]` 에 `markers = ["commits: ..."]`
- [ ] `tests/test_bids.py` — 첫 입찰 시작가 OK / 시작가 미만 422 `BID_TOO_LOW`(메시지에 "10,000") / 현재가+단위 미만 422 → 이상 201 / 0원 422 `VALIDATION_ERROR` / 본인 403 `CANNOT_BID_OWN_AUCTION` / scheduled·ended·마감 지난 active 409 `AUCTION_NOT_ACTIVE` / 없는 경매 404 / 토큰 없음 401 / 마감 10초 전 입찰 → ends_at +30s / 하루 전 입찰 → 그대로 / 시계 멈추고 한도 2 → `[201, 201, 429]` `BID_RATE_LIMITED` / GET 목록 금액 내림차순·공개 / 없는 경매 GET 404
- [ ] `tests/test_bids_concurrency.py` — `committed_auction` fixture(`SessionLocal` 로 판매자·경매·입찰자 50 커밋, 끝나면 `TRUNCATE bids, payments, auctions, users CASCADE`); 50개 코루틴이 각자 세션으로 `place_bid`(금액 셔플) → `rows == accepted`, `current_price == max(accepted)`, `bid_count == version == len(accepted)`; 같은 금액 50건 → 정확히 1건 수락
- [ ] 실행: `uv run pytest -q` → `ImportError: cannot import name 'BidTooLowError'` … `2 errors during collection`

### Task 2: 구현 (GREEN)

- [ ] `config.py` 설정 3개 추가
- [ ] `exceptions.py` 429 부모 + 입찰 예외 4개 (docstring 트리 갱신)
- [ ] `repositories/auction.py` `get_for_update` / `repositories/bid.py`
- [ ] `schemas/bid.py`, `services/bid.py`, `routers/bids.py`, `main.py` 등록
- [ ] 실행: `uv run pytest -q` → `59 passed`; `uv run pytest -q -m commits` → `2 passed`; ruff check/format 통과

### Task 3: 락 없으면 어떻게 되나 (가이드용 실험)

- [ ] `with_for_update()` 한 줄을 지우고 `uv run pytest -q -m commits` → `current_price 50000 != max 59000`, 같은 금액 7건 수락 → 두 테스트 모두 FAILED. 원복 후 다시 2 passed. 출력을 가이드 `#design`/`#pitfalls` 에 싣는다.

### Task 4: 실행·확인 시나리오 (run.sh)

- [ ] alice(판매자)·bob·carol 가입/로그인 → 경매 A(10분 뒤 마감) 생성 → bob 5,000 → 422 / 10,000 → 201 / alice 본인 → 403 / carol 10,500 → 422 / 11,000 → 201(bid_count 2)
- [ ] 경매 B(20초 뒤 마감) → bob 입찰 → ends_at 30초 뒤로
- [ ] carol 연속 8건 → 201×5 + 429×3 (같은 1초 안이면)
- [ ] GET 입찰 목록 → [11000, 10000]
- [ ] psql 두 세션: 세션1 `BEGIN; … FOR UPDATE; pg_sleep(5); COMMIT;` 백그라운드, 세션2 같은 행 `FOR UPDATE` → `pg_stat_activity` 에 `wait_event_type = Lock`, 세션2가 ~4초 기다렸다 통과
- [ ] 정리: 만든 유저 DELETE(CASCADE)

### Task 5: 가이드 + replay + 동기화 + 핸드오프

- [ ] `guides/06-bids-concurrency.html` (규약대로 전문 코드·실제 출력)
- [ ] replay: `git archive step-05` → `alembic upgrade head` → 42 passed 기준선 → 가이드 블록 적용 → RED → 59 passed → run.sh 출력 대조
- [ ] `index.html`·`01`~`05` 사이드바 동기화, `progress.md`, solution 커밋 + 태그 `step-06`
