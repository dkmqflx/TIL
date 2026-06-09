"""SQLAlchemy 2.0 ORM 모델 (Week 5에서 만든 Todo 테이블).

Mapped / mapped_column 을 쓰는 2.0 선언형 스타일.
"""

from datetime import datetime

from sqlalchemy import func
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column


class Base(DeclarativeBase):
    """모든 모델의 베이스. metadata.create_all 로 테이블을 만든다."""


class Todo(Base):
    __tablename__ = "todos"

    id: Mapped[int] = mapped_column(primary_key=True)
    title: Mapped[str] = mapped_column(index=True)
    done: Mapped[bool] = mapped_column(default=False)
    created_at: Mapped[datetime] = mapped_column(server_default=func.now())
