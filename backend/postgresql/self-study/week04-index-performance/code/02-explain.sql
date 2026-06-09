-- =========================================================================
-- Week 4 · Lesson 02 — EXPLAIN ANALYZE · 플래너 · 통계 · 인덱스 함정
-- postgres:18 에서 검증됨. 멱등(idempotent): 여러 번 실행해도 깨끗하게 동작.
-- DB 띄우기: ../../week01-overview-env-types/code/docker-compose.yml 사용.
-- =========================================================================

DROP TABLE IF EXISTS orders CASCADE;

-- 10만 행: status는 5%만 'shipped'(선택도 낮음), 나머지는 흔함
CREATE TABLE orders (
  id        int  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id   int  NOT NULL,
  status    text NOT NULL,        -- 'pending'(95%) / 'shipped'(5%)
  amount    numeric(10,2) NOT NULL,
  created_at timestamptz NOT NULL
);

INSERT INTO orders (user_id, status, amount, created_at)
SELECT
  (i % 5000) + 1,
  CASE WHEN i % 20 = 0 THEN 'shipped' ELSE 'pending' END,
  (i % 1000)::numeric + 0.99,
  timestamptz '2024-01-01' + (i || ' minutes')::interval
FROM generate_series(1, 100000) AS i;

CREATE INDEX idx_orders_status ON orders (status);
CREATE INDEX idx_orders_user   ON orders (user_id);

-- 통계 갱신(필수)
ANALYZE orders;

-- =========================================================================
-- 1) EXPLAIN(추정) vs EXPLAIN ANALYZE(실측)
-- =========================================================================
-- 추정만: 실제로 실행하지 않고 플래너의 비용 추정만 본다
EXPLAIN
SELECT * FROM orders WHERE user_id = 42;

-- 실측: 실제 실행 + actual time/rows + 버퍼 사용량
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM orders WHERE user_id = 42;

-- =========================================================================
-- 2) Seq Scan vs Index/Bitmap Scan — 선택도에 따라 플래너가 고른다
-- =========================================================================
-- (a) 낮은 선택도(5% 'shipped') → 인덱스 경로
EXPLAIN (ANALYZE, BUFFERS, COSTS OFF)
SELECT * FROM orders WHERE status = 'shipped';

-- (b) 높은 선택도(95% 'pending') → 인덱스가 쓸모없어 Seq Scan이 더 빠름
EXPLAIN (ANALYZE, BUFFERS, COSTS OFF)
SELECT * FROM orders WHERE status = 'pending';

-- =========================================================================
-- 3) 통계 & ANALYZE — 추정이 틀리면 나쁜 플랜
-- =========================================================================
-- 통계를 일부러 망가뜨림: 대량 변경 후 ANALYZE를 생략하면 추정이 어긋난다
UPDATE orders SET status = 'shipped' WHERE id <= 90000;  -- 이제 대부분 shipped

-- ANALYZE 전: 플래너는 여전히 'shipped'가 5%라고 착각 → 추정 rows가 실제와 크게 다름
EXPLAIN (ANALYZE, COSTS OFF)
SELECT * FROM orders WHERE status = 'shipped';

-- ANALYZE 후: 통계가 갱신되어 추정이 실제에 가까워지고 Seq Scan으로 교정
ANALYZE orders;
EXPLAIN (ANALYZE, COSTS OFF)
SELECT * FROM orders WHERE status = 'shipped';

-- 원복
UPDATE orders SET status = 'pending'
WHERE id <= 90000 AND id % 20 <> 0;
UPDATE orders SET status = 'shipped' WHERE id % 20 = 0 AND id <= 90000;
ANALYZE orders;

-- default_statistics_target: 통계 표본 크기(기본 100). 분포가 치우친 컬럼은 ↑
SHOW default_statistics_target;

-- =========================================================================
-- 4) 인덱스 함정 — 인덱스를 못 타게 만드는 흔한 실수
-- =========================================================================
-- (함정 a) 컬럼에 함수를 씌우면 일반 인덱스를 못 탄다 → Seq Scan
EXPLAIN (ANALYZE, BUFFERS, COSTS OFF)
SELECT * FROM orders WHERE upper(status) = 'SHIPPED';

-- (고치기) expression 인덱스를 만들면 다시 인덱스를 탄다
CREATE INDEX idx_orders_upper_status ON orders (upper(status));
EXPLAIN (ANALYZE, BUFFERS, COSTS OFF)
SELECT * FROM orders WHERE upper(status) = 'SHIPPED';
DROP INDEX idx_orders_upper_status;

-- (함정 b) 앞 와일드카드 LIKE '%x' → prefix가 없어 B-tree 못 씀
EXPLAIN (ANALYZE, COSTS OFF)
SELECT * FROM orders WHERE status LIKE '%ipped';

-- 정리
DROP TABLE IF EXISTS orders CASCADE;
