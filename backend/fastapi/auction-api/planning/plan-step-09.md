# 9단계 — 결제 웹훅과 외부 연동: 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 낙찰자가 `POST /payments/{id}/checkout` 으로 모의 PG 에 결제를 열고, PG 가 보내는 웹훅(`POST /webhooks/payments`)을 **서명 검증 + 멱등 처리**해 `paid` 로 바꾼다. 외부 호출은 타임아웃·재시도, 테스트는 respx 로 모킹.

**Architecture:** 앱은 `httpx.AsyncClient` 하나(모듈 수준, lifespan 에서 닫음)로 PG 를 부른다. 웹훅은 인증 대신 `X-PG-Signature`(HMAC-SHA256, 원문 바이트) 로 발신자를 확인하고, `webhook_events(event_id PK)` 에 `INSERT … ON CONFLICT DO NOTHING` 으로 "처음 본 이벤트인가" 를 원자적으로 판정한다. 모의 PG(`mock_pg/`, 8001) 는 별도 FastAPI 앱으로, BackgroundTasks 로 1초 뒤 콜백을 보낸다.

**Tech Stack:** httpx 0.28(앱 클라이언트) · httpx2 2.12(테스트 클라이언트, 공존) · respx 0.23 · hmac/hashlib · Alembic

**Spec:** `planning/2026-08-25-auction-api-design.md` §4(Payment·WebhookEvent) §5(9단계 API) §6 9단계 §8

## Global Constraints

- solution `~/Documents/auction-api-solution` 에서 TDD, 태그 `step-09`. til 레포 git 금지. 포트 8000/8001/5435/6380.
- 시간 규칙(결제 기한)은 `now` 인자 + `_now()` 제공자. 재시도 횟수·타임아웃은 Settings.
- stall 방지: 가이드는 생성 스크립트, 긴 명령은 `timeout`.

---

## 파일 구조

```
app/core/config.py          (수정) pg_base_url · pg_webhook_secret · pg_timeout_seconds · pg_retries · public_base_url
app/core/security.py        (수정) sign_payload(body, secret) / verify_signature(body, signature, secret)
app/core/http.py            http_client(httpx.AsyncClient) · get_http()
app/core/exceptions.py      (수정) BadGatewayError(502) · PaymentGatewayError · PaymentNotFoundError ·
                            NotPaymentPayerError · PaymentNotPendingError · PaymentExpiredError ·
                            InvalidSignatureError(401) · AmountMismatchError(422)
app/models/webhook_event.py WebhookEvent(event_id PK, received_at)     + models/__init__ (수정)
alembic/versions/xxxx_add_webhook_events.py  (참고: autogenerate)
app/repositories/payment.py (수정) get(selectinload auction) · get_for_update · get_by_external_id_for_update
app/repositories/webhook_event.py  try_record(db, event_id) -> bool
app/schemas/payment.py      PaymentRead · CheckoutResult · PgWebhook · WebhookAck
app/services/pg_client.py   create_payment(http, *, payment_id, amount, callback_url) -> external_id
app/services/payment.py     get · checkout · handle_webhook
app/routers/payments.py     POST /payments/{id}/checkout · GET /payments/{id}
app/routers/webhooks.py     POST /webhooks/payments
app/main.py                 (수정) 라우터 2개 등록, lifespan 에서 http_client.aclose()
mock_pg/__init__.py, mock_pg/main.py   모의 PG (8001)
tests/test_payments.py
```

## 인터페이스

```python
# app/core/security.py
def sign_payload(body: bytes, secret: str) -> str          # hmac sha256 hexdigest
def verify_signature(body: bytes, signature: str | None, secret: str) -> bool  # compare_digest

# app/services/pg_client.py
async def create_payment(http: httpx.AsyncClient, *, payment_id: UUID, amount: int,
                         callback_url: str) -> str   # 실패(타임아웃/5xx 재시도 소진) → PaymentGatewayError

# app/services/payment.py
async def get(db, payment_id: UUID, user: User) -> Payment          # payer 또는 판매자만
async def checkout(db, http, payment_id: UUID, user: User) -> Payment   # pending & 기한 내 & payer
async def handle_webhook(db, redis, data: PgWebhook) -> bool         # True = 이미 처리한 event_id

# app/repositories/webhook_event.py
async def try_record(db, event_id: str) -> bool   # INSERT … ON CONFLICT DO NOTHING RETURNING
```

## 규칙(서비스)

