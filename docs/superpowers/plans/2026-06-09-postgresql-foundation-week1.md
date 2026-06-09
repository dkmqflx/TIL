# PostgreSQL 셀프 스터디 — Foundation + Week 1 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** PostgreSQL 셀프 스터디의 디자인 시스템·실습 환경·HTML 템플릿을 구축하고, Week 1(큰 그림·환경·데이터 타입) 3개 레슨을 완성한다.

**Architecture:** FastAPI 자료(`backend/fastapi/self-study/`)의 디자인 시스템과 페이지 구조를 그대로 계승한다. 한 토픽 = 한 `.html` 파일, 공유 `assets/style.css`, 인라인 SVG 시각화. 실습은 Docker `postgres:18` + psql 순수 SQL. 모든 SQL 예제는 `code/`에서 실제 실행되어야 한다.

**Tech Stack:** HTML/CSS (정적), 인라인 SVG, PostgreSQL 18 (Docker), psql.

**Spec:** `docs/superpowers/specs/2026-06-09-postgresql-self-study-curriculum-design.md`

---

## File Structure

```
backend/postgresql/self-study/
├── README.md                              # 커리큘럼 인덱스 + 진행 체크리스트 (Task 6)
├── index.html                             # 시각화 랜딩 페이지 (Task 5)
├── .gitignore                             # (Task 1)
├── assets/
│   └── style.css                          # FastAPI 자료에서 복사 + MySQL/PG compare alias (Task 2)
├── _TEMPLATE.html                         # 레슨 작성용 골격 (Task 3, 비커밋 참고용)
└── week01-overview-env-types/
    ├── 01-why-postgres-architecture.html  # (Task 7)
    ├── 02-docker-psql-basics.html         # (Task 8)
    ├── 03-data-types.html                 # (Task 9)
    └── code/
        ├── docker-compose.yml             # postgres:18 (Task 4)
        ├── 02-psql-basics.sql             # (Task 8)
        └── 03-data-types.sql              # (Task 9)
```

**책임 분리:**
- `assets/style.css` — 모든 페이지가 공유하는 단일 디자인 시스템. 색상/박스/코드/비교 패널/아코디언.
- 각 `NN-*.html` — 한 토픽. 자체 완결적. 공유 CSS만 의존.
- `code/*.sql` — 해당 레슨에서 등장한 SQL을 psql로 그대로 실행 가능한 형태로 보관.
- `_TEMPLATE.html` — 레슨 골격(빈 섹션). 실제 페이지는 이걸 복제해 채운다. 학습 콘텐츠 아님 → 커밋하지 않는다(`.gitignore` 또는 로컬 참고).

---

## 디자인 시스템 참조 (모든 레슨 공통)

FastAPI 자료에서 확인된 클래스. 새 레슨은 아래만 사용한다(새 클래스 임의 추가 금지):

| 용도 | 마크업 |
|------|--------|
| 상단 네비 | `<nav class="topbar">` |
| 헤더 | `<header class="head">` + `.kicker` `.subtitle` |
| 한 줄 요약 | `<div class="summary"><div class="summary__inner">` |
| 목표 리스트 | `<ul class="goals">` |
| 본문 래퍼 | `<main class="wrap">` + `<h2><span class="num">N</span>...` |
| 비유 박스 | `<div class="box analogy"><span class="ic">📦</span><span class="label">...</span><p>...` |
| 팁/경고/노트 | `<div class="box tip">` / `box warn` / `box note` |
| 코드 블록 | `<div class="code"><div class="code__bar">...<span class="name">파일명</span></div><pre>...</pre></div>` |
| 비교 패널 | `<div class="compare">` + `.compare__nest`(좌) / `.compare__fast`(우) — **MySQL/PG alias 사용** |
| 표 | `<table class="tbl">` |
| SVG 도식 | `<figure class="diagram"><svg viewBox=...>...</svg><figcaption>...` |
| 셀프 체크 | `<details class="qa"><summary><span class="qmark">Q</span>...</summary><div class="answer">...` |
| 페이저 | `<nav class="pager">` + `.prev` / `.next` |
| 푸터 | `<footer class="foot">` |

