"""
Week 3 — Pydantic 모델 모음

핵심 패턴: 입력 모델(Create)과 출력 모델(Public)을 분리한다.
- UserCreate : 받을 때 (password 포함)
- UserPublic : 돌려줄 때 (password 없음 + id 추가)  → response_model 로 사용
"""

from pydantic import BaseModel, Field, field_validator


# === 받을 때 ===
class UserCreate(BaseModel):
    username: str = Field(min_length=2, max_length=20)
    email: str
    password: str = Field(min_length=8)

    @field_validator("password")
    @classmethod
    def password_has_digit(cls, v: str) -> str:
        if not any(c.isdigit() for c in v):
            raise ValueError("비밀번호에 숫자가 1개 이상 필요합니다")
        return v


# === 돌려줄 때 (password 없음!) ===
class UserPublic(BaseModel):
    id: int
    username: str
    email: str


# === 중첩 모델 예시 ===
class Author(BaseModel):
    name: str
    email: str


class Todo(BaseModel):
    id: int
    title: str = Field(min_length=1, max_length=50)
    priority: int = Field(default=1, ge=1, le=5)
    author: Author  # 중첩 — author 도 Author 규칙으로 검증된다
    tags: list[str] = []
