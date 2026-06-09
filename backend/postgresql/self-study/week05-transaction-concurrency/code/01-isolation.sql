-- =========================================================================
-- Week 5 · Lesson 01 — 트랜잭션 · 격리 수준
-- postgres:18 에서 검증됨. 멱등(idempotent): 여러 번 실행해도 깨끗하게 동작.
-- DB 띄우기: ../../week01-overview-env-types/code/docker-compose.yml 사용.
--
-- 주의: 동시성 이상현상(non-repeatable read 등)은 두 세션이 필요하므로
--       이 스크립트는 "단일 세션에서 도는 부분"만 담는다(대기/블로킹 없음).
--       두 세션 타임라인은 HTML 레슨의 Session A / Session B 표를 보라.
-- =========================================================================

DROP TABLE IF EXISTS accounts CASCADE;

CREATE TABLE accounts (
  id      int  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  owner   text NOT NULL,
  balance numeric(12,2) NOT NULL CHECK (balance >= 0)
);

INSERT INTO accounts (owner, balance) VALUES
  ('Alice', 1000.00),
  ('Bob',    500.00);

-- =========================================================================
-- 1) 트랜잭션 기본 — BEGIN / COMMIT / ROLLBACK (송금: 둘 다 성공 또는 둘 다 취소)
-- =========================================================================
-- Alice -> Bob 으로 200 송금: 인출과 입금을 한 트랜잭션으로 묶는다
BEGIN;
  UPDATE accounts SET balance = balance - 200 WHERE owner = 'Alice';
  UPDATE accounts SET balance = balance + 200 WHERE owner = 'Bob';
COMMIT;

SELECT owner, balance FROM accounts ORDER BY id;

-- ROLLBACK: 중간에 취소하면 변경이 없던 일이 된다
BEGIN;
  UPDATE accounts SET balance = balance - 300 WHERE owner = 'Alice';
ROLLBACK;

SELECT owner, balance FROM accounts ORDER BY id;  -- 그대로 (롤백됨)

-- =========================================================================
-- 2) SAVEPOINT / ROLLBACK TO — 트랜잭션 안의 부분 취소
-- =========================================================================
BEGIN;
  UPDATE accounts SET balance = balance + 50 WHERE owner = 'Alice';
  SAVEPOINT sp1;
  UPDATE accounts SET balance = balance + 9999 WHERE owner = 'Bob';  -- 실수
  ROLLBACK TO sp1;  -- Bob 변경만 취소, Alice +50 은 살아 있음
  UPDATE accounts SET balance = balance + 10 WHERE owner = 'Bob';    -- 다시 정상 처리
COMMIT;

SELECT owner, balance FROM accounts ORDER BY id;  -- Alice +50, Bob +10

-- =========================================================================
-- 3) 격리 수준 — 기본값 확인 & 트랜잭션 단위 설정
-- =========================================================================
-- Postgres 기본 격리 수준은 read committed (MySQL InnoDB 는 repeatable read)
SHOW default_transaction_isolation;

-- 이번 트랜잭션만 REPEATABLE READ 로 (스냅샷 격리)
BEGIN;
  SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  SELECT current_setting('transaction_isolation') AS lvl;
  SELECT owner, balance FROM accounts ORDER BY id;  -- 이 트랜잭션 내내 같은 스냅샷
COMMIT;

-- SERIALIZABLE 도 같은 방식으로 시작 (직렬화 실패 시 앱이 재시도해야 함)
BEGIN ISOLATION LEVEL SERIALIZABLE;
  SELECT current_setting('transaction_isolation') AS lvl;
  SELECT sum(balance) AS total FROM accounts;
COMMIT;

-- 정리
DROP TABLE IF EXISTS accounts CASCADE;
