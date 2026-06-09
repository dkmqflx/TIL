"""
Week 8 — 인증 / 인가 종합 예제 (단일 파일, 실행 가능)

담은 것
    - 패스워드 해싱 (pwdlib[bcrypt]) — hash / verify
    - POST /token   : OAuth2 Password Flow 로 로그인 → JWT 발급
    - get_current_user 의존성 : Bearer 토큰 검증 → 유저 주입
    - GET /me       : 보호된 라우트 (로그인해야 접근 가능)
    - POST /signup  : BackgroundTasks 로 '환영 메일 발송'을 응답 후 처리

    ※ Redis / OTP 는 별도 서버가 필요해 이 단일 파일 예제에서는 제외했다.
      (레슨 02·03 HTML 의 코드 스니펫 참고)
    ※ 유저 저장소는 메모리(dict) 다. 실제 DB 연동은 Week 5/6 에서 다룬다.

설치 & 실행 (uv)
----------------
    uv add fastapi "uvicorn[standard]" pyjwt "pwdlib[bcrypt]" python-multipart
    #                                  └ JWT   └ 해싱          └ /token 폼 파싱에 필수!
    cd code
    uv run uvicorn main:app --reload
    http://127.0.0.1:8000/docs   ← 우측 상단 자물쇠(Authorize)로 로그인 후 /me 테스트

빠른 확인 (curl)
----------------
    # 1) 로그인 → 토큰 받기  (seed 계정: alice / secret123)
    curl -s -X POST http://127.0.0.1:8000/token \
      -d "username=alice&password=secret123"
    # → {"access_token":"eyJ...","token_type":"bearer"}

    # 2) 받은 토큰으로 보호된 /me 호출
    TOKEN="<위에서 받은 access_token>"
    curl -s http://127.0.0.1:8000/me -H "Authorization: Bearer $TOKEN"
    # → {"username":"alice","role":"user"}

    # 3) 토큰 없이 /me → 401
    curl -i http://127.0.0.1:8000/me
"""

from __future__ import annotations

from datetime import datetime, timedelta, timezone

import jwt  # PyJWT
from fastapi import BackgroundTasks, Depends, FastAPI, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from pwdlib import PasswordHash
from pwdlib.hashers.bcrypt import BcryptHasher
from pydantic import BaseModel

# ---------------------------------------------------------------------------
# 설정
# ---------------------------------------------------------------------------
# ⚠️ 프로덕션에선 환경변수/시크릿 매니저로 주입한다. 절대 소스에 커밋하지 말 것!
SECRET_KEY = "dev-only-change-me-please-use-env-in-prod"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

password_hash = PasswordHash((BcryptHasher(),))
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

app = FastAPI(title="Week 8 — Auth")


# ---------------------------------------------------------------------------
# 비밀번호 해싱
# ---------------------------------------------------------------------------
def hash_password(raw: str) -> str:
    return password_hash.hash(raw)


def verify_password(raw: str, hashed: str) -> bool:
    return password_hash.verify(raw, hashed)


# ---------------------------------------------------------------------------
# 메모리 유저 저장소 (실제 DB 연동은 Week 5/6)
#   - 평문 비밀번호는 어디에도 저장하지 않는다. 가입 시점에 즉시 해싱한다.
# ---------------------------------------------------------------------------
class User(BaseModel):
    username: str
    role: str
    hashed_password: str


_USERS: dict[str, User] = {}


def _seed_user(username: str, password: str, role: str = "user") -> None:
    _USERS[username] = User(
        username=username,
        role=role,
        hashed_password=hash_password(password),  # 해시만 저장
    )


# 데모용 시드 계정
_seed_user("alice", "secret123", role="user")
_seed_user("admin", "admin123", role="admin")


def get_user(username: str) -> User | None:
    return _USERS.get(username)


# ---------------------------------------------------------------------------
# JWT 발급 / 검증
# ---------------------------------------------------------------------------
def create_access_token(sub: str) -> str:
    payload = {
        "sub": sub,
        "exp": datetime.now(timezone.utc)
        + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES),
    }
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)


def get_current_user(token: str = Depends(oauth2_scheme)) -> User:
    """Bearer 토큰을 검증해 현재 유저를 반환한다. 실패하면 401."""
    cred_exc = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="인증 정보를 확인할 수 없습니다",
        headers={"WWW-Authenticate": "Bearer"},  # 표준 권장 헤더
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username = payload.get("sub")
    except jwt.ExpiredSignatureError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="토큰이 만료되었습니다",
            headers={"WWW-Authenticate": "Bearer"},
        )
    except jwt.InvalidTokenError:  # 서명 위변조 등
        raise cred_exc

    if username is None:
        raise cred_exc
    user = get_user(username)
    if user is None:
        raise cred_exc
    return user


def require_admin(user: User = Depends(get_current_user)) -> User:
    """인가(authorization) — admin 역할만 통과. 부족하면 403."""
    if user.role != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="관리자 권한이 필요합니다",
        )
    return user


# ---------------------------------------------------------------------------
# 라우트
# ---------------------------------------------------------------------------
@app.post("/token")
def login(form: OAuth2PasswordRequestForm = Depends()):
    """OAuth2 Password Flow — username/password 로 로그인하고 JWT 를 받는다."""
    user = get_user(form.username)
    if user is None or not verify_password(form.password, user.hashed_password):
        # 어떤 쪽이 틀렸는지 알려주지 않는다(계정 존재 여부 노출 방지).
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="아이디 또는 비밀번호가 올바르지 않습니다",
            headers={"WWW-Authenticate": "Bearer"},
        )
    token = create_access_token(sub=user.username)
    return {"access_token": token, "token_type": "bearer"}


@app.get("/me")
def read_me(user: User = Depends(get_current_user)):
    """보호된 라우트 — 유효한 토큰이 있어야 도달한다. 비밀번호 해시는 노출하지 않는다."""
    return {"username": user.username, "role": user.role}


@app.get("/admin")
def admin_only(user: User = Depends(require_admin)):
    """인가 데모 — admin 역할만 접근 가능."""
    return {"message": f"환영합니다, 관리자 {user.username}님"}


def send_welcome_email(to: str) -> None:
    """느린 후처리 흉내. 실제로는 메일 서버 호출 등. (여기선 콘솔 출력만)"""
    # 데모이므로 출력만 한다. 실제 작업이라면 외부 메일 API 를 호출.
    print(f"[background] 환영 메일 발송 → {to}")


class SignupIn(BaseModel):
    username: str
    password: str


@app.post("/signup", status_code=status.HTTP_201_CREATED)
def signup(body: SignupIn, bg: BackgroundTasks):
    """가입 후 환영 메일 발송을 BackgroundTasks 로 넘긴다(응답 먼저 반환)."""
    if get_user(body.username) is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="이미 존재하는 사용자입니다",
        )
    _seed_user(body.username, body.password)  # 비밀번호는 즉시 해싱되어 저장
    bg.add_task(send_welcome_email, body.username)  # 등록만 — 응답 후 실행
    return {"username": body.username}


@app.get("/")
def root():
    return {"message": "Week 8 — /docs 에서 Authorize 후 /me, /admin 을 눌러보세요"}
