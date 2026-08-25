# 7단계 — 실시간(WebSocket + Redis Pub/Sub): 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 경매 하나를 WebSocket 으로 구독하면 입찰이 들어올 때마다 실시간으로 받는다. uvicorn 워커가 여러 개여도 모든 구독자가 받는다(Redis Pub/Sub).

**Architecture:** 서비스가 커밋 뒤 `events.publish()` → Redis `PUBLISH auction:{id}` → 프로세스마다 하나 있는 구독 루프(`ws/bridge.py`)가 받아 → 그 프로세스의 `ConnectionManager` 가 자기 소켓들에 `send_text`. 소켓은 access 토큰(query `token=`)으로 인증하고 실패하면 accept 후 `4401` 로 닫는다.

**Tech Stack:** FastAPI WebSocket, redis-py asyncio PubSub(`psubscribe`), websockets 17(테스트·CLI 클라이언트), uvicorn `--workers 2`

**Spec:** `planning/2026-08-25-auction-api-design.md` §5(WS 인증), §6 7단계

## Global Constraints

- 작업 위치 `~/Documents/auction-api-solution/`(태그 `step-06` 기준). 가이드는 `guides/07-realtime-ws.html`. git 커밋 금지(til). 포트 8000/8765(테스트 서버).
- 테스트는 **실제 uvicorn 자식 프로세스** 를 띄운다(TestClient 는 세션 루프와 충돌). `@pytest.mark.commits`.

---

## 파일 구조

```
app/core/events.py      AuctionEvent, channel(), publish()             (신규)
app/ws/manager.py       ConnectionManager, manager                     (신규)
app/ws/bridge.py        run_bridge(redis, manager)                     (신규)
app/ws/router.py        WS /ws/auctions/{id}?token=                    (신규)
app/services/bid.py     커밋 뒤 bid_placed 발행                        (수정)
app/main.py             lifespan 에서 bridge task, ws 라우터, /static  (수정)
static/ws-demo.html     브라우저 데모                                  (신규)
scripts/ws_listen.py    터미널 구독 클라이언트                         (신규)
tests/test_ws.py        live_server fixture + 5 테스트                 (신규)
```

## Task 1: 실패 테스트

**Files:** Create `tests/test_ws.py`
- [ ] `uv add --dev websockets`
- [ ] `live_server`(module) fixture: `subprocess.Popen([sys.executable, "-m", "uvicorn", "app.main:app", "--port", "8765"])`, `/health` 폴링, 종료 시 terminate.
- [ ] `seeded` fixture: `SessionLocal()` 로 판매자·입찰자·active 경매 커밋, 끝나면 TRUNCATE.
- [ ] 테스트 5개: 토큰 없음 → `ConnectionClosedError.rcvd.code == 4401`; 없는 경매 → 4404; snapshot 수신 후 HTTP 입찰 → `bid_placed`(amount·current_price·bid_count·bidder_id); 구독자 2명 동일 이벤트; 끊긴 소켓 뒤에도 남은 소켓 정상.
- [ ] `timeout 180 uv run pytest -q tests/test_ws.py` → `5 failed` (`InvalidStatus: server rejected WebSocket connection: HTTP 403`)

## Task 2: 이벤트·매니저·브리지

**Interfaces:** `events.AuctionEvent(type, auction_id, payload, at)`, `events.channel(id) -> "auction:{id}"`, `events.publish(redis, event) -> int`; `ConnectionManager.connect/disconnect/count/broadcast(auction_id, text)`; `run_bridge(redis, manager)` (CancelledError 로 정리)
- [ ] `app/core/events.py`, `app/ws/manager.py`, `app/ws/bridge.py` 작성 (코드는 가이드 `#impl`)

## Task 3: 라우터·서비스·main

- [ ] `app/ws/router.py`: accept → `_user_id_from_token` → 4401 / 경매 없음 4404 → snapshot(`served_by_pid` 포함) → `manager.connect` → `receive_text` 루프 → finally disconnect. 세션은 `SessionLocal()` 로 짧게.
- [ ] `app/services/bid.py`: `extended` 플래그, `db.commit()`·refresh **뒤** `events.publish(bid_placed)`.
- [ ] `app/main.py`: lifespan 에서 `asyncio.create_task(run_bridge(...))` / cancel, `ws_router`, `app.mount("/static", StaticFiles(directory=STATIC_DIR))`.
- [ ] `static/ws-demo.html`, `scripts/ws_listen.py`
- [ ] `timeout 180 uv run pytest -q tests/test_ws.py` → `5 passed`; `timeout 300 uv run pytest -q` → `64 passed`; ruff check/format 통과

## Task 4: 실전 확인 (가이드 `#run`)

- [ ] `uv run uvicorn app.main:app --workers 2 --port 8000`
- [ ] 가입 3명 → 경매 → 리스너 4개 백그라운드(`scripts/ws_listen.py`) → 입찰 2건 → `redis-cli PUBLISH auction:$A …` → `PUBSUB NUMPAT` → 리스너 로그(served_by_pid 가 두 값으로 갈린다, 4명 모두 이벤트 수신) → `/static/ws-demo.html` 200 → 정리
- [ ] 브라우저 `http://localhost:8000/static/ws-demo.html` 로 두 탭 동시 수신

## Task 5: 가이드 · 재검증 · 핸드오프

- [ ] `scratchpad/gen_step07.py` 로 `guides/07-realtime-ws.html` 생성 (파일 전문 + 캡처 출력)
- [ ] replay: `git archive step-06` → `.env` → `alembic upgrade head` → 가이드 블록 적용 → RED/GREEN/run.sh 일치
- [ ] 사이드바 동기화(index·01~06), `progress.md`, solution 커밋 + 태그 `step-07`
