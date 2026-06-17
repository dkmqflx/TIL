import { Repository, FindManyOptions, MoreThan } from 'typeorm';
import { BasePaginationDto } from './base-pagination.dto';

// DTO 접두사 파싱: "where__id__more_than" → { id: MoreThan(value) }
//                  "order__createdAt"    → order: { createdAt: 'ASC' }
function composeFindOptions<T>(dto: BasePaginationDto): FindManyOptions<T> {
  const where: Record<string, unknown> = {};
  const order: Record<string, string> = {};

  for (const [key, value] of Object.entries(dto)) {
    if (value === undefined || value === null) continue;

    if (key.startsWith('where__')) {
      // e.g. "where__id__more_than" → field="id", op="more_than"
      const [, field, op] = key.split('__');
      if (op === 'more_than') {
        where[field] = MoreThan(value as number);
      } else {
        where[field] = value;
      }
    } else if (key.startsWith('order__')) {
      // e.g. "order__createdAt" → { createdAt: value ?? 'ASC' }
      const [, field] = key.split('__');
      order[field] = (value as string) ?? 'ASC';
    }
  }

  return { where: where as FindManyOptions<T>['where'], order: order as FindManyOptions<T>['order'] };
}

export async function paginate<T>(
  dto: BasePaginationDto,
  repository: Repository<T>,
  overrideFindOptions: FindManyOptions<T> = {},
) {
  const baseOptions = composeFindOptions<T>(dto);

  // 페이지 모드: page 파라미터가 있으면 offset(skip) 방식
  if (dto.page !== undefined) {
    const take = dto.take ?? 20;
    const skip = (dto.page - 1) * take;

    const findOptions: FindManyOptions<T> = {
      ...baseOptions,
      ...overrideFindOptions,
      skip,
      take,
    };

    const [items, total] = await repository.findAndCount(findOptions);

    return {
      data: items,
      meta: {
        total,
        page: dto.page,
        take,
        totalPages: Math.ceil(total / take),
      },
    };
  }

  // 커서 모드: take+1 개를 조회해 hasMore 판정, id ASC 필수
  const take = dto.take ?? 20;
  const findOptions: FindManyOptions<T> = {
    ...baseOptions,
    ...overrideFindOptions,
    take: take + 1, // 한 개 더 조회해 다음 페이지 존재 여부 확인
  };

  const results = await repository.find(findOptions);
  const hasMore = results.length > take;
  const items = hasMore ? results.slice(0, take) : results;

  // 슬라이스된 마지막 항목의 id 를 다음 커서로 사용
  const lastItem = items[items.length - 1] as (T & { id: number }) | undefined;

  return {
    data: items,
    meta: {
      cursor: { after: lastItem?.id ?? null },
      hasMore,
    },
  };
}
