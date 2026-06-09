"""Pydantic v2 스키마 (요청/응답 DTO).

- TodoCreate : 생성 요청 본문 (POST)
- TodoUpdate : 부분 수정 요청 본문 (PATCH) — 모든 필드 Optional
- TodoPublic : 응답 모델 — ORM 객체를 그대로 직렬화하기 위해
               ConfigDict(from_attributes=True) 를 켠다.
"""

from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field


class TodoCreate(BaseModel):
    title: str = Field(min_length=1, max_length=100)
    done: bool = False


class TodoUpdate(BaseModel):
    # PATCH(부분 수정): 보낸 필드만 바꾼다 → 전부 Optional + 기본값 None
    title: str | None = Field(default=None, min_length=1, max_length=100)
    done: bool | None = None


class TodoPublic(BaseModel):
    # from_attributes=True : dict 뿐 아니라 '속성 접근(todo.id, todo.title)'으로도
    # 값을 읽어 모델을 만들 수 있게 한다 → SQLAlchemy ORM 객체를 그대로 응답 가능.
    model_config = ConfigDict(from_attributes=True)

    id: int
    title: str
    done: bool
    created_at: datetime
