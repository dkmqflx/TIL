# NestJS 코어 마스터 클래스 — 셀프 스터디 자료 설계

> 인프런 *NestJS 백엔드 완전정복 마스터 클래스 : Part 1* 커리큘럼을, `backend/fastapi/self-study`와 동일한 **시각화 중심 HTML 학습 자료** 포맷으로 **큐레이션 재구성**한다.

- **날짜**: 2026-06-16
- **위치(결과물)**: `backend/nestjs/nestjs-core/`
- **레퍼런스 포맷**: `backend/fastapi/self-study/`
- **상태**: 설계 승인 대기

---

## 1. 목표와 학습자

- **목표**: React/프론트엔드 출신 개발자가 NestJS로 REST API 백엔드(인스타그램 SNS 컨셉)를 설계·구현하는 데 필요한 **코어 기능 전반**을 직관적으로 학습.
- **학습자 가정**: FastAPI 자료와 동일 인물. React 경험 + NestJS 기본(데코레이터/모듈) 개념을 **약간** 아는 상태.
- **큐레이션 방향**:
  - **압축**: 기본 컨트롤러/라우팅, 단순 CRUD, REST 감각, 순수 툴링(환경설정·PgAdmin·Postman·디버거).
  - **확장(★)**: DI/IoC 내부, TypeORM 이론·관계, 인증/인가, 요청 파이프라인(Guard/Pipe/Decorator), 페이지네이션 일반화, 트랜잭션/인터셉터, 횡단 관심사, 실시간(WebSocket), RBAC, 팔로우 시스템.

---

## 2. 확정된 설계 결정 (브레인스토밍 합의)

| 항목 | 결정 | 비고 |
|------|------|------|
| 충실도/세분화 | **큐레이션 재구성** | ~12주 / 36 레슨, 단일 spec |
| 디자인 테마 | **`style.css` 그대로 재사용** | FastAPI와 동일 'engineer field note' 시스템 → repo 일관성 |
| 비교 패널 | **사용 안 함** | Nest↔Fast `.compare` 패널 제거. 비유·시각화·코드 비중↑ |
| 실행 코드 | **주차별 `code/` 최소 예제** | 인라인 스니펫 + 각 주차 실행 가능한 핵심 파일만 |
| 언어 | 한국어(기술 용어 영문 병기) | 레퍼런스 자료와 동일 |

> **비교 패널 제거**의 의미: 매 레슨에 반복 등장하던 좌(Nest)/우(FastAPI) 2단 패널을 **쓰지 않는다**. CSS의 `.compare` 클래스는 style.css에 남겨두되 사용하지 않는다. 단, Week 1의 "왜 Nest가 Express를 감싸나" 레슨처럼 **그 레슨의 주제 자체가 코드 대조**인 경우는 일반 코드 블록으로 표현한다(반복 패널이 아니라 1회성 설명).

---

## 3. 폴더 구조

```
backend/nestjs/nestjs-core/
├── README.md                       # 현재의 강의 덤프 → 계획표+인덱스+체크리스트로 교체
├── index.html                      # 시각화 랜딩 페이지 (fastapi index.html 구조 차용)
├── assets/
│   └── style.css                   # fastapi/self-study/assets/style.css 복사 (그대로)
│
├── week01-overview-architecture/
│   ├── 01-*.html  02-*.html  03-*.html
│   └── code/                       # 실행 가능한 최소 NestJS 예제
├── week02-controller-request/  …  week12-realtime-rbac-sns/
```

- **한 토픽 = 한 `.html`** (TIL "one file per topic" 규칙 유지).
- `code/`는 **각 주차의 핵심 파일만** (전체 누적 프로젝트 아님). 5주차부터 TypeORM/엔티티 예제가 등장.
- GitHub은 `.html`을 렌더링하지 않음 → **로컬 브라우저로 열어 학습**.

---

## 4. HTML 레슨 페이지 구조 (템플릿)

각 레슨은 fastapi 레슨 페이지 골격을 따른다(단, 비교 패널 제외):

1. `topbar` — 브레드크럼(← 커리큘럼 / Week N · 테마) + 진행(예: `02 / 03`)
2. `head` — kicker · h1 · subtitle
3. `summary` — 한 줄 핵심 요약 카드
4. `ul.goals` — 학습 목표 체크리스트
5. 번호 매긴 `h2` 섹션들, 각 섹션에 적절히 배치:
   - 🍔 **비유 박스**(`.box.analogy`) — 어려운 개념을 일상 비유로
   - **코드 블록**(`.code`) — 실행 가능한 최소 예제, 파일명 바
   - 💡/⚠️/📝 **콜아웃**(`.box.tip` / `.warn` / `.note`)
   - **인라인 SVG 다이어그램**(`figure.diagram`) — 흐름/계층/시퀀스
   - **표**(`.tbl`)
