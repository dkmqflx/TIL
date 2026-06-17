import { IsString, IsInt, IsOptional, Length, Min, Max } from 'class-validator';
import { PartialType, PickType } from '@nestjs/mapped-types';

export class CreatePostDto {
  @IsString()
  @Length(1, 100, { message: '제목은 1~100자 사이여야 합니다' })
  title: string;

  @IsString()
  @Length(1, 5000, { message: '본문은 1~5000자 사이여야 합니다' })
  content: string;

  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(5)
  rating?: number;
}

// PickType: CreatePostDto 중 title·content 만 추출
export class UpdatePostTitleDto extends PickType(CreatePostDto, ['title', 'content'] as const) {}

// PartialType: CreatePostDto의 모든 필드를 Optional로 변환
export class UpdatePostDto extends PartialType(CreatePostDto) {}
