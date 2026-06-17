import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { RoleEnum } from './roles.guard';

/**
 * IsPostMineOrAdminGuard
 *
 * 요청한 사용자가 게시글의 작성자이거나 ADMIN 역할인 경우에만 허용한다.
 * PATCH /posts/:postId, DELETE /posts/:postId 등에 적용.
 */
@Injectable()
export class IsPostMineOrAdminGuard implements CanActivate {
  constructor(
    @InjectRepository(PostEntity)
    private readonly postRepository: Repository<PostEntity>,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const req = context.switchToHttp().getRequest();
    const user = req.user as { id: number; role: RoleEnum };
    const postId = parseInt(req.params.postId ?? req.params.id, 10);

    // ADMIN은 모든 게시글에 접근 가능
    if (user.role === RoleEnum.ADMIN) return true;

    const post = await this.postRepository.findOne({ where: { id: postId } });
    if (!post) throw new NotFoundException(`Post #${postId} not found`);

    // 본인 글이 아니면 거부
    if (post.authorId !== user.id) {
      throw new ForbiddenException('본인의 게시글만 수정·삭제할 수 있습니다.');
    }

    return true;
  }
}

// ── 최소 타입 선언 (실제 프로젝트에서는 posts/entities/post.entity.ts 를 import) ──
class PostEntity {
  id: number;
  authorId: number;
}
