-- =========================================================================
-- Week 2 · Lesson 01 — DDL · 제약 · 기본키 전략
-- postgres:18 에서 검증됨. 멱등(idempotent): 여러 번 실행해도 깨끗하게 동작.
-- DB 띄우기: ../../week01-overview-env-types/code/docker-compose.yml 사용.
-- =========================================================================

-- 확장: 제외 제약(EXCLUDE USING gist)에서 = 연산자를 쓰려면 필요
CREATE EXTENSION IF NOT EXISTS btree_gist;

-- 정리(이전 실행 잔여물 제거) — 자식부터, FK 때문에 CASCADE
DROP TABLE IF EXISTS orders, users, room_booking, membership CASCADE;

-- 1) CREATE TABLE & 컬럼 제약 — NOT NULL / DEFAULT / UNIQUE / CHECK
CREATE TABLE users (
  id          int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email       text NOT NULL UNIQUE,                 -- 비어 있을 수 없고 중복 불가
  age         int CHECK (age >= 0 AND age < 150),   -- 값의 범위를 DB가 강제
  status      text NOT NULL DEFAULT 'active',       -- 미지정 시 기본값
  created_at  timestamptz NOT NULL DEFAULT now()
);

INSERT INTO users (email, age) VALUES ('a@ex.com', 30), ('b@ex.com', 25);
SELECT id, email, age, status FROM users ORDER BY id;

-- 제약 위반은 DB가 막는다 (아래는 '의도적 에러'라 주석 처리 — 실행하면 ERROR)
--   INSERT INTO users (email, age) VALUES ('a@ex.com', 40);  -- UNIQUE 위반(중복 이메일)
--   INSERT INTO users (email, age) VALUES ('c@ex.com', -5);  -- CHECK 위반(나이 음수)
--   INSERT INTO users (email)      VALUES (NULL);            -- NOT NULL 위반

-- 2) 외래키(FK)와 참조 무결성 — REFERENCES + ON DELETE 동작
CREATE TABLE orders (
  id        int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id   int NOT NULL REFERENCES users(id) ON DELETE CASCADE,  -- 부모 삭제 시 함께 삭제
  amount    numeric(10,2) NOT NULL CHECK (amount > 0)
);

INSERT INTO orders (user_id, amount) VALUES (1, 9.99), (1, 5.00), (2, 12.50);
SELECT * FROM orders ORDER BY id;

-- ON DELETE CASCADE 시연: user 1을 지우면 그 주문도 함께 사라진다
DELETE FROM users WHERE id = 1;
SELECT * FROM orders ORDER BY id;   -- user_id=1 주문이 모두 사라졌는지 확인

-- 존재하지 않는 부모를 참조하면 막힌다 (의도적 에러 — 주석)
--   INSERT INTO orders (user_id, amount) VALUES (999, 1.00);  -- FK 위반

-- 3) 기본키 전략 — IDENTITY(권장) vs uuidv7()(분산/외부노출)
--    Week1 L03 복습: 정수 키는 IDENTITY, UUID 키는 PG18 내장 uuidv7()
CREATE TABLE membership (
  id      uuid PRIMARY KEY DEFAULT uuidv7(),   -- 외부 노출/분산 환경에 유리
  label   text NOT NULL
);
INSERT INTO membership (label) VALUES ('gold'), ('silver');
SELECT id, label FROM membership ORDER BY id;  -- uuidv7은 생성 순서대로 정렬

-- 4) 시퀀스(SEQUENCE) — IDENTITY 뒤의 시퀀스, 그리고 직접 만들기
--    IDENTITY 컬럼이 소유한 시퀀스를 카탈로그로 확인
SELECT pg_get_serial_sequence('users', 'id') AS owned_sequence;

DROP SEQUENCE IF EXISTS ticket_seq;
CREATE SEQUENCE ticket_seq START 100 INCREMENT 1;
SELECT nextval('ticket_seq');   -- 100
SELECT nextval('ticket_seq');   -- 101
SELECT currval('ticket_seq');   -- 101 (이 세션의 마지막 값)
DROP SEQUENCE ticket_seq;

-- 5) (PG18) 제외 제약 & temporal 맛보기
-- 5a) EXCLUDE USING gist — "같은 방(room)이면서(=) 시간대가 겹치면(&&) 안 됨"
CREATE TABLE room_booking (
  id      int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  room    text NOT NULL,
  during  tsrange NOT NULL,
  EXCLUDE USING gist (room WITH =, during WITH &&)
);
INSERT INTO room_booking (room, during)
  VALUES ('A', '[2026-06-09 10:00, 2026-06-09 11:00)');
INSERT INTO room_booking (room, during)        -- 다른 방이면 같은 시간대 OK
  VALUES ('B', '[2026-06-09 10:00, 2026-06-09 11:00)');
INSERT INTO room_booking (room, during)        -- 같은 방 A의 인접(겹치지 않는) 시간 OK
  VALUES ('A', '[2026-06-09 11:00, 2026-06-09 12:00)');
SELECT id, room, during FROM room_booking ORDER BY id;

-- 같은 방 A의 겹치는 시간대는 막힌다 (의도적 에러 — 주석)
--   INSERT INTO room_booking (room, during)
--     VALUES ('A', '[2026-06-09 10:30, 2026-06-09 11:30)');  -- EXCLUDE 위반

-- 5b) (PG18) temporal PRIMARY KEY — WITHOUT OVERLAPS
--     (id, 기간) 조합에서 같은 id끼리 기간이 겹치지 않도록 PK가 직접 보장
DROP TABLE IF EXISTS price_history;
CREATE TABLE price_history (
  product_id  int,
  valid_at    daterange,
  price       numeric(10,2) NOT NULL,
  PRIMARY KEY (product_id, valid_at WITHOUT OVERLAPS)   -- PG18 temporal PK
);
INSERT INTO price_history VALUES (1, '[2026-01-01, 2026-06-01)', 10.00);
INSERT INTO price_history VALUES (1, '[2026-06-01, 2026-12-01)', 12.00);  -- 인접, OK
SELECT * FROM price_history ORDER BY valid_at;

-- 같은 product_id의 겹치는 기간은 막힌다 (의도적 에러 — 주석)
--   INSERT INTO price_history VALUES (1, '[2026-03-01, 2026-09-01)', 11.00);

-- 정리
DROP TABLE IF EXISTS orders, users, room_booking, membership, price_history CASCADE;
