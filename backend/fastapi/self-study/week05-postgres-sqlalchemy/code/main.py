"""Week 5 데모 — PostgreSQL + SQLAlchemy 2.0 + FastAPI.

실행 방법
=========
1) DB 띄우기 (이 폴더에서):
       docker compose up -d

2) 의존성 설치 (uv 사용):
       uv init                         # 아직 프로젝트가 아니라면
       uv add fastapi "uvicorn[standard]" sqlalchemy "psycopg[binary]"
   # 참고: psycopg(v3)는 시스템 libpq가 없어도 되도록 [binary] 옵션을 권장한다.
   #       서버 환경에서 직접 빌드한다면 그냥 `psycopg` 만 써도 된다.

3) 서버 실행:
       uv run uvicorn main:app --reload

4) 확인:
       http://localhost:8000/todos       (GET, 빈 배열로 시작)
       http://localhost:8000/docs        (Swagger UI에서 POST로 데이터 추가)

5) 정리:
       docker compose down -v
"""

from collections.abc import AsyncIterator
from contextlib import asynccontextmanager
from datetime import datetime

from fastapi import Depends, FastAPI
from pydantic import BaseModel, ConfigDict, Field
from sqlalchemy import select
from sqlalchemy.orm import Session

from database import engine, get_db
from models import Base, Todo


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    # 시작 시 테이블을 생성한다(DDL). 데모 편의용.
    # 실무에서는 Week 10의 Alembic 마이그레이션으로 대체한다.
    Base.metadata.create_all(engine)
    yield


app = FastAPI(title="Week 5 · PostgreSQL & SQLAlchemy", lifespan=lifespan)


# ---- Pydantic v2 스키마 -------------------------------------------------

class TodoCreate(BaseModel):
    title: str = Field(min_length=1, max_length=100)
    done: bool = False


class TodoOut(BaseModel):
    # from_attributes=True: ORM 객체(속성 접근)를 그대로 직렬화할 수 있게 한다.
    # (Pydantic v1의 orm_mode 가 v2에서는 이 이름으로 바뀌었다.)
    model_config = ConfigDict(from_attributes=True)

    id: int
    title: str
    done: bool
    created_at: datetime


# ---- 라우트 -------------------------------------------------------------

@app.get("/todos", response_model=list[TodoOut])
def list_todos(db: Session = Depends(get_db)) -> list[Todo]:
    # 2.0 스타일 조회: select() + scalars()로 ORM 객체 리스트를 받는다.
    stmt = select(Todo).order_by(Todo.id)
    return db.scalars(stmt).all()


@app.post("/todos", response_model=TodoOut, status_code=201)
def create_todo(payload: TodoCreate, db: Session = Depends(get_db)) -> Todo:
    todo = Todo(title=payload.title, done=payload.done)
    db.add(todo)
    db.commit()
    db.refresh(todo)  # DB가 채운 id, created_at을 객체에 다시 채운다
    return todo
