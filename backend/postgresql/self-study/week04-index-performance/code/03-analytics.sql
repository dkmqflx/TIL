-- =========================================================================
-- Week 4 · Lesson 03 — CTE · 윈도우 함수 · keyset pagination · N+1
-- postgres:18 에서 검증됨. 멱등(idempotent): 여러 번 실행해도 깨끗하게 동작.
-- DB 띄우기: ../../week01-overview-env-types/code/docker-compose.yml 사용.
-- =========================================================================

DROP TABLE IF EXISTS sales, comments CASCADE;

-- =========================================================================
-- 1) CTE (WITH) — 단계를 쪼개 가독성 / 재귀 CTE로 계층 순회
-- =========================================================================
-- 댓글 트리(부모-자식). 재귀 CTE로 깊이(depth)까지 계산
CREATE TABLE comments (
  id        int  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  parent_id int  REFERENCES comments(id),
  body      text NOT NULL
);
INSERT INTO comments (id, parent_id, body) OVERRIDING SYSTEM VALUE VALUES
  (1, NULL, '원댓글'),
  (2, 1,    '답글 A'),
  (3, 1,    '답글 B'),
  (4, 2,    '답글 A-1'),
  (5, 4,    '답글 A-1-1');
SELECT setval(pg_get_serial_sequence('comments','id'), 5);

-- 재귀 CTE: 루트에서 시작해 자식으로 내려가며 depth 누적
WITH RECURSIVE tree AS (
  SELECT id, parent_id, body, 0 AS depth
  FROM comments WHERE parent_id IS NULL
  UNION ALL
  SELECT c.id, c.parent_id, c.body, t.depth + 1
  FROM comments c
  JOIN tree t ON c.parent_id = t.id
)
SELECT id, depth, repeat('  ', depth) || body AS thread
FROM tree ORDER BY id;

-- =========================================================================
-- 2) 윈도우 함수 — 행을 접지 않고 옆에 계산(순위·누계·LAG/LEAD)
-- =========================================================================
CREATE TABLE sales (
  id      int  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  region  text NOT NULL,
  ymd     date NOT NULL,
  amount  int  NOT NULL
);
INSERT INTO sales (region, ymd, amount) VALUES
  ('Seoul', '2024-01-01', 100),
  ('Seoul', '2024-01-02', 150),
  ('Seoul', '2024-01-03', 120),
  ('Busan', '2024-01-01', 200),
  ('Busan', '2024-01-02', 180),
  ('Busan', '2024-01-03', 220);

-- ROW_NUMBER / RANK / DENSE_RANK + 지역별 누계(running total) + LAG(전일 대비)
SELECT
  region, ymd, amount,
  ROW_NUMBER() OVER (PARTITION BY region ORDER BY amount DESC) AS rn,
  RANK()       OVER (PARTITION BY region ORDER BY amount DESC) AS rnk,
  SUM(amount)  OVER (PARTITION BY region ORDER BY ymd)         AS running_total,
  amount - LAG(amount) OVER (PARTITION BY region ORDER BY ymd) AS vs_prev
FROM sales
ORDER BY region, ymd;

-- GROUP BY 와 차이: GROUP BY는 행을 접어 region당 1행만 남긴다
SELECT region, SUM(amount) AS total FROM sales GROUP BY region ORDER BY region;

-- =========================================================================
-- 3) keyset pagination — OFFSET 대안(인덱스로 바로 점프)
--    10만 행으로 OFFSET 깊은 페이지 vs keyset 비용 비교
-- =========================================================================
DROP TABLE IF EXISTS feed CASCADE;
CREATE TABLE feed (
  id         int  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  created_at timestamptz NOT NULL,
  body       text NOT NULL
);
INSERT INTO feed (created_at, body)
SELECT timestamptz '2024-01-01' + (i || ' seconds')::interval, 'post ' || i
FROM generate_series(1, 100000) AS i;
-- 정렬 키 (created_at, id) 에 복합 인덱스
CREATE INDEX idx_feed_created ON feed (created_at, id);
ANALYZE feed;

-- (a) OFFSET 깊은 페이지: 앞 50000행을 모두 읽고 버린다(느림)
EXPLAIN (ANALYZE, BUFFERS, COSTS OFF)
SELECT id, created_at FROM feed
ORDER BY created_at, id
OFFSET 50000 LIMIT 10;

-- (b) keyset: 마지막으로 본 (created_at,id)보다 큰 행만 → 인덱스로 즉시 점프
--     아래 :last 값은 50000번째 근처 행의 키를 직접 넣었다고 가정
EXPLAIN (ANALYZE, BUFFERS, COSTS OFF)
SELECT id, created_at FROM feed
WHERE (created_at, id) > (timestamptz '2024-01-01' + interval '50000 seconds', 50000)
ORDER BY created_at, id
LIMIT 10;

-- =========================================================================
-- 4) N+1 — 여러 번 쿼리 대신 한 방 JOIN
-- =========================================================================
-- ORM에서 흔한 N+1: 글 N개를 가져온 뒤 각 글의 작성자를 한 건씩 또 조회
-- → JOIN 한 방으로 합친다(여기선 sales의 지역 합을 한 번에)
SELECT s.region, s.ymd, s.amount, t.region_total
FROM sales s
JOIN (
  SELECT region, SUM(amount) AS region_total FROM sales GROUP BY region
) t ON t.region = s.region
ORDER BY s.region, s.ymd;

-- 정리
DROP TABLE IF EXISTS sales, comments, feed CASCADE;
