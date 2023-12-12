- JSX에서 css라는 prop를 통해서 스타일을 전달하고 싶은 경우가 있다

- styled components의 타입이 정의되어 있는 파일을 보면 이때 해결할 수 있는 방법이 주석으로 작성되어 있다.

````ts
// node_modules/styled-components/dist/types.d.ts


/**
 * The `css` prop is not declared by default in the types as it would cause `css` to be present
 * on the types of anything that uses styled-components indirectly, even if they do not use the
 * babel plugin.
 *
 * To enable support for the `css` prop in TypeScript, create a `styled-components.d.ts` file in
 * your project source with the following contents:
 *
 * ```ts
 * import type { CSSProp } from "styled-components";
 *
 * declare module "react" {
 *  interface Attributes {
 *    css?: CSSProp;
 *  }
 * }
 *
 * /


````

- 아래처럼 `css.d.ts`파일을 만들고 아래와 같은 코드를 추가해준다.

```ts
// css.d.ts

import { CSSProp } from "styled-components";

declare module "react" {
  interface Attributes {
    css?: CSSProp;
  }
}
```

- React의 타입이 정의되어 있는 파일을 보면 아래처럼 namespace 내부에 Attributes라는 interface가 있기 때문에

- 위와 같이 interface Attributes 내부에 css라는 객체를 추가하면, 기존의 인터페이스가 확장되면서 새로운 객체가 추가된다

```ts
// index.d.ts

declare namespace React {

  ...

  interface Attributes {
    key?: Key | null | undefined;
  }

  ...
}
```

- 그 결과 아래처럼 코드를 작성할 수 있다.

```tsx
  <Box

    css={css`
      @media screen and (min-width: ${PC}px) {
        width: 100%;
        max-width: ${PC}px;
      }
    `}
  >


```
