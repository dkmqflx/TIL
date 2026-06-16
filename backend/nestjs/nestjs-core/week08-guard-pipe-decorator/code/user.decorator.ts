import { createParamDecorator, ExecutionContext } from '@nestjs/common';

/**
 * UserModel 의 최소 형태를 정의합니다.
 * 실제 프로젝트에서는 users/entity/users.entity.ts 의 UserModel 을 import 합니다.
 */
export interface UserModel {
  id: number;
  email: string;
  nickname: string;
  role: string;
}

/**
 * @User() — request.user 전체를 주입합니다.
 * @User('email') — request.user.email 만 주입합니다.
 *
 * Guard(BearerTokenGuard / AccessTokenGuard)가 request.user 를 세팅한 뒤에
 * 이 데코레이터가 값을 꺼냅니다. Guard 없이 사용하면 undefined 가 반환됩니다.
 */
export const User = createParamDecorator(
  (data: keyof UserModel | undefined, ctx: ExecutionContext) => {
    const req = ctx.switchToHttp().getRequest<{ user?: UserModel }>();
    const user = req.user;

    return data ? user?.[data] : user;
  },
);
