-- =========================================================================
-- Week 6 · Lesson 01 — RLS (Row Level Security) · 멀티테넌시
-- postgres:18 에서 검증됨. 멱등(idempotent): 여러 번 실행해도 깨끗하게 동작.
-- DB 띄우기: ../../week01-overview-env-types/code/docker-compose.yml 사용.
--
-- 핵심 함정(GOTCHA): 접속 유저(study)는 SUPERUSER 라 RLS 를 통째로 우회한다.
--   테이블 OWNER 도 (FORCE 없이는) 우회한다. 그래서 RLS 가 "행을 걸러내는"
--   장면을 진짜로 보여주려면 → NOSUPERUSER 앱 롤(app_user)을 만들고, 권한을
--   부여하고, SET ROLE 로 그 롤이 되어서 SELECT 해야 한다. 이 스크립트는 바로
--   그 과정을 그대로 담아, 테넌트 변수에 따라 다른 행이 나오는 것을 증명한다.
-- =========================================================================

-- 멱등 정리: 앱 롤이 남아 있으면 소유물/권한까지 정리하고 지운다.
DO $$
BEGIN
  IF EXISTS (SELECT FROM pg_roles WHERE rolname = 'app_user') THEN
    EXECUTE 'REASSIGN OWNED BY app_user TO study';
    EXECUTE 'DROP OWNED BY app_user';
    EXECUTE 'DROP ROLE app_user';
  END IF;
END $$;

DROP TABLE IF EXISTS documents CASCADE;

-- 한 테이블에 여러 테넌트의 데이터가 섞여 있는 멀티테넌트 SaaS 모델
CREATE TABLE documents (
  id        int  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  tenant_id int  NOT NULL,
  title     text NOT NULL
);

INSERT INTO documents (tenant_id, title) VALUES
  (1, 'Acme 분기 보고서'),
  (1, 'Acme 채용 계획'),
  (2, 'Globex 신제품 로드맵'),
  (2, 'Globex 가격표'),
  (3, 'Initech 회의록');

-- 앱이 붙을 NOSUPERUSER 앱 롤. SUPERUSER 가 아니고 테이블 owner 도 아니므로
-- RLS 정책의 적용을 "실제로" 받는다.
CREATE ROLE app_user NOSUPERUSER LOGIN PASSWORD 'app_pw';
GRANT SELECT, INSERT ON documents TO app_user;

-- =========================================================================
-- 1) RLS 켜기 + 정책 정의 (USING = 가시성/읽기, WITH CHECK = 쓰기 제약)
-- =========================================================================
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

-- 멱등: 정책엔 IF NOT EXISTS 가 없으므로 먼저 지운다.
DROP POLICY IF EXISTS tenant_isolation ON documents;

-- 세션 변수 app.current_tenant 에 적힌 테넌트의 행만 보이고/넣을 수 있다.
-- current_setting(..., true): 변수가 없으면 에러 대신 NULL 을 돌려준다.
CREATE POLICY tenant_isolation ON documents
  USING      (tenant_id = current_setting('app.current_tenant', true)::int)
  WITH CHECK (tenant_id = current_setting('app.current_tenant', true)::int);

-- =========================================================================
-- 2) SUPERUSER 는 RLS 를 우회한다 (GOTCHA 증명) — study 로 전체가 보인다
-- =========================================================================
-- 지금 접속 유저(study)는 SUPERUSER → 정책을 무시하고 5개 행이 다 보인다.
SELECT id, tenant_id, title FROM documents ORDER BY id;

-- =========================================================================
-- 3) 멀티테넌시 실전 — SET ROLE app_user 후 테넌트별로 다른 행이 나온다
-- =========================================================================
-- (A) 테넌트 1 로 설정 → 테넌트 1 행만 보인다
SET ROLE app_user;
SET app.current_tenant = '1';
SELECT id, tenant_id, title FROM documents ORDER BY id;   -- 행 1,2 만

-- (B) 같은 쿼리, 테넌트 2 로 바꾸면 → 테넌트 2 행만 보인다 (RLS 가 거른다!)
SET app.current_tenant = '2';
SELECT id, tenant_id, title FROM documents ORDER BY id;   -- 행 3,4 만

-- (C) WITH CHECK 위반: 테넌트 2 인데 테넌트 1 행을 넣으려 하면 거부된다.
--     ON_ERROR_STOP 으로 멈추지 않게 DO 블록으로 잡아 메시지만 확인한다.
DO $$
BEGIN
  INSERT INTO documents (tenant_id, title) VALUES (1, '몰래 넣기');
  RAISE NOTICE '예상과 다름: INSERT 가 통과했다';
EXCEPTION WHEN insufficient_privilege THEN
  RAISE NOTICE 'WITH CHECK 위반으로 INSERT 거부됨: %', SQLERRM;
END $$;

-- (D) 같은 테넌트(2) 행 INSERT 는 통과한다
INSERT INTO documents (tenant_id, title) VALUES (2, 'Globex 추가 메모');
SELECT id, tenant_id, title FROM documents ORDER BY id;   -- 테넌트 2 행 3개

RESET ROLE;   -- 다시 superuser(study) 로 복귀

-- =========================================================================
-- 4) FORCE ROW LEVEL SECURITY — owner 에게도 RLS 를 강제
-- =========================================================================
-- 기본적으로 테이블 owner 는 RLS 를 우회한다. FORCE 를 켜면 owner 도 정책 적용.
-- (study 는 여기선 superuser 라 그래도 우회하지만, 설정 자체를 확인한다.)
ALTER TABLE documents FORCE ROW LEVEL SECURITY;

-- 정책/강제 설정이 카탈로그에 반영됐는지 확인
SELECT relname, relrowsecurity, relforcerowsecurity
FROM pg_class WHERE relname = 'documents';

SELECT polname, polcmd FROM pg_policy
WHERE polrelid = 'documents'::regclass;

-- 정리(멱등): 앱 롤과 테이블 제거
DROP TABLE IF EXISTS documents CASCADE;
DO $$
BEGIN
  IF EXISTS (SELECT FROM pg_roles WHERE rolname = 'app_user') THEN
    EXECUTE 'DROP OWNED BY app_user';
    EXECUTE 'DROP ROLE app_user';
  END IF;
END $$;
