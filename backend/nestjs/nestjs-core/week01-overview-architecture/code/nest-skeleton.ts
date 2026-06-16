// nest new로 생성되는 NestJS 골격의 최소 형태.
// 실제 프로젝트에서는 아래 세 덩어리가 각각 별도 파일로 나뉜다:
//   - main.ts            : 부트스트랩(앱 생성·리스닝)
//   - app.module.ts      : 루트 모듈(컨트롤러·프로바이더를 묶음)
//   - app.controller.ts  : 라우트 핸들러
//
// 설치/실행(참고):
//   npm i -g @nestjs/cli
//   nest new my-sns          # 골격 생성
//   npm run start:dev        # watch 모드로 실행 → http://localhost:3000

import { NestFactory } from "@nestjs/core";
import { Module, Controller, Get } from "@nestjs/common";

// ── app.controller.ts ───────────────────────────────────────────
@Controller("posts")
export class AppController {
  @Get()
  findAll() {
    // 데코레이터가 "GET /posts"를 이 메서드에 연결한다.
    return { message: "hello" };
  }
}

// ── app.module.ts ───────────────────────────────────────────────
// @Module이 이 앱의 "조립 설명서". controllers/providers를 등록하면
// Nest의 DI 컨테이너가 의존성을 알아서 연결해 준다(Week 3에서 심화).
@Module({
  imports: [],
  controllers: [AppController],
  providers: [],
})
export class AppModule {}

// ── main.ts ─────────────────────────────────────────────────────
// 진입점. AppModule을 루트로 앱을 만들고 포트를 연다.
async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.listen(3000);
}
bootstrap();
