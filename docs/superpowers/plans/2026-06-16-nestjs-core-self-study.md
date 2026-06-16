# NestJS 코어 셀프 스터디 자료 — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking. **각 태스크 실행 전 반드시 이 문서의 "Shared Conventions" 절을 먼저 읽을 것.**

**Goal:** 인프런 *NestJS 마스터 클래스 Part 1*을 `backend/fastapi/self-study`와 동일한 시각화 HTML 포맷으로 큐레이션 재구성한 12주·36레슨 학습 사이트를 `backend/nestjs/nestjs-core/`에 만든다.

**Architecture:** 정적 HTML 사이트. 공유 `assets/style.css`(fastapi에서 복사) + 주차 폴더별 토픽 HTML + 최소 `code/` 예제. 빌드는 **스캐폴드 1회 → 주차 단위 1커밋** 으로 진행하며, 각 주차 완료 시 `index.html`·`README.md`의 링크/배지를 활성화한다.

**Tech Stack:** HTML5 · CSS(기존 디자인 시스템) · 인라인 SVG · Node.js(검증 스크립트). 빌드 도구 없음. 한국어 콘텐츠(기술 용어 영문 병기).

**Spec:** `docs/superpowers/specs/2026-06-16-nestjs-core-self-study-design.md`

---

## Shared Conventions (모든 태스크 공통 — 먼저 읽기)

### 레퍼런스 파일 (복사/구조 차용 원본)
- **디자인 시스템**: `backend/fastapi/self-study/assets/style.css` → 그대로 복사. **수정 금지.**
- **레슨 페이지 구조 레퍼런스**: `backend/fastapi/self-study/week06-json-api-structure/02-dependency-injection-mvc.html`
  → 이 파일의 골격(topbar/head/summary/goals/번호 h2/box/code/figure/qa/pager/foot)을 그대로 따르되 **`.compare` 패널(좌 Nest/우 Fast 2단)은 절대 사용하지 않는다.**
- **인덱스 레퍼런스**: `backend/fastapi/self-study/index.html` (hero·stats·week 카드·badge 구조 차용)
- **README 레퍼런스**: `backend/fastapi/self-study/README.md` (목표/구조/원칙/커리큘럼/체크리스트 구조 차용)

### 레슨 페이지 필수 요소 (verify.mjs가 검사)
모든 레슨 `.html`은 다음 클래스를 반드시 포함한다: `topbar`, `summary`, `goals`, `qa`, `pager`.
추가로 권장 구성(검사는 안 하지만 작성 시 포함): `head`(kicker+h1+subtitle), 번호 매긴 `h2`, 🍔 `box analogy` ≥1, 인라인 SVG `figure.diagram` ≥1, `box`(tip/warn/note) ≥1, `details.qa` 2~3개, `foot`.

### 디자인 규칙
- 비교 패널 제거분을 **비유 박스(`box analogy`)와 SVG 다이어그램으로 보강**한다.
- 모든 페이지는 `<link rel="stylesheet" href="../assets/style.css">`(레슨) / `href="assets/style.css"`(index) 로 디자인 시스템을 로드.
- 코드 블록은 레퍼런스의 `<span class="k|s|t|f|c|d|n">` 하이라이트 클래스를 사용. 언어는 TypeScript.
- `lang="ko"`, `<meta charset="UTF-8">`, viewport meta 포함.

### Per-Week Build Procedure (Week 태스크 공통 절차)
각 주차 태스크는 아래 순서를 따른다(구체 콘텐츠는 해당 태스크의 "레슨 브리프" 사용):
1. 주차 폴더 생성: `backend/nestjs/nestjs-core/weekNN-slug/` 및 필요 시 `code/`.
2. 레슨 브리프에 따라 `01-*.html`, `02-*.html`, `03-*.html` 작성. 레퍼런스 골격 복사 후 콘텐츠 교체, `.compare` 제거.
3. `pager`의 이전/다음 링크를 같은 주차 레슨끼리 연결(첫 레슨의 prev는 이전 주차 마지막 레슨 또는 `../index.html`, 마지막 레슨의 next는 다음 주차 첫 레슨 또는 `../index.html`). 아직 없는 다음 주차 링크는 `../index.html`로 둔다.
4. 브리프에 명시된 `code/` 파일 작성(있는 경우).
5. `index.html`: 해당 주차 `<section class="week">`의 레슨 `<a href>`를 실제 경로로 활성화하고 배지를 `badge-ready ● 작성 완료`로 변경.
6. `README.md`: 해당 주차 진행 체크리스트 항목을 `[x]`로 변경.
7. **검증**: `node backend/nestjs/nestjs-core/verify.mjs` → `✓ all passed` 확인. 실패 시 수정 후 재실행.
8. **커밋**: 아래 커밋 규칙.

