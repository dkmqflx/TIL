import { Injectable, NotFoundException } from '@nestjs/common';

interface Post {
  id: number;
  content: string;
}

/**
 * PostsService — 게시글 관련 비즈니스 로직을 담당.
 * @Injectable() 데코레이터로 NestJS DI 컨테이너에 등록된다.
 * 컨트롤러는 이 서비스에 로직을 위임하고, 요청/응답 처리만 맡는다.
 */
@Injectable()
export class PostsService {
  private posts: Post[] = [];
  private nextId = 1;

  findAll(): Post[] {
    return this.posts;
  }

  findOne(id: number): Post {
    const post = this.posts.find((p) => p.id === id);
    if (!post) throw new NotFoundException(`Post #${id} not found`);
    return post;
  }

  create(content: string): Post {
    const post: Post = { id: this.nextId++, content };
    this.posts.push(post);
    return post;
  }

  update(id: number, content: string): Post {
    const post = this.findOne(id);
    post.content = content;
    return post;
  }

  remove(id: number): { deleted: number } {
    const idx = this.posts.findIndex((p) => p.id === id);
    if (idx === -1) throw new NotFoundException(`Post #${id} not found`);
    this.posts.splice(idx, 1);
    return { deleted: id };
  }
}
