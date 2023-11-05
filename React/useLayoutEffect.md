## useLayoutEffect

- [useLayoutEffect](https://ko.reactjs.org/docs/hooks-reference.html#uselayouteffect)는 useEffect와 동일하지만, 렌더링 후 layout과 paint 전에 **동기적**으로 실행된다.

- 때문에 설령 DOM을 조작하는 코드가 존재하더라도, 사용자는 깜빡임을 보지 않는다.

- [React Hook Flow Diagram](https://github.com/donavon/hook-flow)를 통해서 useEffect와 useLayoutEffect의 실행 시점을 확인할 수 있다

> `useLayoutEffect` can hurt performance. Prefer `[useEffect](https://react.dev/reference/react/useEffect)` when possible.

- `useLayoutEffect` is a version of `[useEffect](https://react.dev/reference/react/useEffect)` that fires before the browser repaints the screen.

## useEffect

- [useEffect](https://react.dev/reference/react/useEffect)는 화면 렌더링이 완료된 후 혹은 어떤 값이 변경되었을 때 사이드 이펙트를 수행한다.

  - `useEffect` is a React Hook that lets you [synchronize a component with an external system.](https://react.dev/learn/synchronizing-with-effects)

- useEffect로 전달된 함수는 layout과 paint가 완료된 후에 실행된다.

- 이때 만약 DOM에 영향을 주는 코드가 있을 경우, 사용자는 화면의 깜빡임과 동시에 화면 내용이 달라지는 것을 볼 수 있다. 중요한 정보일 경우, 화면이 다 렌더되기 전에 동기화해주는 것이 좋은데, 이를 위해 useLayoutEffect라는 훅이 나왔으며, 기능은 동일하되 실행 시점만 다르다.

## useIsomorphicLayoutEffect

- 서버 렌더링에서 useLayoutEffect 사용하기

  - Next.js와 같은 서버 렌더링을 사용하는 경우, 자바스크립트가 모두 다운로드 될 때까지 useEffect와 useLayoutEffect 그 어느 것도 실행되지 않는다. 따라서 서버에서 렌더링되는 컴포넌트에서 useLayoutEffect를 사용하는 경우, React에서 경고를 띄운다.

  ```jsx
  Warning: useLayoutEffect does nothing on the server,
  because its effect cannot be encoded into the server renderer's output format.
  This will lead to a mismatch between the initial, non-hydrated UI and the intended UI.
  To avoid this, useLayoutEffect should only be used in components that render exclusively on the client.
  See <https://fb.me/react-uselayouteffect-ssr> for common fixes.
  ```

- useLayoutEffect는 페인트 전에 실행되기 때문에 서버에서 렌더되는 화면과 클라이언트에서 렌더되는 화면이 다를 수 있다. 따라서 useLayoutEffect는 오직 클라이언트 사이드에서만 실행되어야 한다는 경고 메세지다.

- The React documentation says about `useLayoutEffect`:

> The signature is identical to useEffect, but it fires synchronously after all DOM mutations.

- That means this hook is a browser hook. But React code could be generated from the server without the Window API.
- If you're using NextJS, you'll have this error message:

> Warning: useLayoutEffect does nothing on the server, because its effect cannot be encoded into the server renderer's output format. This will lead to a mismatch between the initial, non-hydrated UI and the intended UI.

> To avoid this, useLayoutEffect should only be used in components that render exclusively on the client. See [https://reactjs.org/link/uselayouteffect-ssr](https://reactjs.org/link/uselayouteffect-ssr) for common fixes.

- This hook fixes this problem by switching between `useEffect` and `useLayoutEffect` following the execution environment.

## The Hook

```jsx
import { useEffect, useLayoutEffect } from "react";

const useIsomorphicLayoutEffect =
  typeof window !== "undefined" ? useLayoutEffect : useEffect;

export default useIsomorphicLayoutEffect;
```

## Usage

```jsx
import { useIsomorphicLayoutEffect } from "usehooks-ts";

export default function Component() {
  useIsomorphicLayoutEffect(() => {
    console.log(
      "In the browser, I'm an `useLayoutEffect`, but in SSR, I'm an `useEffect`."
    );
  }, []);

  return <p>Hello, world</p>;
}
```

---

## Reference

- [useEffect와 useLayoutEffect의 차이](https://www.howdy-mj.me/react/useEffect-and-useLayoutEffect)
- [usehooks-ts useIsomorphicLayoutEffect()](https://usehooks-ts.com/react-hook/use-isomorphic-layout-effect)