코드 블록 내 신택스 하이라이트 span: `.k`(키워드) `.t`(태그/식별자) `.s`(문자열) `.n`(숫자) `.c`(주석) `.f`(함수) — FastAPI 자료와 동일.

---

## Task 1: 디렉터리 스캐폴드 + .gitignore

**Files:**
- Create: `backend/postgresql/self-study/.gitignore`
- Create: `backend/postgresql/self-study/week01-overview-env-types/code/` (디렉터리)

- [ ] **Step 1: 디렉터리 생성**

```bash
mkdir -p backend/postgresql/self-study/assets
mkdir -p backend/postgresql/self-study/week01-overview-env-types/code
```

- [ ] **Step 2: .gitignore 작성** (FastAPI 자료와 동일 패턴)

`backend/postgresql/self-study/.gitignore`:
```
# 레슨 작성용 골격 (학습 콘텐츠 아님)
_TEMPLATE.html
# psql 로컬 산출물
*.log
.DS_Store
```

- [ ] **Step 3: 확인**

Run: `ls -la backend/postgresql/self-study/`
Expected: `assets/`, `week01-overview-env-types/`, `.gitignore` 존재.

---

## Task 2: 디자인 시스템 (style.css 복사 + MySQL/PG 비교 alias)

**Files:**
- Create: `backend/postgresql/self-study/assets/style.css` (FastAPI 자료에서 복사)

- [ ] **Step 1: FastAPI style.css 복사**

```bash
cp backend/fastapi/self-study/assets/style.css backend/postgresql/self-study/assets/style.css
```

- [ ] **Step 2: 비교 패널 색상 의미를 MySQL/PG에 맞춤**

`.compare__nest`(좌)는 MySQL, `.compare__fast`(우)는 PostgreSQL로 사용한다. 클래스명은 그대로 두되, 파일 끝에 의미를 명확히 하는 alias를 추가한다:

`assets/style.css` 맨 끝에 추가:
```css

/* MySQL ↔ PostgreSQL 비교 패널 alias (의미 명확화용; 스타일은 기존과 동일) */
.compare__mysql { /* 좌측: MySQL */ }
.compare__pg    { /* 우측: PostgreSQL */ }
```
> 실제 레슨에서는 기존 `.compare__nest`/`.compare__fast`를 그대로 써도 되고, 위 alias를 병기해도 된다. 핵심은 **좌=MySQL, 우=PostgreSQL** 일관성.

- [ ] **Step 3: 확인**

Run: `head -5 backend/postgresql/self-study/assets/style.css && echo "---" && grep -c "compare" backend/postgresql/self-study/assets/style.css`
Expected: CSS 내용 출력, `compare` 클래스 다수 매칭(>0).

---

## Task 3: 레슨 HTML 템플릿 (_TEMPLATE.html)

**Files:**
- Create: `backend/postgresql/self-study/_TEMPLATE.html`

- [ ] **Step 1: 골격 작성** — 이후 모든 레슨이 이 구조를 복제한다.

`_TEMPLATE.html`:
```html
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Week N·NN — {제목}</title>
<link rel="stylesheet" href="../assets/style.css">
</head>
<body>

<nav class="topbar">
  <span class="crumb"><a href="../index.html">← 커리큘럼</a> &nbsp;/&nbsp; <b>Week N · {주차명}</b></span>
  <span>NN / 03</span>
</nav>

<header class="head">
  <span class="kicker">◆ Week N — Lesson NN</span>
  <h1>{제목}</h1>
  <p class="subtitle">{한 문장 부제}</p>
</header>

<div class="summary">
  <div class="summary__inner">
    <span class="big">"</span>
    <p>{한 줄 요약 — 비유 한 스푼}</p>
  </div>
</div>

<main class="wrap">
  <ul class="goals">
    <li>{학습 목표 1}</li>
    <li>{학습 목표 2}</li>
    <li>{학습 목표 3}</li>
  </ul>

  <h2><span class="num">1</span>{섹션 제목}</h2>
  <p>{본문}</p>

  <!-- 비유 / 코드 / 비교 패널 / SVG / 경고 박스를 본문에 배치 -->

  <div class="section-divider">복습</div>

  <h2><span class="num">N</span>✅ 셀프 체크</h2>
  <details class="qa">
    <summary><span class="qmark">Q</span> {질문}</summary>
    <div class="answer"><p>{답}</p></div>
  </details>

  <nav class="pager">
    <a class="prev" href="{이전}"><span class="dir">← 이전</span><span class="ttl">{이전 제목}</span></a>
    <a class="next" href="{다음}"><span class="dir">다음 →</span><span class="ttl">{다음 제목}</span></a>
  </nav>
</main>

<footer class="foot">PostgreSQL 셀프 스터디 · Week N · Lesson NN · {제목}</footer>
</body>
</html>
```

