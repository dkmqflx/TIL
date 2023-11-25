
- 아래 이미지를 통해서 useEffect와 useLayoutEffect의 실행 시점의 차이를 알 수 있다.

<img src='https://raw.githubusercontent.com/donavon/hook-flow/master/hook-flow.png'>

## useEffect

- useEffect 는 컴포넌트들이 render 와 paint 된 후 실행된다

- 즉, **렌더(render) -> 페인트(paint) -> `useEffect`** 순으로 실행된다.

- paint 된 후 실행되기 때문에, useEffect 내부에 dom 에 영향을 주는 코드가 있을 경우 사용자 입장에서는 화면이 깜빡이는 현상을 볼 수 있다

- 공식문서에서도 브라우저에 paint 되기 전에 특정한 작업을 수행하고 싶은 경우에 useLayoutEffect를 사용하라고 되어 있다.

> If your Effect wasn’t caused by an interaction (like a click), React will generally let the browser **paint the updated screen first before running your Effect.** If your Effect is doing something visual (for example, positioning a tooltip), and the delay is noticeable (for example, it flickers), replace `useEffect` with `useLayoutEffect`

하지만 아래처럼 대부분의 경우에는 useEffect를 사용할 것을 주의하고 있다

### **[My Effect does something visual, and I see a flicker before it runs](https://react.dev/reference/react/useEffect#my-effect-does-something-visual-and-i-see-a-flicker-before-it-runs)**

> If your Effect must block the browser from [painting the screen,](https://react.dev/learn/render-and-commit#epilogue-browser-paint) replace `useEffect` with `useLayoutEffect`. Note that **this shouldn’t be needed for the vast majority of Effects.** You’ll only need this if it’s crucial to run your Effect before the browser paint: for example, to measure and position a tooltip before the user sees it.

<br/>

## useLayoutEffect

- `useLayoutEffect` is a version of `useEffect` that fires before the browser repaints the screen.

- 다른점은, 브라우저가 화면을 DOM에 그리기(paint) 전에 `useLayoutEffect`를 실행하기 때문에 useEffect를 사용할 때의 깜빡거림 현상이 나타나지 않는다.

- 즉, **렌더(render) -> `useLayoutEffect` -> 페인트(paint)** 순으로 실행된다

```tsx
useEffect(() => {
  console.log("log 1");
}, []);

useLayoutEffect(() => {
  console.log("log 2");
}, []);

// log 2
// log 1
```

## useIsomorphicLayoutEffect

- Client-side에서는 useLayoutEffect 방식을 쓰고, Server-side에서는 useEffect 방식을 쓰도록 하는 hook.

- Server-side에서는 useLayoutEffect 함수를 사용하면 다음과 같은 warning 오류가 발생하기 때문에 사용하는 함수이다

  - `Warning: useLayoutEffect does nothing on the server, because its effect cannot be encoded into the server r`

- 즉, 서버 사이드에서 useLayoutEffect를 실행하면 에러가 나는 경우에 useIsomorphicLayoutEffect를 사용해서 useEffect가 사용되도록 해서 에러를 해결할 수 있다

- Next.js와 같은 서버 렌더링을 사용하는 경우, 자바스크립트가 모두 다운로드 될 때까지 useEffect와 useLayoutEffect 그 어느 것도 실행되지 않는데 useEffect는 컴포넌트의 렌더 주기와 관련이 없지만, useLayoutEffect는 관련이 있고 컴포넌트가 맨 처음 렌더링될 때 사용자가 보게 될 것과 연관이 있기 때문이다.

- 즉, useLayoutEffect를 사용할 때만 이러한 에러가 나타나는 이유는 useEffect가 paint 단계 이후에 실행되는 것과 달리 useLayoutEffect는 paint 이전에 실행되기 때문이다

- 아래는 toss slash의 **[useIsomorphicLayoutEffect](https://github.com/toss/slash/blob/main/packages/react/react/src/hooks/useIsomorphicLayoutEffect.ts)** hook 코드이다

```tsx
import { isClient } from "@toss/utils";
import { useEffect, useLayoutEffect } from "react";

/** 
@tossdocs-ignore
@see https://github.com/toss/slash/blob/main/packages/react/react/src/hooks/useIsomorphicLayoutEffect.ts
*/
export const useIsomorphicLayoutEffect = isClient()
  ? useLayoutEffect
  : useEffect;
```

```tsx
// isClient

/** 
@tossdocs-ignore 
@see https://github.com/toss/slash/blob/main/packages/common/utils/src/device/isClient.ts
*/
import { isServer } from "./isServer";

export function isClient() {
  return !isServer();
}
```

```tsx
// isServer
/** 
@tossdocs-ignore 
@see https://github.com/toss/slash/blob/main/packages/common/utils/src/device/isServer.ts
*/
declare const global: unknown;

export function isServer() {
  return typeof window === "undefined" && typeof global !== "undefined";
}
```

---

## Reference

- [useEffect](https://react.dev/reference/react/useEffect)

- [useLayoutEffect](https://react.dev/reference/react/useLayoutEffect)

- [SSR에서는 UseLayoutEffect 대신 useEffect를 사용하자!](https://velog.io/@khy226/SSR%EC%97%90%EC%84%9C%EB%8A%94-UseLayoutEffect-%EB%8C%80%EC%8B%A0-useEffect%EB%A5%BC-%EC%82%AC%EC%9A%A9%ED%95%98%EC%9E%90)

- [why does the useEffect hook even with no dependecies still "run" on the client side even though the page has been pre-rendered by next-js](https://stackoverflow.com/questions/73022162/why-does-the-useeffect-hook-even-with-no-dependecies-still-run-on-the-client-s)

- [useEffect와 useLayoutEffect의 차이](https://www.howdy-mj.me/react/useEffect-and-useLayoutEffect)
