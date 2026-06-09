"""
Week 2 — Request & HTTP 종합 예제

요청의 여러 입구(Path/Query/Body), HTTP 메서드별 상태 코드,
그리고 HTTPException까지 한 파일에 모았다. 인메모리 dict를 DB 대신 사용한다.

실행
----
   uv add fastapi "uvicorn[standard]"
   uv run uvicorn main:app --reload
   http://127.0.0.1:8000/docs  에서 직접 눌러보며 확인

cURL 맛보기
-----------
   # 전체 조회 (Query 파라미터)
   curl "http://127.0.0.1:8000/todos?done=false&limit=5"
   # 단일 조회 (Path 파라미터) — 없는 id면 404
   curl -i http://127.0.0.1:8000/todos/99
   # 생성 (Body) — 성공 시 201
   curl -i -X POST http://127.0.0.1:8000/todos \
     -H "Content-Type: application/json" \
     -d '{"title": "운동하기", "done": false}'
   # 삭제 — 성공 시 204 (본문 없음)
   curl -i -X DELETE http://127.0.0.1:8000/todos/1
"""

from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel

app = FastAPI(title="Week 2 — Request & HTTP")

# --- 인메모리 저장소 (실DB는 Week 5에서) ---
todos: dict[int, dict] = {
    1: {"id": 1, "title": "장보기", "done": False},
    2: {"id": 2, "title": "청소하기", "done": True},
}
_next_id = 3


# --- 요청 본문(Body)을 받는 Pydantic 모델 (Week 3에서 깊게) ---
class CreateTodo(BaseModel):
    title: str
    done: bool = False


# === 전체 조회: Query 파라미터(선택적) ===
@app.get("/todos")
def list_todos(skip: int = 0, limit: int = 10, done: bool | None = None):
    items = list(todos.values())
    if done is not None:
        items = [t for t in items if t["done"] == done]
    return items[skip : skip + limit]


# === 단일 조회: Path 파라미터(필수) + 404 ===
@app.get("/todos/{todo_id}")
def read_todo(todo_id: int):
    if todo_id not in todos:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"id={todo_id} 할 일을 찾을 수 없습니다",
        )
    return todos[todo_id]


# === 생성: Body + 201 Created ===
@app.post("/todos", status_code=status.HTTP_201_CREATED)
def create_todo(todo: CreateTodo):
    global _next_id
    new = {"id": _next_id, **todo.model_dump()}
    todos[_next_id] = new
    _next_id += 1
    return new


# === 삭제: 204 No Content (본문 없음) ===
@app.delete("/todos/{todo_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_todo(todo_id: int):
    if todo_id not in todos:
        raise HTTPException(404, f"id={todo_id} 없음")
    del todos[todo_id]
    return  # 204 응답은 본문이 없어야 한다
