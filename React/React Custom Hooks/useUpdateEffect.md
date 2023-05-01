## useUpdataEffect

- useEffect hook이 처음에는 실행되지 않고

- dep의 변경사항이 생겼을 때 실행되도록 하는 hook

```js
// useUpdateEffect.js
import { useEffect, useRef } from 'react';

export default function useUpdateEffect(callback, dependencies) {
  const firstRenderRef = useRef(true);

  useEffect(() => {
    // 처음 mount 될 때는 true 이므로 아래 조건문이 실행되어 그냥 return 되고
    // callback 함수가 실행되지 않는다
    if (firstRenderRef.current) {
      firstRenderRef.current = false;
      return;
    }
    return callback();
  }, dependencies);
}
```

### Usage

```js
import { useState } from 'react';
import useUpdateEffect from './useUpdateEffect';

export default function UpdateEffectComponent() {
  const [count, setCount] = useState(10);
  useUpdateEffect(() => alert(count), [count]);

  return (
    <div>
      <div>{count}</div>
      <button onClick={() => setCount((c) => c + 1)}>Increment</button>
    </div>
  );
}
```
