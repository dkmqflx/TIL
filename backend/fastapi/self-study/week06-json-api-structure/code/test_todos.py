"""pytest 입문 — TestClient 로 첫 API 테스트.

실행:
    uv add --dev pytest httpx
    uv run pytest -v

여기서는 간단히 앱의 실제 DB(SQLite)를 그대로 쓴다.
(테스트 전용 DB 분리 / fixture(conftest.py) 는 Week 10에서 심화한다.)
"""

from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_list_todos_returns_200():
    res = client.get("/todos")
    assert res.status_code == 200
    assert isinstance(res.json(), list)


def test_create_todo_returns_201():
    res = client.post("/todos", json={"title": "pytest 배우기"})
    assert res.status_code == 201

    body = res.json()
    assert body["title"] == "pytest 배우기"
    assert body["done"] is False
    assert "id" in body


def test_get_missing_todo_returns_404():
    res = client.get("/todos/999999")
    assert res.status_code == 404
    assert res.json()["error"] == "todo_not_found"