### 커밋 규칙 (commitlint 강제 — scope `be(nestjs)`)
```bash
git add backend/nestjs/nestjs-core
git commit -m "add(be(nestjs)): week NN — <짧은 제목>"
```
타입은 `add`(신규 주차) / `update`(인덱스·README 활성화 동반 시에도 add로 통일 가능). 커밋 메시지 본문 마지막 줄:
`Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>`

### 검증 스크립트가 검사하는 것
- 모든 상대 `href`/`src` 링크가 실제 파일로 해석됨(깨진 prev/next/index/css 링크 탐지).
- 각 페이지가 `style.css`를 로드.
- 레슨 페이지가 필수 구조 요소 포함.

---

## File Structure

```
backend/nestjs/nestjs-core/
├── README.md                          # [교체] 강의 덤프 → 계획표+인덱스+체크리스트
├── index.html                         # [신규] 랜딩(12 week 카드, 배지로 진행 표시)
├── verify.mjs                         # [신규] 링크/구조 검증 스크립트(Node, 무의존성)
├── assets/style.css                   # [신규] fastapi style.css 복사(불변)
├── week01-overview-architecture/      # 3 html + (code/)
├── week02-controller-request/         # 3 html + code/
├── week03-service-module-di/          # 3 html + code/
├── week04-sql-docker-typeorm/         # 3 html + code/
├── week05-typeorm-deep/               # 3 html + code/
├── week06-relations/                  # 3 html + code/
├── week07-authentication/             # 3 html + code/
├── week08-guard-pipe-decorator/       # 3 html + code/
├── week09-validation-transform/       # 3 html + code/
├── week10-pagination/                 # 3 html + code/
├── week11-cross-cutting/              # 3 html + code/
└── week12-realtime-rbac-sns/          # 3 html + code/
```

각 파일 책임: `index.html`=네비게이션 허브 / `README.md`=텍스트 계획·진행 / `verify.mjs`=자동 검증 / 주차 HTML=토픽별 학습 / `code/`=실행 가능한 최소 예제.

---

## Task 0: 스캐폴드 (style.css · verify.mjs · README · index)

**Files:**
- Create: `backend/nestjs/nestjs-core/assets/style.css` (복사)
- Create: `backend/nestjs/nestjs-core/verify.mjs`
- Modify: `backend/nestjs/nestjs-core/README.md` (현재 강의 덤프를 계획표로 교체)
- Create: `backend/nestjs/nestjs-core/index.html`

- [ ] **Step 1: style.css 복사**

Run:
```bash
mkdir -p backend/nestjs/nestjs-core/assets
cp backend/fastapi/self-study/assets/style.css backend/nestjs/nestjs-core/assets/style.css
```
Expected: 파일 복사됨, 내용 동일.

- [ ] **Step 2: verify.mjs 작성**

