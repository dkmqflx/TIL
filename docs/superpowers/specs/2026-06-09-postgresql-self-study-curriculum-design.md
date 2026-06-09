# 앱 개발자를 위한 실전 PostgreSQL — 6주 셀프 스터디 (설계 문서)

> MySQL/SQL 기초(대학 데이터베이스 강의 수준)는 알지만 **PostgreSQL 고유 기능**(RLS, JSONB, MVCC 등)은 잘 모르는 백엔드/앱 개발자를 위한 갭 중심 커리큘럼.

작성일: 2026-06-09 · 위치: `backend/postgresql/self-study/`

---

## 1. 목표와 전제

- **목표**: 앱(FastAPI/Supabase 등)에서 PostgreSQL을 자신 있게 쓰는 백엔드 개발자. "백엔드 개발자가 알아야 할 Postgres"에 집중.
- **이미 아는 것 (압축 대상)**: 기본 SQL 문법(SELECT/JOIN/WHERE), 정규화, 기본 CRUD — 대학 DB 강의 수준.
- **모르는 것 (집중 영역 ⭐)**: Postgres 고유 기능 — RLS, JSONB, 인덱스 종류, MVCC/VACUUM, 트랜잭션 격리, 트리거/함수, 연결 풀링.
- **각도**: DBA/엔진 내부가 아니라 **앱 개발자 실전**. 최근(2024~) 실무 트렌드 반영(UUIDv7, keyset pagination, pgvector 등).

## 2. 대상 독자의 상태 (캘리브레이션)

- MySQL **문법 수준**은 안다 → 비교는 문법 레벨에서만(AUTO_INCREMENT vs IDENTITY, FULLTEXT vs tsvector).
- MySQL **내부 동작**(InnoDB 락/MVCC 등)은 모른다고 가정 → 내부 비교 대신 Postgres 개념을 직접 설명.
- 윈도우 함수/CTE는 표준 SQL이지만 대학 강의에서 안 배웠을 수 있음 → "압축"이 아니라 "새로 배우는" 영역으로 다룸.

## 3. 분량 / 형식 결정

| 항목 | 결정 |
|------|------|
| 분량 | **6주 · 18편** (주당 3레슨) — 중형 |
| 비교 학습 장치 | **MySQL ↔ PostgreSQL 비교 패널** 적극 활용 (FastAPI 자료의 NestJS 비교와 동일 역할) |
| 실습 환경 | **Docker + psql 순수 SQL 중심** — `docker compose`로 Postgres 띄우고 psql로 직접 SQL 실행 |
| 포맷 | 한 토픽 = 한 `.html` 파일, 공통 `assets/style.css` 디자인 시스템 (FastAPI 자료와 동일) |

## 4. HTML 페이지 작성 원칙 (FastAPI 자료 계승)

각 `.html` 페이지는 **비유 + 시각화로 직관적 이해**를 최우선:

1. 한 줄 요약 — 이 페이지에서 무엇을 얻는가
2. 왜 필요한가 (실무 맥락)
3. 🍔 비유 패널 — 어려운 개념을 일상 비유로
4. 시각화 — 인라인 SVG / CSS 흐름도
5. 핵심 개념 + **실행 가능한 최소 SQL** (psql 기준)
6. 🔁 MySQL ↔ PostgreSQL 비교 패널 (해당 시)
7. ⚠️ 함정 & 실무 팁 (경고 박스)
8. ✅ 셀프 체크 — 면접식 질문 2~3개 (아코디언)
9. 🔗 참고 링크

> `assets/style.css`는 FastAPI 자료의 디자인 시스템(비유/경고/비교/코드 박스)을 재사용하거나 동일 구조로 복제.

## 5. 폴더 구조

```
backend/postgresql/self-study/
├── README.md            # 커리큘럼 계획표 + 인덱스 + 진행 체크리스트
├── index.html           # 시각화 랜딩 페이지
├── assets/
│   └── style.css        # 공유 디자인 시스템
├── week01-overview-env-types/
│   ├── 01-why-postgres-architecture.html
│   ├── 02-docker-psql-basics.html
│   ├── 03-data-types.html
│   └── code/            # docker-compose.yml + 실행 가능한 .sql
├── week02-schema-write-power/
├── week03-jsonb-search/
├── week04-index-performance/
├── week05-transaction-concurrency/
└── week06-rls-security-ops/
```

- 각 주차 `code/`에 실행 가능한 `.sql` + 필요한 `docker-compose.yml`.
- GitHub은 `.html`을 렌더링하지 않음 → 로컬 브라우저로 학습 (추후 GitHub Pages 가능).

## 6. 확정 커리큘럼 (6주 · 18편)

⭐ = Postgres 고유 / 실무 가치 특히 높음

### Week 1 — 큰 그림 · 환경 · 데이터 타입
- `01` 왜 Postgres인가 · 멀티프로세스 아키텍처 → **연결 비용이 비싸다**는 실무적 결과 · 생태계
- `02` Docker로 띄우기 · `psql` 핵심 명령(`\d \dt \l \du`) · 데이터베이스/스키마 개념
- `03` 데이터 타입 (IDENTITY/UUIDv7, numeric, **`timestamptz` 타임존 함정**, boolean, text) ↔ MySQL

### Week 2 — 스키마 설계 · 쓰기 측 강력 기능 ⭐
- `01` DDL · 제약 · 기본키 전략(IDENTITY vs UUIDv7) · 시퀀스 ↔ MySQL AUTO_INCREMENT
- `02` ⭐ `RETURNING` · UPSERT(`ON CONFLICT`) · 생성 컬럼 ↔ MySQL `ON DUPLICATE KEY`
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
- `02` ROLE · GRANT · 스키마 권한 · 앱 전용 유저 (RLS와 연결)
- `03` ⭐ **연결 풀링(PgBouncer · 풀 사이징 · 서버리스 connection storm)** · 확장(pgcrypto · **pgvector**) · 백업(`pg_dump`) · 회고 & 다음 로드맵(파티셔닝/논리 복제 등)

## 7. 스코프 결정 (포함/제외)

- **포함**: 위 18편. 최근 실무 디테일(UUIDv7, timestamptz 타임존, keyset pagination, pgvector) 주입.
- **제외**: `LISTEN/NOTIFY`(전용 메시지 브로커로 대체되는 추세), 파티셔닝(대규모 한정 → Week 6.03 회고에서 "다음 로드맵"으로만 언급), 논리 복제/CDC(운영 심화).
- **YAGNI**: DBA 전용 운영(레플리케이션 설정, 페일오버), 엔진 소스 레벨 내부는 다루지 않음.

## 8. 저장소 설정 변경 (필수 선행)

PostgreSQL 콘텐츠를 커밋하려면 저장소 자체 규칙을 따라야 함:

- `commitlint.config.js`의 `scope-enum`에 **`be(postgresql)`** 추가.
- `CLAUDE.md`의 백엔드 폴더 구조 및 scope 목록에 `postgresql` / `be(postgresql)` 반영.

## 9. 성공 기준

- 18편 각각이 작성 원칙(비유→시각화→실행 SQL→비교→함정→셀프체크)을 충족.
- 모든 `.sql` 예제가 `code/`의 docker-compose Postgres에서 실제로 실행됨.
- README.md 인덱스 + index.html 랜딩이 FastAPI 자료와 동등한 완성도.
