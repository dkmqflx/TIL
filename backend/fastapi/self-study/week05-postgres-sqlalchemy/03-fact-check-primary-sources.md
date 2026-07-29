# Week 5·03 문서 팩트체크 — 1차 출처 검증 기록

> `03-connection-pool-session.html`(Connection Pool · Session · fetch · bind 변수)에 담긴 주장 25개를
> **공식 문서와 소스 코드**로만 검증한 기록입니다.
>
> - 검증일: 2026-07-29
> - 허용 출처: `docs.sqlalchemy.org` (2.0), `fastapi.tiangolo.com`, `typeorm.io`, `docs.nestjs.com`, `node-postgres.com`, `postgresql.org/docs`, 그리고 각 프로젝트의 **소스 코드 저장소**
> - 블로그·StackOverflow·튜토리얼 사이트는 인용하지 않았습니다. 1차 출처로 뒷받침되지 않는 항목은 `UNVERIFIABLE`로 표시했습니다.

## 결론 요약

| 판정 | 개수 | 항목 |
|------|------|------|
| ✅ CONFIRMED | 22 | 1·2·3·5·6·7·8·10·11·12·13·14·15·16·17·19·20·21·22·23·24·25 |
| ⚠️ IMPRECISE | 2 | 4(부분) · 9(문서 본문의 적용 지점) |
| ❓ UNVERIFIABLE | 1 | 18 (연결 수립 시간 수치) |
| ❌ WRONG | 0 | — |