Create `backend/nestjs/nestjs-core/verify.mjs`:
```js
#!/usr/bin/env node
// nestjs-core 학습 사이트 검증: 상대 링크 무결성 + 레슨 필수 구조 요소.
import { readFileSync, readdirSync, existsSync } from 'node:fs';
import { join, dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = dirname(fileURLToPath(import.meta.url));

function walk(dir) {
  const out = [];
  for (const e of readdirSync(dir, { withFileTypes: true })) {
    const p = join(dir, e.name);
    if (e.isDirectory()) out.push(...walk(p));
    else if (e.name.endsWith('.html')) out.push(p);
  }
  return out;
}

const htmlFiles = walk(root);
let errors = 0;
const err = (f, msg) => { console.error(`✗ ${f.replace(root + '/', '')}: ${msg}`); errors++; };

for (const file of htmlFiles) {
  const html = readFileSync(file, 'utf8');
  const isIndex = file.endsWith('index.html');

  const cssMatch = html.match(/<link[^>]+href="([^"]+style\.css)"/);
  if (!cssMatch) err(file, 'missing style.css <link>');
  else if (!existsSync(resolve(dirname(file), cssMatch[1]))) err(file, `style.css not found: ${cssMatch[1]}`);

  for (const m of html.matchAll(/(?:href|src)="([^"]+)"/g)) {
    if (/^(https?:|mailto:|data:|#)/.test(m[1])) continue;
    const link = m[1].split('#')[0];
    if (!link) continue;
    if (!existsSync(resolve(dirname(file), link))) err(file, `broken link: ${link}`);
  }

  const need = isIndex
    ? ['class="topbar"', 'class="week"']
    : ['class="topbar"', 'class="summary"', 'class="goals"', 'class="qa"', 'class="pager"'];
  for (const n of need) if (!html.includes(n)) err(file, `missing element: ${n}`);
}

console.log(`\nChecked ${htmlFiles.length} HTML file(s). ${errors === 0 ? '✓ all passed' : `✗ ${errors} error(s)`}`);
process.exit(errors === 0 ? 0 : 1);
```

- [ ] **Step 3: README.md 교체**

`backend/fastapi/self-study/README.md`의 구조를 차용해 NestJS 버전으로 작성. 반드시 포함: 제목/한줄소개, 🎯 목표와 전제(§spec 1 반영), 🗂 폴더 구조, 📄 HTML 작성 원칙(비교 패널 없음 명시), 📚 12주 커리큘럼(spec §5 그대로), ✅ 진행 체크리스트(week01~week12 모두 `[ ]`로 시작). 현재의 강의 덤프 내용은 전부 대체한다.

- [ ] **Step 4: index.html 작성**

`backend/fastapi/self-study/index.html` 구조 차용. hero(제목 "NestJS 코어\n마스터하기"), stats(`12 Weeks` / `36 Lessons` / `1 SNS 백엔드` / `★ 핵심 7주`), 12개 `<section class="week">` 카드. 각 카드: 번호, 제목(spec §5), 한줄 부제, 3개 레슨 `<li>`. ★주차(3·5·6·7·8·10·11·12)는 `<section class="week star">` + `<span class="tag">★ 핵심</span>`. **모든 레슨 링크는 처음엔 `href="#"` + `<span class="badge-soon">○ 작성 예정</span>`** (주차 완료 시 활성화). FastAPI 인덱스를 가리키는 링크/문구는 제거.

- [ ] **Step 5: 검증**

Run: `node backend/nestjs/nestjs-core/verify.mjs`
Expected: `Checked 1 HTML file(s). ✓ all passed` (이 시점엔 index.html만 존재).
추가 수동: index.html을 브라우저로 열어 스타일이 적용되는지 확인.

- [ ] **Step 6: 커밋**

```bash
git add backend/nestjs/nestjs-core
git commit -m "add(be(nestjs)): nestjs-core self-study 스캐폴드 (style.css·index·README·verify)"
```
(본문 끝에 Co-Authored-By 라인 포함)

---

## Task 1: Week 1 — 큰 그림 & NestJS 아키텍처 (워크드 예시)

**Files:**
- Create: `week01-overview-architecture/01-backend-map-http-rest.html`
- Create: `week01-overview-architecture/02-why-nest-wraps-express.html`
- Create: `week01-overview-architecture/03-setup-sns-concept-lifecycle.html`
- Create: `week01-overview-architecture/code/raw-http.js`, `code/express-server.js`, `code/nest-skeleton.ts`
- Modify: `index.html`, `README.md`

**Per-Week Build Procedure(공통 절차)를 따르되, 아래 레슨 브리프로 콘텐츠를 채운다.**

- [ ] **Step 1: 레슨 01 작성 — 백엔드의 지도 · HTTP · REST**
  - h1: `백엔드의 지도 · HTTP · REST`, subtitle: 프론트엔드가 매일 쓰던 HTTP/REST를 '서버 입장'에서 다시 본다.
  - summary: 클라이언트-서버·HTTP·REST는 이미 절반은 안다 — 서버가 무엇을 받고 무엇을 돌려주는지로 다시 정리한다.
  - goals(4~5): 클라이언트-서버 모델 / HTTP 요청·응답 구조 / REST 자원·메서드 원칙 / Node.js와 NestJS의 위치.
  - h2: ①클라이언트-서버(🍔 비유: 식당 주문) ②HTTP 요청/응답 해부(SVG: req line·headers·body / res status·headers·body) ③REST 원칙(`.tbl`: 메서드↔CRUD↔상태코드) ④Node.js & NestJS의 위치(SVG: 런타임→Express→NestJS 스택).
  - 코드: `curl` 요청 예 1개.
  - qa(3): "REST를 한 문장으로?" / "GET과 POST의 멱등성 차이?" / "404 vs 500은 누구의 잘못?".
  - code/: 없음.

