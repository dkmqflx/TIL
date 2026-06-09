"""
Week 1 · Lesson 03 — 첫 FastAPI 앱

실행 방법
---------
1) uv 설치 후, 이 폴더에서:
   uv init           # (최초 1회) pyproject.toml 생성
   uv add fastapi "uvicorn[standard]"

2) 서버 기동:
   uv run uvicorn main:app --reload

3) 확인:
   - http://127.0.0.1:8000/            → {"message": "Hello, FastAPI"}
   - http://127.0.0.1:8000/todos/42    → {"todo_id": 42, "q": null}
   - http://127.0.0.1:8000/docs        → Swagger UI (자동 생성)
   - http://127.0.0.1:8000/redoc       → ReDoc

cURL 테스트
-----------
   curl http://127.0.0.1:8000/todos/42
   curl "http://127.0.0.1:8000/todos/42?q=hello"
   curl -i http://127.0.0.1:8000/
"""

from fastapi import FastAPI

app = FastAPI(title="Week 1 — Hello FastAPI")


@app.get("/")
def read_root():
    # dict를 반환하면 FastAPI가 자동으로 JSON으로 직렬화한다.
    return {"message": "Hello, FastAPI"}


@app.get("/todos/{todo_id}")
def read_todo(todo_id: int, q: str | None = None):
    # todo_id: 경로(Path) 파라미터 — int 힌트 덕분에 자동 검증/변환된다.
    #          "/todos/abc" 처럼 변환 불가하면 FastAPI가 422를 자동 응답.
    # q:       쿼리(Query) 파라미터 — 기본값 None 이므로 생략 가능(선택).
    return {"todo_id": todo_id, "q": q}
