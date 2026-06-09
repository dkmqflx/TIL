"""
Week 3 — Pydantic & 응답 설계 종합 예제

구조 (APIRouter 로 도메인 분리)
    code/
    ├── main.py        ← 여기 (include_router)
    ├── schemas.py     ← Pydantic 모델
    └── routers/
        └── users.py   ← /users 라우터 (response_model 사용)

실행
----
   uv add fastapi "uvicorn[standard]"
   cd code
   uv run uvicorn main:app --reload
   http://127.0.0.1:8000/docs

확인 포인트
-----------
   # 회원 생성 — 응답에 password 가 '없는' 것을 확인!
   curl -i -X POST http://127.0.0.1:8000/users \
     -H "Content-Type: application/json" \
     -d '{"username": "민수", "email": "a@b.com", "password": "secret12"}'

   # 검증 실패 예시 — 숫자 없는 비밀번호 → 422
   curl -i -X POST http://127.0.0.1:8000/users \
     -H "Content-Type: application/json" \
     -d '{"username": "민수", "email": "a@b.com", "password": "noDigits"}'
"""

from fastapi import FastAPI

from routers import users

app = FastAPI(title="Week 3 — Pydantic & Response")

app.include_router(users.router)


@app.get("/")
def root():
    return {"message": "Week 3 — /docs 에서 /users API 를 눌러보세요"}
