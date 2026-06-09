"""
Week 3 — users 도메인 라우터 (APIRouter)

response_model=UserPublic 덕분에, 함수가 password를 포함한 dict를 반환해도
실제 응답에는 password가 빠진다 (출국 검색대).
"""

from fastapi import APIRouter, HTTPException, status

from schemas import UserCreate, UserPublic

router = APIRouter(prefix="/users", tags=["users"])

# 인메모리 저장소 (실DB는 Week 5)
_users: dict[int, dict] = {}
_next_id = 1


@router.post("", response_model=UserPublic, status_code=status.HTTP_201_CREATED)
def create_user(user: UserCreate):
    global _next_id
    # password 를 포함한 dict 를 저장하지만...
    saved = {"id": _next_id, **user.model_dump()}
    _users[_next_id] = saved
    _next_id += 1
    return saved  # response_model 이 password 를 걸러 내보낸다


@router.get("/{user_id}", response_model=UserPublic)
def get_user(user_id: int):
    if user_id not in _users:
        raise HTTPException(status.HTTP_404_NOT_FOUND, f"id={user_id} 회원 없음")
    return _users[user_id]
