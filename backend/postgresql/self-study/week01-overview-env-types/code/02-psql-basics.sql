-- psql 메타 명령은 SQL이 아니라 psql 클라이언트 명령이다(아래는 안내용 주석).
-- \l         : 데이터베이스 목록
-- \dt        : 현재 스키마의 테이블 목록
-- \d <table> : 테이블 구조
-- \du        : 역할(role) 목록
-- \dn        : 스키마 목록
-- \?         : psql 메타 명령 도움말

-- 실제 SQL: 연결 확인 + 스키마/검색경로 감각
SELECT current_database(), current_user, version();
SHOW search_path;

-- 간단 테이블로 \d 체험
CREATE TABLE ping (id int PRIMARY KEY, msg text);
INSERT INTO ping VALUES (1, 'hello postgres 18');
SELECT * FROM ping;
-- 이제 psql에서:  \dt   그리고   \d ping

DROP TABLE ping;
