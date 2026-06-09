"""SQLAlchemy 2.0 — Engine + Session 설정.

핵심 개념
---------
- Engine: DB로 가는 "연결 공장 + Connection Pool". 앱당 1개만 만든다.
- sessionmaker: Session(작업 단위)을 찍어내는 틀.
- get_db: 요청 1건마다 Session을 빌려주고 끝나면 닫는 의존성(FastAPI Depends).

드라이버
--------
DATABASE_URL의 `postgresql+psycopg://...` 에서 `+psycopg` 가 psycopg(v3) 동기
드라이버를 가리킨다. 여기서는 create_engine(동기)을 쓰므로 동기 드라이버가 맞다.
"""

import os
from collections.abc import Iterator

from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

# 형식: postgresql+<드라이버>://<유저>:<비번>@<호스트>:<포트>/<DB명>
# 환경변수로 덮어쓸 수 있게 하되, 기본값은 docker-compose.yml과 동일하게 맞춘다.
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql+psycopg://todo:todo_pw@localhost:5432/todo_db",
)

# Engine 하나가 Connection Pool을 들고 있다. 풀 파라미터는 여기서 조정한다.
engine = create_engine(
    DATABASE_URL,
    pool_size=5,        # 평상시 유지하는 연결 수
    max_overflow=10,    # 몰릴 때 추가로 빌려줄 수 있는 한도
    pool_pre_ping=True, # 빌려주기 전 "살아있니?" ping (끊긴 연결 자동 폐기)
    echo=False,         # True로 켜면 실행되는 SQL이 로그에 찍힌다
)

# autoflush=False: commit/명시적 flush 시점에만 DB로 내보낸다.
# expire_on_commit=False: commit 후에도 객체 속성을 그대로 읽을 수 있게 한다.
SessionLocal = sessionmaker(
    bind=engine,
    autoflush=False,
    expire_on_commit=False,
    class_=Session,
)


def get_db() -> Iterator[Session]:
    """요청 단위로 Session을 빌려주고, 끝나면 반드시 닫는다."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
