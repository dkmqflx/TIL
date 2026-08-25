# 10단계 — 성능·관측성·배포: 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 9단계까지의 API·워커·모의 PG 를 운영 모양으로 만든다 — 목록 캐시, JSON 로그 + request-id, CORS, 부하 테스트로 블로킹 병목 찾기, 멀티스테이지 Dockerfile + prod compose(5개 서비스), GitHub Actions, README.

**Architecture:** 캐시는 "버전 키" 방식(`auction:list:version` 을 INCR, 키에 버전을 박아 스캔 없이 무효화). 로깅은 stdlib `logging` + `JsonFormatter` + contextvar `request_id`, 미들웨어가 발급·전파. 느린 쿼리는 SQLAlchemy 커서 이벤트로. 컨테이너는 uv 빌더 → `python:3.13-slim` 런타임, 비루트, exec-form CMD(SIGTERM 전달). CI 는 til 루트 기준 `working-directory`.

**Tech Stack:** redis, contextvars, CORSMiddleware, locust, Docker(buildx), docker compose, GitHub Actions(setup-uv v10).

**Spec:** `planning/2026-08-25-auction-api-design.md` §6 10단계, §3

## Global Constraints
- solution `~/Documents/auction-api-solution/`(태그 `step-09`, 87 passed)에서 작업. til 레포 git 금지. 포트 5435/6380/8000/8001, prod compose 는 db·redis 미노출.
- 시간·임계값은 Settings(`list_cache_ttl_seconds`, `slow_query_ms`, `cors_origins`, `demo_blocking_sleep`).

---

## 파일 구조
```
app/core/cache.py        VERSION_KEY · current_version/bump_version · list_cache_key · get_json/set_json
app/core/logging.py      request_id_var · JsonFormatter · setup_logging · RequestIdMiddleware(함수) · install_slow_query_logging
app/core/config.py       (수정) 10단계 설정 5개 + cors_origins 파서
app/services/auction.py  (수정) list_auctions(db, redis, params) -> AuctionPage (캐시) · create/update/cancel 이 bump
app/services/bid.py      (수정) place_bid 커밋 뒤 bump
app/services/closer.py   (수정) close_due 커밋 뒤 bump · activate_due 는 워커 tick 에서 bump
app/workers/closer.py    (수정) setup_logging · activated>0 → bump
app/services/auth.py     (수정) bcrypt 를 asyncio.to_thread 로 (부하 테스트가 찾아낸 진짜 병목)
app/routers/auctions.py  (수정) list 에 RedisClient · read 에 demo_blocking_sleep
app/main.py              (수정) setup_logging · CORS · request-id 미들웨어 · slow query
tests/conftest.py        (수정) CORS_ORIGINS 환경변수
tests/test_cache.py      4  · tests/test_observability.py 6
loadtest/locustfile.py   · Dockerfile · .dockerignore · docker-compose.prod.yml · .github/workflows/ci.yml · README.md
```

## Task 1: 목록 캐시 (TDD)
- [ ] `tests/test_cache.py`: 두 번째 호출 SELECT 0 · 입찰 후 버전 증가 → 미스 · 경매 생성 후 미스 · 파라미터별 키 분리
- [ ] RED: `ImportError: cannot import name 'cache'`
- [ ] `app/core/cache.py`, Settings `list_cache_ttl_seconds=5`, 서비스·라우터 수정, bump 지점 4곳
- [ ] GREEN: `timeout 300 uv run pytest -q tests/test_cache.py`

## Task 2: 관측성 + CORS (TDD)
- [ ] `tests/test_observability.py`: X-Request-ID 생성/에코 · access 로그 JSON 에 request_id/status/duration_ms · slow query 경고 · CORS preflight 허용/거부
- [ ] `app/core/logging.py`, `main.py` 수정, conftest 에 `CORS_ORIGINS`
- [ ] GREEN

## Task 3: 부하 테스트로 병목 찾기
- [ ] `demo_blocking_sleep` 플래그 + `time.sleep(0.05)` (라우터 read_auction)
- [ ] `uv add --dev locust`, `loadtest/locustfile.py`
- [ ] A: `DEMO_BLOCKING_SLEEP=true` 20초 · B: 기본 20초 → p50/p95/RPS 표 캡처
- [ ] bcrypt 동기 호출 발견 → `asyncio.to_thread`, 재측정 근거 기록

## Task 4: Dockerfile · prod compose · e2e
- [ ] `Dockerfile`(멀티스테이지, 비루트, exec CMD), `.dockerignore`, `docker-compose.prod.yml`(name: auction-prod, app/worker/mock_pg/db/redis)
- [ ] `timeout 900 docker compose -f docker-compose.prod.yml up -d --build` → `ps` 전부 healthy/running
- [ ] e2e: signup → 45초 경매 → 입찰 → 마감 → checkout → 웹훅 paid → 로그에 request_id
- [ ] `down -v`

## Task 5: CI + README
- [ ] `.github/workflows/ci.yml`(til 루트 배치 안내, paths·working-directory), `yaml.safe_load` 검증, CI 와 동일한 명령 로컬 실행
- [ ] `README.md`

## Task 6: 가이드 · replay · 동기화 · 핸드오프
- [ ] `guides/10-deploy.html` (생성 스크립트 2파일), `index.html` 완주 후 섹션, `01`–`09` 사이드바, 링크 검사 11파일
- [ ] replay from `step-09`
- [ ] `progress.md` 전체 완료, solution 커밋 + `step-10`