- [ ] **Step 2: 레슨 02 작성 — 왜 NestJS는 Express를 감싸나**
  - h1: `왜 NestJS는 Express를 감싸나`, subtitle: raw http → Express → NestJS, 각 계층이 무엇을 대신 해주는가.
  - summary: NestJS는 Express 위에 구조(DI·모듈·데코레이터)를 얹은 프레임워크다.
  - goals: 순수 Node http 서버 / Express 서버 / NestJS가 더하는 구조적 가치 / 언제 Nest를 택하나.
  - h2: ①raw Node `http` 서버(code: `raw-http.js`) ②Express 서버(code: `express-server.js`) — **1회성 코드 대조**(반복 비교 패널 아님, 일반 코드 블록 2개) ③NestJS가 더해주는 것(SVG: http→express→nest 레이어 + DI/모듈/데코레이터 라벨) ④그래서 언제? (`.box tip`).
  - qa(3): "NestJS가 기본으로 쓰는 HTTP 라이브러리는?(Express)" / "데코레이터·DI가 주는 이점?" / "Express만으로 부족해지는 지점?".
  - code/: `raw-http.js`(node 내장 http로 200 JSON 반환), `express-server.js`(express로 동일 동작).

- [ ] **Step 3: 레슨 03 작성 — 셋업 · SNS 컨셉 · 요청 라이프사이클**
  - h1: `프로젝트 셋업 · SNS 컨셉 · 요청 라이프사이클`.
  - summary: `nest new`로 골격을 만들고, 인스타그램 SNS 도메인을 정의하고, 요청이 거치는 단계를 외운다.
  - goals: Nest CLI 셋업·폴더 구조 / SNS 도메인(User·Post·Comment·Follow) / Request Life Cycle 순서.
  - h2: ①`nest new`와 프로젝트 구조(code: `main.ts`·`app.module.ts` 스니펫) ②인스타그램 SNS 컨셉(SVG: User—Post—Comment—Follow 관계도) ③Request Life Cycle(SVG: Middleware→Guard→Interceptor(before)→Pipe→Handler→Interceptor(after)→Exception Filter) — 환경설정/디버거/PgAdmin/Postman은 `.box note` 콜아웃으로 흡수.
  - qa(3): "Request Life Cycle 순서?" / "Guard와 Middleware의 차이?" / "Nest CLI가 만들어주는 핵심 파일?".
  - code/: `nest-skeleton.ts`(main.ts + AppModule 최소 형태).

- [ ] **Step 4: pager 연결** — 절차 3번. (01.prev=`../index.html`, 03.next=`../week02-controller-request/01-controller-routing.html`는 아직 없으므로 `../index.html`로 둠).
- [ ] **Step 5: index.html·README 활성화** — 절차 5·6번 (Week 1 링크 실경로, 배지 작성 완료, 체크리스트 `[x]`).
- [ ] **Step 6: 검증** — `node backend/nestjs/nestjs-core/verify.mjs` → `✓ all passed`. + 브라우저에서 3개 레슨 열어 깨짐/링크 확인.
- [ ] **Step 7: 커밋** — `add(be(nestjs)): week 1 — overview & architecture`.

---

## Tasks 2–12: 주차별 레슨 브리프

> 각 태스크는 **Per-Week Build Procedure**(폴더 생성→3 레슨 작성→pager 연결→code/ →index·README 활성화→verify→커밋)를 따른다. 아래는 각 주차의 구체 콘텐츠. 모든 레슨은 §"레슨 페이지 필수 요소"를 충족하고 qa 2~3개를 포함한다. 직전 주차 마지막 레슨의 `next`를 이 주차 첫 레슨으로 연결하는 것도 잊지 말 것.

