import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';
import { Exclude, Expose } from 'class-transformer';

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  email: string;

  @Column()
  nickname: string;

  // toPlainOnly: true → 응답(직렬화) 시에만 제외, 입력(역직렬화) 시에는 포함
  @Exclude({ toPlainOnly: true })
  @Column()
  password: string;

  // @Expose() 예시: 계산된 필드를 응답에 포함시킬 때
  @Expose()
  get displayName(): string {
    return `${this.nickname} <${this.email}>`;
  }
}
