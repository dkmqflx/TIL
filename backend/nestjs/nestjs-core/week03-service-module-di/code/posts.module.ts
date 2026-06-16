import { Module } from '@nestjs/common';
import { PostsController } from './posts.controller';
import { PostsService } from './posts.service';

/**
 * PostsModule — 게시글 기능을 하나의 단위로 묶는 모듈.
 * - controllers: HTTP 요청을 처리하는 컨트롤러 목록
 * - providers:   DI 컨테이너에 등록할 서비스(프로바이더) 목록
 * - exports:     다른 모듈에서 PostsService를 주입받으려면 여기에 명시해야 한다
 */
@Module({
  controllers: [PostsController],
  providers: [PostsService],
  exports: [PostsService],
})
export class PostsModule {}
