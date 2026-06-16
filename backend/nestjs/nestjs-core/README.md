# NestJS 코어 마스터하기 — 12주 셀프 스터디

> React/프론트엔드 출신 개발자가 **NestJS로 REST API 백엔드(인스타그램 SNS 컨셉)를 설계·구현**하는 데 필요한 코어 기능 전반을 직관적으로 학습하는 커리큘럼.

이 폴더는 단순 강의 따라하기가 아니라, **이미 아는 것은 압축하고 / 부족한 핵심(★)에 집중**하도록 인프런 NestJS 마스터 클래스(Part 1) 커리큘럼을 큐레이션·재구성한 학습 자료입니다.

---

## 🎯 목표와 전제

- **목표**: NestJS로 REST API를 설계·구현하고, DI/TypeORM·인증·Guard/Pipe·페이지네이션·WebSocket까지 다루는 실무형 백엔드 개발자
- **학습자 가정**: React 경험 + NestJS 기본(데코레이터/모듈) 개념을 **약간** 아는 상태 (FastAPI 자료와 동일 인물)
- **압축 대상**: 기본 컨트롤러/라우팅, 단순 CRUD, REST 감각, 순수 툴링(환경설정·PgAdmin·Postman·디버거)
- **★ 확장 영역**: DI/IoC 내부, TypeORM 이론·관계, 인증/인가, 요청 파이프라인(Guard/Pipe/Decorator), 페이지네이션 일반화, 트랜잭션/인터셉터, 횡단 관심사, 실시간(WebSocket), RBAC, 팔로우 시스템
- **DB**: PostgreSQL · **컨테이너**: Docker / Docker Compose

---

## 🗂 폴더 구조

```
backend/nestjs/nestjs-core/
├── README.md                       # (이 파일) 계획표 + 인덱스 + 진행 체크리스트
├── index.html                      # 시각화 랜딩 페이지
├── assets/
│   └── style.css                   # 모든 .html이 공유하는 디자인 시스템 (fastapi 그대로)
│
├── week01-overview-architecture/
│   ├── 01-*.html  02-*.html  03-*.html
│   └── code/                       # 실행 가능한 최소 NestJS 예제
│
├── week02-controller-request/  …  week12-realtime-rbac-sns/
```

- **한 토픽 = 한 `.html` 파일** (TIL의 "one file per topic" 규칙을 HTML로 적용)
- **코드 예제**: 각 주차 `code/`에 실행 가능한 핵심 파일만 (전체 누적 프로젝트 아님)
- GitHub은 `.html`을 렌더링하지 않음 → **로컬 브라우저로 열어 학습** (추후 GitHub Pages 연결 가능)

---

## 📄 HTML 작성 원칙

각 `.html` 페이지는 **비유 + 시각화로 직관적 이해**를 최우선으로 합니다.

1. **한 줄 요약** — 이 페이지에서 무엇을 얻는가
2. **왜 필요한가 (실무 맥락)** — 현업에서 언제 쓰이나
3. **🍔 비유 패널** — 어려운 개념을 일상 비유로
4. **시각화** — 인라인 SVG 다이어그램 / CSS 흐름도 / 시퀀스 그림
5. **핵심 개념 + 코드** — 실행 가능한 최소 예제
6. **⚠️ 함정 & 실무 팁** — 경고 박스
7. **✅ 셀프 체크** — 면접식 질문 2~3개 (아코디언)
8. **🔗 참고 링크**

> **비교 패널 없음**: FastAPI 자료에 있던 좌(Nest)/우(FastAPI) 2단 `.compare` 패널은 **이 사이트에서 사용하지 않는다**. 비교 패널이 빠진 만큼 **비유 박스와 SVG 다이어그램을 더 적극 활용**한다.

> 공통 `assets/style.css`로 색상·컴포넌트(비유 박스, 경고 박스, 코드 블록)를 통일.

---

## 📚 12주 커리큘럼

★ = 실무/취업 가치가 특히 높은 확장 영역. 괄호는 인프런 원본 섹션/주제 출처.

### Week 1 — 큰 그림 & NestJS 아키텍처
- `01` 백엔드 지도: Node.js·HTTP·클라이언트-서버·REST (압축) — (이론1, 섹션3)
- `02` 왜 NestJS는 Express를 감싸나: raw HTTP → Express → Nest 계층 — (섹션3)
- `03` 프로젝트 셋업 · 인스타그램 SNS 컨셉 · Request Life Cycle — (섹션2,4,5)

### Week 2 — Controller · 라우팅 · 요청 데이터
- `01` Controller & 데코레이터 라우팅 (GET/POST/PATCH/DELETE, Path) — (섹션5)
- `02` Query · Param · Body — 요청 데이터 받기, REST API 세트 — (섹션6)
- `03` 기본 CRUD 엔드포인트 + 내장 Exception(NotFound 등) — (섹션6)