### Task 2: Week 2 — Controller · 라우팅 · 요청 데이터 (`week02-controller-request/`)
- `01-controller-routing.html` — Controller & 데코레이터 라우팅. h2: `@Controller` prefix / `@Get/@Post/@Patch/@Delete` / 라우트 path & 와일드카드 / 응답 반환. 🍔 비유: 우편물 분류실. SVG: URL→컨트롤러 메서드 매핑. code: `posts.controller.ts`. qa: 라우팅 데코레이터 역할 / 컨트롤러의 책임 범위.
- `02-query-param-body.html` — 요청 데이터 받기. h2: `@Param` / `@Query` / `@Body` / `@Headers` / REST API 세트(목록·단건·생성·수정·삭제). 표: 데코레이터↔요청 위치. code: 각 데코레이터 사용 예. qa: Param vs Query 선택 기준 / Body는 어떤 메서드에서.
- `03-crud-builtin-exceptions.html` — 기본 CRUD + 내장 Exception. h2: 메모리 배열 CRUD / `NotFoundException` 등 내장 예외 / 적절한 상태코드. SVG: 예외→HTTP 응답 변환. `.box warn`: 메모리 저장의 한계(→ Week 4 DB 예고). code: `posts.controller.ts` 확장. qa: NotFoundException이 만드는 응답 / 내장 예외 목록은 어디서.
- code/: `posts.controller.ts`(인메모리 CRUD).

### Task 3: Week 3 — ★ Service · Module · Provider · DI/IoC (`week03-service-module-di/`)
- `01-service-layer.html` — Service로 로직 분리. h2: `@Injectable` 서비스 / 컨트롤러는 얇게 / 책임 분리. 🍔 비유: 주방(서비스) vs 홀(컨트롤러). SVG: Controller→Service→(저장소) 단방향. code: `posts.service.ts` + 얇아진 컨트롤러. qa: 서비스로 빼면 좋은 점.
- `02-di-ioc.html` — DI & IoC 원리. h2: 의존성을 직접 만들지 않기 / IoC 컨테이너 / 생성자 주입 / 토큰. 🍔 비유: 재료를 받아 쓰는 요리사(fastapi 비유 재활용 OK). SVG: 컨테이너가 인스턴스를 주입하는 그림. code: 생성자 주입 예. qa: IoC란? / 생성자 주입의 장점(테스트 용이).
- `03-module-provider-appmodule.html` — Module/Provider·AppModule·main.ts. h2: `@Module`(providers·controllers·imports·exports) / providers 등록 / 모듈 간 export·import / `main.ts` 부트스트랩. SVG: 모듈 그래프(AppModule→PostsModule). code: `posts.module.ts`·`app.module.ts`·`main.ts`. qa: provider를 다른 모듈에서 쓰려면? / AppModule의 역할.
- code/: `posts.service.ts`·`posts.module.ts`·`app.module.ts`.

### Task 4: Week 4 — SQL · Docker · TypeORM 시작 (`week04-sql-docker-typeorm/`)
- `01-sql-docker-postgres.html` — SQL 기본기 + Docker로 Postgres. h2: SQL 기초(SELECT/INSERT/UPDATE/DELETE, 테이블·PK) / Docker·이미지·컨테이너 개념 / `docker-compose.yml`로 Postgres 띄우기 / VSC Postgres 익스플로러. 🍔 비유: 컨테이너=밀폐 도시락. SVG: docker compose → postgres 컨테이너. code: `docker-compose.yml`. qa: 이미지 vs 컨테이너 / compose를 쓰는 이유.
- `02-typeorm-setup-entity-repo.html` — TypeORM 설정·Entity·Repository. h2: `TypeOrmModule.forRoot` 설정 / `@Entity`·`@Column`·`@PrimaryGeneratedColumn` / `forFeature`로 Repository 주입. SVG: Entity↔테이블 매핑. code: `app.module.ts`(TypeORM 설정), `post.entity.ts`. qa: Entity가 하는 일 / Repository는 어떻게 주입.
- `03-repository-crud.html` — Find/Create/Save/Delete. h2: `find`·`findOne` / `create`+`save` / `save`로 업데이트 / `delete`. 표: 메서드↔SQL. `.box warn`: `create`는 인스턴스만, `save`가 DB 반영. code: `posts.service.ts`(Repository 사용). qa: create와 save 차이 / findOne where 옵션.
- code/: `docker-compose.yml`·`post.entity.ts`·`posts.service.ts`.

