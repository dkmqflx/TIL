## UseTimeout

- setTimeout을 사용하기 위한 hook으로 전달한 delay 이후에 callback 함수가 실행되도록 한다

```js
import { useCallback, useEffect, useRef } from 'react';

export default function useTimeout(callback, delay) {
  const callbackRef = useRef(callback); // callback 함수 등록
  const timeoutRef = useRef();

  // callback 함수가 변경될 때 마다 실행되는 hook
  useEffect(() => {
    callbackRef.current = callback;
  }, [callback]);

  // 아래 함수에서 useCallback으로 감싸준 이유는
  // useTimeout을 사용하는 외부 컴포넌트에서 다시 렌더링 될 때 마다
  // callback 함수도 반복해서 전달되기 때문에, 불필요한 렌더링을 막기 위해서 useCallback을 사용했다.

  // timeout set
  const set = useCallback(() => {
    // delay 후에 실행된다
    timeoutRef.current = setTimeout(() => callbackRef.current(), delay);
  }, [delay]);

  // timeout clear
  // reset 실행하더라도, clear 함수실행해서 timeout을 없애면, reset이 실행되지 않는다
  const clear = useCallback(() => {
    timeoutRef.current && clearTimeout(timeoutRef.current);
  }, []);

  useEffect(() => {
    set();
    // set 함수 실행하면, setTimeout에 등록한 콜백 함수 실행된다
    return clear;
    // unmount시, 등록한 setTimeout clear 해준다.
  }, [delay, set, clear]);

  // 다시 timeout reset 하는 함수
  const reset = useCallback(() => {
    clear(); // timeout clear
    set(); // 다시
  }, [clear, set]);

  return { reset, clear };
}
```

### Usage

```js
import { useState } from 'react';
import useTimeout from './useTimeout';

export default function TimeoutComponent() {
  const [count, setCount] = useState(10);
  const { clear, reset } = useTimeout(() => setCount(0), 1000);

  return (
    <div>
      <div>{count}</div>
      <button onClick={() => setCount((c) => c + 1)}>Increment</button>
      <button onClick={clear}>Clear Timeout</button>
      <button onClick={reset}>Reset Timeout</button>
    </div>
  );
}
```
