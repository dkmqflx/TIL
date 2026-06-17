import {
  Injectable,
  CanActivate,
  ExecutionContext,
  SetMetadata,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    // @Roles() 데코레이터가 핸들러 또는 클래스에 설정한 역할 목록을 읽음
    const requiredRoles = this.reflector.getAllAndOverride<RoleEnum[]>(
      ROLES_KEY,
      [context.getHandler(), context.getClass()],
    );

    // @Roles() 데코레이터가 없으면 역할 제한 없음 → 통과
    if (!requiredRoles || requiredRoles.length === 0) {
      return true;
    }

    const { user } = context.switchToHttp().getRequest();

    // user가 없거나 필요한 역할을 갖지 않으면 거부
    if (!user) return false;

    return requiredRoles.includes(user.role);
  }
}

// ── 함께 사용하는 데코레이터 (같은 파일 또는 roles.decorator.ts로 분리 가능) ──

export const ROLES_KEY = 'roles';

export enum RoleEnum {
  USER = 'USER',
  ADMIN = 'ADMIN',
}

/** @Roles(RoleEnum.ADMIN) — 해당 라우트에 접근 가능한 역할을 지정 */
export const Roles = (...roles: RoleEnum[]) => SetMetadata(ROLES_KEY, roles);

/** @IsPublic() — 전역 AuthGuard를 건너뛰고 공개 라우트로 표시 */
export const IS_PUBLIC_KEY = 'isPublic';
export const IsPublic = () => SetMetadata(IS_PUBLIC_KEY, true);
