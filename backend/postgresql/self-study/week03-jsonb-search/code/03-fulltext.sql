-- =========================================================================
-- Week 3 · Lesson 03 — 전문검색 tsvector/tsquery · pg_trgm
-- postgres:18 에서 검증됨. 멱등(idempotent): 여러 번 실행해도 깨끗하게 동작.
-- DB 띄우기: ../../week01-overview-env-types/code/docker-compose.yml 사용.
-- =========================================================================

-- 트라이그램 검색 확장 (postgres:18 공식 이미지에 contrib로 포함)
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- 정리(이전 실행 잔여물 제거)
DROP TABLE IF EXISTS docs, docs_big CASCADE;

-- 1) 왜 LIKE '%...%'로는 부족한가
--    선두 와일드카드 LIKE는 일반 B-tree 인덱스를 못 탄다(전체 스캔).
--    형태소 분석·랭킹도 없다.
CREATE TABLE docs (
  id    int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title text NOT NULL,
  body  text NOT NULL,
  -- 2) tsvector를 '생성 컬럼(STORED)'으로 미리 계산해 둔다 → GIN으로 인덱싱
  --    english 사전: 어간 분석(running→run) 지원. 한국어는 simple로 처리.
  search tsvector GENERATED ALWAYS AS (
    to_tsvector('english', title || ' ' || body)
  ) STORED
);

INSERT INTO docs (title, body) VALUES
  ('Postgres indexing',  'Indexes make queries run fast. Running a scan is slow.'),
  ('Full text search',   'Use tsvector and tsquery for searching documents.'),
  ('JSONB and GIN',      'GIN indexes accelerate jsonb containment searches.'),
  ('Trigram matching',   'pg_trgm enables fuzzy and partial matching.');

-- 생성 컬럼 search 에 GIN 인덱스
CREATE INDEX idx_docs_search ON docs USING gin (search);

-- 2) tsvector @@ tsquery 매칭
-- to_tsquery: 연산자(&, |, !) 직접 사용 / plainto_tsquery: 평문을 AND로
-- websearch_to_tsquery: 웹 검색 문법("따옴표", -제외, or)
SELECT title FROM docs WHERE search @@ to_tsquery('english', 'run');     -- 어간 → running/run 매칭
SELECT title FROM docs WHERE search @@ plainto_tsquery('english', 'search documents');
SELECT title FROM docs WHERE search @@ websearch_to_tsquery('english', 'gin or trigram');

-- ts_rank로 관련도 랭킹
SELECT title, ts_rank(search, q) AS rank
FROM docs, to_tsquery('english', 'index | search') AS q
WHERE search @@ q
ORDER BY rank DESC;

-- 한국어: 기본 사전은 한국어 형태소를 모른다 → 'simple'(토큰 그대로) 사용
-- 공백 단위로 끊기므로 부분일치는 약하다 → pg_trgm로 보완(아래 3번)
SELECT to_tsvector('simple', '포스트그레스 전문검색 예제') AS ko_simple;

-- 3) pg_trgm — 트라이그램으로 유사도/부분일치/오타 허용
-- similarity(): 0~1 유사도 점수
SELECT similarity('postgres', 'postgrey') AS sim;   -- 오타에도 높은 점수

-- % 연산자: 유사도 임계값(기본 0.3) 이상이면 참
SELECT title FROM docs WHERE title % 'Postgrez';    -- 오타 'Postgrez' → 'Postgres indexing'

SELECT title FROM docs WHERE title ILIKE '%text%';   -- 부분일치 결과(작은 표라 seq scan)

-- 4) 인덱스가 '실제로' 쓰이는지 확인하려면 행이 충분해야 한다
--    작은 표(4행)는 플래너가 그냥 seq scan을 고른다 → 대량 표로 시연
CREATE TABLE docs_big (
  id    int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title text NOT NULL,
  body  text NOT NULL,
  search tsvector GENERATED ALWAYS AS (
    to_tsvector('english', title || ' ' || body)
  ) STORED
);
INSERT INTO docs_big (title, body)
SELECT 'doc number ' || i,
       (ARRAY['fast index lookup','fuzzy partial match','ranked relevance score',
              'containment query plan','stemmed token vector'])[1 + (i % 5)]
FROM generate_series(1, 5000) i;

-- 4a) tsvector 생성 컬럼 + GIN → @@ 검색이 인덱스를 탄다(함정 회피의 핵심)
CREATE INDEX idx_docsbig_search ON docs_big USING gin (search);
EXPLAIN (COSTS OFF)
SELECT title FROM docs_big WHERE search @@ to_tsquery('english', 'fuzzy');

-- 4b) 트라이그램 GIN → 선두 와일드카드 ILIKE '%..%'도 인덱스를 탄다
CREATE INDEX idx_docsbig_body_trgm ON docs_big USING gin (body gin_trgm_ops);
EXPLAIN (COSTS OFF)
SELECT title FROM docs_big WHERE body ILIKE '%fuzzy%';

-- 정리
DROP TABLE IF EXISTS docs, docs_big CASCADE;
