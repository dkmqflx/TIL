import { Module } from '@nestjs/common';
import { PostsModule } from './posts.module';

/**
 * AppModule — 애플리케이션의 루트(최상위) 모듈.
 * NestFactory.create(AppModule)에 넘겨지는 진입점.
 * 기능 모듈(PostsModule 등)을 imports 배열에 나열하여 조립한다.
 */
@Module({
  imports: [PostsModule],
})
export class AppModule {}