- [ ] **Step 2: 확인** — 브라우저로 열어 CSS가 로드되는지(레이아웃 깨짐 없음) 확인.

Run: `open backend/postgresql/self-study/_TEMPLATE.html`
Expected: 스타일 적용된 빈 골격 페이지가 보인다.

---

## Task 4: 실습 환경 — docker-compose.yml (postgres:18)

**Files:**
- Create: `backend/postgresql/self-study/week01-overview-env-types/code/docker-compose.yml`

- [ ] **Step 1: compose 파일 작성**

`week01-overview-env-types/code/docker-compose.yml`:
```yaml
services:
  db:
    image: postgres:18          # 2026 현재 최신 안정 버전
    container_name: pg-study
    environment:
      POSTGRES_USER: study
      POSTGRES_PASSWORD: study_pw
      POSTGRES_DB: study_db
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

- [ ] **Step 2: 컨테이너 기동 + 버전 확인** (실습 환경이 진짜 도는지 검증)

```bash
cd backend/postgresql/self-study/week01-overview-env-types/code
docker compose up -d
docker compose exec db psql -U study -d study_db -c "SELECT version();"
```
Expected: `PostgreSQL 18.x ...` 출력.

- [ ] **Step 3: 정리(다음 태스크에서 다시 사용하므로 down은 선택)**

```bash
# 그대로 둬도 됨. 완전 정리: docker compose down -v
```

---

## Task 5: index.html 랜딩 페이지

**Files:**
- Create: `backend/postgresql/self-study/index.html`
- Reference: `backend/fastapi/self-study/index.html` (구조 참고)

- [ ] **Step 1: FastAPI index.html 구조를 참고해 작성**

요구사항:
- `<head>`에 `<link rel="stylesheet" href="assets/style.css">` (경로 주의: 루트라 `assets/`).
- 히어로 섹션: 제목 "앱 개발자를 위한 실전 PostgreSQL — 6주 셀프 스터디", 부제(MySQL은 알지만 Postgres 고유 기능은 처음인 개발자용).
- 전제/목표 요약 박스 (`.summary` 또는 `.box note`).
- **6주 커리큘럼 카드/리스트** — 각 주차 제목 + 3개 레슨 링크. Week 1만 실제 파일로 링크(`week01-overview-env-types/01-...html`), Week 2~6은 `(준비 중)` 텍스트(링크 없음 또는 `#`).
- 각 레슨 옆 ⭐ 표시(Postgres 고유/핵심).
- MySQL↔Postgres 비교 학습 + Docker+psql 실습이라는 학습 방식 안내.

- [ ] **Step 2: 확인**

Run: `open backend/postgresql/self-study/index.html`
Expected: 6주 커리큘럼이 보이고, Week 1 레슨 링크 클릭 시(레슨 작성 후) 이동.

---

## Task 6: README.md — 커리큘럼 인덱스

**Files:**
- Create: `backend/postgresql/self-study/README.md`
- Reference: `backend/fastapi/self-study/README.md`

- [ ] **Step 1: spec(§6 커리큘럼)을 그대로 옮긴 README 작성**