6. `section-divider` "복습"
7. ✅ **셀프 체크**(`details.qa`) — 면접식 Q&A 2~3개(아코디언)
8. `pager` — 이전/다음 레슨
9. `foot`

**작성 원칙**: 비유 + 시각화로 직관적 이해 최우선. 비교 패널이 빠진 만큼 **비유 박스와 SVG 다이어그램을 더 적극 활용**한다.

---

## 5. 12주 커리큘럼 (확정 후보)

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
- `03` ★ Pagination 일반화 — BasePaginationDto · `paginate()` · composeFindOptions — (섹션25)

### Week 11 — ★ 횡단 관심사 + 파일/설정
- `01` Config 모듈(ENV) + 파일 업로드(Multer·FileInterceptor) + Static Serving — (섹션26,27,28,29)
- `02` ★ Transaction(QueryRunner) + Interceptor(로거·Transaction Interceptor) — (섹션30,31)
- `03` Exception Filter + Middleware — (섹션32,33)

### Week 12 — ★ 실시간 · 권한 · SNS 완성
- `01` WebSocket & Socket.IO — Gateway · Room · Broadcasting · 채팅 — (섹션34,35)
- `02` 모듈 네스팅(Comments) + RBAC(Roles·IsPublic) + Authorization(IsMineOrAdmin Guard) — (섹션36,37,38)
- `03` Follow System + Follow/Comment Count + 회고 & 다음 로드맵 — (섹션39,40)

**총 36 레슨.** 순수 툴링 섹션(환경설정·PgAdmin·Postman·디버거)은 별도 레슨이 아니라 관련 주차의 **짧은 콜아웃**으로 흡수한다.

---

## 6. 빌드 접근 (구현 단계 지침)

> 글로벌 CLAUDE.md의 "한 번에 한 기능 → 커밋 → 진행 파일", **40% 컨텍스트 상한**을 준수한다.

1. **스캐폴드 먼저**: `assets/style.css` 복사 → `README.md`(계획표+인덱스) → `index.html`(랜딩, 전 주차 링크는 "작성 예정" 배지로 시작).
2. **주차 단위로 1커밋**: 한 세션에서 한 주차(3 레슨 + `code/`)를 작성 → 검증 → 커밋. 다음 주차는 새 세션 권장.
3. **커밋 규칙**: commitlint 스코프 `be(nestjs)`. 예) `add(be(nestjs)): week 1 — overview & architecture`.
4. **활성화 패턴**: 각 주차 완료 시 `index.html`·`README.md`의 해당 주차 링크/배지를 "작성 완료"로 갱신(fastapi 진행 방식과 동일).
5. **검증(주차별)**: ① HTML이 브라우저에서 깨짐 없이 열림 ② 모든 링크(이전/다음/인덱스) 유효 ③ `code/` 예제가 의도대로 구성됨 ④ 셀프 체크 Q&A 포함.

---

## 7. 범위 밖 (YAGNI)

- 누적되는 풀 인스타그램 SNS 프로덕션 프로젝트(capstone) — 채택 안 함.
- Nest↔FastAPI(또는 타 프레임워크) 반복 비교 패널 — 채택 안 함.
- 배포(AWS) · Socket 프로덕션 배포 — 원강의 Part 1 범위지만 본 자료에서는 Week 12 회고에서 "다음 로드맵"으로만 언급.
- 테마 색상 변경(NestJS 레드) — 채택 안 함(style.css 그대로).
- 자동 빌드/번들링 · GitHub Pages 연결 — 추후 별도 작업.

---

## 8. 성공 기준

- `backend/nestjs/nestjs-core/`가 fastapi/self-study와 **동일한 룩앤필**의 학습 사이트로 동작.
- 12주 × 3 레슨 = 36개 `.html`이 모두 작성되고 인덱스/페이저로 상호 연결됨.
- 각 레슨이 §4 템플릿(비유·시각화·코드·셀프체크)을 충족.
- README가 계획표 + 인덱스 + 진행 체크리스트로 기능.
- 각 주차 `code/`에 실행 가능한 최소 예제 존재.
