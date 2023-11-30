Next.js에서 환경변수를 관리하는 방법으로는 환경별로 각각의 파일을 생성해준 다음 해당 파일 내부에 변수를 선언해주면 된다.

아래와 같은 파일을 생성해줄 수 있으며 순서대로 우선순위를 갖는다

- **`.env`**

  - 모든 환경에서 적용된다

- **`.env.dev`**

  - 개발 환경(process.env.NODE_ENV === 'development') 에서 적용된다.

  - next dev

- **`.env.prod`**

  - 배포/빌드 환경(process.env.NODE_ENV === 'production') 에서 적용된다.

  - next start

- **`.env.test`**

  - 테스트 환경(process.env.NODE_ENV === 'test') 에서 적용된다.

- **`.env.local`**

  - 가장 우선순위가 높다. 다른 파일들에 정의된 값들을 모두 덮어쓴다.

- NEXT_PUBLIC 없이 선언된 변수는 Node.js 환경에서만 사용이 가능하지만 NEXT_PUBLIC이라는 prefix를 붙여주면 브라우저에서도 사용이 가능하다

```tsx
// .env.local

// 서버에서만 사용가능한 환경변수
DB_HOST = localhost;

// 브라우저에서도 사용가능한 환경변수
NEXT_PUBLIC_ANALYTICS_ID = abcdefghijk;

// 'NEXT_PUBLIC_ANALYTICS_ID' can be used here as it's prefixed by 'NEXT_PUBLIC_'.
// It will be transformed at build time to `setupAnalyticsService('abcdefghijk')`.
setupAnalyticsService(process.env.NEXT_PUBLIC_ANALYTICS_ID);
```

- 그리고 아래처럼 NEXT_PUBLIC prefix가 있는 환경변수와 없는 환경변수가 있다면 next build시 환경에 따라 다른 환경 변수를 사용하게 된다

```tsx
ENV_LOCAL_VARIABLE = "server_only_variable_from_env_local";

NEXT_PUBLIC_ENV_LOCAL_VARIABLE = "public_variable_from_env_local";
```

---

## Reference

- [Environment Variables](https://nextjs.org/docs/pages/building-your-application/configuring/environment-variables#default-environment-variables)