포함:
- 제목 + 한 줄 소개(갭 중심: MySQL 문법은 알되 Postgres 고유 기능 집중).
- 목표/전제 (spec §1).
- 개발 환경 표: PostgreSQL 18 (Docker), psql, 순수 SQL.
- 폴더 구조.
- HTML 작성 원칙 9단계 (spec §4).
- **6주 18편 커리큘럼 전체** (spec §6, ⭐ 표시 포함).
- 진행 체크리스트: `- [ ] Week 1` ~ `- [ ] Week 6` (Week 1은 이 계획 완료 시 체크).

- [ ] **Step 2: 확인**

Run: `grep -c "Week" backend/postgresql/self-study/README.md`
Expected: 6주차 + 체크리스트로 다수 매칭.

---

## Task 7: Week 1 · Lesson 01 — 왜 Postgres인가 · 아키텍처 · 연결 비용

**Files:**
- Create: `backend/postgresql/self-study/week01-overview-env-types/01-why-postgres-architecture.html`

이 레슨은 코드 실행보다 **개념/시각화** 중심(SQL 파일 없음).

- [ ] **Step 1: 템플릿 복제 후 콘텐츠 채우기**

**한 줄 요약(summary):** "Postgres는 '연결 하나 = 프로세스 하나'다. 그래서 연결은 비싸고, 그 한 가지 사실이 풀링·서버리스 설계를 전부 좌우한다."

**학습 목표(goals):**
- MySQL과 다른 Postgres의 멀티프로세스 아키텍처를 안다
- "연결이 비싸다"는 결과가 왜 중요한지(풀링 필요성) 이해한다
- PG18 비동기 I/O가 무엇을 개선했는지 한 줄로 안다

**섹션 구성:**
1. **왜 Postgres인가** — 표준 준수, 확장성(extension), JSONB/RLS 같은 고유 기능, 오픈소스 생태계. (`.tbl`로 "Postgres가 강한 영역" 정리)
2. **아키텍처 — 연결 하나에 프로세스 하나**
   - 비유 박스(🏢): "MySQL은 한 사무실(프로세스) 안에 직원(스레드)을 늘리는 회사, Postgres는 연결마다 독립 사무실(프로세스) 한 채를 새로 짓는 회사. 사무실 짓는 비용이 커서 함부로 많이 못 짓는다."
   - SVG 도식: 클라이언트 N개 → postmaster(부모 프로세스) → backend 프로세스 N개. (FastAPI 자료 SVG 스타일 차용)
   - 비교 패널 (좌 MySQL / 우 PostgreSQL): thread-per-connection vs process-per-connection.
3. **그래서 — 연결은 비싸다 (실무 결과)**
   - 경고 박스(⚠️): "연결을 요청마다 새로 열면 프로세스 생성 비용 + 메모리(work_mem 등) 폭증. 수백 연결이면 Postgres가 무릎 꿇는다. → 그래서 **연결 풀(PgBouncer)** 이 거의 필수. 서버리스(람다 등)에선 connection storm이 대표적 사고." (상세는 Week 6.03 예고)
4. **PG18 비동기 I/O 한 스푼**
   - 노트 박스(🧩): "PG18부터 `io_method`로 비동기 I/O 도입 — 시퀀셜 스캔/VACUUM 등에서 최대 3배 빨라진 사례. '읽기 요청을 줄 세워 한꺼번에' 처리한다는 정도만 기억." (출처 링크)

**셀프 체크(2~3개):**
- Q: Postgres에서 연결이 '비싸다'고 하는 이유는? → A: 연결 하나가 OS 프로세스 하나라서. 생성 비용·메모리가 커 다수 연결이 서버를 압박. 그래서 풀링이 필요.
- Q: MySQL과 Postgres의 연결 처리 모델 차이는? → A: MySQL은 thread-per-connection(한 프로세스 내 스레드), Postgres는 process-per-connection(연결마다 백엔드 프로세스).
- Q: 서버리스 환경에서 Postgres 연결이 문제되는 이유는? → A: 인스턴스가 폭발적으로 늘면 각자 연결을 열어 connection storm 발생. 풀러(PgBouncer)나 서버리스 드라이버로 완화.

**페이저:** prev 없음(또는 `../index.html`), next → `02-docker-psql-basics.html`.
**참고 링크:** PostgreSQL 18 Released, Postgres process architecture 문서.

- [ ] **Step 2: 확인**

