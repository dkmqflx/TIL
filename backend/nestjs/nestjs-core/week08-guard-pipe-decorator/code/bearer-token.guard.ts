import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';

/**
 * BearerTokenGuard
 *
 * Authorization: Bearer <jwt> 헤더를 파싱하고 토큰을 검증합니다.
 * 검증 성공 시 request.user 와 request.token 을 세팅하고 true 를 반환합니다.
 *
 * 실제 프로젝트에서는 AuthService 또는 JwtService 를 생성자에서 주입받아
 * 토큰 서명을 검증합니다. 아래 주석이 그 자리입니다.
 */
@Injectable()
export class BearerTokenGuard implements CanActivate {
  // constructor(private readonly authService: AuthService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const req = context.switchToHttp().getRequest<{
      headers: Record<string, string | undefined>;
      user?: unknown;
      token?: string;
    }>();

    const rawHeader = req.headers['authorization'];

    if (!rawHeader) {
      throw new UnauthorizedException('Authorization 헤더가 없습니다');
    }

    const [type, token] = rawHeader.split(' ');

    if (type !== 'Bearer' || !token) {
      throw new UnauthorizedException('올바르지 않은 Bearer 토큰 형식입니다');
    }

    // 실제 구현: authService.verifyToken(token) 으로 payload 를 반환받고
    // req.user 에 사용자 정보를 세팅합니다.
    // 예시:
    //   const payload = await this.authService.verifyToken(token);
    //   const user = await this.usersService.getUserByEmail(payload.email);
    //   req.user = user;
    //   req.token = token;

    req.token = token;

    return true;
  }
}
