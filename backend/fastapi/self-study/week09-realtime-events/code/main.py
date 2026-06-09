"""Week 9 — 실시간(WebSocket) · 이벤트 · 성능 데모.

하나의 FastAPI 앱에 세 가지를 담았다.
  1) WebSocket 채팅      : /ws/chat/{name}  + ConnectionManager(broadcast)
  2) 성능 비교용 엔드포인트 : /blocking vs /async  (동기 블로킹 vs 비동기)
  3) (선택) Redis Pub/Sub : redis 가 설치돼 있으면 여러 서버 인스턴스 간
                            메시지 broadcast 까지 확장하는 패턴을 보여준다.

핵심: redis 는 "선택"이다. redis 패키지/서버가 없어도 앱은 그대로 뜨고
      WebSocket 채팅과 성능 데모는 fastapi + uvicorn 만으로 동작한다.

────────────────────────────────────────────────────────────────────────
실행 방법 (uv)
────────────────────────────────────────────────────────────────────────
  # 1) 의존성 설치 (redis 는 선택)
  uv add fastapi uvicorn
  uv add redis          # Pub/Sub 데모까지 보려면 (선택)

  # 2) 서버 실행
  uv run uvicorn main:app --reload

  # 3) 성능 비교 (부하 테스트) — 별도 터미널
  ab -n 500 -c 50 http://localhost:8000/blocking   # 처리량 낮음
  ab -n 500 -c 50 http://localhost:8000/async      # 처리량 높음
  #   (ab 가 없으면: wrk -t4 -c100 -d10s http://localhost:8000/async)

────────────────────────────────────────────────────────────────────────
WebSocket 테스트 방법
────────────────────────────────────────────────────────────────────────
  - 브라우저로 http://localhost:8000/ 접속하면 간단한 채팅 UI 가 뜬다.
    여러 탭을 열어 서로 메시지가 broadcast 되는지 확인하면 된다.
  - 또는 CLI 로:  websocat ws://localhost:8000/ws/chat/alice
    (설치: brew install websocat  또는  cargo install websocat)
  - 또는 파이썬으로:
        import asyncio, websockets        # uv add websockets
        async def main():
            async with websockets.connect("ws://localhost:8000/ws/chat/bob") as ws:
                await ws.send("hello")
                print(await ws.recv())
        asyncio.run(main())

  # Redis 데모(선택)를 켜려면: 로컬에 Redis 를 띄우고(예: docker run -p 6379:6379 redis)
  # 환경변수 USE_REDIS=1 로 실행한다.  USE_REDIS=1 uv run uvicorn main:app
"""

from __future__ import annotations

import asyncio
import contextlib
import os
import time

from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.responses import HTMLResponse

# ── (선택) Redis: 없으면 None 으로 두고 앱은 정상 동작 ──────────────────
USE_REDIS = os.getenv("USE_REDIS") == "1"
REDIS_URL = os.getenv("REDIS_URL", "redis://localhost:6379")
redis_client = None  # 시작 시 채워짐(가능한 경우)

try:
    import redis.asyncio as aioredis  # 최신 redis-py 의 비동기 클라이언트
except ImportError:
    aioredis = None  # redis 미설치 — Pub/Sub 데모만 비활성화된다


app = FastAPI(title="Week 9 — Realtime / Events / Performance")


# =========================================================================
# 1) ConnectionManager — 다중 WebSocket 접속 관리
# =========================================================================
class ConnectionManager:
    """현재 살아있는 WebSocket 연결들을 들고, 연결/해제/방송을 책임진다."""

    def __init__(self) -> None:
        self.active: list[WebSocket] = []

    async def connect(self, ws: WebSocket) -> None:
        await ws.accept()          # 핸드셰이크 수락 (필수)
        self.active.append(ws)

    def disconnect(self, ws: WebSocket) -> None:
        if ws in self.active:
            self.active.remove(ws)  # 목록에서 제거 (정리)

    async def broadcast(self, message: str) -> None:
        # 끊긴 소켓이 섞여 있어도 방송 전체가 깨지지 않도록 개별 예외를 무시한다.
        dead: list[WebSocket] = []
        for connection in self.active:
            try:
                await connection.send_text(message)  # send 는 I/O → await
            except Exception:
                dead.append(connection)
        for ws in dead:
            self.disconnect(ws)


manager = ConnectionManager()