Run: `open backend/postgresql/self-study/week01-overview-env-types/01-why-postgres-architecture.html`
Expected: 비유·SVG·비교 패널·셀프체크가 스타일대로 렌더링. 깨진 마크업 없음.

- [ ] **Step 3: 커밋**

```bash
git add backend/postgresql/self-study/
git commit -m "add(be(postgresql)): week 1 lesson 01 — why postgres & architecture"
```

---

## Task 8: Week 1 · Lesson 02 — Docker로 띄우기 · psql 기초

**Files:**
- Create: `backend/postgresql/self-study/week01-overview-env-types/02-docker-psql-basics.html`
- Create: `backend/postgresql/self-study/week01-overview-env-types/code/02-psql-basics.sql`

- [ ] **Step 1: SQL 실습 파일 작성**

`code/02-psql-basics.sql`:
```sql
-- psql 메타 명령은 SQL이 아니라 psql 클라이언트 명령이다(주석으로 안내).
-- \l   : 데이터베이스 목록
-- \dt  : 현재 스키마의 테이블 목록
-- \d <table> : 테이블 구조
-- \du  : 역할(role) 목록
-- \dn  : 스키마 목록

-- 실제 SQL: 연결 확인 + 스키마/검색경로 감각
SELECT current_database(), current_user, version();
SHOW search_path;

-- 간단 테이블로 \d 체험
CREATE TABLE ping (id int primary key, msg text);
INSERT INTO ping VALUES (1, 'hello postgres 18');
SELECT * FROM ping;
-- 이제 psql에서: \dt  그리고  \d ping
DROP TABLE ping;
```

- [ ] **Step 2: SQL이 실제로 도는지 검증**

```bash
cd backend/postgresql/self-study/week01-overview-env-types/code
docker compose up -d
docker compose exec -T db psql -U study -d study_db < 02-psql-basics.sql
```
Expected: `SELECT`/`CREATE TABLE`/`INSERT`/`DROP TABLE` 정상 실행, 에러 없음.

- [ ] **Step 3: 레슨 HTML 작성**

**한 줄 요약:** "DB를 직접 설치하지 말고 `postgres:18` 컨테이너로 빌려 쓴다. 그리고 psql의 백슬래시 명령(`\d` 패밀리)으로 DB 속을 들여다본다."

**학습 목표:** Docker로 PG18 띄우고 끄기 / psql 접속 / `\l \dt \d \du \dn` 핵심 메타 명령 / 데이터베이스·스키마·search_path 개념.

**섹션 구성:**
1. 왜 Docker로 — 격리·재현성 (비유 박스 📦: "조립식 창고", FastAPI 자료와 동일 톤).
2. `docker-compose.yml`(postgres:18) 코드 블록 + `up -d`/`ps`/`down`/`down -v`.
3. psql 접속: `docker compose exec db psql -U study -d study_db`.
4. psql 메타 명령 표(`.tbl`): `\l \dt \d <t> \du \dn \?`.
5. 데이터베이스 vs 스키마 vs search_path — 비유(서랍장: 데이터베이스=장, 스키마=서랍, 테이블=물건) + `SHOW search_path;`.
6. 비교 패널(좌 MySQL / 우 PG): `SHOW DATABASES;`/`USE db;` ↔ `\l`/`\c db`; MySQL은 DB=스키마 동의어, Postgres는 DB 안에 여러 스키마(public 등).

**함정 박스(⚠️):** "`\c` 로 데이터베이스를 바꾸면 연결이 새로 맺어진다. MySQL의 `USE`와 달리 Postgres는 한 연결이 한 데이터베이스에 묶인다."

**셀프 체크:**
- Q: Postgres에서 database와 schema의 관계는? → A: database 안에 여러 schema가 있고 기본은 `public`. MySQL은 database와 schema가 사실상 동의어.
- Q: 테이블 구조를 보는 psql 명령은? → A: `\d <table>` (목록은 `\dt`).
- Q: `search_path`는 무엇을 결정하나? → A: 스키마를 명시 안 했을 때 객체를 찾는 스키마 순서.

**페이저:** prev → `01-...`, next → `03-data-types.html`.

