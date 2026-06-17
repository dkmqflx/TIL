import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable, catchError, tap, throwError } from 'rxjs';
import { DataSource, QueryRunner } from 'typeorm';

@Injectable()
export class TransactionInterceptor implements NestInterceptor {
  constructor(private readonly dataSource: DataSource) {}

  async intercept(
    context: ExecutionContext,
    next: CallHandler,
  ): Promise<Observable<unknown>> {
    const req = context.switchToHttp().getRequest();

    const qr: QueryRunner = this.dataSource.createQueryRunner();

    await qr.connect();
    await qr.startTransaction();

    // 핸들러에서 @QueryRunner() 커스텀 데코레이터로 꺼낼 수 있도록 요청에 주입
    req.queryRunner = qr;

    return next.handle().pipe(
      catchError(async (err) => {
        await qr.rollbackTransaction();
        await qr.release();
        return throwError(() => err);
      }),
      tap(async () => {
        await qr.commitTransaction();
        await qr.release();
      }),
    );
  }
}
