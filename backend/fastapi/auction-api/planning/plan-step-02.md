# 2단계 — 모델링 + Alembic: 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** User·Auction·Bid·Payment 네 테이블을 SQLAlchemy 2.0 async 모델로 정의하고, 첫날부터 Alembic(async env)으로 스키마를 관리하며, 제약·인덱스가 실제 DB에 생겼는지 테스트로 확인한다. 결과는 `guides/02-models-alembic.html`.

**Architecture:** `app/models/base.py`의 `Base` + 두 믹스인(UUID PK, created_at)을 모든 모델이 상속. enum은 Python `StrEnum` → DB에는 `VARCHAR(20)`(native enum 아님, `values_callable`로 소문자 값 저장). `alembic/env.py`는 `Settings.database_url`과 `Base.metadata`를 쓰는 async 템플릿. 검증은 `alembic upgrade head` → `alembic check` → `\d` → pytest.

**Tech Stack:** SQLAlchemy 2.0 (`Mapped`/`mapped_column`), asyncpg, Alembic 1.19 async template, pytest(동기 테스트 + `asyncio.run`)

**Spec:** `planning/2026-08-25-auction-api-design.md` §4, §6 2단계

## Global Constraints

- 작업 위치 `~/Documents/auction-api-solution/`(태그 `step-02`), 가이드는 `guides/`. til 레포 git 금지.
- 금액은 원 단위 정수 `BigInteger`. 시각은 전부 `DateTime(timezone=True)` + UTC.
- `Base.metadata.create_all`은 쓰지 않는다 — 스키마 변경은 항상 마이그레이션.

---

## 파일 구조

```
app/models/base.py        Base, UUIDPrimaryKeyMixin(id, sort_order=-100), CreatedAtMixin(created_at, sort_order=100)
app/models/enums.py       AuctionStatus, AuctionCategory, PaymentStatus (StrEnum), enum_values()
app/models/user.py        User(email unique, password_hash, nickname)
app/models/auction.py     Auction(+4 CHECK, ix_auctions_status_ends_at, seller/winner/bids relationship)
app/models/bid.py         Bid(+CHECK, ix_bids_auction_id_amount_desc = (auction_id, amount DESC))
app/models/payment.py     Payment(auction_id unique, status, external_id, expires_at, paid_at)
app/models/__init__.py    전부 import → Base.metadata 완성
alembic.ini               sqlalchemy.url 주석 처리 (env.py 가 주입)
alembic/env.py            async 템플릿 + Settings + Base.metadata + compare_type
alembic/versions/<rev>_create_users_auctions_bids_payments.py   autogenerate 산출물
tests/test_models.py      메타데이터·테이블 존재·기본값/CHECK 라운드트립 (rollback)
pyproject.toml            ruff: alembic/versions 제외, known-third-party=["alembic"]
```

---

### Task 1: 의존성 + ruff 설정

- [ ] `uv add alembic` (검증 버전 1.19.1)
- [ ] `pyproject.toml` `[tool.ruff]`에 `extend-exclude = ["alembic/versions"]`, `[tool.ruff.lint.isort] known-third-party = ["alembic"]` 추가. 이유: 프로젝트에 `alembic/` 폴더가 생기면 ruff가 `alembic` 패키지를 1st-party로 오인해 import 순서를 틀리게 잡고, 자동 생성 마이그레이션은 스타일 검사 대상이 아니다.
- [ ] 검증: `uv run ruff check .` → `All checks passed!`

### Task 2: 모델

**Interfaces (Produces):** `Base`, `User`, `Auction`, `Bid`, `Payment`, `AuctionStatus`, `AuctionCategory`, `PaymentStatus`, `enum_values(enum_cls) -> list[str]`. 관계: `Auction.seller`, `Auction.winner`, `Auction.bids`(amount desc), `Bid.auction`, `Bid.bidder`, `Payment.auction`, `Payment.payer`.

- [ ] `base.py` 믹스인 — `sort_order`로 `id`가 맨 앞, `created_at`이 맨 뒤에 오게 한다(믹스인 컬럼은 기본적으로 자식 컬럼 뒤에 붙는다).
- [ ] `enums.py` — `StrEnum`; `Enum(..., native_enum=False, length=20, values_callable=enum_values)`로 DB에 값(`"active"`) 저장.
- [ ] `user.py`, `auction.py`, `bid.py`, `payment.py` — 스펙 §4 그대로. `auction.py`는 `users`로 가는 FK가 둘(seller, winner)이므로 `relationship(foreign_keys=[...])` 필수. 순환 import는 `TYPE_CHECKING` 블록으로 회피.
- [ ] `bid.py`의 내림차순 복합 인덱스는 클래스 밖에서 `Index("ix_bids_auction_id_amount_desc", Bid.auction_id, Bid.amount.desc())`.
- [ ] `__init__.py`에서 전부 import (+`__all__`).
- [ ] 검증: `uv run python -c "from app.models import Base; print(sorted(Base.metadata.tables))"` → `['auctions', 'bids', 'payments', 'users']`

### Task 3: 테스트 (RED)

- [ ] `tests/test_models.py`: `test_metadata_declares_all_tables`(통과), `test_tables_exist_after_migration`(테이블 없으면 실패), `test_auction_defaults_and_check_constraint`(flush → 기본값 확인 → `ends_at == starts_at` flush에 `IntegrityError` → rollback). 코루틴은 `run()` 헬퍼로 실행하고 `engine.dispose()`로 루프 종료 전 커넥션 정리.
- [ ] `uv run pytest -q` → `2 failed, 2 passed` (`relation "users" does not exist`)

### Task 4: Alembic

- [ ] `uv run alembic init -t async alembic`
- [ ] `alembic.ini`의 `sqlalchemy.url = driver://...` 줄 주석 처리(sed).
- [ ] `alembic/env.py` 전면 교체: `config.set_main_option("sqlalchemy.url", get_settings().database_url)`, `target_metadata = Base.metadata`, `compare_type=True`.
- [ ] `uv run alembic revision --autogenerate -m "create users auctions bids payments"` → 4 테이블 + 5 인덱스 감지
- [ ] `uv run alembic upgrade head`, `uv run alembic check` → `No new upgrade operations detected.`
- [ ] `docker compose exec db psql -U auction -d auction -c '\d auctions'` → CHECK 4개, 인덱스 3개, FK 2개(CASCADE/SET NULL). `\d bids` → `(auction_id, amount DESC)`.
- [ ] `uv run pytest -q` → `4 passed`; `uv run alembic downgrade base` → `\dt`에 `alembic_version`만 → `upgrade head`.

### Task 5: 가이드 + 재검증 + 동기화

- [ ] `guides/02-models-alembic.html` — 위 순서대로. 마이그레이션 파일은 **복사하지 않고 생성**하도록 안내(rev id는 머신마다 다름). 부분 수정 블록(pyproject, alembic.ini)은 헤더가 경로로 시작하지 않게 `(수정)`을 앞에 둔다.
- [ ] replay: `git archive step-01` → 가이드 블록 적용 → 위 검증 명령 출력 일치.
- [ ] `index.html`, `01-skeleton.html` 사이드바에서 02 활성화. `progress.md` 갱신. solution 커밋 + `step-02` 태그.
