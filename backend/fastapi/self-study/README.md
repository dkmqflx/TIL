# FastAPI 백엔드 개발자 되기 — 10주 셀프 스터디

> 프론트엔드(React/NestJS) 개발자가 **실무에 필요한 지식을 갖춘 FastAPI 백엔드 개발자**로 전환하기 위한 갭 중심 커리큘럼.

이 폴더는 단순 강의 따라하기가 아니라, **이미 아는 것은 압축하고 / 부족한 핵심에 집중**하도록 4개의 FastAPI 커리큘럼을 종합해 재구성한 학습 자료입니다.

---

## 🎯 목표와 전제

- **목표**: JSON REST API를 설계·구현하고, 비동기·인증·테스트·배포까지 다루는 실무형 백엔드 개발자
- **이미 아는 것 (압축 대상)**: 기본 라우팅, 단순 CRUD, REST 감각, NestJS의 DI/모듈/데코레이터
- **집중 영역 (⭐)**: async 내부 동작, SQLAlchemy 심화, 인증/인가, 실시간·이벤트, 테스트, 배포
- **DB**: PostgreSQL · **캐시/세션**: Redis · 둘 다 **Docker**로 구동
- **관점**: 가능한 모든 곳에서 **NestJS ↔ FastAPI 비교**로 빠른 전이 학습

---

## 🛠 개발 환경 / 툴링

| 항목 | 선택 | 비고 |
|------|------|------|
| 언어 | **Python 3.12** | |
| 패키지 관리 | **uv** | 프론트의 npm/lockfile 경험과 가장 유사, 매우 빠름 |
| 웹 프레임워크 | **FastAPI + Uvicorn** | |
| DB | **PostgreSQL** (Docker) | 동기 `psycopg` → 비동기 `asyncpg` |
| 캐시/세션/PubSub | **Redis** (Docker) | |
| ORM / 마이그레이션 | **SQLAlchemy 2.0** / **Alembic** | |
| 테스트 | **pytest** + httpx TestClient | |
| 린트/포맷 | **ruff** | |
| 컨테이너 | **Docker / docker compose** | |

---

## 🗂 폴더 구조

```
backend/fastapi/self-study/
├── README.md                       # (이 파일) 계획표 + 인덱스 + 진행 체크리스트
├── index.html                      # 풍부한 시각화 랜딩 페이지
├── assets/
│   └── style.css                   # 모든 .html이 공유하는 디자인 시스템
│
├── week01-overview-typehints/
│   ├── 01-msa-client-server-rest.html
│   ├── 02-python-typehints.html
│   ├── 03-fastapi-flow-swagger-curl.html
│   └── code/                       # uv로 바로 실행 가능한 예제
│
├── week02-request-http/  …  week10-test-deploy/
│
└── capstone/
    └── app/                        # ToDo→Blog JSON API (5주부터 점진적 누적)
```

- **한 토픽 = 한 `.html` 파일** (TIL의 "one file per topic" 규칙을 HTML로 적용)
- **코드 예제**: 각 주차 `code/`에 실행 가능한 `.py`. 5주부터는 `capstone/`에 실제 API를 누적 → **포트폴리오 제출용 결과물**
- GitHub은 `.html`을 렌더링하지 않음 → **로컬 브라우저로 열어 학습** (추후 GitHub Pages 연결 가능)

---

## 📄 강의 자료(HTML) 작성 원칙

각 `.html` 페이지는 **비유 + 시각화로 직관적 이해**를 최우선으로 합니다.

1. **한 줄 요약** — 이 페이지에서 무엇을 얻는가
2. **왜 필요한가 (실무 맥락)** — 현업에서 언제 쓰이나
3. **🍔 비유 패널** — 어려운 개념을 일상 비유로
4. **시각화** — 인라인 SVG 다이어그램 / CSS 흐름도 / 시퀀스 그림
5. **핵심 개념 + 코드** — 실행 가능한 최소 예제
6. **🔁 NestJS 비교 패널** — 좌(Nest) / 우(FastAPI) 2단 (해당 시)
7. **⚠️ 함정 & 실무 팁** — 경고 박스
8. **✅ 셀프 체크** — 면접식 질문 2~3개 (아코디언)
9. **🔗 참고 링크**

