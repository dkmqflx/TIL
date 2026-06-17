import {
  Entity,
  PrimaryGeneratedColumn,
  ManyToOne,
  JoinColumn,
  Column,
  CreateDateColumn,
} from 'typeorm';

/**
 * Follow — 커스텀 조인 테이블 (User 자기참조 N:M)
 *
 * 단순 @ManyToMany 대신 별도 Entity로 만들어 isConfirmed 같은
 * 추가 컬럼을 붙일 수 있다.
 */
@Entity()
export class Follow {
  @PrimaryGeneratedColumn()
  id: number;

  /** 팔로우를 신청한 사람 */
  @ManyToOne(() => UserEntity, (user) => user.following, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'follower_id' })
  follower: UserEntity;

  @Column()
  follower_id: number;

  /** 팔로우 대상(팔로위) */
  @ManyToOne(() => UserEntity, (user) => user.followers, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'following_id' })
  following: UserEntity;

  @Column()
  following_id: number;

  /**
   * 팔로우 승인 여부.
   * false(기본) = 신청 대기, true = 승인 완료.
   * 비공개 계정에서 맞팔 승인 플로우를 구현할 때 사용.
   */
  @Column({ default: false })
  isConfirmed: boolean;

  @CreateDateColumn()
  createdAt: Date;
}

// ── 최소 User 타입 (실제 프로젝트에서는 users/entities/user.entity.ts import) ──
class UserEntity {
  id: number;
  following: Follow[];
  followers: Follow[];
  followerCount: number;
  followingCount: number;
}