# =========================================================================
# 2) WebSocket 채팅 엔드포인트
# =========================================================================
@app.websocket("/ws/chat/{name}")
async def chat(websocket: WebSocket, name: str) -> None:
    await manager.connect(websocket)               # accept + 목록 등록
    await _fanout(f"🟢 {name} 님 입장")
    try:
        while True:
            text = await websocket.receive_text()  # 클라이언트 메시지 대기
            await _fanout(f"{name}: {text}")       # 모두에게
    except WebSocketDisconnect:                     # 정상 종료 신호
        manager.disconnect(websocket)              # 정리
        await _fanout(f"🔴 {name} 님 퇴장")


async def _fanout(message: str) -> None:
    """메시지를 퍼뜨린다.

    - Redis 가 켜져 있으면 채널로 publish 한다(여러 서버가 구독 → 각자 broadcast).
    - 꺼져 있으면 이 프로세스의 소켓들에 직접 broadcast 한다(단일 서버 모드).
    """
    if redis_client is not None:
        await redis_client.publish("chat", message)
    else:
        await manager.broadcast(message)


# =========================================================================
# 3) (선택) Redis Pub/Sub — 여러 서버 인스턴스 간 broadcast (스케일아웃)
# =========================================================================
async def redis_to_clients() -> None:
    """Redis 'chat' 채널을 구독하다가, 받은 메시지를 내 소켓들에 broadcast 한다."""
    assert redis_client is not None
    pubsub = redis_client.pubsub()
    await pubsub.subscribe("chat")
    async for message in pubsub.listen():
        # listen() 은 'subscribe' 같은 제어 신호도 내보내므로 실제 메시지만 거른다.
        if message["type"] == "message":
            data = message["data"]
            if isinstance(data, bytes):
                data = data.decode()
            await manager.broadcast(data)


@app.on_event("startup")
async def _startup() -> None:
    global redis_client
    if USE_REDIS and aioredis is not None:
        redis_client = aioredis.from_url(REDIS_URL)
        # 백그라운드 구독 태스크 시작
        app.state.redis_task = asyncio.create_task(redis_to_clients())


@app.on_event("shutdown")
async def _shutdown() -> None:
    task = getattr(app.state, "redis_task", None)
    if task is not None:
        task.cancel()
        with contextlib.suppress(asyncio.CancelledError):
            await task
    if redis_client is not None:
        await redis_client.aclose()


# =========================================================================
# 4) 성능 비교용 엔드포인트 (I/O 바운드 100ms 대기를 가정)
# =========================================================================
@app.get("/blocking")
async def blocking_endpoint():
    """❌ async 함수 안에서 블로킹 — 이벤트 루프가 100ms 동안 멈춘다.

    이 엔드포인트는 동시 요청을 사실상 한 줄로 세워 처리하므로 처리량(RPS)이 낮다.
    (현실에서는 동기 DB 드라이버/동기 HTTP 라이브러리가 이 역할을 한다.)
    """
    time.sleep(0.1)
    return {"ok": True, "mode": "blocking"}


@app.get("/async")
async def async_endpoint():
    """✅ await 로 양보 — 대기 중 루프가 다른 요청을 처리한다.

    100ms 대기가 겹쳐 처리되어 같은 서버로 훨씬 높은 처리량(RPS)을 낸다.
    """
    await asyncio.sleep(0.1)
    return {"ok": True, "mode": "async"}


# =========================================================================
# 5) 채팅 테스트용 최소 HTML (브라우저에서 바로 확인)
# =========================================================================
@app.get("/", response_class=HTMLResponse)
async def index() -> str:
    return """<!doctype html><meta charset="utf-8">
<title>WS chat demo</title>
<h3>WebSocket 채팅 데모</h3>
<input id="name" placeholder="이름" value="guest">
<button onclick="join()">입장</button>
<div id="log" style="white-space:pre-wrap;border:1px solid #ccc;padding:8px;margin:8px 0;height:200px;overflow:auto"></div>
<input id="msg" placeholder="메시지"><button onclick="send()">전송</button>
<script>
let ws;
function join(){
  const name = document.getElementById('name').value || 'guest';
  ws = new WebSocket(`ws://${location.host}/ws/chat/${name}`);
  ws.onmessage = e => { log.textContent += e.data + "\\n"; log.scrollTop = log.scrollHeight; };
}
function send(){ if(ws && ws.readyState===1){ ws.send(msg.value); msg.value=''; } }
</script>"""