### Task 5: Week 5 — ★ TypeORM 심화 이론 (`week05-typeorm-deep/`)
- `01-columns-enum-embedding.html` — Column 옵션·Enum·Embedding. h2: `@Column` 옵션(type·nullable·default·unique·length) / `enum` 컬럼 / `@Column(() => Embedded)` 임베딩. 표: 옵션 정리. `.box warn`: `update:false`/select 동작 주의. code: 옵션 예. qa: nullable vs default / enum 컬럼 장점.
- `02-inheritance-basemodel.html` — Table Inheritance·BaseModel. h2: `@CreateDateColumn`/`@UpdateDateColumn` / 추상 `BaseModel` 상속 / 단일/구체 테이블 상속. 🍔 비유: 공통 양식 상속. SVG: BaseModel→User/Post. code: `base.entity.ts` + 상속. qa: BaseModel을 쓰는 이유 / createdAt 자동화 방법.
- `03-findoptions-utils-methods.html` — FindManyOptions·유틸·메서드. h2: `where`·`select`·`order`·`relations`·`take/skip` / 연산자(`MoreThan`·`Like`·`In`·`Between`·`IsNull`) / 흔히 쓰는 메서드(`count`·`exist`·`findAndCount`). 표: 연산자 모음. code: 복합 find 예. qa: relations 옵션 역할 / findAndCount는 무엇을 반환.
- code/: `base.entity.ts`·`post.entity.ts`(옵션 적용판).

### Task 6: Week 6 — ★ Table Relations (`week06-relations/`)
- `01-relation-theory-sql.html` — 관계 이론 + SQL Relations. h2: FK 개념 / JOIN / 1:1·1:N·N:M 모델링 사고. 🍔 비유: 명함첩(참조). SVG: 두 테이블 FK 연결 + JOIN 결과. code: SQL JOIN 예. qa: FK가 보장하는 것 / N:M은 왜 중간 테이블.
- `02-relations-impl.html` — 관계 TypeORM 구현. h2: `@OneToOne`+`@JoinColumn` / `@ManyToOne`·`@OneToMany` / `@ManyToMany`+`@JoinTable`. SVG: 데코레이터↔FK 위치. code: User·Post·Profile 엔티티. qa: `@JoinColumn`은 어느 쪽에 / OneToMany는 FK를 갖나.
- `03-relation-options-query.html` — Relation Options·쿼리·Author 적용. h2: `cascade`·`eager`·`onDelete` / `relations` 로 조회 / Post.author 관계 적용 + 초기화. `.box warn`: `eager` 남용 주의. code: 옵션 + relation 포함 조회. qa: eager vs lazy / cascade가 위험할 수 있는 이유.
- code/: `user.entity.ts`·`post.entity.ts`(author relation).

### Task 7: Week 7 — ★ Authentication (`week07-authentication/`)
- `01-jwt-refresh-hashing.html` — Session vs JWT·토큰 이론·해싱. h2: 세션 vs JWT 트레이드오프 / Access·Refresh 역할 / `bcrypt` 해싱·솔트. 🍔 비유: 입장 팔찌(JWT). SVG: 로그인→토큰 발급→요청에 토큰 동봉. `.box warn`: 비밀번호 평문 저장 금지. qa: JWT가 stateless인 이유 / refresh 토큰이 필요한 이유.
- `02-register-login-signing.html` — 회원가입/로그인·signing. h2: `registerWithEmail`(해싱 후 저장) / `authenticate`+`loginWithEmail` / `jwtService.sign` / 엔드포인트. SVG: 로그인 시퀀스. code: `auth.service.ts`. qa: 로그인 검증 단계 / sign에 무엇을 payload로.
- `03-token-extract-refresh.html` — 토큰 추출·재발급. h2: Authorization 헤더 파싱(Basic/Bearer) / 토큰 검증 / access 재발급 로직. SVG: refresh 흐름. code: `extractTokenFromHeader` + refresh. qa: Bearer 헤더 형식 / 재발급 시 검증 대상.
- code/: `auth.service.ts`(해싱·sign·extract 핵심만).

