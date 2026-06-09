# 앱 개발자를 위한 실전 PostgreSQL — 6주 셀프 스터디

> MySQL/SQL 기초(대학 데이터베이스 강의 수준)는 알지만 **PostgreSQL 고유 기능**(RLS · JSONB · MVCC · 인덱스 · 연결 풀링)은 잘 모르는 백엔드/앱 개발자를 위한 갭 중심 커리큘럼.

이 폴더는 단순 강의 따라하기가 아니라, **기본 SQL 문법은 압축하고 / Postgres 고유 기능에 집중**하도록 재구성한 학습 자료입니다. PostgreSQL 18 기준입니다.

---

## 🎯 목표와 전제

- **목표**: 앱(FastAPI/Supabase 등)에서 PostgreSQL을 자신 있게 쓰는 백엔드 개발자. "백엔드 개발자가 알아야 할 Postgres"에 집중.
- **이미 아는 것 (압축 대상)**: 기본 SQL 문법(SELECT/JOIN/WHERE), 정규화, 기본 CRUD — 대학 DB 강의 수준.
- **모르는 것 (집중 영역 ⭐)**: Postgres 고유 기능 — RLS, JSONB, 인덱스 종류, MVCC/VACUUM, 트랜잭션 격리, 트리거/함수, 연결 풀링.
- **각도**: DBA/엔진 내부가 아니라 **앱 개발자 실전**. 2026 기준(PostgreSQL 18) 트렌드 반영 — 네이티브 `uuidv7()`, virtual generated columns, `RETURNING OLD/NEW`, 비동기 I/O, keyset pagination, pgvector 등.
- **관점**: 아는 영역은 **MySQL ↔ PostgreSQL 비교**로 빠른 전이 학습 (좌=MySQL, 우=PostgreSQL).

---

## 🛠 개발 환경 / 툴링

| 항목 | 선택 | 비고 |
|------|------|------|
| DB | **PostgreSQL 18** (Docker `postgres:18`) | 2026 현재 최신 안정 버전 |
| 실습 방식 | **순수 SQL 중심** | ORM 없이 SQL 그 자체에 집중 |
| 클라이언트 | **psql** | `\d` 패밀리 메타 명령으로 DB 내부 탐색 |
| 컨테이너 | **Docker / docker compose** | `docker compose up -d` 한 줄로 DB 기동 |
| 비교 학습 | **MySQL ↔ PostgreSQL 비교 패널** | 아는 문법을 Postgres로 빠르게 전이 |
| 디자인 | 공유 `assets/style.css` | 모든 `.html`이 공유하는 디자인 시스템 |

> 실습 환경은 `week01-overview-env-types/code/docker-compose.yml`로 띄웁니다. **PostgreSQL 18은 데이터 디렉터리 규칙이 바뀌어** named volume을 `/var/lib/postgresql`(하위 디렉터리 자동 생성)에 마운트합니다 — 기존처럼 `/var/lib/postgresql/data`에 마운트하면 컨테이너가 기동을 거부합니다.

---

## 🗂 폴더 구조

```
backend/postgresql/self-study/
├── README.md                              # (이 파일) 계획표 + 인덱스 + 진행 체크리스트
├── index.html                             # 풍부한 시각화 랜딩 페이지
├── .gitignore
├── assets/
│   └── style.css                          # 모든 .html이 공유하는 디자인 시스템
│
└── week01-overview-env-types/
    ├── 01-why-postgres-architecture.html
    ├── 02-docker-psql-basics.html
    ├── 03-data-types.html
    └── code/                              # psql로 바로 실행 가능한 예제
        ├── docker-compose.yml             # postgres:18 실습 환경
        ├── 02-psql-basics.sql
        └── 03-data-types.sql

   week02-schema-write-power/ … week06-rls-security-ops/   (순차 작성)
```

- **한 토픽 = 한 `.html` 파일** (TIL의 "one file per topic" 규칙을 HTML로 적용)
- **코드 예제**: 각 주차 `code/`에 실행 가능한 `.sql` + 필요한 `docker-compose.yml`. 모든 SQL은 Docker Postgres에서 실제로 실행됩니다.
- GitHub은 `.html`을 렌더링하지 않음 → **로컬 브라우저로 열어 학습** (추후 GitHub Pages 연결 가능)

---

## 📄 강의 자료(HTML) 작성 원칙

각 `.html` 페이지는 **비유 + 시각화로 직관적 이해**를 최우선으로 합니다.

