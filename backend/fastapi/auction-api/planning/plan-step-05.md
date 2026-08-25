# 5단계 — 목록 조회 실무화: 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `GET /auctions`에 커서(keyset) 페이지네이션·필터·정렬을 붙이고, `selectinload`로 N+1을 없앤 뒤 그 사실을 쿼리 카운트 테스트로 증명한다. 과정을 `guides/05-list-pagination.html`로 만든다.

**Architecture:** 커서는 `[정렬 기준, 정렬 키(ISO 시각), id]`를 base64url로 싼 불투명 문자열(`app/core/pagination.py`). 리포지토리 `list_page`가 `(키, id)` 행 비교(`tuple_`)와 `limit+1`로 한 장을 가져오고, 서비스 `list_auctions`가 잘라내고 다음 커서를 만든다. 쿼리 파라미터는 Pydantic 모델 하나(`AuctionListParams`)를 `Query()`로 받는다.

**Tech Stack:** SQLAlchemy `select/tuple_/selectinload`, Pydantic query-param model, `event.listen(engine.sync_engine, "before_cursor_execute")`

**Spec:** `planning/2026-08-25-auction-api-design.md` §5 커서 페이지네이션, §6 5단계

## Global Constraints

- 작업 위치 `~/Documents/auction-api-solution/`(검증용, git 태그 `step-05`), 가이드는 `guides/`. til 레포 git 금지.
- 기존 표준 에러 껍데기·예외 계층은 바꾸지 않고 `InvalidCursorError(UnprocessableError)`만 추가.
- 새 패키지 없음.

---

## 파일 구조

```
app/core/pagination.py        (신규) encode_cursor / decode_cursor
app/core/exceptions.py        (수정) InvalidCursorError 추가
app/schemas/auction.py        (수정) AuctionListParams · SellerBrief · AuctionListItem · AuctionPage
app/repositories/auction.py   (수정) list_page(...)
app/services/auction.py       (수정) list_auctions(db, params) -> (items, next_cursor)
app/routers/auctions.py       (수정) GET "" (list) — /{auction_id} 보다 위
tests/conftest.py             (수정) QueryCounter + query_counter fixture
tests/test_auction_list.py    (신규) 14개
```

## Interfaces

- `encode_cursor(sort: str, key: datetime, id_: UUID) -> str` / `decode_cursor(cursor: str, sort: str) -> tuple[datetime, UUID]` (실패·정렬 불일치 → `InvalidCursorError` 422 `INVALID_CURSOR`)
- `auction_repo.list_page(db, *, status, category, min_price, max_price, sort="ending_soon", limit=20, after=None, load_seller=True) -> list[Auction]` — 최대 `limit+1`건
- `auction_service.list_auctions(db, params: AuctionListParams) -> tuple[list[Auction], str | None]`
- `AuctionListParams(status?, category?, min_price?≥0, max_price?≥0, sort: ending_soon|newest, limit 1..50=20, cursor?)`, `min>max` → 422 `loc ["query"]`
- `AuctionPage {items: [AuctionListItem{id,title,category,current_price,bid_count,ends_at,status,created_at,seller{id,nickname}}], next_cursor}`
- `query_counter` fixture: `.selects`, `.statements`, `.reset()`

---

### Task 1: 실패하는 테스트 (RED)
- [ ] `tests/conftest.py`에 `QueryCounter`/`query_counter` 추가, `tests/test_auction_list.py` 작성(시드 25건: ends_at 5건씩 동점, created_at i분 전, 짝/홀 카테고리, 가격 10,000×(i+1), 7의 배수는 ended)
- [ ] 검증: `uv run pytest -q` → `14 failed, 28 passed`

### Task 2: 커서 + 예외
- [ ] `app/core/pagination.py`, `InvalidCursorError`
- [ ] 검증: `uv run python -c "from app.core.pagination import *; ..."` 왕복

### Task 3: 스키마 · 리포지토리 · 서비스 · 라우터
- [ ] `AuctionListParams` 등 4개 스키마, `list_page`(tuple_ 행 비교, limit+1, selectinload), `list_auctions`, `GET ""`
- [ ] 검증: `uv run pytest -q` → `42 passed`; `uv run ruff check . && uv run ruff format --check .`

### Task 4: 수동 시나리오 캡처
- [ ] 두 판매자 · 경매 12건(2건씩 같은 마감) 시드 → `limit=5` 세 장 넘기기 → 커서 디코드 → 필터 → newest → 422 네 가지 → `echo=True` 엔진으로 SQL 두 문장 확인 → 정리

### Task 5: 가이드 + 재검증 + 동기화
- [ ] `guides/05-list-pagination.html` 생성(gen 스크립트), 링크·앵커 검사
- [ ] replay: `git archive step-04` → `alembic upgrade head` → 가이드 블록 적용 → RED 14/28 → 42 passed → run.sh
- [ ] 사이드바 동기화(index·01~04), `progress.md`, solution 태그 `step-05`
