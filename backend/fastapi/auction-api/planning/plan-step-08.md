# 8단계 — 마감과 시간 기반 처리 (closer 워커): 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 별도 프로세스(`python -m app.workers.closer`)가 1초마다 시계를 보고 ① 시작 시각이 지난 `scheduled` 경매를 `active`로, ② 마감 시각이 지난 `active` 경매를 `ended`로(낙찰자 확정 + `Payment(pending, 24h)` 생성 + `auction_closed` 발행), ③ 기한 지난 `pending` 결제를 `expired`로 바꾼다. 워커가 둘이어도 한 경매는 한 번만 처리된다.

**Architecture:** 규칙은 `app/services/closer.py`의 순수 함수 세 개(`activate_due`, `close_due`, `expire_payments`)에 두고 `now`를 인자로 받는다(테스트가 시계를 쥔다). 마감은 "후보 id 목록 → 한 건씩 `FOR UPDATE SKIP LOCKED`로 집어 재검사 → 커밋 → 발행" 순서라 워커 두 개가 같은 후보를 봐도 잠긴 행은 건너뛴다. 활성화·만료는 `UPDATE … RETURNING` 한 문장(UPDATE 가 스스로 행을 잠근다). `app/workers/closer.py`는 루프·시그널·로그만 맡는다.

**Tech Stack:** SQLAlchemy 2.0 async(`with_for_update(skip_locked=True)`, `update().returning()`), Redis Pub/Sub(7단계 `events.publish`), asyncio(`Event`, `add_signal_handler`), logging.

**Spec:** `planning/2026-08-25-auction-api-design.md` §4 규칙 5·6, §6 8단계, §8

## Global Constraints

- 작업 위치 `~/Documents/auction-api-solution/`(검증), 가이드 `guides/08-closer-worker.html`. til 레포 git 금지.
- 시간 값은 Settings: `closer_interval_seconds=1.0`, `closer_batch_size=100`, `payment_deadline_hours=24`.
- 서비스는 HTTP 를 모른다. 발행은 커밋 뒤. 알림(이메일)은 `[notify]` 로그 한 줄로 대체.
- 마이그레이션 없음 — `payments` 테이블(2단계)에 `status/expires_at/paid_at/external_id` 가 이미 있다.

---

## 파일 구조

```
app/core/config.py             (수정) closer_*·payment_deadline_hours
app/repositories/auction.py    (수정) get_for_update(skip_locked=), list_due_scheduled_ids, list_due_active_ids
app/repositories/bid.py        (수정) top_bid()
app/repositories/payment.py    신규  add()
app/services/closer.py         신규  ClosedResult · activate_due · close_due · expire_payments
app/workers/closer.py          신규  TickResult · tick · run · main (python -m app.workers.closer)
tests/test_closer.py           신규  8 테스트 (2개는 commits)
```

## 인터페이스

```python
# app/repositories/auction.py
async def get_for_update(db, auction_id, *, skip_locked: bool = False) -> Auction | None
async def list_due_scheduled_ids(db, now, *, limit) -> list[uuid.UUID]   # scheduled & starts_at <= now
async def list_due_active_ids(db, now, *, limit) -> list[uuid.UUID]      # active & ends_at <= now
# app/repositories/bid.py
async def top_bid(db, auction_id) -> Bid | None                           # amount desc, created_at asc
# app/repositories/payment.py
async def add(db, payment) -> Payment
# app/services/closer.py
@dataclass class ClosedResult: auction_id, winner_id, final_price, bid_count, payment_id
async def activate_due(db, now, *, limit=None) -> int
async def close_due(db, redis, now, *, limit=None) -> list[ClosedResult]
async def expire_payments(db, now, *, limit=None) -> int
# app/workers/closer.py
@dataclass class TickResult: activated: int; closed: list[ClosedResult]; expired: int; empty -> bool
async def tick(redis, now=None) -> TickResult        # 세션 3개를 열고 세 함수를 차례로
async def run(stop: asyncio.Event, redis, interval) -> None
async def main() -> None                              # 시그널 → stop.set()
```

---

### Task 1: 실패하는 테스트 (RED)

- [ ] `tests/test_closer.py` 작성 — 낙찰(winner+payment+이벤트), 유찰(winner 없음·payment 없음), 마감 전 무시, 비활성 무시, 활성화, 결제 만료, 두 워커 동시(commits, 5건 → 중복 0), 루프 종료.
- [ ] `timeout 300 uv run pytest -q tests/test_closer.py` → `ModuleNotFoundError: No module named 'app.services.closer'`

### Task 2: 설정·리포지토리

- [ ] `config.py` 세 값 추가 → `uv run python -c "from app.core.config import get_settings as g; print(g().closer_interval_seconds)"` → `1.0`
- [ ] `repositories/auction.py` `skip_locked` 인자 + 후보 id 조회 두 개, `repositories/bid.py` `top_bid`, `repositories/payment.py` 신규

### Task 3: 서비스 (GREEN 1차)

- [ ] `services/closer.py` — `close_due`: 후보 id → `get_for_update(skip_locked=True)` → 상태·시각 재검사 → `top_bid` → `ended`/`winner_id`/`version+1` → Payment → `commit` → `publish(auction_closed)` → `[notify]` 로그. `activate_due`/`expire_payments`: `update().where().values().returning(id)` + commit.
- [ ] `timeout 300 uv run pytest -q tests/test_closer.py` → 루프 테스트만 실패

### Task 4: 워커 (GREEN)

- [ ] `workers/closer.py` — `tick`·`run`·`main`, `logging.basicConfig(format="%(asctime)s [pid %(process)d] …")`, `loop.add_signal_handler(SIGINT/SIGTERM, stop.set)`
- [ ] `timeout 300 uv run pytest -q` → 72 passed, `uv run ruff check .` / `ruff format --check .` 통과

### Task 5: 수동 확인 (#run 캡처)

- [ ] API(백그라운드) + 워커(`nohup timeout 60 uv run python -m app.workers.closer &`) → 15초 뒤 마감 경매 + 입찰 2건 + `ws_listen.py` → 리스너에 `auction_closed`, 워커 로그에 `closed`·`[notify]`, `GET /auctions/{id}` → `ended`+`winner_id`, psql `payments` 1행 `pending`.
- [ ] 워커를 하나 더 잠깐 띄워 두 로그에 중복 처리 없음(각 경매 한 번).
- [ ] `docker compose exec db psql … "DELETE FROM users …"` 정리

### Task 6: 가이드·재검증·동기화

- [ ] `scratchpad/gen_step08_a.py` + `gen_step08_b.py` 로 `guides/08-closer-worker.html` 조립(파일 전문·캡처 출력)
- [ ] `git archive step-07` → replay 디렉터리 → `alembic upgrade head` → `replay08.py` 로 블록 적용 → RED/GREEN/run.sh 출력 일치
- [ ] `index.html`·`01`~`07` 사이드바 동기화, `07` pager `(예정)` 제거, `progress.md`, solution 커밋 + `step-08`