### Week 3 — ★ Service · Module · Provider · DI/IoC
- `01` Service로 로직 분리 (계층 분리) — (섹션7)
- `02` Dependency Injection & Inversion of Control 원리 — (섹션8)
- `03` Module/Provider 코드로 이해 · AppModule · main.ts — (섹션8)

### Week 4 — SQL · Docker · TypeORM 시작
- `01` SQL 기본기 + Docker/Docker Compose로 PostgreSQL 띄우기 — (섹션9)
- `02` NestJS+TypeORM 설정 · Entity로 테이블 생성 · Repository 주입 — (섹션10)
- `03` Find / FindOne / Create / Save / Delete — Repository 기본 — (섹션10)

### Week 5 — ★ TypeORM 심화 이론
- `01` Column 데코레이터/옵션 · Enum · Entity Embedding — (섹션11)
- `02` Table Inheritance · BaseModel 상속(createdAt/updatedAt) — (섹션11,16)
- `03` FindManyOptions · TypeORM 유틸리티(연산자) · 흔히 쓰는 메서드 — (섹션11)

### Week 6 — ★ Table Relations (관계)
- `01` 관계 이론 + SQL Relations(FK·JOIN) — (섹션12, 주제64)
- `02` 1:1 / N:1 / 1:N / N:M 관계 TypeORM 구현 — (섹션12)
- `03` Relation Options(cascade·eager) · Relation 포함 쿼리 · Author Relation 적용 — (섹션12, 주제69-72)

### Week 7 — ★ Authentication (인증)
- `01` Session vs JWT · Access/Refresh Token 이론 · 암호화(해싱) — (섹션14)
- `02` 회원가입/로그인 로직 · 토큰 signing · 엔드포인트 — (섹션14)
- `03` 헤더에서 토큰 추출 · 토큰 재발급(refresh) 로직 — (섹션14)

### Week 8 — ★ Guard · Pipe · Custom Decorator (요청 파이프라인)
- `01` Pipe — ParseIntPipe · Custom Pipe · DefaultValuePipe · 다중 파이프 — (섹션15)
- `02` Guard — BasicTokenGuard · BearerTokenGuard · AccessTokenGuard 적용 — (섹션18,19)
- `03` Custom Decorator — `@User` 데코레이터 · `data` 파라미터 — (섹션19)

### Week 9 — DTO 검증·변환 (Class Validator & Transformer)
- `01` Class Validator + DTO · 에러 메시지 · PickType · IsOptional — (섹션21)
- `02` Validation Message 일반화 — (섹션21)
- `03` Class Transformer — Exclude/Expose · ClassSerializerInterceptor — (섹션22)

### Week 10 — ★ Pagination (기본 → 일반화)
- `01` Cursor Pagination — 이론 + 구현(MoreThan·Order·next cursor) — (섹션23)
- `02` Page Pagination — (섹션24)
- `03` Pagination 일반화 — BasePaginationDto · `paginate()` · composeFindOptions — (섹션25)

### Week 11 — ★ 횡단 관심사 + 파일/설정
- `01` Config 모듈(ENV) + 파일 업로드(Multer·FileInterceptor) + Static Serving — (섹션26,27,28,29)
- `02` Transaction(QueryRunner) + Interceptor(로거·Transaction Interceptor) — (섹션30,31)
- `03` Exception Filter + Middleware — (섹션32,33)

### Week 12 — ★ 실시간 · 권한 · SNS 완성
- `01` WebSocket & Socket.IO — Gateway · Room · Broadcasting · 채팅 — (섹션34,35)
- `02` 모듈 네스팅(Comments) + RBAC(Roles·IsPublic) + Authorization(IsMineOrAdmin Guard) — (섹션36,37,38)
- `03` Follow System + Follow/Comment Count + 회고 & 다음 로드맵 — (섹션39,40)

**총 36 레슨.** 순수 툴링 섹션(환경설정·PgAdmin·Postman·디버거)은 별도 레슨이 아니라 관련 주차의 **짧은 콜아웃**으로 흡수한다.

---

## ✅ 진행 체크리스트

- [x] Week 1 — 큰 그림 & NestJS 아키텍처
- [x] Week 2 — Controller · 라우팅 · 요청 데이터
- [x] Week 3 — ★ Service · Module · Provider · DI/IoC
- [x] Week 4 — SQL · Docker · TypeORM 시작
- [ ] Week 5 — ★ TypeORM 심화 이론
- [ ] Week 6 — ★ Table Relations (관계)
- [ ] Week 7 — ★ Authentication (인증)
- [ ] Week 8 — ★ Guard · Pipe · Custom Decorator (요청 파이프라인)
- [ ] Week 9 — DTO 검증·변환 (Class Validator & Transformer)
- [ ] Week 10 — ★ Pagination (기본 → 일반화)
- [ ] Week 11 — ★ 횡단 관심사 + 파일/설정
- [ ] Week 12 — ★ 실시간 · 권한 · SNS 완성