1. **한 줄 요약** — 이 페이지에서 무엇을 얻는가
2. **왜 필요한가 (실무 맥락)** — 현업에서 언제 쓰이나
3. **🍔 비유 패널** — 어려운 개념을 일상 비유로
4. **시각화** — 인라인 SVG 다이어그램 / CSS 흐름도
5. **핵심 개념 + 실행 가능한 최소 SQL** (psql 기준)
6. **🔁 MySQL ↔ PostgreSQL 비교 패널** — 좌(MySQL) / 우(PostgreSQL) 2단 (해당 시)
7. **⚠️ 함정 & 실무 팁** — 경고 박스
8. **✅ 셀프 체크** — 면접식 질문 2~3개 (아코디언)
9. **🔗 참고 링크**

> 공통 `assets/style.css`로 색상·컴포넌트(비유 박스, 경고 박스, 비교 패널, 코드 블록)를 통일.

---

## 📚 6주 커리큘럼 (6주 · 18편)

⭐ = Postgres 고유 / 실무 가치가 특히 높은 핵심 영역

### Week 1 — 큰 그림 · 환경 · 데이터 타입
- `01` 왜 Postgres인가 · 멀티프로세스 아키텍처 → **연결 비용이 비싸다**는 실무적 결과 · **PG18 비동기 I/O(`io_method`)** 한 줄 소개 · 생태계
- `02` Docker(`postgres:18`)로 띄우기 · `psql` 핵심 명령(`\d \dt \l \du`) · 데이터베이스/스키마 개념
- `03` 데이터 타입 (IDENTITY, ⭐ 네이티브 `uuidv7()`(PG18), numeric, `timestamptz` 타임존 함정, boolean, text) ↔ MySQL

### Week 2 — 스키마 설계 · 쓰기 측 강력 기능 ⭐
- `01` DDL · 제약(**PG18 시간 범위 temporal 제약** 포함) · 기본키 전략(IDENTITY vs `uuidv7()`) · 시퀀스 ↔ MySQL AUTO_INCREMENT
- `02` ⭐ `RETURNING`(**PG18 `OLD`/`NEW` 지원**) · UPSERT(`ON CONFLICT`) · MERGE · 생성 컬럼(**PG18 virtual이 기본**) ↔ MySQL `ON DUPLICATE KEY`
- `03` ⭐ PL/pgSQL 함수 · 트리거(`updated_at` 자동 갱신 · 감사 로그)

### Week 3 — JSONB & 반정형 데이터 · 검색 ⭐
- `01` ⭐ JSON vs JSONB · 연산자(`-> ->> @> #>`) · 갱신 · GIN 인덱스
- `02` 배열(array) · enum · range 타입
- `03` 전문검색 `tsvector`/`tsquery` · `pg_trgm`(유사도) ↔ MySQL FULLTEXT

### Week 4 — 인덱스 · 쿼리 성능 · 분석 SQL ⭐
- `01` 인덱스 종류 (B-tree / GIN / GiST / BRIN / partial / expression)
- `02` `EXPLAIN ANALYZE` 읽는 법 · 쿼리 플래너 · 통계 · 인덱스 함정
- `03` CTE(`WITH`) · 재귀 CTE · 윈도우 함수 · **keyset pagination** · N+1

### Week 5 — 트랜잭션 · 동시성 · MVCC ⭐
- `01` 트랜잭션 · 격리 수준 (개념 중심, Postgres 기본 동작)
- `02` ⭐ MVCC 원리 · VACUUM · autovacuum · bloat
- `03` 락 · `SELECT FOR UPDATE` · 데드락 · advisory lock

### Week 6 — RLS · 권한 · 운영 · 확장 ⭐
- `01` ⭐ **RLS (Row Level Security)** — 정책(policy) · `USING`/`WITH CHECK` · 멀티테넌시
- `02` ROLE · GRANT · 스키마 권한 · 앱 전용 유저 (RLS와 연결) · **PG18 OAuth 인증** 한 줄 소개
- `03` ⭐ **연결 풀링(PgBouncer · 풀 사이징 · 서버리스 connection storm)** · 확장(pgcrypto · **pgvector**) · 백업(`pg_dump` · **증분 백업 `pg_basebackup --incremental`**) · 회고 & 다음 로드맵

---

## ✅ 진행 체크리스트

- [x] Week 1 — 큰 그림 · 환경 · 데이터 타입
- [x] Week 2 — 스키마 설계 · 쓰기 측 강력 기능
- [x] Week 3 — JSONB & 반정형 데이터 · 검색
- [x] Week 4 — 인덱스 · 쿼리 성능 · 분석 SQL
- [x] Week 5 — 트랜잭션 · 동시성 · MVCC
- [x] Week 6 — RLS · 권한 · 운영 · 확장
