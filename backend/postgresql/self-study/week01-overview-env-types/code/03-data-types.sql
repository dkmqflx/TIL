-- 정리(이전 실행 잔여물 제거)
DROP TABLE IF EXISTS old_way, std_way, evt, log;

-- 1) 자동증가 키: SERIAL(구식) vs IDENTITY(SQL 표준, 권장)
CREATE TABLE old_way (id serial PRIMARY KEY, name text);
CREATE TABLE std_way (id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY, name text);

-- 2) PG18 네이티브 UUIDv7 — 시간순으로 정렬되는 UUID (인덱스 친화적)
SELECT uuidv7();                       -- PG18+
CREATE TABLE evt (
  id uuid PRIMARY KEY DEFAULT uuidv7(),
  payload text
);
INSERT INTO evt (payload) VALUES ('a'), ('b'), ('c');
SELECT id FROM evt ORDER BY id;        -- 생성 순서대로 정렬됨에 주목

-- 3) timestamptz — 앱에선 거의 항상 timestamptz
CREATE TABLE log (
  at_wrong timestamp,        -- 타임존 정보 없음 (지뢰)
  at_right timestamptz       -- UTC로 저장, 세션 타임존으로 표시
);
SHOW timezone;
INSERT INTO log VALUES (now(), now());
SELECT * FROM log;

-- 세션 타임존을 바꿔 보면 함정이 드러난다
SET timezone TO 'Asia/Seoul';
SELECT * FROM log;   -- at_wrong는 그대로(타임존 무시), at_right는 +09로 변환되어 표시
RESET timezone;

-- 4) numeric vs float — 돈/정밀 계산은 numeric
SELECT 0.1::float8 + 0.2::float8 AS float_bad,    -- 0.30000000000000004
       0.1::numeric + 0.2::numeric AS numeric_ok; -- 0.3

-- 정리
DROP TABLE IF EXISTS old_way, std_way, evt, log;
