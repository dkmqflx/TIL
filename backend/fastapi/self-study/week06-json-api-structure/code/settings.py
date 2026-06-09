"""pydantic-settings 로 환경변수/.env 를 읽는 설정 객체.

⚠️ DATABASE_URL 같은 비밀값은 코드에 하드코딩하거나 git에 커밋하지 말 것.
   .env 파일에 두고, .env 는 .gitignore 에 등록한다.

.env 예시:
    DATABASE_URL=sqlite:///./test.db
    APP_NAME=Todo API
"""

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    # env 파일이 없으면 아래 기본값을 사용한다(로컬 SQLite).
    database_url: str = "sqlite:///./test.db"
    app_name: str = "Todo API"

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")


# 앱 전역에서 import 해서 쓰는 단일 설정 인스턴스.
settings = Settings()
