/**
 * posts.controller.ts — 예시용 발췌 (illustrative excerpt)
 *
 * 실제 NestJS 프로젝트에서는 PostsModule에 이 컨트롤러를 등록하고,
 * 비즈니스 로직은 PostsService로 분리해야 합니다 (Week 3).
 * 여기서는 Week 2 학습 목적으로 인메모리 배열을 컨트롤러 내부에 직접 뒀습니다.
 */

import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Param,
  Query,
  Body,
  NotFoundException,
} from '@nestjs/common';

/** 게시글 타입 (인메모리 학습용) */
interface Post {
  id: number;
  content: string;
}

@Controller('posts')
export class PostsController {
  /** 인메모리 게시글 저장소 (서버 재시작 시 초기화 — Week 4에서 DB로 교체) */
  private posts: Post[] = [];
  private nextId = 1;

  /**
   * GET /posts?page=1
   * 게시글 목록 조회. 쿼리스트링으로 페이지 번호를 받는다.
   */
  @Get()
  findAll(@Query('page') page = '1') {
    return { page: +page, data: this.posts };
  }

  /**
   * GET /posts/:id
   * 단건 조회. id가 없으면 404 NotFoundException을 던진다.
   */
  @Get(':id')
  findOne(@Param('id') id: string) {
    const post = this.posts.find((p) => p.id === +id);
    if (!post) {
      throw new NotFoundException(`Post #${id} not found`);
    }
    return post;
  }

  /**
   * POST /posts
   * 새 게시글 생성. 바디에서 content를 받아 인메모리 배열에 추가한다.
   * 기본 상태코드 201 Created.
   */
  @Post()
  create(@Body() body: { content: string }) {
    const post: Post = { id: this.nextId++, content: body.content };
    this.posts.push(post);
    return post;
  }

  /**
   * PATCH /posts/:id
   * 부분 수정. id가 없으면 404 NotFoundException을 던진다.
   */
  @Patch(':id')
  update(@Param('id') id: string, @Body() body: { content: string }) {
    const post = this.posts.find((p) => p.id === +id);
    if (!post) {
      throw new NotFoundException(`Post #${id} not found`);
    }
    post.content = body.content;
    return post;
  }

  /**
   * DELETE /posts/:id
   * 삭제. id가 없으면 404 NotFoundException을 던진다.
   */
  @Delete(':id')
  remove(@Param('id') id: string) {
    const idx = this.posts.findIndex((p) => p.id === +id);
    if (idx === -1) {
      throw new NotFoundException(`Post #${id} not found`);
    }
    this.posts.splice(idx, 1);
    return { deleted: +id };
  }
}
