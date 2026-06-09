-- =========================================================================
-- Week 3 · Lesson 02 — 배열 · enum · range
-- postgres:18 에서 검증됨. 멱등(idempotent): 여러 번 실행해도 깨끗하게 동작.
-- DB 띄우기: ../../week01-overview-env-types/code/docker-compose.yml 사용.
-- =========================================================================

-- EXCLUDE(range 겹침 방지)에서 = 연산자를 쓰려면 필요 (Week2 연결)
CREATE EXTENSION IF NOT EXISTS btree_gist;

-- 정리(이전 실행 잔여물 제거)
DROP TABLE IF EXISTS articles, mood_log, room_booking CASCADE;
DROP TYPE  IF EXISTS mood CASCADE;

-- 1) 배열(array) — text[], int[]
CREATE TABLE articles (
  id    int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title text NOT NULL,
  tags  text[] NOT NULL DEFAULT '{}'    -- 빈 배열 기본값
);

-- 리터럴 '{a,b}' 또는 ARRAY[...] 두 방식 모두 가능
INSERT INTO articles (title, tags) VALUES
  ('Postgres 입문', '{db,sql,postgres}'),
  ('JSONB 검색',    ARRAY['db','postgres','jsonb']),
  ('CSS 그리드',    '{css,frontend}');

-- 인덱싱은 1-based(MySQL/대부분 언어의 0-based와 다름)
SELECT title, tags[1] AS first_tag, array_length(tags, 1) AS n_tags
FROM articles ORDER BY id;

-- ANY: 배열 안에 특정 값이 있는가
SELECT title FROM articles WHERE 'postgres' = ANY(tags);   -- 입문, JSONB

-- @> : 포함 / && : 겹침(overlap)
SELECT title FROM articles WHERE tags @> ARRAY['db','sql'];   -- 입문(둘 다 포함)
SELECT title FROM articles WHERE tags && ARRAY['css','jsonb'];-- JSONB, CSS(하나라도 겹침)

-- unnest: 배열을 행으로 펼치기 / array_agg: 행을 배열로 모으기
SELECT tag, count(*) AS n
FROM articles, unnest(tags) AS tag
GROUP BY tag ORDER BY n DESC, tag;

SELECT array_agg(title ORDER BY id) AS all_titles FROM articles;

-- 배열도 GIN 인덱스로 @>, &&, = ANY 검색을 가속
CREATE INDEX idx_articles_tags ON articles USING gin (tags);

-- 2) enum — 재사용 가능한 '타입'으로 정의
CREATE TYPE mood AS ENUM ('low', 'mid', 'high');

-- 값 추가는 ALTER TYPE ... ADD VALUE (IF NOT EXISTS로 재실행 안전)
ALTER TYPE mood ADD VALUE IF NOT EXISTS 'peak';   -- 끝에 추가

CREATE TABLE mood_log (
  id    int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  note  text NOT NULL,
  level mood NOT NULL
);
INSERT INTO mood_log (note, level) VALUES
  ('피곤', 'low'), ('보통', 'mid'), ('최고', 'peak'), ('좋음', 'high');

-- 정렬은 알파벳이 아니라 '정의한 순서'(low < mid < high < peak)
SELECT note, level FROM mood_log ORDER BY level;

-- 잘못된 값은 DB가 거부 (의도적 에러 — 주석)
--   INSERT INTO mood_log (note, level) VALUES ('???', 'unknown');  -- invalid enum value

-- 3) range 타입 — int4range / numrange / tstzrange
-- 경계 표기 [) : 시작 포함, 끝 미포함 (기본이자 권장)
SELECT
  int4range(1, 10)            AS r1,          -- [1,10)
  numrange(0, 100) @> 50::numeric AS contains_50,  -- t (포함)
  int4range(1,10) && int4range(5,20) AS overlaps;  -- t (겹침)

-- 예: 회의실 예약 — 같은 방의 시간대 겹침을 EXCLUDE로 막기 (Week2 연결)
CREATE TABLE room_booking (
  id     int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  room   text NOT NULL,
  during tstzrange NOT NULL,
  EXCLUDE USING gist (room WITH =, during WITH &&)
);
INSERT INTO room_booking (room, during) VALUES
  ('A', '[2026-06-09 10:00+09, 2026-06-09 11:00+09)'),   -- OK
  ('A', '[2026-06-09 11:00+09, 2026-06-09 12:00+09)');   -- 인접, 안 겹침 → OK
SELECT id, room, during FROM room_booking ORDER BY id;

-- 같은 방 A의 겹치는 시간대는 막힌다 (의도적 에러 — 주석)
--   INSERT INTO room_booking (room, during)
--     VALUES ('A', '[2026-06-09 10:30+09, 2026-06-09 11:30+09)');  -- EXCLUDE 위반

-- 정리
DROP TABLE IF EXISTS articles, mood_log, room_booking CASCADE;
DROP TYPE  IF EXISTS mood CASCADE;
