import {
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

/**
 * 모든 Entity가 공유하는 추상 기반 클래스.
 * @Entity() 없음 → 자체 테이블을 만들지 않는다.
 * 상속받는 구체 Entity(@Entity() 붙인 클래스)가 각자의 테이블에
 * id / createdAt / updatedAt 컬럼을 포함하게 된다.
 */
export abstract class BaseModel {
  @PrimaryGeneratedColumn()
  id: number;

  /** INSERT 시 TypeORM이 자동으로 현재 시각을 기록한다. */
  @CreateDateColumn()
  createdAt: Date;

  /** INSERT 및 save() 호출마다 현재 시각으로 자동 갱신된다. */
  @UpdateDateColumn()
  updatedAt: Date;
}