### Task 8: Week 8 — ★ Guard · Pipe · Custom Decorator (`week08-guard-pipe-decorator/`)
- `01-pipes.html` — Pipe. h2: `ParseIntPipe`/`ParseUUIDPipe` / Custom Pipe(`transform`) / `DefaultValuePipe` / 다중 파이프. 🍔 비유: 정수기 필터. SVG: 요청값→파이프→핸들러. code: 커스텀 파이프. qa: 파이프의 두 역할(검증·변환) / 파이프 적용 위치.
- `02-guards.html` — Guard. h2: `CanActivate` / BasicTokenGuard / BearerTokenGuard / AccessTokenGuard 적용. 🍔 비유: 클럽 입구 보안요원. SVG: 요청→Guard(통과/차단). code: `bearer-token.guard.ts`. qa: Guard와 Middleware 차이 / Guard는 무엇을 반환.
- `03-custom-decorator.html` — Custom Decorator. h2: `createParamDecorator` / `@User()` 구현 / `data` 파라미터로 특정 필드. SVG: request.user→@User. code: `user.decorator.ts`. qa: 파라미터 데코레이터가 꺼내는 것 / data 인자 용도.
- code/: `bearer-token.guard.ts`·`user.decorator.ts`.

### Task 9: Week 9 — DTO 검증·변환 (`week09-validation-transform/`)
- `01-class-validator-dto.html` — Class Validator + DTO. h2: DTO 개념 / `@IsString`·`@IsEmail`·`@Length` / `ValidationPipe` 전역 적용 / `PickType`·`PartialType` / `@IsOptional`. SVG: 요청 body→DTO 검증→거부/통과. code: `create-post.dto.ts`. qa: DTO가 필요한 이유 / PickType의 효과.
- `02-validation-message.html` — Validation Message 일반화. h2: 데코레이터별 message 옵션 / 메시지 생성 함수로 일반화. code: 공통 메시지 유틸. qa: 메시지를 일반화하면 좋은 점.
- `03-class-transformer.html` — Class Transformer. h2: `@Exclude`/`@Expose` / `ClassSerializerInterceptor` 전역 / `toClassOnly`/`toPlainOnly`. 🍔 비유: 민감정보 가리개. SVG: 엔티티→직렬화→응답(필드 제거). code: User 엔티티 + serializer. qa: 비밀번호를 응답에서 빼는 법 / Expose 언제.
- code/: `create-post.dto.ts`·`user.entity.ts`(Exclude 적용).

### Task 10: Week 10 — ★ Pagination (`week10-pagination/`)
- `01-cursor-pagination.html` — Cursor Pagination. h2: 오프셋의 한계 / 커서 개념 / `MoreThan`+`order` 필터 / next cursor·`hasMore` 메타. 🍔 비유: 책갈피(커서). SVG: 커서로 다음 페이지 가져오기. code: `paginatePosts`(cursor). qa: cursor가 offset보다 나은 점 / 마지막 페이지 판단.
- `02-page-pagination.html` — Page Pagination. h2: `page`·`take` / `skip = (page-1)*take` / `total` 포함 응답. SVG: 페이지 번호→skip 계산. code: page 방식. qa: page 방식이 적합한 경우 / total은 어떻게.
- `03-paginate-generalize.html` — ★ 일반화. h2: `BasePaginationDto` / 공통 `paginate()` / `composeFindOptions`(where·order 생성) / cursor·page 분기 / override options. SVG: DTO→FindOptions 변환→Repository. code: `common.service.ts` `paginate()`. qa: 일반화의 이점 / where 필터 파싱 전략.
- code/: `base-pagination.dto.ts`·`paginate.ts`.

