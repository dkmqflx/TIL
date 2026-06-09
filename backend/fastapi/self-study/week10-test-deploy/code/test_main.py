"""
test_main.py — FastAPI TestClient + dependency_overrides 예제
============================================================

이 파일은 Week 10 Lesson 01(pytest 심화)에서 다루는 패턴을 실제로 보여주는
실행 가능한 예제입니다.

실행 방법
---------
    # 1) 의존성 설치 (예시)
    pip install fastapi "uvicorn[standard]" sqlalchemy pytest httpx
    # uv를 쓴다면:
    #   uv add fastapi "uvicorn[standard]" sqlalchemy pytest httpx
    #   uv run pytest -v

    # 2) 테스트 실행
    pytest -v test_main.py

핵심 포인트
----------
- TestClient 는 httpx 기반으로, 실제 서버를 띄우지 않고 ASGI 앱을 직접 호출한다.
- get_db 의존성을 dependency_overrides 로 "테스트용 sqlite DB" 로 교체한다.
- in-memory sqlite("sqlite://") 를 멀티 요청에서 공유하려면 StaticPool 이 필수다.
  (안 그러면 요청마다 새 커넥션 = 새 DB 가 되어 만든 테이블이 사라진다.)

이 예제는 한 파일에 앱(app)과 테스트를 함께 담았지만,
실무에서는 app 정의를 main.py 로 분리하고 fixture 는 conftest.py 로 옮긴다.
(conftest.py 예시는 파일 하단 주석 참고)
"""

import pytest
from fastapi import FastAPI, Depends, HTTPException
from fastapi.testclient import TestClient
from pydantic import BaseModel
from sqlalchemy import create_engine, Column, Integer, String, Boolean
from sqlalchemy.orm import declarative_base, sessionmaker, Session
from sqlalchemy.pool import StaticPool

# ---------------------------------------------------------------------------
# 1) 애플리케이션 코드 (실무에서는 main.py / database.py 로 분리)
# ---------------------------------------------------------------------------
Base = declarative_base()


class TodoORM(Base):
    __tablename__ = "todos"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    done = Column(Boolean, default=False)


