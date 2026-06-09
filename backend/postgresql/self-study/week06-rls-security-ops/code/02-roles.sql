-- =========================================================================
-- Week 6 · Lesson 02 — ROLE · GRANT · 권한 · 앱 전용 최소 권한 유저
-- postgres:18 에서 검증됨. 멱등(idempotent): 여러 번 실행해도 깨끗하게 동작.
-- DB 띄우기: ../../week01-overview-env-types/code/docker-compose.yml 사용.
--
-- 핵심: Postgres 에서 유저와 그룹은 모두 ROLE 이다. 앱은 superuser 로 붙지 말고,
--       꼭 필요한 권한만 가진 "앱 전용 최소 권한 유저" 로 붙어야 한다.
--       권한 거부(permission denied)는 의도된 동작이므로, ON_ERROR_STOP 으로
--       전체 실행이 멈추지 않게 DO/EXCEPTION 으로 잡아 메시지만 확인한다.
-- =========================================================================

-- 멱등 정리: 데모용 롤들이 남아 있으면 소유물/권한까지 정리하고 지운다.
DO $$
DECLARE r text;
BEGIN
  FOREACH r IN ARRAY ARRAY['app_rw','app_ro'] LOOP
    IF EXISTS (SELECT FROM pg_roles WHERE rolname = r) THEN
      EXECUTE format('REASSIGN OWNED BY %I TO study', r);
      EXECUTE format('DROP OWNED BY %I', r);
      EXECUTE format('DROP ROLE %I', r);
    END IF;
  END LOOP;
END $$;

DROP TABLE IF EXISTS orders CASCADE;

CREATE TABLE orders (
  id     int  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  amount numeric(10,2) NOT NULL,
  status text NOT NULL DEFAULT 'new'
);
INSERT INTO orders (amount) VALUES (100.00), (250.00), (40.00);

-- =========================================================================
-- 1) ROLE = 유저 + 그룹 — LOGIN 가진 ROLE 이 곧 "유저"
-- =========================================================================
-- app_rw: 읽기/쓰기 앱 유저, app_ro: 읽기 전용 앱 유저. 둘 다 NOSUPERUSER.
CREATE ROLE app_rw NOSUPERUSER LOGIN PASSWORD 'rw_pw';
CREATE ROLE app_ro NOSUPERUSER LOGIN PASSWORD 'ro_pw';

-- 롤 목록 확인 (rolcanlogin = 로그인 가능 = 통상적 의미의 "유저")
SELECT rolname, rolsuper, rolcanlogin
FROM pg_roles WHERE rolname IN ('app_rw','app_ro') ORDER BY rolname;

-- =========================================================================
-- 2) 권한 — 스키마 USAGE + 테이블 권한 (PostgreSQL 은 스키마 권한이 별도)
-- =========================================================================
-- 스키마를 "쓸 수 있게" USAGE 부터 줘야 그 안의 객체에 접근 가능하다.
GRANT USAGE ON SCHEMA public TO app_rw, app_ro;

-- app_rw: 읽기 + 쓰기 / app_ro: 읽기만
GRANT SELECT, INSERT, UPDATE, DELETE ON orders TO app_rw;
GRANT SELECT ON orders TO app_ro;

-- 주의: orders.id 는 GENERATED ALWAYS AS IDENTITY 다. IDENTITY 컬럼은
--       뒤의 시퀀스에 대한 USAGE 권한이 필요 없다 — 테이블 INSERT 권한이면
--       충분하다. (3절에서 app_rw 가 시퀀스 USAGE 없이 INSERT 하는 것으로 증명)
--       시퀀스 USAGE 가 필요한 경우는 레거시 serial 컬럼이거나, 앱이 직접
--       nextval() 을 호출하는 경우다. 그런 상황이라면 아래처럼 부여한다:
--   GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO app_rw;

-- =========================================================================
-- 3) 앱 전용 최소 권한 유저 — SET ROLE 로 각 유저의 권한을 검증
-- =========================================================================
-- (A) app_ro: SELECT 는 되고 INSERT 는 거부된다 (의도된 동작)
SET ROLE app_ro;
SELECT count(*) AS visible_rows FROM orders;     -- 3 (읽기 성공)
DO $$
BEGIN
  INSERT INTO orders (amount) VALUES (999.00);
  RAISE NOTICE '예상과 다름: app_ro 의 INSERT 가 통과했다';
EXCEPTION WHEN insufficient_privilege THEN
  RAISE NOTICE 'app_ro INSERT 거부됨(정상): %', SQLERRM;
END $$;
RESET ROLE;

-- (B) app_rw: SELECT 와 INSERT 모두 성공
SET ROLE app_rw;
INSERT INTO orders (amount) VALUES (500.00);
SELECT count(*) AS rows_after_rw_insert FROM orders;   -- 4
RESET ROLE;

-- =========================================================================
-- 4) ALTER DEFAULT PRIVILEGES — "앞으로 만들" 테이블에도 자동 부여
-- =========================================================================
-- 기본적으로 새 테이블은 생성자에게만 권한이 간다. 아래 설정 후 study 가 만드는
-- public 스키마의 새 테이블은 app_ro 에게 자동으로 SELECT 가 부여된다.
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO app_ro;

-- 검증: 설정 후 새 테이블을 만들고, app_ro 가 바로 읽을 수 있는지 확인
CREATE TABLE invoices (id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY, total numeric);
INSERT INTO invoices (total) VALUES (10), (20);

SET ROLE app_ro;
SELECT count(*) AS invoices_readable_by_ro FROM invoices;   -- 2 (자동 부여됨)
RESET ROLE;

-- default privileges 등록 내용 확인
SELECT defaclobjtype, defaclacl FROM pg_default_acl;

-- 정리(멱등)
DROP TABLE IF EXISTS invoices CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
-- ALTER DEFAULT PRIVILEGES 도 되돌려 멱등 보장
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE SELECT ON TABLES FROM app_ro;
DO $$
DECLARE r text;
BEGIN
  FOREACH r IN ARRAY ARRAY['app_rw','app_ro'] LOOP
    IF EXISTS (SELECT FROM pg_roles WHERE rolname = r) THEN
      EXECUTE format('DROP OWNED BY %I', r);
      EXECUTE format('DROP ROLE %I', r);
    END IF;
  END LOOP;
END $$;
