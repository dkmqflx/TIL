-- =========================================================================
-- Week 5 · Lesson 03 — 락 · FOR UPDATE · 데드락 · advisory lock
-- postgres:18 에서 검증됨. 멱등(idempotent): 여러 번 실행해도 깨끗하게 동작.
-- DB 띄우기: ../../week01-overview-env-types/code/docker-compose.yml 사용.
--
-- 주의: 두 트랜잭션이 서로의 락을 기다리는 "블로킹/데드락" 은 단일 세션에서
--       재현할 수 없다(스크립트가 멈춰 버림). 그런 시나리오는 HTML 레슨의
--       Session A / Session B 타임라인으로 설명한다. 이 스크립트는 멈추지 않고
--       끝까지 도는 부분만 담는다(SKIP LOCKED, advisory lock, lock_timeout 확인).
-- =========================================================================

DROP TABLE IF EXISTS jobs CASCADE;

-- 작업 큐 테이블 (여러 워커가 집어가는 패턴)
CREATE TABLE jobs (
  id      int  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  payload text NOT NULL,
  status  text NOT NULL DEFAULT 'queued'   -- queued / done
);

INSERT INTO jobs (payload) VALUES
  ('send-email-1'), ('send-email-2'), ('resize-image-3'),
  ('build-report-4'), ('charge-card-5');

-- =========================================================================
-- 1) 행 잠금 — FOR UPDATE / FOR SHARE (단일 세션이라 충돌 없이 통과)
-- =========================================================================
-- FOR UPDATE: 이 행을 "고칠 거다"라고 잠금 표시. 다른 트랜잭션이 같은 행을
--             FOR UPDATE/UPDATE 하려 하면 이 트랜잭션이 끝날 때까지 대기한다.
--             (대기 장면은 HTML 타임라인 참조 — 여기선 혼자라 바로 통과)
BEGIN;
  SELECT id, payload FROM jobs WHERE id = 1 FOR UPDATE;
COMMIT;

-- =========================================================================
-- 2) SKIP LOCKED 큐 패턴 — 여러 워커가 안 겹치게 작업을 집어간다
-- =========================================================================
-- 핵심: 잠긴 행은 "건너뛰고" 안 잠긴 다음 행을 가져온다 → 워커끼리 충돌 없음.
-- 단일 세션에서는 잠긴 행이 없으니 그냥 맨 앞 행을 가져온다(구문이 도는지 확인).
BEGIN;
  SELECT id, payload
  FROM jobs
  WHERE status = 'queued'
  ORDER BY id
  FOR UPDATE SKIP LOCKED
  LIMIT 1;
  -- 실제 워커라면 여기서 처리 후 상태를 바꾸고 커밋한다
  UPDATE jobs SET status = 'done' WHERE id = 1;
COMMIT;

SELECT id, payload, status FROM jobs ORDER BY id;

-- NOWAIT: 잠겨 있으면 기다리지 말고 즉시 에러. 단일 세션이라 충돌 없이 통과.
BEGIN;
  SELECT id FROM jobs WHERE id = 2 FOR UPDATE NOWAIT;
COMMIT;

-- =========================================================================
-- 3) advisory lock — 행이 아니라 "앱이 정한 키"로 잠금 (크론 중복 실행 방지 등)
-- =========================================================================
-- pg_try_advisory_lock: 잠금을 시도하고 성공 여부를 즉시 true/false 로 반환
--                       (기다리지 않으므로 스크립트가 멈추지 않는다)
SELECT pg_try_advisory_lock(42) AS got_lock;   -- t (이 세션이 키 42 를 잡음)

-- 같은 세션은 재진입 가능(카운트 증가). 다른 세션이었다면 f 를 받는다.
SELECT pg_try_advisory_lock(42) AS got_again;  -- t

-- 잡은 만큼 풀어 준다(두 번 잡았으니 두 번 unlock)
SELECT pg_advisory_unlock(42) AS released_1;   -- t
SELECT pg_advisory_unlock(42) AS released_2;   -- t

-- 현재 보유 중인 advisory 락 확인(모두 풀었으니 비어 있음)
SELECT count(*) AS held_advisory_locks
FROM pg_locks WHERE locktype = 'advisory';

-- =========================================================================
-- 4) lock_timeout — 락을 무한정 기다리지 않게 (값 설정/확인만; 충돌은 HTML 참조)
-- =========================================================================
-- 락을 1초 넘게 기다리면 포기하고 에러. 충돌이 없으니 여기선 에러가 나지 않는다.
SET lock_timeout = '1s';
SHOW lock_timeout;

BEGIN;
  SELECT id FROM jobs WHERE id = 3 FOR UPDATE;  -- 충돌 없음 → 즉시 성공
COMMIT;

RESET lock_timeout;

-- 정리
DROP TABLE IF EXISTS jobs CASCADE;