- [ ] **Step 4: 확인 + 커밋**

```bash
open backend/postgresql/self-study/week01-overview-env-types/02-docker-psql-basics.html
git add backend/postgresql/self-study/week01-overview-env-types/
git commit -m "add(be(postgresql)): week 1 lesson 02 — docker & psql basics"
```

---

## Task 9: Week 1 · Lesson 03 — 데이터 타입 (PG18 uuidv7 포함)

**Files:**
- Create: `backend/postgresql/self-study/week01-overview-env-types/03-data-types.html`
- Create: `backend/postgresql/self-study/week01-overview-env-types/code/03-data-types.sql`

- [ ] **Step 1: SQL 실습 파일 작성**

`code/03-data-types.sql`:
```sql
-- 1) 자동증가 키: SERIAL(구식) vs IDENTITY(표준, 권장)
CREATE TABLE old_way  (id serial PRIMARY KEY, name text);
CREATE TABLE std_way  (id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY, name text);

-- 2) PG18 네이티브 UUIDv7 — 시간순 정렬되는 UUID (인덱스 친화적)
SELECT uuidv7();                       -- PG18+
CREATE TABLE evt (
  id uuid PRIMARY KEY DEFAULT uuidv7(),
  payload text
);
INSERT INTO evt (payload) VALUES ('a'), ('b'), ('c');
SELECT id FROM evt ORDER BY id;        -- 생성 순서대로 정렬됨에 주목

-- 3) timestamptz — 항상 timestamptz를 써라(타임존 인지)
CREATE TABLE log (
  at_wrong timestamp,        -- 타임존 정보 없음 (지뢰)
  at_right timestamptz       -- UTC로 저장, 세션 타임존으로 표시
);
SHOW timezone;
INSERT INTO log VALUES (now(), now());
SELECT * FROM log;

-- 4) numeric vs float — 돈은 numeric
SELECT 0.1::float + 0.2::float AS float_bad,   -- 0.30000000000000004
       0.1::numeric + 0.2::numeric AS numeric_ok;

-- 정리
DROP TABLE old_way, std_way, evt, log;
```

- [ ] **Step 2: SQL 검증 (PG18 uuidv7 동작 확인이 핵심)**

```bash
cd backend/postgresql/self-study/week01-overview-env-types/code
docker compose exec -T db psql -U study -d study_db < 03-data-types.sql
```
Expected: `uuidv7()`가 값을 반환(PG18), float_bad ≈ 0.30000000000000004, numeric_ok = 0.3, 에러 없음.

- [ ] **Step 3: 레슨 HTML 작성**

**한 줄 요약:** "Postgres의 풍부한 타입 중 앱 개발자가 매일 쓰는 것만: IDENTITY 키, PG18 네이티브 `uuidv7()`, 그리고 무조건 `timestamptz`."

**학습 목표:** SERIAL vs IDENTITY(왜 IDENTITY가 표준 권장) / PG18 `uuidv7()`로 정렬 가능한 UUID 키 / `timestamp` vs `timestamptz` 함정 / numeric으로 돈 다루기.

**섹션 구성:**
1. 자동증가 키 — `SERIAL`(레거시) vs `GENERATED ALWAYS AS IDENTITY`(SQL 표준, 권장). 비교 패널(좌 MySQL `AUTO_INCREMENT` / 우 PG `IDENTITY`).
2. **UUIDv7 (PG18 ⭐)** — 비유 박스(🧬): "UUIDv4는 무작위라 인덱스에 흩뿌려져 페이지 분할이 잦다. UUIDv7은 앞부분에 시간이 박혀 있어 '새 행은 항상 뒤에' 꽂힌다 → B-tree에 친화적." `uuidv7()` 코드. 노트: PG18 이전엔 확장/앱에서 생성했으나 이제 내장.
3. **timestamptz 함정 ⚠️** — 경고 박스: "`timestamp`(without time zone)는 타임존을 안 들고 있어 서버/클라 타임존이 다르면 시간이 어긋난다. 앱에선 거의 항상 `timestamptz`를 써라(내부 UTC 저장)." 비교 패널(좌 MySQL `DATETIME` vs `TIMESTAMP` / 우 PG `timestamp` vs `timestamptz`).
4. numeric vs float/double — `0.1+0.2` 데모. 돈·정밀 계산은 `numeric`.
5. (간단 표) 자주 쓰는 타입 매핑 MySQL↔PG: `INT/BIGINT`=같음, `VARCHAR`→`text` 선호, `TINYINT(1)`→`boolean`, `JSON`→`jsonb`(Week 3), `ENUM`→enum 타입(Week 3).

