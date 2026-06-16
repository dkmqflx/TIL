import { Entity, Column } from 'typeorm';
import { BaseModel } from './base.entity';

/** 게시글 상태를 나타내는 TypeScript enum. */
export enum PostStatus {
  DRAFT = 'DRAFT',
  PUBLISHED = 'PUBLISHED',
  ARCHIVED = 'ARCHIVED',
}

/**
 * Post Entity — BaseModel을 상속해 id / createdAt / updatedAt 포함.
 *
 * 컬럼 옵션 예시:
 *  - title: 최대 200자 varchar, NOT NULL
 *  - content: text, NULL 허용
 *  - viewCount: int, 기본값 0, 한 번 저장 후 ORM 레이어에서 update 불가
 *  - status: enum 컬럼, 기본값 DRAFT
 */
@Entity()
export class Post extends BaseModel {
  /** 게시글 제목 — 최대 200자, NOT NULL */
  @Column({ type: 'varchar', length: 200, nullable: false })
  title: string;

  /** 본문 — NULL 허용 (임시저장 상태에서는 비어있을 수 있음) */
  @Column({ type: 'text', nullable: true })
  content: string | null;

  /**
   * 조회수 — 기본값 0, update: false 이므로
   * ORM을 통한 save() 호출 시 이 컬럼은 변경되지 않는다.
   * (직접 SQL 또는 QueryBuilder로는 변경 가능)
   */
  @Column({ type: 'int', default: 0, update: false })
  viewCount: number;

  /** 게시글 상태 — Enum 컬럼, 기본값 DRAFT */
  @Column({
    type: 'enum',
    enum: PostStatus,
    default: PostStatus.DRAFT,
  })
  status: PostStatus;
}
