import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Post } from './post.entity';

@Injectable()
export class PostsService {
  constructor(
    @InjectRepository(Post)
    private postsRepo: Repository<Post>,
  ) {}

  // ─── 조회 ───────────────────────────────────────────────────

  /** 전체 게시글 조회 — SQL: SELECT * FROM post */
  findAll(): Promise<Post[]> {
    return this.postsRepo.find();
  }

  /** 단건 조회 — SQL: SELECT * FROM post WHERE id = ? LIMIT 1 */
  findOne(id: number): Promise<Post | null> {
    return this.postsRepo.findOne({ where: { id } });
  }

  // ─── 생성 ───────────────────────────────────────────────────

  /**
   * create() → 메모리에 Post 인스턴스만 생성 (DB 미반영)
   * save()   → SQL INSERT 실행 (DB 반영, id 자동 할당)
   */
  async create(title: string, content: string): Promise<Post> {
    // 1단계: 메모리 인스턴스 생성 — DB에 아무것도 저장되지 않음
    const post = this.postsRepo.create({ title, content });

    // 2단계: INSERT 실행 — id 포함한 Post 반환
    return this.postsRepo.save(post);
  }

  // ─── 수정 ───────────────────────────────────────────────────

  /**
   * save()는 id가 있으면 UPDATE, 없으면 INSERT를 실행한다.
   */
  async update(id: number, title: string): Promise<Post> {
    // 1. 기존 행 조회
    const post = await this.postsRepo.findOne({ where: { id } });

    // 2. 메모리에서 값 변경
    post.title = title;

    // 3. save() — id가 있으므로 UPDATE 실행
    return this.postsRepo.save(post);
  }

  // ─── 삭제 ───────────────────────────────────────────────────

  /**
   * delete(id) — 인스턴스 없이 id만으로 SQL DELETE 실행.
   * 실무에서 더 자주 쓰는 패턴 (findOne 불필요, 쿼리 1회).
   */
  async remove(id: number): Promise<void> {
    await this.postsRepo.delete(id);
  }
}
