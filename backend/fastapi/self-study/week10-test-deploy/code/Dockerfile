# =============================================================================
# Dockerfile — uv 기반 멀티스테이지 빌드 (FastAPI 프로덕션 이미지)
# =============================================================================
# 목표: 빌드 도구(uv, 캐시)는 빌더 스테이지에만 두고, 최종 이미지에는
#       파이썬 슬림 베이스 + 만들어진 가상환경(.venv)만 복사해 경량화한다.
#
# 전제: pyproject.toml + uv.lock 이 프로젝트 루트에 있고, 앱 진입점은 main:app.
# 빌드:  docker build -t my-fastapi-app .
# 실행:  docker run -p 8000:8000 my-fastapi-app
# =============================================================================

# ---- 1) builder 스테이지: 의존성 설치 전용 -----------------------------------
FROM python:3.12-slim AS builder

# uv 정적 바이너리를 공식 이미지에서 그대로 가져온다 (별도 설치 단계 불필요)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# 바이트코드 컴파일 + 링크 모드(복사)로 재현성/속도 확보
ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy

# 락 파일만 먼저 복사 → 의존성 레이어 캐시 (소스만 바뀔 때 재설치 안 함)
COPY pyproject.toml uv.lock ./

# --frozen: uv.lock 그대로 설치(락 변경 금지), --no-dev: 개발 의존성 제외
# --no-install-project: 프로젝트 자체 코드는 아래에서 따로 복사
RUN uv sync --frozen --no-dev --no-install-project

# 애플리케이션 소스 복사 후 프로젝트 본체까지 설치 완료
COPY . .
RUN uv sync --frozen --no-dev


# ---- 2) final 스테이지: 실행 전용 (uv 없음, 복사만) --------------------------
FROM python:3.12-slim AS final

WORKDIR /app

# 빌더에서 만든 가상환경과 애플리케이션 코드만 가져온다
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app /app

# .venv 의 실행 파일을 PATH 앞에 둬서 uvicorn 등을 바로 쓸 수 있게 한다
ENV PATH="/app/.venv/bin:$PATH"

# 루트 대신 비특권 사용자로 실행 (보안 모범 사례)
RUN useradd --create-home appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

# uvicorn 으로 기동. (운영에서는 --workers N 또는 gunicorn+uvicorn worker 사용)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