**셀프 체크:**
- Q: 새 테이블의 자동증가 PK, SERIAL과 IDENTITY 중 무엇을? → A: `GENERATED ALWAYS AS IDENTITY`(SQL 표준, 시퀀스 소유·권한이 깔끔). SERIAL은 레거시.
- Q: UUIDv4 대신 UUIDv7을 PK로 쓰면 좋은 이유는? → A: 시간순 정렬이라 인덱스에 순차 삽입 → 페이지 분할↓, 캐시 지역성↑. PG18은 `uuidv7()` 내장.
- Q: `timestamp`와 `timestamptz` 중 기본 선택은? → A: `timestamptz`. 타임존을 인지해 UTC로 저장하므로 다중 타임존에서 안전.

**페이저:** prev → `02-...`, next → `../week02-schema-write-power/01-...html`(아직 없으므로 `#` 또는 index).

- [ ] **Step 4: 확인 + 커밋**

```bash
open backend/postgresql/self-study/week01-overview-env-types/03-data-types.html
git add backend/postgresql/self-study/week01-overview-env-types/
git commit -m "add(be(postgresql)): week 1 lesson 03 — data types (uuidv7, timestamptz)"
```

---

## Task 10: Week 1 마무리 — README 체크 + index 링크 검증

**Files:**
- Modify: `backend/postgresql/self-study/README.md` (Week 1 체크)
- Verify: `index.html` Week 1 링크

- [ ] **Step 1: README 진행 체크리스트에서 Week 1 체크**

`- [ ] Week 1 — 큰 그림 · 환경 · 데이터 타입` → `- [x] ...`

- [ ] **Step 2: 전체 링크 흐름 검증**

```bash
open backend/postgresql/self-study/index.html
```
Expected: index → Week1·01 → 02 → 03 페이저로 끊김 없이 이동. 깨진 링크/스타일 없음.

- [ ] **Step 3: docker 정리**

```bash
cd backend/postgresql/self-study/week01-overview-env-types/code && docker compose down
```

- [ ] **Step 4: 커밋**

```bash
git add backend/postgresql/self-study/README.md
git commit -m "update(be(postgresql)): mark week 1 complete"
```

---

## Self-Review (작성자 체크)

**Spec 커버리지 (Foundation + Week 1 범위):**
- spec §3 형식/환경(Docker postgres:18, psql, 공유 CSS) → Task 1·2·4 ✓
- spec §4 작성 원칙(비유→시각화→SQL→비교→함정→셀프체크) → Task 3 템플릿 + Task 7·8·9 ✓
- spec §5 폴더 구조 → File Structure + Task 1 ✓
- spec §6 Week 1 (01 아키텍처/연결비용/async I/O, 02 docker+psql, 03 타입+uuidv7+timestamptz) → Task 7·8·9 ✓
- spec §8 저장소 설정(be(postgresql) scope) → 이미 이전 커밋에서 완료 ✓

**플레이스홀더 스캔:** 각 레슨 태스크는 실제 한 줄 요약·목표·섹션·SQL·셀프체크 Q&A를 포함. `{...}`는 템플릿(_TEMPLATE.html) 골격에만 존재(의도된 빈칸). ✓

**타입/명명 일관성:** DB 계정 `study/study_pw/study_db`, 컨테이너 `pg-study`, 포트 5432 — Task 4·8·9 전반 일관. ✓

**범위 메모:** Week 2~6은 별도 후속 계획서. 각 레슨의 `next` 페이저는 미작성 주차를 가리킬 경우 `#` 또는 index로 임시 처리(후속 계획에서 연결).