**수정이 필요한 곳은 3군데**입니다. 상세는 맨 아래 [수정 필요 목록](#수정-필요-목록) 참고.

---

## 1. SQLAlchemy 2.0

### ① 풀 파라미터 기본값 — ✅ CONFIRMED

`create_engine()` 문서가 기본값을 그대로 명시합니다.

- `pool_size=5` — "the number of connections to keep open inside the connection pool. This used with QueuePool as well as SingletonThreadPool."
- `max_overflow=10` — "the number of connections to allow in connection pool 'overflow', that is connections that can be opened above and beyond the pool_size setting, which defaults to five."
- `pool_timeout=30` — "number of seconds to wait before giving up on getting a connection from the pool. This is only used with QueuePool."

출처: <https://docs.sqlalchemy.org/en/20/core/engines.html>

### ② 풀이 고갈되면 대기 후 예외 — ✅ CONFIRMED

즉시 실패가 아니라 **대기 → 타임아웃 → 예외** 순서가 맞습니다.

- 대기 시간: "The number of seconds to wait before giving up on returning a connection. Defaults to 30.0." (<https://docs.sqlalchemy.org/en/20/core/pooling.html>)
- 예외 이름: `sqlalchemy.exc.TimeoutError` — "Raised when a connection pool times out on getting a connection." (<https://docs.sqlalchemy.org/en/20/core/exceptions.html>)

문서에서 "30초씩 느려지다가 터진다"고 쓴 서술은 정확합니다.

### ③ overflow 연결은 반납 시 닫힌다 — ✅ CONFIRMED

> "When those additional connections are returned to the pool, they are disconnected and discarded."

출처: <https://docs.sqlalchemy.org/en/20/core/pooling.html>

즉 `pool_size`만큼만 상시 유지되고, 초과분은 반납 시 **실제로 연결이 끊깁니다**. 문서의 "임시로 부른 10대는 대기열에 남지 않고 해산" 표현이 맞습니다.

### ④ `pool_recycle` — ⚠️ IMPRECISE (기본값은 맞고, 이유 설명이 일부 미출처)

기본값은 확인됩니다.

> "this setting causes the pool to recycle connections after the given number of seconds has passed. It defaults to -1, or no timeout."
> — <https://docs.sqlalchemy.org/en/20/core/engines.html>

**필요한 이유**로 SQLAlchemy 문서가 실제로 드는 사례는 다음뿐입니다.

- DB 재시작: "allow the connection pool to gracefully recover when the database server has been restarted, and all previously established connections are no longer functional."
- DB의 유휴 연결 자동 종료: "appropriate for database backends such as **MySQL** that automatically close connections that have been stale after a particular period of time."

출처: <https://docs.sqlalchemy.org/en/20/core/pooling.html>

**"방화벽·로드밸런서 같은 중간 장비가 끊는다"는 서술은 SQLAlchemy·PostgreSQL 어느 공식 문서에서도 확인되지 않았습니다.** (`tcp_keepalives_idle` 설명에도 방화벽·NAT 언급 없음 — <https://www.postgresql.org/docs/current/runtime-config-connection.html>)

대신 **PostgreSQL 쪽에도 서버가 유휴 세션을 끊는 설정이 실제로 있다**는 것은 확인됩니다. 이쪽으로 근거를 바꾸는 편이 안전합니다.

> `idle_session_timeout` — "Terminate any session that has been idle (that is, waiting for a client query), but not within an open transaction, for longer than the specified amount of time. ... A value of zero (the default) disables the timeout."
>
> "**Be wary of enforcing this timeout on connections made through connection-pooling software or other middleware, as such a layer may not react well to unexpected connection closure.**"

출처: <https://www.postgresql.org/docs/current/runtime-config-client.html>

마지막 문장은 "DB가 끊은 연결을 풀이 모른 채 들고 있다가 사고가 난다"는 문서의 설명과 **정확히 같은 상황**을 공식 문서가 인정한 것이라, 근거로 쓰기에 오히려 더 좋습니다.

### ⑤ `pool_pre_ping` — ✅ CONFIRMED

> "boolean, if True will enable the connection pool 'pre-ping' feature that tests connections for liveness upon each checkout." (<https://docs.sqlalchemy.org/en/20/core/engines.html>)
>
> "The 'pre ping' feature operates on a per-dialect basis either by invoking a DBAPI-specific 'ping' method, or if not available will emit SQL equivalent to 'SELECT 1', catching any errors and detecting the error as a 'disconnect' situation." (<https://docs.sqlalchemy.org/en/20/core/pooling.html>)

문서의 "빌려주기 직전에 아주 가벼운 확인 쿼리" 서술이 정확합니다.

### ⑥ `Session.close()`는 연결을 풀로 반납한다 — ✅ CONFIRMED

> "The `Session.close()` method issues a `Session.expunge_all()` which removes all ORM-mapped objects from the session, and **releases any transactional/connection resources** from the `Engine` object(s) to which it is bound. **When connections are returned to the connection pool**, transactional state is rolled back as well."

출처: <https://docs.sqlalchemy.org/en/20/orm/session_basics.html>

"close는 끊기가 아니라 반납"이라는 문서의 강조가 맞습니다. 덤으로 **반납 시 트랜잭션이 롤백된다**는 사실도 확인됩니다(문서에 없는 내용이지만 추가하면 좋음).

### ⑦ 연결은 첫 쿼리 때 지연 획득된다 — ✅ CONFIRMED

두 출처가 함께 뒷받침합니다.

> "The `Session` object features a behavior known as **autobegin**. ... **When the `Session` is first constructed, there's no transactional state present.**" (<https://docs.sqlalchemy.org/en/20/orm/session_basics.html>)
>
> "All SQLAlchemy pool implementations have in common that none of them 'pre create' connections - all implementations **wait until first use** before creating a connection." (<https://docs.sqlalchemy.org/en/20/core/pooling.html>)

문서의 타임라인 3단계("첫 쿼리가 실행되는 순간 세션이 풀에서 연결 하나를 빌립니다")가 정확합니다.

### ⑧ `autoflush` — ✅ CONFIRMED

> "Autoflush is defined as a configurable, automatic flush call which occurs at the beginning of methods including: `Session.execute()` and other SQL-executing methods, when used against ORM-enabled SQL constructs."

출처: <https://docs.sqlalchemy.org/en/20/orm/session_basics.html>

문서의 "쿼리 직전에 장바구니 내용을 DB로 미리 밀어 보내는 기능"이라는 설명은 정확합니다.

다만 **끄면 생기는 반대급부**(쿼리가 아직 flush되지 않은 내 변경을 못 본다)는 문서에 빠져 있고, "초보일수록 꺼 두는 게 예측 가능하다"는 공식 권고가 아니라 **저자 의견**입니다. 사실 오류는 아니지만, 의견임을 드러내거나 반대급부를 한 줄 덧붙이면 더 정확합니다.

### ⑨ `expire_on_commit` — ✅ CONFIRMED (단, 본문 적용 지점은 ⚠️ IMPRECISE)

기본값과 의미:

> "Defaults to `True`. When `True`, all instances will be fully expired after each `commit()`, so that all attribute/object access subsequent to a completed transaction will load from the most recent database state."

출처: <https://docs.sqlalchemy.org/en/20/orm/session_api.html>

commit 후 만료된 객체를 **세션이 닫힌 뒤** 건드리면 나는 에러도 공식 문서에 있습니다.

> "Parent instance \<x\> is not bound to a Session; (lazy load/deferred load/refresh/etc.) operation cannot proceed"
>
> "**The most common reason that objects become detached from their Session is that the session itself was closed, typically via the `Session.close()` method.** The objects will then live on to be accessed further, very often within web applications where they are delivered to a server-side templating engine and are asked for further attributes which they cannot load."

출처: <https://docs.sqlalchemy.org/en/20/errors.html>

**⚠️ 다만 본문 "전체 흐름" 5단계의 적용이 부정확합니다.** 해당 예시(`list_todos`)는 **조회 전용이라 `commit()`을 부르지 않습니다.** commit이 없으면 만료도 없으므로 `expire_on_commit`은 그 엔드포인트에서 아무 역할도 하지 않습니다. 게다가 FastAPI는 **응답을 보낸 뒤에** 의존성 종료 코드를 실행하므로(아래 ⑯), 직렬화 시점에는 세션이 아직 열려 있습니다. `expire_on_commit=False`가 실제로 중요해지는 곳은 **commit 후 객체를 반환하는 생성·수정 엔드포인트**입니다.

### ⑩ flush vs commit — ✅ CONFIRMED

> "The `Session.commit()` operation **unconditionally issues `Session.flush()` before emitting COMMIT** on relevant database connections."

출처: <https://docs.sqlalchemy.org/en/20/orm/session_basics.html>

flush가 트랜잭션 안에서만 유효하다는 점도 같은 페이지에서 확인됩니다("the flush step is nearly always done transparently", 트랜잭션 내 동기화). 문서의 "계산대에 목록 보여주기 vs 결제 완료" 비유는 정확합니다.

### ⑪ `scalars()` — ✅ CONFIRMED

> "`Session.scalars()` ... will return a `ScalarResult` object that **delivers the first 'column' of each row at once**."
>
> "`scalars()` ... delivers the first 'column' of each row at once, in this case, **instances of the `User` class**" (Row 객체가 아니라)

출처: <https://docs.sqlalchemy.org/en/20/tutorial/data_select.html>, <https://docs.sqlalchemy.org/en/20/orm/session_api.html>

문서의 "각 줄의 첫 칸만 꺼내 줘" 설명이 정확합니다.

### ⑫ `.all()` / `.first()` / `.one()` / `.one_or_none()` — ✅ CONFIRMED

라이브러리 소스의 docstring 원문입니다.

| 메서드 | docstring 원문 |
|--------|----------------|
| `one()` | "Return exactly one row or raise an exception. Raises `NoResultFound` if the result returns no rows, or `MultipleResultsFound` if multiple rows would be returned." |
| `one_or_none()` | "Return at most one result or raise an exception. Returns `None` if the result has no rows. Raises `MultipleResultsFound` if multiple rows are returned." |
| `first()` | "Fetch the first row or `None` if no row is present. **Closes the result set and discards remaining rows.**" |
| `all()` | "Return all rows in a sequence. Closes the result set after invocation." |

출처: <https://github.com/sqlalchemy/sqlalchemy/blob/main/lib/sqlalchemy/engine/result.py>

예외 정의도 확인됩니다.

- `NoResultFound` — "A database result was required but none was found."
- `MultipleResultsFound` — "A single database result was required but more than one were found."
- 출처: <https://docs.sqlalchemy.org/en/20/core/exceptions.html>

`ScalarResult`의 동명 메서드들도 "Equivalent to `Result.one` except that scalar values, rather than `Row` objects, are returned."로 동일 동작임이 명시돼 있습니다. 문서의 표는 정확합니다.

### ⑬ `Session.get()` — ✅ CONFIRMED

> "Return an instance based on the given primary key identifier, or `None` if not found."

출처: <https://docs.sqlalchemy.org/en/20/orm/session_api.html>

### ⑭ bind 변수 — ✅ CONFIRMED (양쪽 모두)

**`:name` + dict 문법**

> "the `text()` construct accepts these using a colon format `:y`."
>
> ```python
> result = conn.execute(text("SELECT x, y FROM some_table WHERE y > :y"), {"y": 2})
> ```
>
> "a Python literal value, even non-strings like integers or dates, should **never be stringified into SQL string directly**; a parameter should **always** be used. **This is most famously known as how to avoid SQL injection attacks when the data is untrusted.**"

출처: <https://docs.sqlalchemy.org/en/20/tutorial/dbapi_transactions.html>

**"값만 바인딩되고 식별자는 안 된다"**

> "Note that **parameter symbols can only be used for data values** — if you want to use dynamically determined table or column names, you must insert them into the command string textually."

출처: <https://www.postgresql.org/docs/current/plpgsql-statements.html>

**"문장 구조를 먼저 확정한 뒤 값을 끼운다"는 메커니즘 설명도 정확합니다.**

> "When the `PREPARE` statement is executed, the specified statement is **parsed, analyzed, and rewritten**. When an `EXECUTE` command is subsequently issued, the prepared statement is planned and executed."

출처: <https://www.postgresql.org/docs/current/sql-prepare.html>

문서의 "빈칸 채우기 시험지" 비유는 이 동작을 정확히 옮긴 것입니다. 식별자 허용 목록(allow-list) 팁도 위 PostgreSQL 문서의 권고(`quote_ident()` / `format()` `%I`)와 같은 방향입니다.

### ⑮ 세션의 변경 추적 — ✅ CONFIRMED

> "If we alter the attributes of this object, **the `Session` tracks this change**."
>
> "The object appears in a collection called `Session.dirty`, indicating the object is 'dirty'."
>
> "When the `Session` next emits a flush, **an UPDATE will be emitted** that updates this value in the database."

출처: <https://docs.sqlalchemy.org/en/20/tutorial/orm_data_manipulation.html> (섹션 제목이 "Updating ORM Objects using the **Unit of Work** pattern")

문서의 "세션이 변경을 추적해 commit만 해도 UPDATE"라는 NestJS 대비 서술이 정확합니다.

---

## 2. FastAPI

### ⑯ `yield` 의존성의 종료 코드는 응답 후 실행 — ✅ CONFIRMED

> "**Normally** the exit code of dependencies with `yield` is executed **after the response** is sent to the client."
>
> "you can use `finally` to make sure the exit steps are executed, **no matter if there was an exception or not**."

출처: <https://fastapi.tiangolo.com/tutorial/dependencies/dependencies-with-yield/>

문서의 "응답이 나간 뒤 `finally`가 실행된다" + "에러가 터지든 정상 종료하든 세션은 반드시 닫힌다"가 둘 다 맞습니다.

> ℹ️ 참고: 원문의 첫 단어가 "Normally"인 이유는, 최신 FastAPI에 종료 시점을 앞당기는 옵션(`Depends`의 `scope` / early exit)이 있기 때문입니다. 기본 동작을 설명하는 문서 서술은 그대로 유효합니다.

---

## 3. PostgreSQL

### ⑰ 연결마다 프로세스를 fork — ✅ CONFIRMED

> "The PostgreSQL server can handle multiple concurrent connections from clients. To achieve this it **starts ("forks") a new process for each connection**. From that point on, the client and the new server process communicate without intervention by the original `postgres` process."
>
> "As is typical of client/server applications, the client and the server can be on different hosts. In that case they **communicate over a TCP/IP network connection**."

출처: <https://www.postgresql.org/docs/current/tutorial-arch.html>

문서의 "연결 하나마다 서버 쪽에서도 프로세스를 하나씩 잡는다"와 "다른 컨테이너나 아예 다른 서버에서 도는 별개 프로그램"이라는 설명이 모두 정확합니다.
(다만 "**메모리**를 하나씩 잡는다"는 부분은 위 인용에 직접 포함되지 않은, 프로세스 모델에서 따라오는 추론입니다.)

### ⑱ 연결 수립 "수 ms~수십 ms" vs 쿼리 "~1ms" — ❓ UNVERIFIABLE

**어떤 1차 출처도 이런 수치를 제시하지 않습니다.**

SQLAlchemy 풀링 문서가 존재 이유로 말하는 것은 정성적 서술뿐입니다.

> "A connection pool is a standard technique used to maintain long running connections in memory for **efficient reuse**, as well as to provide management for the total number of connections an application might use simultaneously."

출처: <https://docs.sqlalchemy.org/en/20/core/pooling.html>

PostgreSQL 문서도 연결 수립 지연 시간에 대한 수치를 제공하지 않습니다.

**권장 대안 표현** — 수치를 빼고, 출처가 확실한 두 가지 사실로 바꾸는 것:

1. 연결 하나마다 **서버가 프로세스를 fork**한다 (⑰, 출처 있음)
2. 그래서 풀링이 **"efficient reuse"를 위한 표준 기법**이다 (위 인용, 출처 있음)

굳이 체감 수치를 남기고 싶다면 "환경에 따라 다르지만, 연결 수립은 단순 조회보다 **훨씬 비싼 작업**입니다" 정도로 정성적으로 쓰는 것이 안전합니다.

---

## 4. TypeORM / NestJS / node-postgres

### ⑲ `poolSize` → 드라이버의 `max`, `extra` 전달 — ✅ CONFIRMED

공식 문서:

> `poolSize` — "Configure maximum number of active connections is the pool."
> `extra` — "Extra options to be passed to the underlying driver. Use it if you want to pass extra settings to the underlying database driver."

출처: <https://typeorm.io/docs/data-source/data-source-options/>

실제 매핑은 소스에서 확인됩니다.

```typescript
Object.assign(
    {},
    {
        // ...
        max: options.poolSize,
    },
    options.extra ?? {},
)
```

출처: <https://github.com/typeorm/typeorm/blob/master/src/driver/postgres/PostgresDriver.ts>

즉 `poolSize` → pg의 `max`가 맞습니다. **`extra`가 뒤에 병합되므로 `extra.max`를 주면 `poolSize`를 덮어씁니다.**

pg 쪽 기본값도 확인됩니다.

- `max` — "Maximum number of clients the pool should contain. **By default this is set to 10.**"
- `idleTimeoutMillis` — "Number of milliseconds a client must sit idle in the pool and not be checked out before it is disconnected from the backend and discarded. **Default is 10000 (10 seconds).**"
- `connectionTimeoutMillis` — "Number of milliseconds to wait before timing out when connecting a new client. By default this is 0 which means no timeout."

출처: <https://node-postgres.com/apis/pool>

문서의 "TypeORM은 `poolSize`로 상한 하나만 정하고, SQLAlchemy는 상시+임시로 나눈다"는 대비가 정확합니다.

### ⑳ TypeORM에는 변경 추적(dirty checking)이 없다 — ✅ CONFIRMED

`EntityManager` 소스 전체에 **`flush()` 메서드가 존재하지 않으며**, 영속화는 전부 명시 호출입니다.

- 공개 영속화 메서드: `save()`, `insert()`, `upsert()`, `update()`, `updateAll()`, `delete()`, `deleteAll()`, `remove()`, `softRemove()`, `recover()`, `softDelete()`, `restore()`, `increment()`, `decrement()`
- 로드된 엔티티를 수정했을 때 자동으로 UPDATE를 내보내는 경로 없음

출처: <https://github.com/typeorm/typeorm/blob/master/src/entity-manager/EntityManager.ts>

문서상 `save()`의 정의도 "명시 호출" 모델을 뒷받침합니다.

> "Saves a given entity or array of entities. **If the entity already exist in the database, it is updated. If the entity does not exist in the database, it is inserted.**"

출처: <https://typeorm.io/docs/working-with-entity-manager/repository-api/>

> ℹ️ 예외적으로 "직접 안 불러도 저장되는" 경우: **cascade 옵션**이 걸린 관계는 부모를 `save()`할 때 자식도 함께 저장되고, **subscriber/listener**(`@BeforeUpdate` 등)가 값을 바꿀 수 있습니다. 둘 다 "변경 추적"이 아니라 **`save()` 호출에 딸려오는 동작**이므로, 문서의 대비는 그대로 유효합니다.

### ㉑ QueryBuilder의 `:name` 파라미터 — ✅ CONFIRMED

> ```typescript
> .where("user.name = :name", { name: "Timber" })
> ```
>
> "It's a parameter we used to **prevent SQL injection**. We could have written: `where("user.name = '" + name + "')`, however **this is not safe, as it opens the code to SQL injections**."

출처: <https://typeorm.io/docs/query-builder/select-query-builder/>

**문서의 경고 콜아웃("템플릿 리터럴로 조건문을 조립하면 TypeORM에서도 그대로 인젝션이 된다")이 공식 문서의 문장과 정확히 일치합니다.** 배열 확장 문법 `IN (:...names)`도 같은 페이지에 있습니다.

### ㉒ `repository.query()`는 드라이버 자리표시자 — ✅ CONFIRMED

> "Executes a raw SQL query." — 파라미터 문법은 드라이버마다 다르며 **PostgreSQL은 `$1`/`$2`**, MySQL은 `?`, Oracle은 `:1`, MSSQL은 `@0` 형식.

출처: <https://typeorm.io/docs/working-with-entity-manager/repository-api/>

문서의 `repo.query('... WHERE title = $1', [q])` 예시가 정확합니다.

### ㉓ find 계열 메서드 의미 — ✅ CONFIRMED

| 메서드 | 공식 설명 |
|--------|-----------|
| `find()` | "Finds entities that match given `FindOptions`." |
| `findOne()` | "Finds the first entity that matches given `FindOptions`." (`where`를 포함한 FindOptions 필요) |
| `findOneBy()` | "Finds the first entity that matches given `FindOptionsWhere`." |
| `findOneOrFail()` | "Finds the first entity that matches some id or find options. **Rejects the returned promise if nothing matches.**" |

출처: <https://typeorm.io/docs/working-with-entity-manager/repository-api/>

문서의 대응표(`findOne` → `.first()`/`.one_or_none()`, `findOneOrFail` → `.one()`)가 적절합니다. `findOne({ where })`처럼 `where`를 명시한 것도 맞습니다.

### ㉔ 트랜잭션은 명시적으로 열어야 한다 — ✅ CONFIRMED

> `await myDataSource.transaction(async (transactionalEntityManager) => { ... })`
>
> "**ALWAYS use the provided instance of entity manager** - `transactionalEntityManager` in this example. **DO NOT USE GLOBAL ENTITY MANAGER.** All operations **MUST** be executed using the provided transactional entity manager."
>
> `QueryRunner`는 "a single database connection"을 제공하며, 수동 사용 시 `queryRunner.connect()` / `queryRunner.release()`로 생명주기를 관리.

출처: <https://typeorm.io/docs/transactions/>

문서의 "여러 작업을 묶으려면 `dataSource.transaction(...)`을 따로 써야 한다"가 정확합니다.

### ㉕ Repository는 쿼리마다 풀에서 빌리고 돌려준다 — ✅ CONFIRMED (표현 주의)

드라이버 레벨:

> pg의 `pool.query()`는 "**the pool is doing the acquiring and releasing internally**" — 클라이언트를 빌려 쿼리하고 자동 반납.

출처: <https://node-postgres.com/apis/pool>

TypeORM 레벨: `PostgresQueryRunner.connect()`가 `obtainMasterConnection()`으로 연결과 `release` 콜백을 함께 받고, `release()`가 그 콜백을 호출해 풀로 돌려줍니다.

```typescript
this.releaseCallback = (err?: Error) => {
    this.databaseConnection.removeListener("error", onErrorCallback)
    release(err)
}
```

출처: <https://github.com/typeorm/typeorm/blob/master/src/driver/postgres/PostgresQueryRunner.ts>

> ℹ️ 정밀하게 말하면 `EntityManager.find()` 자체가 매번 QueryRunner를 만들고 버리는 코드를 갖고 있는 건 아니고, **쿼리 빌더 계층이 러너 생명주기를 처리**합니다. 다만 개발자 관점에서 "명시적으로 반납할 필요가 없다"는 문서의 서술은 결과적으로 정확합니다.

---

## 수정 필요 목록

### (1) ⑱ — 연결 수립 시간 수치 (출처 없음)

현재 본문:

> 정확한 수치는 환경마다 다르지만 감을 잡아 보면, 연결을 새로 맺는 데는 보통 <strong>수 ms에서 수십 ms</strong>가 걸립니다. 반면 `SELECT * FROM todos` 같은 가벼운 쿼리는 <strong>1ms 안팎</strong>이면 끝납니다. 즉 <strong>준비에 30, 본론에 1</strong>을 쓰는 셈입니다.

→ 어떤 공식 문서도 이 수치를 뒷받침하지 않으므로, 정성적 표현으로 바꾸거나 "일반적인 경험칙"임을 명시할 것.

### (2) ④ — `pool_recycle` 이유의 "방화벽·로드밸런서" (출처 없음)

현재 본문:

> 내 쪽에서는 연결을 잘 들고 있어도, <strong>중간의 방화벽·로드밸런서나 DB 서버가 "오래 조용한 연결"을 몰래 끊어 버리는</strong> 일이 흔합니다.

→ SQLAlchemy가 실제로 드는 사례는 **DB 재시작**과 **DB의 유휴 연결 자동 종료**뿐. PostgreSQL의 `idle_session_timeout` 문서에는 "커넥션 풀 계층이 예기치 않은 연결 종료에 잘 대응하지 못할 수 있으니 주의하라"는 **딱 맞는 경고**가 있으므로 그쪽으로 근거를 바꾸면 더 강해짐.

### (3) ⑨ — "전체 흐름" 5단계의 `expire_on_commit` 적용 (논리 오류)

현재 본문:

> 반환된 객체를 FastAPI가 <strong>JSON으로 직렬화해 응답</strong>합니다. (`expire_on_commit=False` 덕분에 이 시점에도 값을 안전하게 읽을 수 있습니다.)

→ 이 예시(`list_todos`)는 **조회 전용이라 `commit()`이 없고**, commit이 없으면 만료도 없습니다. 게다가 FastAPI는 **응답을 보낸 뒤에** 종료 코드를 실행하므로 직렬화 시점에는 세션이 열려 있습니다. `expire_on_commit=False`가 실제로 필요한 곳은 **commit 후 객체를 반환하는 생성·수정 엔드포인트**입니다.

---

## 참고 — 문서에 추가하면 좋을 검증된 사실

이번 검증에서 확인됐지만 현재 문서에 없는 내용입니다(수정 필수는 아님).

1. **반납 시 트랜잭션 롤백** — "When connections are returned to the connection pool, transactional state is rolled back as well." (<https://docs.sqlalchemy.org/en/20/orm/session_basics.html>) → `close()`만 하고 `commit()`을 안 하면 변경이 사라지는 이유.
2. **`Result.first()`는 나머지 행을 버린다** — "Closes the result set and discards remaining rows." (소스 docstring) → LIMIT 1과는 다른 개념.
3. **`extra`가 `poolSize`를 덮어쓴다** — TypeORM 소스의 `Object.assign` 병합 순서 때문.
4. **autoflush를 끄면 생기는 반대급부** — 아직 flush되지 않은 내 변경을 쿼리가 보지 못함.

---

## 파일 위치에 대해

이 저장소에는 **연구·검증 노트를 모아 두는 기존 관례가 없어서**(각 폴더는 주제별 `.md` 문서와 `README.md`, self-study 폴더는 번호가 붙은 `.html` 강의 파일로만 구성됨), 검증 대상 문서 바로 옆에 같은 번호 접두사를 붙여 저장했습니다.

```
backend/fastapi/self-study/week05-postgres-sqlalchemy/03-fact-check-primary-sources.md
```
