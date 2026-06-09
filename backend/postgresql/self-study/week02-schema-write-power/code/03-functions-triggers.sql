-- =========================================================================
-- Week 2 · Lesson 03 — PL/pgSQL 함수 · 트리거
-- postgres:18 에서 검증됨. 멱등(idempotent).
-- DB 띄우기: ../../week01-overview-env-types/code/docker-compose.yml 사용.
-- =========================================================================

DROP TABLE IF EXISTS article, audit_log CASCADE;

-- 1) PL/pgSQL 함수 — DB 안에 사는 작은 함수
--    CREATE OR REPLACE 라 여러 번 실행해도 안전
CREATE OR REPLACE FUNCTION discounted_price(price numeric, pct numeric)
RETURNS numeric
LANGUAGE plpgsql
AS $$
DECLARE
  result numeric;
BEGIN
  IF pct < 0 OR pct > 100 THEN
    RAISE EXCEPTION '할인율은 0~100 사이여야 합니다: %', pct;
  END IF;
  result := price * (1 - pct / 100);
  RETURN round(result, 2);
END;
$$;

SELECT discounted_price(10000, 30) AS sale_price;   -- 7000.00

-- 2) 트리거 기본 — BEFORE/AFTER, ROW, NEW/OLD
CREATE TABLE article (
  id          int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title       text NOT NULL,
  body        text,
  updated_at  timestamptz NOT NULL DEFAULT now()
);

-- 3) ⭐ updated_at 자동 갱신 트리거 (실무 단골)
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at := now();   -- 행이 저장되기 전(BEFORE)에 값을 손본다
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_set_updated_at ON article;
CREATE TRIGGER trg_set_updated_at
  BEFORE UPDATE ON article
  FOR EACH ROW
  EXECUTE FUNCTION set_updated_at();

INSERT INTO article (title, body) VALUES ('첫 글', '초안');
-- 잠시 후 UPDATE 하면 트리거가 updated_at을 자동으로 now()로 바꾼다
SELECT id, title, updated_at AS before_update FROM article;
UPDATE article SET body = '수정본' WHERE id = 1;
SELECT id, title, updated_at AS after_update FROM article;  -- updated_at 갱신됨

-- 4) 감사 로그(audit) 트리거 — 변경 내용을 jsonb로 자동 기록
CREATE TABLE audit_log (
  id          int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  table_name  text NOT NULL,
  action      text NOT NULL,           -- INSERT / UPDATE / DELETE
  old_row     jsonb,
  new_row     jsonb,
  at          timestamptz NOT NULL DEFAULT now()
);

CREATE OR REPLACE FUNCTION audit_changes()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO audit_log (table_name, action, old_row, new_row)
  VALUES (
    TG_TABLE_NAME,                                       -- 트리거가 걸린 테이블 이름
    TG_OP,                                               -- INSERT/UPDATE/DELETE
    CASE WHEN TG_OP <> 'INSERT' THEN to_jsonb(OLD) END,  -- 변경 전 행
    CASE WHEN TG_OP <> 'DELETE' THEN to_jsonb(NEW) END   -- 변경 후 행
  );
  RETURN NULL;   -- AFTER 트리거의 반환값은 무시됨
END;
$$;

DROP TRIGGER IF EXISTS trg_audit ON article;
CREATE TRIGGER trg_audit
  AFTER INSERT OR UPDATE OR DELETE ON article
  FOR EACH ROW
  EXECUTE FUNCTION audit_changes();

-- INSERT/UPDATE/DELETE를 실행해 audit_log가 자동으로 쌓이는지 확인
INSERT INTO article (title, body) VALUES ('둘째 글', 'hello');
UPDATE article SET title = '둘째 글(수정)' WHERE title = '둘째 글';
DELETE FROM article WHERE title = '둘째 글(수정)';

SELECT action, old_row->>'title' AS old_title, new_row->>'title' AS new_title
  FROM audit_log
  ORDER BY id;

-- 정리
DROP TRIGGER IF EXISTS trg_set_updated_at ON article;
DROP TRIGGER IF EXISTS trg_audit ON article;
DROP TABLE IF EXISTS article, audit_log CASCADE;
DROP FUNCTION IF EXISTS discounted_price(numeric, numeric);
DROP FUNCTION IF EXISTS set_updated_at();
DROP FUNCTION IF EXISTS audit_changes();
