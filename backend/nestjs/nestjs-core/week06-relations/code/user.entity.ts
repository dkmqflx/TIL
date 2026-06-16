import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
} from 'typeorm';
import { Post } from './post.entity';

/**
 * User Entity — Week 6 예제용 (자기완결형, BaseModel 상속 없음).
 *
 * 관계 예시:
 *  - posts: User는 여러 개의 Post를 소유 (1:N)
 *  - profile: User는 하나의 Profile을 가질 수 있음 (1:1, 반대쪽)
 *
 * @OneToMany 쪽에는 FK 컬럼이 생기지 않는다 — FK는 Post.author 쪽에만 생긴다.
 */
@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'varchar', length: 100, nullable: false, unique: true })
  email: string;

  @Column({ type: 'varchar', length: 50, nullable: false })
  nickname: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  /**
   * 1:N — 한 User는 여러 Post를 작성할 수 있다.
   * FK는 Post 테이블의 authorId 컬럼에 생긴다 (ManyToOne 쪽).
   * 이 필드에는 DB 컬럼이 생기지 않는다.
   */
  @OneToMany(() => Post, (post) => post.author)
  posts: Post[];
}
