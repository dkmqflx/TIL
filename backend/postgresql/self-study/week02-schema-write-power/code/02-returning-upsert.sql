-- =========================================================================
-- Week 2 · Lesson 02 — RETURNING · UPSERT · MERGE · 생성 컬럼
-- postgres:18 에서 검증됨. 멱등(idempotent).
-- DB 띄우기: ../../week01-overview-env-types/code/docker-compose.yml 사용.
-- =========================================================================

DROP TABLE IF EXISTS products, inventory, stock_feed CASCADE;

-- 1) RETURNING — 쓰기 한 번에 결과까지 받아온다
CREATE TABLE products (
  id          int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  sku         text NOT NULL UNIQUE,
  price       numeric(10,2) NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- INSERT ... RETURNING: 방금 생성된 id, created_at을 재조회 없이 즉시 받는다
INSERT INTO products (sku, price) VALUES ('A-1', 100.00)
  RETURNING id, created_at;

-- DELETE ... RETURNING: 무엇을 지웠는지 그대로 돌려받는다
INSERT INTO products (sku, price) VALUES ('TMP', 1.00);
DELETE FROM products WHERE sku = 'TMP' RETURNING id, sku;

-- (PG18) RETURNING old.* / new.* — UPDATE 전후 값을 한 번에
-- old.*, new.* 를 그대로 쓰면 컬럼명이 겹치므로(예: price 두 번) 별칭으로 깔끔하게
UPDATE products SET price = price * 1.10 WHERE sku = 'A-1'
  RETURNING old.price AS old_price, new.price AS new_price;

-- 2) UPSERT — INSERT ... ON CONFLICT ("있으면 수정, 없으면 삽입")
CREATE TABLE inventory (
  sku    text PRIMARY KEY,
  qty    int NOT NULL
);

-- 첫 INSERT: 충돌 없음 → 그냥 삽입
INSERT INTO inventory (sku, qty) VALUES ('A-1', 10)
  ON CONFLICT (sku) DO UPDATE SET qty = inventory.qty + EXCLUDED.qty;

-- 두 번째: sku='A-1' 충돌 → EXCLUDED(삽입하려던 행)의 qty를 더해 갱신
INSERT INTO inventory (sku, qty) VALUES ('A-1', 5)
  ON CONFLICT (sku) DO UPDATE SET qty = inventory.qty + EXCLUDED.qty;
SELECT * FROM inventory;   -- qty = 15

-- DO NOTHING: 충돌하면 조용히 무시(중복 삽입 방지)
INSERT INTO inventory (sku, qty) VALUES ('A-1', 999)
  ON CONFLICT (sku) DO NOTHING;
SELECT * FROM inventory;   -- 여전히 15

-- 3) MERGE — SQL 표준. 소스 테이블과 조인해 매칭 여부로 분기
CREATE TABLE stock_feed (sku text, qty int);
INSERT INTO stock_feed VALUES ('A-1', 100), ('B-2', 7);  -- 외부에서 들어온 재고 피드

MERGE INTO inventory AS tgt
USING stock_feed AS src
  ON tgt.sku = src.sku
WHEN MATCHED THEN
  UPDATE SET qty = src.qty               -- 이미 있으면 덮어쓰기
WHEN NOT MATCHED THEN
  INSERT (sku, qty) VALUES (src.sku, src.qty);  -- 없으면 삽입
SELECT * FROM inventory ORDER BY sku;    -- A-1=100(갱신), B-2=7(신규)

-- 4) 생성 컬럼(Generated Columns) — STORED vs (PG18 기본) virtual
DROP TABLE IF EXISTS line_item;
CREATE TABLE line_item (
  name        text,
  price       numeric(10,2),
  -- STORED: 디스크에 계산 결과를 저장(쓸 때 계산)
  price_tax   numeric(10,2) GENERATED ALWAYS AS (price * 1.10) STORED,
  -- (PG18) 키워드 생략 시 기본은 virtual: 저장하지 않고 읽을 때 계산
  search_name text GENERATED ALWAYS AS (lower(name))
);
INSERT INTO line_item (name, price) VALUES ('Coffee', 100.00);
SELECT * FROM line_item;

-- 카탈로그로 STORED('s') vs virtual('v') 확인 (PG18: 키워드 없으면 'v')
SELECT attname, attgenerated
  FROM pg_attribute
  WHERE attrelid = 'line_item'::regclass AND attgenerated <> ''
  ORDER BY attnum;

-- 정리
DROP TABLE IF EXISTS products, inventory, stock_feed, line_item CASCADE;
