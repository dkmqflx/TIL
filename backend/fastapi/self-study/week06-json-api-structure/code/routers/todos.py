"""todos 라우터 (컨트롤러 계층).

역할은 딱 두 가지: ① 요청을 받아서 ② 서비스에 넘기고 결과를 응답한다.
- DB 세션은 Depends(get_db) 로 주입받는다(직접 만들지 않는다).
- 비즈니스 로직/DB 쿼리는 services 모듈에 위임한다.
"""

from typing import Annotated

from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session

import services
from database import get_db
from schemas import TodoCreate, TodoPublic, TodoUpdate

router = APIRouter(prefix="/todos", tags=["todos"])

# 매번 Depends(get_db) 를 적는 대신 별칭 타입으로 재사용.
DbSession = Annotated[Session, Depends(get_db)]


@router.get("", response_model=list[TodoPublic])
def list_todos(db: DbSession):
    return services.list_todos(db)


@router.get("/{todo_id}", response_model=TodoPublic)
def get_todo(todo_id: int, db: DbSession):
    return services.get_todo(db, todo_id)


@router.post("", response_model=TodoPublic, status_code=status.HTTP_201_CREATED)
def create_todo(payload: TodoCreate, db: DbSession):
    return services.create_todo(db, payload)


@router.patch("/{todo_id}", response_model=TodoPublic)
def update_todo(todo_id: int, payload: TodoUpdate, db: DbSession):
    return services.update_todo(db, todo_id, payload)


@router.delete("/{todo_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_todo(todo_id: int, db: DbSession):
    services.delete_todo(db, todo_id)
    # 204 No Content → 본문 없이 응답