- `checkout`: 404 → payer 아니면 403 `NOT_PAYMENT_PAYER` → status≠pending 409 `PAYMENT_NOT_PENDING` → `expires_at ≤ now` 409 `PAYMENT_EXPIRED` → 이미 `external_id` 있으면 PG 를 다시 부르지 않고 그대로(멱등) → PG 호출 → `external_id` 저장·commit.
- `handle_webhook`: `try_record` 실패 → commit, `duplicate=True`(아무것도 안 바꿈) → `external_id` 로 결제 잠금(404 면 예외 → 롤백이라 이벤트도 기록되지 않음, PG 가 재전송) → `payment_id`·`amount` 대조(틀리면 422 `AMOUNT_MISMATCH`) → `status=="paid"` 이고 결제가 pending 이면 `paid`+`paid_at`, 아니면 로그만 → `status=="failed"` 면 `external_id=None`(다시 checkout 가능) → commit → paid 로 바뀐 경우 `payment_completed` 이벤트.

---

### Task 1: 실패 테스트 `tests/test_payments.py`

- [ ] respx `pg_mock` fixture(`base_url=settings.pg_base_url`), `sign(body)` 헬퍼, `won_payment()` 헬퍼(ended 경매 + pending Payment 직접 삽입), 로컬 `published` fixture.
- [ ] 테스트 14개: checkout 성공 / 두 번 호출 시 PG 1회·같은 external_id / 비-payer 403 / 기한 지남 409 `PAYMENT_EXPIRED` / 이미 paid 409 `PAYMENT_NOT_PENDING` / PG 타임아웃 → 502 `PG_UNAVAILABLE`, 호출 수 = retries+1 / 500 뒤 200 → 성공, 호출 2회 / 서명 없음 401 / 서명 틀림 401 / 정상 웹훅 → paid·paid_at·이벤트 1건 / 같은 event_id 두 번 → `duplicate: true`·변화 없음 / 모르는 external_id 404 / 금액 불일치 422 / failed 웹훅 → external_id 비움 / GET payer·판매자 200, 남 403 / `expire_payments` 뒤 checkout → 409 `PAYMENT_NOT_PENDING`.
- [ ] `timeout 300 uv run pytest -q tests/test_payments.py` → RED (`ModuleNotFoundError: app.services.payment`)

### Task 2: 설정·서명·HTTP 클라이언트·예외·모델·마이그레이션

- [ ] `config.py` 5개 값, `.env.example` 갱신. `security.py` 서명 두 함수. `core/http.py`. `exceptions.py` 8개 클래스.
- [ ] `models/webhook_event.py` + `__init__` 등록 → `uv run alembic revision --autogenerate -m "add webhook_events"` → `alembic upgrade head` → `alembic check` 무변경.

### Task 3: 리포지토리·스키마·서비스·라우터·main

- [ ] `repositories/payment.py` 3개 함수, `repositories/webhook_event.py`, `schemas/payment.py`, `services/pg_client.py`(재시도 루프), `services/payment.py`, `routers/payments.py`, `routers/webhooks.py`(raw body → 서명 → 파싱), `main.py` 등록.
- [ ] `timeout 300 uv run pytest -q` → 전부 GREEN(71 + 신규). `uv run ruff check . && uv run ruff format --check .`

### Task 4: 모의 PG + 수동 시나리오

- [ ] `mock_pg/main.py`(< 80줄): `POST /pg/payments` → `{external_id}` 즉시, BackgroundTasks 로 `PG_WEBHOOK_DELAY`(기본 1초) 뒤 `callback_url` 에 서명된 웹훅. `POST /pg/payments/{external_id}/fail`. 보낸 웹훅의 body·sig 를 로그에 남긴다(재전송 실험용).
- [ ] run.sh: API·워커·mock_pg 백그라운드 기동 → 가입 3명 → 45초 경매 + 입찰 → 마감 대기 → payment_id → checkout(bob) → 1~2초 뒤 `GET /payments/{id}` = paid → 같은 웹훅 재전송 → `duplicate: true` → 본문 변조 → 401 → 정리. 출력 캡처.

### Task 5: 가이드 · replay · 동기화 · 핸드오프

- [ ] `scratchpad/gen_step09_a.py` + `gen_step09_b.py` → `guides/09-payment-webhook.html`.
- [ ] replay: `git archive step-08` → `alembic upgrade head` → 가이드 블록 적용 → RED → 마이그레이션 생성 → GREEN → run.sh 일치.
- [ ] 사이드바(index, 01~08), progress.md, solution 커밋 + 태그 `step-09`.
