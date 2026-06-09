-- =========================================================================
-- Week 6 · Lesson 03 — 연결 풀링 · 확장 · 백업 · 회고
-- postgres:18 에서 검증됨. 멱등(idempotent): 여러 번 실행해도 깨끗하게 동작.
-- DB 띄우기: ../../week01-overview-env-types/code/docker-compose.yml 사용.
--
-- 주의(GOTCHA): pgvector(vector 확장)는 공식 postgres:18 이미지에 들어 있지 않다.
--   CREATE EXTENSION vector 는 여기서 실행하지 않는다(검증이 깨진다). pgvector 는
--   HTML 레슨에서 "개념 + 예제 SQL" 로만 제시한다. 실제로 실행해 검증하는 확장은
--   공식 이미지의 contrib 에 들어 있는 pgcrypto 와 pg_trgm 뿐이다.
-- =========================================================================

-- =========================================================================
-- 1) 확장 설치 — pgcrypto, pg_trgm (둘 다 공식 이미지 contrib 에 포함)
-- =========================================================================
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- 설치된 확장 확인
SELECT extname FROM pg_extension
WHERE extname IN ('pgcrypto','pg_trgm') ORDER BY extname;

-- =========================================================================
-- 2) pgcrypto — 비밀번호 해싱(crypt/gen_salt), 다이제스트(digest)
-- =========================================================================
-- 주의: gen_random_uuid() 는 PG13 부터 "코어" 함수다(pgcrypto 가 아니다).
--       pgcrypto 고유의 가치는 crypt()/gen_salt()/digest()/hmac() 이다.

-- (A) crypt + gen_salt: 비밀번호를 bcrypt 로 해싱하고, 검증한다.
--     같은 비밀번호라도 salt 때문에 매번 다른 해시가 나온다.
SELECT crypt('s3cret', gen_salt('bf')) <> crypt('s3cret', gen_salt('bf'))
       AS two_hashes_differ;   -- t (salt 가 달라 해시도 다름)

-- 저장된 해시로 검증: 올바른 비밀번호면 다시 같은 값으로 계산된다.
WITH h AS (SELECT crypt('s3cret', gen_salt('bf')) AS stored)
SELECT (stored = crypt('s3cret', stored)) AS right_password_ok,
       (stored = crypt('wrong',  stored)) AS wrong_password_ok
FROM h;   -- t , f

-- (B) digest: SHA-256 해시 길이 확인(원문 무관히 32바이트 고정)
SELECT length(digest('hello', 'sha256')) AS sha256_bytes;   -- 32

-- =========================================================================
-- 3) pg_trgm — 트라이그램 유사도(오타 검색/유사 검색의 기반)
-- =========================================================================
SELECT similarity('postgresql', 'postgres') AS sim;   -- 0.x (높을수록 유사)

SELECT word, similarity(word, 'postgre') AS sim
FROM (VALUES ('postgresql'),('postgrey'),('mysql')) AS t(word)
ORDER BY sim DESC;

-- =========================================================================
-- 4) pgvector(개념만) — 아래는 "실행하지 않는" 예제. 공식 이미지엔 없다.
-- =========================================================================
-- 이 블록은 주석이다. 실행하려면 pgvector/pgvector:pg18 이미지를 쓰거나
-- vector 확장을 따로 설치해야 한다. (HTML 레슨의 코드 박스와 동일)
--
--   CREATE EXTENSION vector;                       -- 공식 postgres:18 엔 없음!
--   CREATE TABLE items (
--     id        bigserial PRIMARY KEY,
--     content   text,
--     embedding vector(1536)                        -- 임베딩 차원(예: OpenAI)
--   );
--   -- 코사인 거리(<=>)로 가장 가까운 5개 (RAG 검색)
--   SELECT id, content FROM items
--   ORDER BY embedding <=> $1 LIMIT 5;
--   -- 근사 최근접(ANN) 인덱스: HNSW 또는 IVFFlat
--   CREATE INDEX ON items USING hnsw (embedding vector_cosine_ops);

-- =========================================================================
-- 5) 백업 명령(개념) — 셸에서 실행하는 도구라 SQL 로는 주석으로 정리
-- =========================================================================
--   pg_dump   -Fc study_db > study.dump        -- 논리 백업(커스텀 포맷)
--   pg_restore -d study_db study.dump           -- 복원
--   pg_dumpall --roles-only > roles.sql         -- 롤(권한)까지 백업
--   pg_basebackup -D /backup -Ft -z             -- 물리 백업(클러스터 전체)
--   pg_basebackup --incremental=backup_manifest -D /backup2   -- PG17+ 증분 백업
-- 현재 클러스터 버전 확인(증분 백업은 PG17+):
SHOW server_version;
