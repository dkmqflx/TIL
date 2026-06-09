"""DB 엔진 + 세션 의존성(get_db).

SQLAlchemy 2.0 스타일. 실행 편의를 위해 파일 기반 SQLite를 사용한다.
(별도 DB 설치 없이 바로 돌아가도록 sqlite:///./test.db 사용.
 PostgreSQL로 바꾸려면 DATABASE_URL을 postgresql+psycopg://... 로 두면 된다.)
"""

from collections.abc import Generator

from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

from settings import settings

# SQLite는 기본적으로 한 스레드에서만 커넥션을 쓰도록 막혀 있어
# FastAPI(여러 스레드)에서 쓰려면 check_same_thread=False 가 필요하다.
# (PostgreSQL 등 다른 DB에서는 이 옵션이 필요 없다.)
connect_args = (
    {"check_same_thread": False}
    if settings.database_url.startswith("sqlite")
    else {}
)

engine = create_engine(settings.database_url, connect_args=connect_args)

SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False)


def get_db() -> Generator[Session, None, None]:
    """요청마다 DB 세션을 하나 열어 주입하고, 끝나면 반드시 닫는 yield 의존성.

    yield 위쪽 = '셋업'(세션 열기), yield 아래쪽 = '정리'(세션 닫기).
    예외가 나도 finally 덕분에 세션은 항상 닫힌다.
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
