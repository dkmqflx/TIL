import { IsNumber, IsOptional, IsString } from 'class-validator';

export class BasePaginationDto {
  // ─── 커서 페이지네이션용 ──────────────────────────────────────────
  // 마지막으로 받은 항목의 id. 이 값보다 큰 id 목록을 반환한다.
  // undefined 이면 첫 페이지 (OFFSET 0 와 동일한 효과).
  @IsNumber()
  @IsOptional()
  where__id__more_than?: number;

  // ─── 페이지 페이지네이션용 ───────────────────────────────────────
  // 1-indexed. page=1 → skip=0, page=2 → skip=take, …
  // page 가 존재하면 커서 모드 대신 페이지 모드로 동작한다.
  @IsNumber()
  @IsOptional()
  page?: number;

  // ─── 공통 ────────────────────────────────────────────────────────
  // 정렬 방향. 커서 모드에서는 반드시 ASC 여야 MoreThan 이 올바르게 동작한다.
  @IsString()
  @IsOptional()
  order__createdAt?: 'ASC' | 'DESC';

  // 한 번에 가져올 항목 수. 기본 20, 최대 100 권장.
  @IsNumber()
  @IsOptional()
  take: number = 20;
}
