"""
Week 4 — 비동기 원리 & 내부 동작 종합 예제

이 한 파일에서 다음을 직접 체감합니다.
  1) async def 경로 vs 일반 def 경로 (실행 위치가 다름)
  2) 올바른 비동기 대기: await asyncio.sleep
  3) async def 안에서 동기 함수를 안전하게: run_in_threadpool
  4) (주석으로만) 절대 하면 안 되는 블로킹 안티패턴 — 실제로 켜면 서버가 멈춤

실행 (uv)
--------
   uv add fastapi "uvicorn[standard]"
   cd code
   uv run uvicorn main:app --reload
   # 또는:  uv run fastapi dev main.py
   http://127.0.0.1:8000/docs

블로킹을 '눈으로' 확인하는 법
----------------------------
   터미널 두 개를 띄우고 동시에 호출해 응답 시간을 비교합니다.

   # (A) 올바른 비동기 — 두 요청이 거의 동시에 끝남 (~2초)
   curl -s "http://127.0.0.1:8000/async-good?seconds=2" &
   curl -s "http://127.0.0.1:8000/async-good?seconds=2" &

   # (B) 동기지만 def 라서 threadpool 로 오프로딩 — 역시 함께 진행됨
   curl -s "http://127.0.0.1:8000/sync-def?seconds=2" &
   curl -s "http://127.0.0.1:8000/sync-def?seconds=2" &

   # (C) async 안 블로킹 안티패턴 — 아래 /async-bad 주석을 풀고 켜면
   #     두 요청이 직렬화되어 ~4초가 걸립니다 (이벤트 루프 정지).
"""

import asyncio
import time

from fastapi import FastAPI
from fastapi.concurrency import run_in_threadpool

app = FastAPI(title="Week 4 — Async Internals")


@app.get("/")
def index():
    """루트 — 사용 가능한 엔드포인트 안내."""
    return {
        "try": [
            "/async-good?seconds=2  (async def + await asyncio.sleep)",
            "/sync-def?seconds=2    (def → 자동 threadpool 오프로딩)",
            "/mixed?seconds=2       (async def + run_in_threadpool)",
            "/docs",
        ]
    }


# ---------------------------------------------------------------------------
# 1) 올바른 비동기 — 이벤트 루프에서 실행, await 로 대기 동안 양보
#    여러 요청이 동시에 들어와도 서로를 막지 않는다.
# ---------------------------------------------------------------------------
@app.get("/async-good")
async def async_good(seconds: float = 1.0):
    await asyncio.sleep(seconds)  # ✅ 양보: 대기 중 루프가 다른 요청 처리
    return {"mode": "async def + await asyncio.sleep", "waited": seconds}


# ---------------------------------------------------------------------------
# 2) 동기 함수는 def 로 — FastAPI 가 자동으로 threadpool(워커 스레드)로 보냄.
#    time.sleep 같은 블로킹이 있어도 이벤트 루프 자체는 막지 않는다.
#    (단, threadpool 은 기본 ~40 스레드로 제한됨을 기억할 것.)
# ---------------------------------------------------------------------------
@app.get("/sync-def")
def sync_def(seconds: float = 1.0):
    time.sleep(seconds)  # 블로킹이지만 def → 워커 스레드에서 실행되어 안전
    return {"mode": "def → threadpool", "waited": seconds}


# ---------------------------------------------------------------------------
# 3) async def 안에서 동기 blocking 함수를 꼭 호출해야 할 때:
#    직접 부르지 말고 run_in_threadpool 로 감싸 워커 스레드로 오프로딩.
# ---------------------------------------------------------------------------
def _blocking_work(seconds: float) -> str:
    """async 가 없는 가상의 동기 라이브러리 호출이라고 가정."""
    time.sleep(seconds)
    return f"slept {seconds}s in a worker thread"


@app.get("/mixed")
async def mixed(seconds: float = 1.0):
    # await run_in_threadpool(...) → 동기 함수가 이벤트 루프를 막지 않는다
    result = await run_in_threadpool(_blocking_work, seconds)
    return {"mode": "async def + run_in_threadpool", "result": result}


# ===========================================================================
# ⚠️ 안티패턴 — 학습용. 실제로 켜지 말 것.
#
#   async def 안에서 time.sleep (또는 requests.get, 동기 DB 드라이버) 같은
#   블로킹 코드를 직접 호출하면, await 양보가 없어 이벤트 루프가 통째로 멈춘다.
#   그 사이 같은 워커의 '모든' 다른 요청이 함께 멈춘다.
#
#   아래 주석을 풀고 /async-bad 를 동시에 두 번 호출하면, 두 요청이
#   직렬로 처리되어(2초 + 2초) 전체가 느려지는 것을 직접 볼 수 있다.
#
# @app.get("/async-bad")
# async def async_bad(seconds: float = 1.0):
#     time.sleep(seconds)   # 😱 블로킹! 이벤트 루프 정지 → 전체 요청 지연
#     return {"mode": "async def + time.sleep (BAD)", "waited": seconds}
#
#   올바른 수정: await asyncio.sleep(seconds)  (위 /async-good 참고)
# ===========================================================================
