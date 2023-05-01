## useRenderCount

- 컴포넌트가 몇번 렌더링되었는지 알 수 있는 hook

```js
import { useEffect, useRef } from 'react';

export default function useRenderCount() {
  const count = useRef(1);

  // 렌더링 될 때 마다 실행된다
  useEffect(() => count.current++);

  // 만약 useEffect 밖에 count.current++ 이런식으로 작성하면
  // 2씩 renderCount가 찍히는데 그 이유는 StrictMode에서 리액트는 double render 하기 때문
  // 하지만 UseEffect hook은 double render 하지 않기 때문에 useEffect hook을 사용한다
  return count.current;
}
```

### Usage

```js
import useRenderCount from './useRenderCount';
import useToggle from './useToggle'; // rendering 횟수 변경시키기 위해 사용하는 hook

export default function RenderCountComponent() {
  const [boolean, toggle] = useToggle(false);

  const renderCount = useRenderCount();

  return (
    <>
      <div>{boolean.toString()}</div>
      <div>{renderCount}</div>
      <button onClick={toggle}>Toggle</button>
    </>
  );
}
```
