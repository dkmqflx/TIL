import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { User } from './user.entity';

/**
 * Post Entity — Week 6 예제용 (자기완결형, BaseModel 상속 없음).
 *
 * 관계 예시:
 *  - author: Post는 하나의 User에 속한다 (N:1)
 *
 * @ManyToOne 쪽에 FK(author_id) 컬럼이 실제로 생성된다.
 * onDelete: 'CASCADE' → User 삭제 시 연관 Post도 자동 삭제됨.
 */
@Entity()
export class Post {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'varchar', length: 200, nullable: false })
  title: string;

  @Column({ type: 'text', nullable: true })
  content: string | null;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  /**
   * N:1 — 여러 Post는 하나의 User(작성자)에 속한다.
   *
   * FK 컬럼 authorId가 posts 테이블에 생성된다.
   * onDelete: 'CASCADE' → 작성자(User)가 삭제되면 게시글도 함께 삭제.
   * eager: false (기본값) → 명시적으로 relations 옵션을 줘야 JOIN 조회됨.
   */
  @ManyToOne(() => User, (user) => user.posts, {
    onDelete: 'CASCADE',
    nullable: true,
  })
  @JoinColumn({ name: 'authorId' })
  author: User | null;
}
