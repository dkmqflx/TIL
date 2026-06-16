import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';

// 실제 프로젝트에서는 ConfigService로 환경변수에서 읽는다
const JWT_SECRET = 'your-jwt-secret';
const ROUNDS = 10; // bcrypt cost factor

@Injectable()
export class AuthService {
  constructor(
    // 실제 프로젝트에서는 @InjectRepository(User) + UsersRepository를 주입
    // 여기서는 의존성을 인터페이스 수준으로 표현
    private readonly jwtService: JwtService,
  ) {}

  /**
   * 회원가입: 비밀번호를 bcrypt로 해싱 후 저장하고 토큰을 즉시 발급한다.
   * 평문 비밀번호는 절대 DB에 저장하지 않는다.
   */
  async registerWithEmail(user: {
    email: string;
    nickname: string;
    password: string;
  }) {
    // 1. 비밀번호 해싱 (bcrypt가 무작위 salt를 생성하고 해시 안에 내장)
    const hashedPassword = await bcrypt.hash(user.password, ROUNDS);

    // 2. 해시된 비밀번호로 유저 생성 (usersRepository.save 위치)
    // const newUser = await this.usersRepository.save({
    //   email: user.email,
    //   nickname: user.nickname,
    //   password: hashedPassword,
    // });

    // 회원가입 성공 시 즉시 토큰 발급 (로그인 처리)
    const newUser = { id: 1, email: user.email, password: hashedPassword };
    return this.loginWithEmail(newUser);
  }

  /**
   * 이메일/비밀번호로 유저를 검증한다.
   * 이메일 조회 → bcrypt.compare 순서로 실행한다.
   */
  async authenticateWithEmailAndPassword(user: {
    email: string;
    password: string;
  }) {
    // 1. 이메일로 유저 조회 (usersRepository.findOne 위치)
    // const existingUser = await this.usersRepository.findOne({
    //   where: { email: user.email },
    // });
    const existingUser: { id: number; email: string; password: string } | null =
      null; // 실제 구현에서는 위 주석 해제

    if (!existingUser) {
      throw new UnauthorizedException('존재하지 않는 사용자입니다');
    }

    // 2. 입력 비밀번호 vs 저장된 해시 비교
    // bcrypt.compare가 해시에서 salt를 추출해 재해싱 후 비교한다
    const isMatch = await bcrypt.compare(user.password, existingUser.password);

    if (!isMatch) {
      throw new UnauthorizedException('비밀번호가 올바르지 않습니다');
    }

    return existingUser;
  }

  /**
   * 유저 정보로 Access Token + Refresh Token을 함께 발급한다.
   */
  async loginWithEmail(user: { email: string; id: number }) {
    return {
      accessToken: this.signToken(user, false),
      refreshToken: this.signToken(user, true),
    };
  }

  /**
   * JWT 토큰 서명.
   * payload에는 sub, email, type만 포함 — 비밀번호는 절대 포함하지 않는다.
   */
  signToken(user: { email: string; id: number }, isRefresh: boolean): string {
    const payload = {
      sub: user.id,      // 유저 식별자 (subject)
      email: user.email,
      type: isRefresh ? 'refresh' : 'access',
      // ⚠️ 비밀번호(평문·해시 모두) payload에 포함 금지
    };

    return this.jwtService.sign(payload, {
      secret: JWT_SECRET,
      expiresIn: isRefresh ? '7d' : '1h',
    });
  }

  /**
   * Authorization 헤더에서 토큰을 추출한다.
   * isBearer=true  → "Bearer <token>"
   * isBearer=false → "Basic <base64>"
   */
  extractTokenFromHeader(header: string, isBearer: boolean): string {
    const [type, token] = header.split(' ');
    const expectedType = isBearer ? 'Bearer' : 'Basic';

    if (type !== expectedType || !token) {
      throw new UnauthorizedException('잘못된 Authorization 헤더 형식입니다');
    }

    return token;
  }

  /**
   * JWT 서명 검증 + 만료 확인.
   * verify 성공 시 payload 반환, 실패 시 UnauthorizedException.
   */
  verifyToken(token: string) {
    try {
      return this.jwtService.verify(token, { secret: JWT_SECRET });
    } catch {
      throw new UnauthorizedException('토큰이 유효하지 않거나 만료되었습니다');
    }
  }

  /**
   * Refresh Token으로 새 Access Token을 발급한다.
   * payload.type이 'refresh'인지 반드시 확인한다.
   */
  async rotateAccessToken(refreshToken: string): Promise<{ accessToken: string }> {
    // 1. 서명 검증 + 만료 확인
    const payload = this.verifyToken(refreshToken);

    // 2. Refresh Token 타입 확인 (핵심 보안 체크)
    if (payload.type !== 'refresh') {
      throw new UnauthorizedException('Refresh Token으로만 재발급이 가능합니다');
    }

    // 3. 새 Access Token 발급
    const newAccessToken = this.signToken(
      { id: payload.sub, email: payload.email },
      false,
    );

    return { accessToken: newAccessToken };
  }
}
