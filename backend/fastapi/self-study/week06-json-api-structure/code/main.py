"""FastAPI 앱 진입점.

- 라우터 등록 (include_router)
- 전역 예외 핸들러 등록 (@app.exception_handler)

실행 방법 (uv):
    uv init                       # 처음 한 번 (pyproject.toml 생성)
    uv add fastapi "uvicorn[standard]" sqlalchemy pydantic-settings
    uv add --dev pytest httpx     # 테스트용
    uv run uvicorn main:app --reload

    # 문서: http://127.0.0.1:8000/docs
    # 테스트: uv run pytest
"""

from fastapi import FastAPI, Request, status
from fastapi.responses import JSONResponse

from database import engine
from exceptions import TodoNotFoundError
from models import Base
from routers import todos
from settings import settings

# 데모용: 앱 시작 시 테이블 생성(실무에서는 Alembic 마이그레이션 사용).
Base.metadata.create_all(bind=engine)

app = FastAPI(title=settings.app_name)

app.include_router(todos.router)


@app.exception_handler(TodoNotFoundError)
async def todo_not_found_handler(request: Request, exc: TodoNotFoundError):
    """도메인 예외 → 일관된 에러 JSON(404)로 변환하는 전역 핸들러.

    서비스가 던진 TodoNotFoundError 를 앱 어디서든 같은 형태로 받아 준다.
    """
    return JSONResponse(
        status_code=status.HTTP_404_NOT_FOUND,
        content={
            "error": "todo_not_found",
            "message": f"id={exc.todo_id} 인 할 일을 찾을 수 없습니다.",
        },
    )


@app.get("/health", tags=["meta"])
def health():
    return {"status": "ok"}
