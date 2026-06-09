-- =========================================================================
-- Week 3 · Lesson 01 — JSON vs JSONB · 연산자 · GIN 인덱스
-- postgres:18 에서 검증됨. 멱등(idempotent): 여러 번 실행해도 깨끗하게 동작.
-- DB 띄우기: ../../week01-overview-env-types/code/docker-compose.yml 사용.
-- =========================================================================

-- 정리(이전 실행 잔여물 제거)
DROP TABLE IF EXISTS events, products CASCADE;

-- 1) json vs jsonb — 같은 값을 두 타입에 넣어 차이 보기
--    json  : 원문 텍스트 그대로 보존(키 순서·중복키·공백 유지)
--    jsonb : 파싱된 바이너리(키 정렬·중복 제거·공백 정규화)
SELECT
  '{"b":1, "a":2, "a":3}'::json  AS as_json,    -- 원문 그대로(중복 a 유지)
  '{"b":1, "a":2, "a":3}'::jsonb AS as_jsonb;    -- 정규화(키 정렬, 중복 제거 → 마지막 승)

-- 2) 핵심 연산자 — 앱에서는 거의 항상 jsonb
CREATE TABLE products (
  id    int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name  text NOT NULL,
  data  jsonb NOT NULL
);

INSERT INTO products (name, data) VALUES
  ('키보드', '{"brand":"Keychron","price":129, "tags":["mech","wireless"], "spec":{"switch":"brown"}}'),
  ('마우스', '{"brand":"Logitech","price":59,  "tags":["wireless"],         "spec":{"dpi":8000}}'),
  ('모니터', '{"brand":"LG","price":299,       "tags":["4k","ips"],          "spec":{"size":27}}');

-- ->  : 키로 접근, 결과는 jsonb (다시 ->/->> 로 이어 쓸 수 있음)
-- ->> : 키로 접근, 결과는 text  (비교·출력에 바로 쓰기 좋음)
SELECT
  name,
  data -> 'brand'        AS brand_jsonb,   -- "Keychron" (따옴표 포함된 jsonb)
  data ->> 'brand'       AS brand_text,    -- Keychron   (순수 text)
  (data ->> 'price')::int AS price_int     -- text를 int로 캐스팅
FROM products
ORDER BY id;

-- #> / #>> : 경로(path)로 깊이 접근. #>는 jsonb, #>>는 text
SELECT
  name,
  data #> '{spec}'          AS spec_jsonb,   -- {"switch":"brown"} 등
  data #>> '{spec,switch}'  AS switch_text   -- brown / NULL
FROM products
ORDER BY id;

-- @> : 포함(containment) — "왼쪽 jsonb가 오른쪽을 포함하는가"
--      GIN 인덱스로 가속되는 핵심 검색 연산자
SELECT name FROM products
WHERE data @> '{"brand":"LG"}';                 -- 모니터

SELECT name FROM products
WHERE data @> '{"tags":["wireless"]}';          -- 키보드, 마우스 (배열 포함도 OK)

-- ? / ?| / ?& : 최상위 '키'가 존재하는가
SELECT name FROM products WHERE data ? 'spec';                 -- 모두(최상위 spec 키 보유)
SELECT name FROM products WHERE data ?| array['tags','spec'];  -- 모두(tags 또는 spec)
SELECT name FROM products WHERE data ?& array['brand','price'];-- 모두(brand 그리고 price)

-- 3) jsonb 갱신 — jsonb_set / || / - / #-
-- jsonb_set: 특정 경로의 값을 교체(또는 생성)
UPDATE products
SET data = jsonb_set(data, '{price}', '139')
WHERE name = '키보드';

-- || : 병합(merge). 같은 키는 오른쪽이 덮어씀, 없는 키는 추가
UPDATE products
SET data = data || '{"in_stock": true}'::jsonb
WHERE name = '마우스';

-- - : 최상위 키 삭제 / #- : 경로로 깊은 키 삭제
UPDATE products
SET data = data - 'tags'                 -- 'tags' 키 통째로 제거
WHERE name = '모니터';

UPDATE products
SET data = data #- '{spec,dpi}'          -- spec.dpi 경로만 제거
WHERE name = '마우스';

SELECT name, data FROM products ORDER BY id;

-- 4) GIN 인덱스 — @> 검색을 가속
-- 기본 GIN: @>, ?, ?|, ?& 모두 지원(키 존재 검색도 가능)
CREATE INDEX idx_products_data ON products USING gin (data);

-- jsonb_path_ops GIN: @> 만 지원하지만 더 작고 빠름(키 존재 ?는 불가)
CREATE TABLE events (
  id    int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  payload jsonb NOT NULL
);
INSERT INTO events (payload)
SELECT jsonb_build_object('type', t, 'level', (i % 3))
FROM generate_series(1, 500) i,
     (VALUES ('login'),('logout'),('error')) AS v(t);

CREATE INDEX idx_events_payload ON events USING gin (payload jsonb_path_ops);

-- 인덱스가 @> 검색에 쓰이는지 EXPLAIN으로 확인
EXPLAIN (COSTS OFF)
SELECT * FROM events WHERE payload @> '{"type":"error"}';

-- (선택) jsonb_path_query — SQL/JSON 경로 질의 맛보기
SELECT jsonb_path_query(
  '{"items":[{"q":2},{"q":5},{"q":9}]}'::jsonb,
  '$.items[*].q ? (@ > 4)'
) AS big_q;

-- 정리
DROP TABLE IF EXISTS events, products CASCADE;
