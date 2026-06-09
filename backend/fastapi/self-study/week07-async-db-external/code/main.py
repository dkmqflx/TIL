"""
Week 7 — 비동기 외부 통신 종합 예제 (Lifespan + httpx + CORS + 커스텀 미들웨어)

이 한 파일에서 Week 7의 핵심을 모두 보여준다.
    - Lifespan: 시작 시 httpx.AsyncClient 생성, 종료 시 aclose()  (Lesson 01)
    - 외부 API 호출: 재사용 클라이언트로 await client.get(...)        (Lesson 02)
    - CORSMiddleware: 프론트(:5173) 출처 허용                       (Lesson 03)
    - 커스텀 미들웨어: 모든 응답에 X-Process-Time 헤더 추가          (Lesson 03)

실행
----
   uv add fastapi "uvicorn[standard]" httpx
   cd code
   uv run uvicorn main:app --reload
   http://127.0.0.1:8000/docs

확인 포인트
-----------
   # 1) 외부 API 호출 — JSONPlaceholder 의 글 1개를 받아 가공해서 돌려준다.
   #    응답 헤더에 X-Process-Time 이 붙어 있는지도 -i 로 확인!
   curl -i http://127.0.0.1:8000/posts/1

   # 2) 일부러 없는 id → 외부가 404 → 우리는 502 로 번역해서 응답
   curl -i http://127.0.0.1:8000/posts/99999999

   # 3) CORS — 프론트(:5173)에서 fetch 하면 통과, 다른 출처는 브라우저가 차단
   #    (preflight 도 CORSMiddleware 가 자동 응답)
"""

import time
from contextlib import asynccontextmanager

import httpx
from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware

EXTERNAL_API = "https://jsonplaceholder.typicode.com"


# ---------------------------------------------------------------------------
# 1) Lifespan — 시작 시 httpx 클라이언트 1개 생성, 종료 시 정리
#    (DB 엔진을 하나만 두고 dispose 하는 것과 같은 패턴)
# ---------------------------------------------------------------------------
@asynccontextmanager
async def lifespan(app: FastAPI):
    # 🟢 startup: 앱 전체에서 재사용할 클라이언트를 만든다 (timeout 필수)
    app.state.http = httpx.AsyncClient(base_url=EXTERNAL_API, timeout=5.0)
    print("서버 시작: httpx 클라이언트 준비 완료")
    yield
    # 🔴 shutdown: 연결을 깔끔히 닫는다
    await app.state.http.aclose()
    print("서버 종료: httpx 클라이언트 정리 완료")


app = FastAPI(title="Week 7 — Async External", lifespan=lifespan)


# ---------------------------------------------------------------------------
# 2) CORSMiddleware — 프론트 출처 허용
#    allow_credentials=True 이면 allow_origins 에 "*" 를 쓸 수 없다.
# ---------------------------------------------------------------------------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],  # 정확한 출처
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ---------------------------------------------------------------------------
# 3) 커스텀 미들웨어 — 모든 응답에 처리시간 헤더를 붙인다
#    call_next 호출 전후로 우리 코드를 끼운다.
# ---------------------------------------------------------------------------
@app.middleware("http")
async def add_process_time_header(request: Request, call_next):
    start = time.perf_counter()          # 전처리
    response = await call_next(request)  # 라우트 실행
    elapsed = time.perf_counter() - start
    response.headers["X-Process-Time"] = f"{elapsed:.4f}"  # 후처리
    return response


# ---------------------------------------------------------------------------
# 4) 외부 API 호출 엔드포인트 — 재사용 클라이언트로 await get
#    외부 실패는 5xx 로 '번역'해서 돌려준다.
# ---------------------------------------------------------------------------
@app.get("/")
async def root():
    return {"message": "Week 7 — /docs 에서 /posts/{id} 를 눌러보세요"}


@app.get("/posts/{post_id}")
async def get_post(post_id: int, request: Request):
    client: httpx.AsyncClient = request.app.state.http
    try:
        r = await client.get(f"/posts/{post_id}")
        r.raise_for_status()  # 4xx·5xx 면 HTTPStatusError
    except httpx.TimeoutException:
        raise HTTPException(status_code=504, detail="외부 API 응답 시간 초과")
    except httpx.HTTPStatusError as e:
        raise HTTPException(
            status_code=502,
            detail=f"외부 API 오류: {e.response.status_code}",
        )
    except httpx.ConnectError:
        raise HTTPException(status_code=503, detail="외부 API 연결 실패")

    data = r.json()
    # 가공해서 우리 형태로 돌려준다 (외부 응답을 그대로 흘리지 않는다)
    return {
        "id": data["id"],
        "title": data["title"],
        "preview": data["body"][:40] + "...",
    }