# 운영용 엔진은 보통 PostgreSQL. 여기서는 데모를 위해 sqlite 파일을 가정한다.
prod_engine = create_engine("sqlite:///./app.db", connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(bind=prod_engine, autoflush=False)


def get_db():
    """운영용 DB 세션 의존성 — 테스트에서 override 된다."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


class TodoIn(BaseModel):
    title: str
    done: bool = False


class TodoPatch(BaseModel):
    title: str | None = None
    done: bool | None = None


app = FastAPI()


@app.post("/todos", status_code=201)
def create_todo(payload: TodoIn, db: Session = Depends(get_db)):
    todo = TodoORM(title=payload.title, done=payload.done)
    db.add(todo)
    db.commit()
    db.refresh(todo)
    return {"id": todo.id, "title": todo.title, "done": todo.done}


@app.get("/todos")
def list_todos(db: Session = Depends(get_db)):
    rows = db.query(TodoORM).all()
    return [{"id": r.id, "title": r.title, "done": r.done} for r in rows]


@app.get("/todos/{todo_id}")
def get_todo(todo_id: int, db: Session = Depends(get_db)):
    todo = db.get(TodoORM, todo_id)
    if todo is None:
        raise HTTPException(status_code=404, detail="todo not found")
    return {"id": todo.id, "title": todo.title, "done": todo.done}


@app.patch("/todos/{todo_id}")
def update_todo(todo_id: int, payload: TodoPatch, db: Session = Depends(get_db)):
    todo = db.get(TodoORM, todo_id)
    if todo is None:
        raise HTTPException(status_code=404, detail="todo not found")
    if payload.title is not None:
        todo.title = payload.title
    if payload.done is not None:
        todo.done = payload.done
    db.commit()
    db.refresh(todo)
    return {"id": todo.id, "title": todo.title, "done": todo.done}


@app.delete("/todos/{todo_id}", status_code=204)
def delete_todo(todo_id: int, db: Session = Depends(get_db)):
    todo = db.get(TodoORM, todo_id)
    if todo is None:
        raise HTTPException(status_code=404, detail="todo not found")
    db.delete(todo)
    db.commit()
    return None


# ---------------------------------------------------------------------------
# 2) 테스트용 DB + dependency_overrides (실무에서는 conftest.py 로 분리)
# ---------------------------------------------------------------------------
# in-memory sqlite 를 여러 요청에서 "같은 커넥션" 으로 공유하기 위한 핵심 설정:
#   - check_same_thread=False : TestClient 가 다른 스레드에서 커넥션을 써도 허용
#   - StaticPool              : 단 하나의 커넥션을 재사용 → 만든 테이블이 유지됨
test_engine = create_engine(
    "sqlite://",
    connect_args={"check_same_thread": False},
    poolclass=StaticPool,
)
TestingSessionLocal = sessionmaker(bind=test_engine, autoflush=False)


def override_get_db():
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()


@pytest.fixture
def client():
    """테스트마다 깨끗한 스키마를 만들고(setup), 끝나면 지운다(teardown)."""
    Base.metadata.create_all(bind=test_engine)        # setup: 테이블 생성
    app.dependency_overrides[get_db] = override_get_db  # get_db → 테스트 DB 로 교체
    with TestClient(app) as c:
        yield c
    app.dependency_overrides.clear()                   # teardown: override 해제
    Base.metadata.drop_all(bind=test_engine)           # teardown: 테이블 제거


# ---------------------------------------------------------------------------
# 3) CRUD 별 API 테스트 — 상태코드 + 응답 본문을 모두 assert
# ---------------------------------------------------------------------------
def test_create_todo(client):
    res = client.post("/todos", json={"title": "장보기"})
    assert res.status_code == 201
    body = res.json()
    assert body["title"] == "장보기"
    assert body["done"] is False
    assert "id" in body


def test_list_todos(client):
    client.post("/todos", json={"title": "할 일 1"})
    client.post("/todos", json={"title": "할 일 2"})
    res = client.get("/todos")
    assert res.status_code == 200
    assert len(res.json()) == 2


def test_get_todo(client):
    created = client.post("/todos", json={"title": "운동"}).json()
    res = client.get(f"/todos/{created['id']}")
    assert res.status_code == 200
    assert res.json()["title"] == "운동"


def test_get_todo_not_found(client):
    res = client.get("/todos/9999")
    assert res.status_code == 404
    assert res.json()["detail"] == "todo not found"


def test_update_todo(client):
    created = client.post("/todos", json={"title": "독서"}).json()
    res = client.patch(f"/todos/{created['id']}", json={"done": True})
    assert res.status_code == 200
    assert res.json()["done"] is True
    assert res.json()["title"] == "독서"  # title 은 그대로 유지


def test_delete_todo(client):
    created = client.post("/todos", json={"title": "삭제 대상"}).json()
    res = client.delete(f"/todos/{created['id']}")
    assert res.status_code == 204
    # 삭제 후 조회하면 404
    assert client.get(f"/todos/{created['id']}").status_code == 404


# ---------------------------------------------------------------------------
# 4) Mocking 예제 — 외부 의존성(외부 API 호출)을 monkeypatch 로 가짜 응답으로 격리
# ---------------------------------------------------------------------------
def call_weather_api(city: str) -> dict:
    """실제로는 외부 HTTP 요청을 보내는 함수라고 가정.
    테스트에서는 이 함수를 monkeypatch 로 가짜(Mock)로 갈아끼운다."""
    raise RuntimeError("실제 외부 API 호출 — 테스트에서는 호출되면 안 됨")


def summarize_weather(city: str) -> str:
    data = call_weather_api(city)
    return f"{city}: {data['temp']}도, {data['desc']}"


def test_summarize_weather_with_mock(monkeypatch):
    # 외부 API 대신 가짜 응답을 주는 "대역 배우"를 주입한다.
    def fake_api(city: str) -> dict:
        return {"temp": 21, "desc": "맑음"}

    monkeypatch.setattr(__name__ + ".call_weather_api", fake_api)
    # 같은 모듈 안에서 호출되므로 globals 를 직접 패치하는 방식도 가능:
    monkeypatch.setitem(globals(), "call_weather_api", fake_api)

    assert summarize_weather("서울") == "서울: 21도, 맑음"


# ---------------------------------------------------------------------------
# conftest.py 로 분리할 때 (참고)
# ---------------------------------------------------------------------------
# 여러 테스트 파일이 client/test DB fixture 를 공유하려면, 위 2)~ 의
# fixture 정의를 conftest.py 로 옮기면 된다. pytest 는 conftest.py 의
# fixture 를 같은 디렉터리(및 하위)의 모든 test_*.py 에서 자동으로 인식한다.
#
#   # conftest.py
#   import pytest
#   from fastapi.testclient import TestClient
#   from main import app, get_db, Base
#   ...
#   @pytest.fixture
#   def client():
#       ...   # 위와 동일
