## useDeepCompareEffect

- 객체를 사용할 때, 각체가 변경되는 경우 deep compare를 통해서 값을 update 할지 결정하는 Hook

```js
import { useEffect, useRef } from 'react';
import isEqual from 'lodash/fp/isEqual'; // loadash 라이브러리 사용

export default function useDeepCompareEffect(callback, dependencies) {
  const currentDependenciesRef = useRef();

  // dep변경되더라도 currentDependenciesRef에 저장된 현재 값과 비교하고, 같지 않은 경우 아래 실행
  if (!isEqual(currentDependenciesRef.current, dependencies)) {
    currentDependenciesRef.current = dependencies; // 현재 값으로 변경된 값을 저장한다
  }

  // 현재 값 같으면 실행되지 않는다
  useEffect(callback, [currentDependenciesRef.current]);
}
```

### Usage

```js
import { useEffect, useState, useRef } from 'react';
import useDeepCompareEffect from './useDeepCompareEffect';

export default function DeepCompareEffectComponent() {
  const [age, setAge] = useState(0);
  const [otherCount, setOtherCount] = useState(0);
  const useEffectCountRef = useRef();
  const useDeepCompareEffectCountRef = useRef();

  const person = { age: age, name: 'Kyle' }; // state가 변경될 때 마다 재정의 된다

  useEffect(() => {
    // hook은 Increment Age를 클릭할 때
    // Increment Other Count 버튼을 클릭할 때
    // 모두 useEffectCountRef 값이 변경된다
    useEffectCountRef.current.textContent =
      parseInt(useEffectCountRef.current.textContent) + 1;
  }, [person]);

  useDeepCompareEffect(() => {
    // hook은 Increment Age를 클릭할 때
    // useDeepCompareEffectCountRef 값이 변경되지만
    // Increment Other Count 버튼을 클릭할 때는
    // useDeepCompareEffectCountRef 값이 변경되지 않는다

    useDeepCompareEffectCountRef.current.textContent =
      parseInt(useDeepCompareEffectCountRef.current.textContent) + 1;
  }, [person]);

  return (
    <div>
      <div>
        useEffect: <span ref={useEffectCountRef}>0</span>
      </div>
      <div>
        useDeepCompareEffect: <span ref={useDeepCompareEffectCountRef}>0</span>
      </div>
      <div>Other Count: {otherCount}</div>
      <div>{JSON.stringify(person)}</div>
      <button onClick={() => setAge((currentAge) => currentAge + 1)}>
        Increment Age
      </button>
      <button onClick={() => setOtherCount((count) => count + 1)}>
        Increment Other Count
      </button>
    </div>
  );
}
```
