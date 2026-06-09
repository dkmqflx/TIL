-- =========================================================================
-- Week 4 · Lesson 01 — 인덱스 종류 (B-tree · GIN · GiST · BRIN · partial · expression)
-- postgres:18 에서 검증됨. 멱등(idempotent): 여러 번 실행해도 깨끗하게 동작.
-- DB 띄우기: ../../week01-overview-env-types/code/docker-compose.yml 사용.
-- =========================================================================

-- 정리(이전 실행 잔여물 제거)
DROP TABLE IF EXISTS users, sensors CASCADE;

-- =========================================================================
-- 1) B-tree 기본 — 등호·범위·정렬·prefix LIKE 에 쓰이는 기본 인덱스
--    인덱스가 실제로 쓰이려면 행이 충분해야 한다 → 10만 행 생성
-- =========================================================================
CREATE TABLE users (
  id       int  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email    text NOT NULL,
  status   text NOT NULL,        -- 'active' / 'inactive'
  age      int  NOT NULL
);

INSERT INTO users (email, status, age)
SELECT
  'User' || i || '@Example.com',
  CASE WHEN i % 20 = 0 THEN 'inactive' ELSE 'active' END,  -- 5%만 inactive
  18 + (i % 60)
FROM generate_series(1, 100000) AS i;

-- 통계 갱신(필수): 이게 없으면 추정이 틀려 나쁜 플랜이 나온다
ANALYZE users;

-- B-tree 인덱스: 등호/범위/정렬에 모두 쓰임
CREATE INDEX idx_users_age ON users (age);

EXPLAIN (ANALYZE, BUFFERS, COSTS OFF)
SELECT * FROM users WHERE age = 25;          -- 등호 → Index Scan/Bitmap

-- =========================================================================
-- 2) partial index — 일부 행만 인덱싱(작고 빠름)
--    inactive(5%)만 인덱싱. 쿼리의 WHERE 가 partial 조건과 맞아야 쓰인다
-- =========================================================================
CREATE INDEX idx_users_inactive ON users (id) WHERE status = 'inactive';

EXPLAIN (ANALYZE, BUFFERS, COSTS OFF)
SELECT id FROM users WHERE status = 'inactive';

-- partial vs 전체 인덱스 크기 비교(부분 인덱스가 훨씬 작다)
CREATE INDEX idx_users_status_full ON users (status);
SELECT
  pg_size_pretty(pg_relation_size('idx_users_inactive'))    AS partial_size,
  pg_size_pretty(pg_relation_size('idx_users_status_full')) AS full_size;
DROP INDEX idx_users_status_full;

-- =========================================================================
-- 3) expression index — 함수 결과를 인덱싱
--    WHERE lower(email)=... 는 일반 인덱스를 못 탄다 → lower(email) 인덱스 필요
-- =========================================================================
CREATE INDEX idx_users_lower_email ON users (lower(email));

EXPLAIN (ANALYZE, BUFFERS, COSTS OFF)
SELECT id FROM users WHERE lower(email) = 'user500@example.com';

-- =========================================================================
-- 4) 멀티컬럼 인덱스 & 컬럼 순서(왼쪽 접두 규칙) + covering INCLUDE
--    age 단독 인덱스를 제거하고, (email, age) 복합 인덱스만 남긴다.
--    선두 컬럼 email 은 distinct 값이 많아(고유) 왼쪽 접두 규칙을 깨끗이 본다.
-- =========================================================================
DROP INDEX idx_users_age;
CREATE INDEX idx_users_email_age ON users (email, age) INCLUDE (status);

-- 선두 컬럼(email) + age → 복합 인덱스를 탄다(INCLUDE(status)로 Index Only Scan)
EXPLAIN (ANALYZE, BUFFERS, COSTS OFF)
SELECT status FROM users WHERE email = 'User500@Example.com' AND age = 38;

-- 선두 컬럼(email) 없이 age 만으로는 (email, age) 인덱스를 못 쓴다 → Seq Scan
EXPLAIN (ANALYZE, BUFFERS, COSTS OFF)
SELECT * FROM users WHERE age = 30;

-- =========================================================================
-- 5) BRIN — 거대한 자연정렬 테이블에 매우 작은 인덱스
--    물리적으로 정렬되어 들어간 컬럼(시계열 ts 등)에 적합
-- =========================================================================
CREATE TABLE sensors (
  id  int  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  ts  timestamptz NOT NULL,         -- 순차 증가(자연정렬)
  val int NOT NULL
);
INSERT INTO sensors (ts, val)
SELECT timestamptz '2024-01-01' + (i || ' seconds')::interval, (i % 1000)
FROM generate_series(1, 500000) AS i;
ANALYZE sensors;

-- 같은 컬럼에 BRIN vs B-tree 크기 비교 → BRIN이 압도적으로 작다
CREATE INDEX idx_sensors_ts_brin  ON sensors USING brin (ts);
CREATE INDEX idx_sensors_ts_btree ON sensors (ts);
SELECT
  pg_size_pretty(pg_relation_size('idx_sensors_ts_brin'))  AS brin_size,
  pg_size_pretty(pg_relation_size('idx_sensors_ts_btree')) AS btree_size;
DROP INDEX idx_sensors_ts_btree;   -- 비교 끝, B-tree 제거

-- BRIN으로 범위 조회
EXPLAIN (ANALYZE, BUFFERS, COSTS OFF)
SELECT count(*) FROM sensors
WHERE ts BETWEEN '2024-01-02' AND '2024-01-03';

-- 정리
DROP TABLE IF EXISTS users, sensors CASCADE;
