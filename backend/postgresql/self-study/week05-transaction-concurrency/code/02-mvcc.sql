-- =========================================================================
-- Week 5 · Lesson 02 — MVCC · VACUUM · autovacuum · bloat
-- postgres:18 에서 검증됨. 멱등(idempotent): 여러 번 실행해도 깨끗하게 동작.
-- DB 띄우기: ../../week01-overview-env-types/code/docker-compose.yml 사용.
--
-- 참고: xmin/xmax 는 트랜잭션 ID라 실행할 때마다 값이 다르다(아래 출력은 예시).
--       ctid 는 (블록,오프셋)이라 재현 가능하다.
-- =========================================================================

DROP TABLE IF EXISTS items CASCADE;

CREATE TABLE items (
  id    int  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name  text NOT NULL,
  price int  NOT NULL
);

-- 데모 동안 autovacuum 이 끼어들어 죽은 튜플을 치워 버리면 before/after 가
-- 흔들리므로, 이 테이블만 autovacuum 을 끈다(수동 VACUUM 으로 직접 확인).
ALTER TABLE items SET (autovacuum_enabled = false);

INSERT INTO items (name, price) VALUES ('coffee', 4500);

-- =========================================================================
-- 1) MVCC 원리 — UPDATE 는 in-place 가 아니라 "새 버전 + 옛 버전 만료"
-- =========================================================================
-- 시스템 컬럼: xmin(이 행을 만든 트랜잭션), xmax(이 행을 만료시킨 트랜잭션),
--             ctid(물리 위치 = (블록,오프셋))
SELECT xmin, xmax, ctid, * FROM items;

-- 같은 논리적 행을 세 번 UPDATE → 매번 새 물리 버전 생성, ctid 가 바뀐다
UPDATE items SET price = 4600 WHERE name = 'coffee';
UPDATE items SET price = 4700 WHERE name = 'coffee';
UPDATE items SET price = 4800 WHERE name = 'coffee';

-- 살아 있는(visible) 버전은 하나지만 ctid 가 처음과 달라졌다(예: (0,1) -> (0,4))
SELECT xmin, xmax, ctid, * FROM items;

-- =========================================================================
-- 2) 죽은 튜플 & VACUUM
-- =========================================================================
-- 통계는 비동기로 모이므로 잠깐 기다린 뒤 ANALYZE 로 죽은 튜플 수를 갱신한다
SELECT pg_sleep(1);
ANALYZE items;

-- UPDATE 가 만든 죽은 튜플 수 확인 (위에서 3번 UPDATE → 죽은 버전 3개)
SELECT relname, n_live_tup, n_dead_tup
FROM pg_stat_user_tables WHERE relname = 'items';

-- VACUUM: 죽은 튜플을 회수해 그 공간을 "재사용 가능"하게 만든다
--         (OS 로 디스크를 돌려주지는 않음 — 그건 VACUUM FULL)
VACUUM (VERBOSE) items;

-- VACUUM 후 죽은 튜플이 0 으로
SELECT pg_sleep(1);
ANALYZE items;
SELECT relname, n_live_tup, n_dead_tup
FROM pg_stat_user_tables WHERE relname = 'items';

-- =========================================================================
-- 3) autovacuum 설정 임계치 (기본값 확인)
-- =========================================================================
-- 죽은 튜플이 (임계치 + 비율 * 행수) 를 넘으면 autovacuum 이 자동 실행
SHOW autovacuum_vacuum_threshold;        -- 기본 50
SHOW autovacuum_vacuum_scale_factor;     -- 기본 0.2 (= 행의 20%)

-- 마지막 (auto)vacuum 시각 모니터링
SELECT relname, last_vacuum, last_autovacuum
FROM pg_stat_user_tables WHERE relname = 'items';

-- =========================================================================
-- 4) bloat 맛보기 — 잦은 UPDATE 는 테이블을 부풀린다
-- =========================================================================
-- 한 행을 1000 번 UPDATE → 죽은 튜플 다량 발생(autovacuum 꺼 둔 상태)
UPDATE items SET price = price + 1 WHERE name = 'coffee';
DO $$
BEGIN
  FOR k IN 1..999 LOOP
    UPDATE items SET price = price + 1 WHERE name = 'coffee';
  END LOOP;
END $$;

SELECT pg_sleep(1);
ANALYZE items;
-- 살아 있는 행은 여전히 1 개지만 죽은 튜플이 잔뜩 쌓였다 = bloat 의 씨앗
SELECT relname, n_live_tup, n_dead_tup,
       pg_size_pretty(pg_table_size('items')) AS table_size
FROM pg_stat_user_tables WHERE relname = 'items';

-- 청소: 죽은 튜플을 회수해 재사용 가능 상태로(단, 디스크 크기는 줄지 않음 → VACUUM FULL 필요)
VACUUM items;
SELECT pg_sleep(1);
ANALYZE items;
SELECT relname, n_live_tup, n_dead_tup,
       pg_size_pretty(pg_table_size('items')) AS table_size
FROM pg_stat_user_tables WHERE relname = 'items';

-- 정리
DROP TABLE IF EXISTS items CASCADE;
