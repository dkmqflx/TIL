"""서비스 계층 — 비즈니스 로직 + DB 접근.

라우터(컨트롤러)는 요청/응답만 다루고, 실제 '무엇을 하는지'는 여기로 뺀다.
HTTP(HTTPException, status code)는 절대 import 하지 않는다 → 도메인 예외만 던진다.
"""

from sqlalchemy import select
from sqlalchemy.orm import Session

from exceptions import TodoNotFoundError
from models import Todo
from schemas import TodoCreate, TodoUpdate


def list_todos(db: Session) -> list[Todo]:
    return list(db.scalars(select(Todo).order_by(Todo.id)))


def get_todo(db: Session, todo_id: int) -> Todo:
    todo = db.get(Todo, todo_id)
    if todo is None:
        raise TodoNotFoundError(todo_id)
    return todo


def create_todo(db: Session, data: TodoCreate) -> Todo:
    todo = Todo(title=data.title, done=data.done)
    db.add(todo)
    db.commit()
    db.refresh(todo)  # DB가 채운 id / created_at 을 다시 읽어 온다
    return todo


def update_todo(db: Session, todo_id: int, data: TodoUpdate) -> Todo:
    todo = get_todo(db, todo_id)  # 없으면 TodoNotFoundError
    # exclude_unset=True : 요청 본문에 실제로 보낸 필드만 추려 부분 수정.
    changes = data.model_dump(exclude_unset=True)
    for field, value in changes.items():
        setattr(todo, field, value)
    db.commit()
    db.refresh(todo)
    return todo


def delete_todo(db: Session, todo_id: int) -> None:
    todo = get_todo(db, todo_id)  # 없으면 TodoNotFoundError
    db.delete(todo)
    db.commit()