> 공통 `assets/style.css`로 색상·컴포넌트(비유 박스, 경고 박스, 비교 패널, 코드 블록)를 통일.

---

## 📚 10주 커리큘럼

⭐ = 실무/취업 가치가 특히 높은 핵심 영역

### Week 1 — 큰 그림 & 타입힌트
- `01` MSA 속 FastAPI의 위치 · 클라이언트-서버 모델 · API · REST API 개념
- `02` Python 타입 힌트 기본/고급 **(↔ TypeScript 타입 비교)**
- `03` FastAPI 동작 흐름 · Swagger/Redoc · cURL로 API 테스트

### Week 2 — Request & HTTP
- `01` Path / Query / Body / Header / Cookie / Form 파라미터 완전 정리
- `02` HTTP 메서드 & 상태 코드 설계
- `03` 예외 처리 기본 · HTTPException

### Week 3 — Pydantic & 응답 설계
- `01` Pydantic 모델 기초 · 중첩 모델 · Field · 커스텀 validator **(↔ class-validator)**
- `02` ⭐ `response_model` & Response 클래스 (직렬화 · JSONResponse/ORJSONResponse)
- `03` APIRouter로 도메인별 모듈 분할 **(↔ Nest Module)**

### Week 4 — ⭐ 비동기 원리 & 내부 동작
- `01` 동기/비동기 함수 · 멀티태스킹 방식 · asyncio · Event Loop
- `02` FastAPI의 async/await 처리 · ThreadPool 함정 (sync 함수 주의)
- `03` 멀티프로세스 구동 · Uvicorn / Starlette / FastAPI 역할 분리

### Week 5 — PostgreSQL & SQLAlchemy (동기)
- `01` Docker Compose로 PostgreSQL 띄우기 · DB 연결
- `02` SQLAlchemy 2.0 ORM 모델링 · DDL
- `03` Connection Pool 메커니즘 · Session · fetch/Row · bind 변수

### Week 6 — ⭐ JSON API 구축 & 구조화
- `01` ToDo/Blog REST API 명세 · CRUD 구현
- `02` Dependency Injection **(↔ Nest Provider)** · 서비스 계층 MVC 리팩터링
- `03` Exception Handler · dotenv 설정 · **pytest 입문**

### Week 7 — 비동기 DB & 외부 통신
- `01` 비동기 SQLAlchemy (asyncpg) · async Session · Lifespan
- `02` 외부 API 요청 (httpx async client)
- `03` CORS · 미들웨어

### Week 8 — ⭐ 인증 / 인가
- `01` JWT · OAuth2PasswordBearer · 패스워드 해싱
- `02` 의존성 기반 권한 처리 **(↔ Nest Guard)** · Redis 세션/캐시
- `03` OTP 생성·검증 API · Background Tasks (회원가입 알림 등)

### Week 9 — ⭐ 실시간 & 이벤트 & 성능
- `01` WebSocket 실시간 통신
- `02` 메시지 브로커 · Redis Pub/Sub (이벤트 기반)
- `03` 동기/비동기 성능 테스트 & 개선

### Week 10 — 테스트 심화 & 배포
- `01` pytest 심화 · Mocking · Fixture · TestClient (CRUD별 테스트)
- `02` Alembic 마이그레이션
- `03` Docker 프로덕션 빌드 · GitHub Actions CI · 회고 & 다음 로드맵

---

## ✅ 진행 체크리스트

- [ ] Week 1 — 큰 그림 & 타입힌트
- [ ] Week 2 — Request & HTTP
- [ ] Week 3 — Pydantic & 응답 설계
- [ ] Week 4 — 비동기 원리 & 내부 동작
- [ ] Week 5 — PostgreSQL & SQLAlchemy
- [ ] Week 6 — JSON API 구축 & 구조화
- [ ] Week 7 — 비동기 DB & 외부 통신
- [ ] Week 8 — 인증 / 인가
- [ ] Week 9 — 실시간 & 이벤트 & 성능
- [ ] Week 10 — 테스트 심화 & 배포
