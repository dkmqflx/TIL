## usePrevious

- 이전 state 값을 저장하고 싶을 때 사용하는 hook

```js
// usePrevious.js
import { useRef } from 'react';

export default function usePrevious(value) {
  const currentRef = useRef(value); // currentRef는 제일 처음 전달한 값이 된다
  const previousRef = useRef();

  // value가 update되어 새로운 value가 전달된 상황
  if (currentRef.current !== value) {
    previousRef.current = currentRef.current; // 이전 값 <- 현재 값
    currentRef.current = value; // 현재 값 <- 업데이트 된 값
  }

  return previousRef.current;
}
```

### Usage

```js
import { useState } from 'react';
import usePrevious from './usePrevious';

export default function PreviousComponent() {
  const [count, setCount] = useState(0);
  const [name, setName] = useState('Kyle');
  const previousCount = usePrevious(count); // 사용자가 업데이트 한 값이 전달된다

  return (
    <div>
      <div>
        {count} - {previousCount}
      </div>
      <div>{name}</div>
      <button onClick={() => setCount((currentCount) => currentCount + 1)}>
        Increment
      </button>
      <button onClick={() => setName('John')}>Change Name</button>
    </div>
  );
}
```
