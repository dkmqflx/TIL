## useStateWithHistory

- 데이터 추가하고 나서 data history를 통해서 데이터에 접근하거나

- undo, redo 등 기능이 필요할 때 사용할 수 있는 Custom hook

```js
import { useCallback, useRef, useState } from 'react';

export default function useStateWithHistory(
  defaultValue,
  { capacity = 10 } = {}
) {
  const [value, setValue] = useState(defaultValue);
  const historyRef = useRef([value]);
  const pointerRef = useRef(0); // pointer 역할을 한다

  const set = useCallback(
    (v) => {
      const resolvedValue = typeof v === 'function' ? v(value) : v;

      // 새로추가된 값이 마지막 pointer가 가리키는 것과 같지 않은 경우
      if (historyRef.current[pointerRef.current] !== resolvedValue) {
        // 현재 포이터 이후에 모든 history 제거 한다
        // ex, 기본 capacity가 10인데, 10개 이상의 데이터가 추가된 경우에는
        // pointer 다음부터 보여줄 수 있도록 history를 잘라준다
        if (pointerRef.current < historyRef.current.length - 1) {
          historyRef.current.splice(pointerRef.current + 1);
        }
        // 새로 추가된 값 history에 추가
        historyRef.current.push(resolvedValue);

        // capacity 이상 추가 된 경우
        // 앞에 있는 값들을 빼준다
        while (historyRef.current.length > capacity) {
          historyRef.current.shift();
        }
        // history의 마지막을 pinter로 가리키도록 한다
        pointerRef.current = historyRef.current.length - 1;
      }
      setValue(resolvedValue);
    },
    [capacity, value]
  );

  // pointer 뒤로 이동하는 함수
  const back = useCallback(() => {
    if (pointerRef.current <= 0) return;
    pointerRef.current--;
    setValue(historyRef.current[pointerRef.current]);
  }, []);

  // pointer 앞으로 이동하는 함수
  const forward = useCallback(() => {
    if (pointerRef.current >= historyRef.current.length - 1) return;
    pointerRef.current++;
    setValue(historyRef.current[pointerRef.current]);
  }, []);

  // 특정한 index로 이동하는 함수
  const go = useCallback((index) => {
    if (index < 0 || index > historyRef.current.length - 1) return;
    pointerRef.current = index;
    setValue(historyRef.current[pointerRef.current]);
  }, []);

  return [
    value,
    set,
    {
      history: historyRef.current,
      pointer: pointerRef.current,
      back,
      forward,
      go,
    },
  ];
}
```

### Usage

```js
import { useState } from 'react';
import useStateWithHistory from './useStateWithHistory';

export default function StateWithHistoryComponent() {
  const [count, setCount, { history, pointer, back, forward, go }] =
    useStateWithHistory(1);
  const [name, setName] = useState('Kyle');

  return (
    <div>
      {/* count는 현재 pointer가 가리키는 값 */}
      <div>{count}</div>
      <div>{history.join(', ')}</div>
      <div>Pointer - {pointer}</div>
      <div>{name}</div>
      <button onClick={() => setCount((currentCount) => currentCount * 2)}>
        Double
      </button>
      <button onClick={() => setCount((currentCount) => currentCount + 1)}>
        Increment
      </button>
      <button onClick={back}>Back</button>
      <button onClick={forward}>Forward</button>
      <button onClick={() => go(2)}>Go To Index 2</button>
      <button onClick={() => setName('John')}>Change Name</button>
    </div>
  );
}
```
