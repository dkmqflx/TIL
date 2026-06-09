"""SQLAlchemy 2.0 스타일 ORM 모델.

- DeclarativeBase 를 상속한 Base 클래스가 모든 모델의 부모.
- Mapped[...] 타입 힌트 + mapped_column() 으로 컬럼을 선언한다 (2.0 스타일).
- 클래스 1개 = 테이블 1개, 인스턴스 1개 = 행(row) 1개.
"""

from datetime import datetime, timezone

from sqlalchemy import String, func
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column


class Base(DeclarativeBase):
    """모든 ORM 모델의 베이스. metadata가 여기에 모인다."""


class Todo(Base):
    __tablename__ = "todos"

    # 기본키(PK). 정수 자동 증가.
    id: Mapped[int] = mapped_column(primary_key=True)

    # 최대 100자, 비어 있을 수 없음(nullable=False가 기본).
    title: Mapped[str] = mapped_column(String(100), index=True)

    # 완료 여부. 기본값 False.
    done: Mapped[bool] = mapped_column(default=False)

    # 생성 시각. DB 서버가 채우게 하는 server_default(func.now())를 쓴다.
    # (datetime.utcnow는 3.12+에서 deprecated이므로 피한다.)
    created_at: Mapped[datetime] = mapped_column(
        server_default=func.now(),
    )

    def __repr__(self) -> str:
        return f"Todo(id={self.id!r}, title={self.title!r}, done={self.done!r})"
