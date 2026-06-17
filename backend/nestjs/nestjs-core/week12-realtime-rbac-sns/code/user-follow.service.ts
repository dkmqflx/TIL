import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { Follow } from './follow.entity';

@Injectable()
export class UserFollowService {
  constructor(
    @InjectRepository(Follow)
    private readonly followRepository: Repository<Follow>,
    private readonly dataSource: DataSource,
  ) {}

  /** 팔로우 신청 (isConfirmed = false) */
  async followUser(followerId: number, followingId: number): Promise<Follow> {
    if (followerId === followingId) {
      throw new BadRequestException('자기 자신을 팔로우할 수 없습니다.');
    }

    const existing = await this.followRepository.findOne({
      where: { follower_id: followerId, following_id: followingId },
    });
    if (existing) {
      throw new BadRequestException('이미 팔로우 신청 중이거나 팔로우한 계정입니다.');
    }

    const follow = this.followRepository.create({
      follower_id: followerId,
      following_id: followingId,
      isConfirmed: false,
    });

    return this.followRepository.save(follow);
  }

  /**
   * 팔로우 승인 (isConfirmed = true) + followerCount 증가
   * 트랜잭션으로 Follow 상태 변경과 카운터 업데이트를 원자적으로 처리
   */
  async confirmFollow(followId: number, followingId: number): Promise<Follow> {
    const qr = this.dataSource.createQueryRunner();
    await qr.connect();
    await qr.startTransaction();

    try {
      const follow = await qr.manager.findOne(Follow, {
        where: { id: followId, following_id: followingId, isConfirmed: false },
      });
      if (!follow) throw new NotFoundException('팔로우 신청을 찾을 수 없습니다.');

      follow.isConfirmed = true;
      await qr.manager.save(Follow, follow);

      // followerCount 증가 (User 테이블의 별도 컬럼)
      await this.incrementFollowerCount(followingId, qr.manager);

      await qr.commitTransaction();
      return follow;
    } catch (err) {
      await qr.rollbackTransaction();
      throw err;
    } finally {
      await qr.release();
    }
  }

  /** 팔로우 취소 + followerCount 감소 */
  async unfollow(followerId: number, followingId: number): Promise<void> {
    const qr = this.dataSource.createQueryRunner();
    await qr.connect();
    await qr.startTransaction();

    try {
      const follow = await qr.manager.findOne(Follow, {
        where: { follower_id: followerId, following_id: followingId },
      });
      if (!follow) throw new NotFoundException('팔로우 관계가 없습니다.');

      await qr.manager.remove(Follow, follow);

      if (follow.isConfirmed) {
        await this.decrementFollowerCount(followingId, qr.manager);
      }

      await qr.commitTransaction();
    } catch (err) {
      await qr.rollbackTransaction();
      throw err;
    } finally {
      await qr.release();
    }
  }

  /** followerCount 컬럼을 +1 증가 (EntityManager 주입 지원 — 트랜잭션 내 사용) */
  async incrementFollowerCount(
    userId: number,
    manager = this.dataSource.manager,
  ): Promise<void> {
    await manager
      .createQueryBuilder()
      .update('user_entity')
      .set({ followerCount: () => 'follower_count + 1' })
      .where('id = :userId', { userId })
      .execute();
  }

  /** followerCount 컬럼을 -1 감소 */
  async decrementFollowerCount(
    userId: number,
    manager = this.dataSource.manager,
  ): Promise<void> {
    await manager
      .createQueryBuilder()
      .update('user_entity')
      .set({ followerCount: () => 'GREATEST(follower_count - 1, 0)' })
      .where('id = :userId', { userId })
      .execute();
  }
}