### Task 11: Week 11 — ★ 횡단 관심사 + 파일/설정 (`week11-cross-cutting/`)
- `01-config-fileupload-static.html` — Config·파일 업로드·Static. h2: `ConfigModule`(.env, `forRoot({isGlobal})`) / Multer·`FileInterceptor` 업로드 / `ServeStaticModule` 서빙 / 업로드 경로 prefix. 🍔 비유: 사물함(static). SVG: 업로드→저장→URL 서빙. code: `multer` 옵션 + 컨트롤러. qa: .env를 코드에서 읽는 법 / static 서빙 설정.
- `02-transaction-interceptor.html` — ★ Transaction·Interceptor. h2: All-or-Nothing 트랜잭션 / `QueryRunner`(connect·startTransaction·commit·rollback·release) / Interceptor(`intercept`+RxJS `tap`) / Transaction Interceptor + `@QueryRunner` 데코레이터. 🍔 비유: 은행 이체(원자성). SVG: 인터셉터가 트랜잭션을 감싸는 그림. code: `transaction.interceptor.ts`. qa: 트랜잭션이 필요한 상황 / rollback은 언제.
- `03-exception-filter-middleware.html` — Exception Filter·Middleware. h2: `@Catch`+`ExceptionFilter`(HttpException 변환) / 전역 등록 / `NestMiddleware`(`use`) / 적용 라우트. SVG: 요청 진입 시 Middleware, 응답 직전 Filter. code: `http-exception.filter.ts`·로깅 미들웨어. qa: Filter와 Interceptor 차이 / Middleware 적용 시점.
- code/: `transaction.interceptor.ts`·`http-exception.filter.ts`.

### Task 12: Week 12 — ★ 실시간 · 권한 · SNS 완성 (`week12-realtime-rbac-sns/`)
- `01-websocket-socketio.html` — WebSocket & Socket.IO. h2: WebSocket vs HTTP / `@WebSocketGateway`·`@SubscribeMessage` / 서버 emit / Room / Broadcasting / 채팅 엔티티·메시지. 🍔 비유: 전화 통화(상시 연결) vs 편지(HTTP). SVG: 클라↔게이트웨이 양방향 + Room. code: `chats.gateway.ts`. qa: WebSocket이 HTTP와 다른 점 / Room을 쓰는 이유.
- `02-nesting-rbac-authz.html` — 모듈 네스팅·RBAC·Authorization. h2: Comments 하위 모듈 네스팅 / `@Roles`+`RolesGuard` / 전역 Private + `@IsPublic` / `IsPostMineOrAdmin`·`IsCommentMineOrAdmin` 가드. SVG: 역할→가드 통과 매트릭스. code: `roles.guard.ts`·`is-mine-or-admin.guard.ts`. qa: RBAC란 / IsPublic 패턴의 목적.
- `03-follow-count-retro.html` — Follow System·Count·회고. h2: Follower/Followee 관계 + 커스텀 Follow 테이블 / confirm·취소 / Follow/Comment Count 증감(트랜잭션과 연계) / **회고 & 다음 로드맵**(배포·Socket 프로덕션은 다음 단계로 언급). SVG: 팔로우 관계 그래프. code: `follow` 로직 핵심. qa: 팔로우를 별도 테이블로 만드는 이유 / count를 별도 컬럼으로 관리하는 트레이드오프.
- code/: `follow.entity.ts`·`user-follow.service.ts`(핵심 스니펫).

---

## Self-Review

**1. Spec coverage:** spec §5의 12주 × 3레슨이 Task 1–12에 1:1 매핑됨(✓). spec §3 폴더구조→File Structure(✓). spec §4 레슨 anatomy→Shared Conventions 필수 요소 + Week1 워크드 예시(✓). spec §6 빌드 접근(스캐폴드 우선·주차 1커밋·index/README 활성화·검증)→Task 0 + Per-Week Build Procedure(✓). spec §2 결정(style.css 재사용·비교 패널 제거·주차별 code/)→Shared Conventions에 반영(✓). spec §7 YAGNI(capstone·비교패널·테마변경 없음)→플랜에서 미포함(✓).

**2. Placeholder scan:** 각 레슨 브리프는 구체적 h2 항목·시각화·code/ 파일·qa 주제를 명시(모호한 "적절히/나중에" 없음). verify.mjs는 완전한 코드 포함. README/index는 레퍼런스 파일 + 구체 포함 항목 지정(✓).

**3. Type/네이밍 일관성:** 파일 경로·폴더 slug가 File Structure ↔ Task 헤더 ↔ index.html 활성화 대상에서 일치. 커밋 scope `be(nestjs)` 전 구간 동일. verify.mjs 실행 경로 동일.

**Note(의도된 적응):** 콘텐츠 생성 작업이라 클래식 TDD(test-first) 대신 "생성 후 verify.mjs + 브라우저 스모크"로 검증 규율을 적용. 각 주차 태스크 크기(3레슨)는 spec의 "주차=커밋" 경계를 따르기 위함이며, 내부 스텝은 레슨 단위로 분할됨.
