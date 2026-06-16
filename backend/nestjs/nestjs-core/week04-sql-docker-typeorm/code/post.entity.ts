import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Post {
  @PrimaryGeneratedColumn()
  id: number; // SERIAL PRIMARY KEY — 자동 증가 PK

  @Column()
  title: string; // NOT NULL TEXT

  @Column({ nullable: true })
  content: string; // NULL 허용 TEXT
}
