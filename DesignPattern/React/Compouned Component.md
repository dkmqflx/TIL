## Compound Component Pattern

- 컴파운드 컴포넌트는 컴포넌트를 만드는 패턴 중 하나로,
- 이 패턴을 사용하면 불필요한?프롭 드릴링(prop drilling)?없이?**표현적(expressive)이고 선언적인(declarative) 컴포넌트**
  를 만들 수 있다.
- 그리고 자식 컴포넌트가 느슨하게 결합되어 있기 때문에 형제 컴포넌트에 영향을 주지 않는다

### 사용예제

- 우선 아래처럼 메인이 되는 Counter 컴포넌트를 정의해주고, 해당 컴포넌트 안에서 사용할 수 있는 서브 컴포넌트인 Count, Label등을 import 해준다
- 그리고 Counter Provider로 감싸주고 외부에서 서브 컴포넌트를 불러와서 사용할 수 있도록 `Counter.Count = Count` 와 같이 정의해준다

```jsx
// Counter

import { Count, Label, Decrement, Increment } from './components';

function Counter({ children, onChange, initialValue = 0 }) {
  const [count, setCount] = useState(initialValue);

  const firstMounded = useRef(true);
  useEffect(() => {
    if (!firstMounded.current) {
      onChange && onChange(count);
    }
    firstMounded.current = false;
  }, [count, onChange]);

  const handleIncrement = () => {
    setCount(count + 1);
  };

  const handleDecrement = () => {
    setCount(Math.max(0, count - 1));
  };

  // Counter에서 Provider를 통해서
  return (
    <CounterProvider value={{ count, handleIncrement, handleDecrement }}>
      <StyledCounter>{children}</StyledCounter>
    </CounterProvider>
  );
}

// 외부에서 컴포넌트에 접근할 수 있도록
Counter.Count = Count;
Counter.Label = Label;
Counter.Increment = Increment;
Counter.Decrement = Decrement;
```

- ㅇ이렇게 하면 아래처럼 Counter 내부에 있는 서브 컴포넌트들을 가져와서 사용할 수 있고

```jsx
import React from 'react';
import { Counter } from './Counter';

function Usage() {
  const handleChangeCounter = (count) => {
    console.log('count', count);
  };

  return (
    <Counter onChange={handleChangeCounter}>
      <Counter.Decrement icon='minus' />
      <Counter.Label>Counter</Counter.Label>
      <Counter.Count max={10} />
      <Counter.Increment icon='plus' />
    </Counter>
  );
}

export { Usage };
```

- 위에서 Counter를 Provider로 감싸주었기 때문에 useContext를 사용해서 필요한 value를 가져와서 사용할 수 있다.

```jsx
import React from 'react';
import styled from 'styled-components';
import { useCounterContext } from '../useCounterContext';

function Count({ max }) {
  const { count } = useCounterContext(); // context hook을 사용해서

  const hasError = max ? count >= max : false;

  return <StyledCount hasError={hasError}>{count}</StyledCount>;
}

const StyledCount = styled.div`
  background-color: ${({ hasError }) => (hasError ? '#bd2130' : '#17a2b8')};
  color: white;
  padding: 5px 7px;
`;

export { Count };
```

---

### 장점

- **API?복잡성 감소**
  - 하나의 부모 컴포넌트에 모든 props를 집어넣고 하위 UI 컴포넌트로 향해 내려가는 대신
  - 각 prop는 가장 적합한 SubComponent 연결되어 있다

```jsx
// Bad
return (
  <Counter
    label='label'
    max={10}
    iconDecrement='minus'
    iconIncrement='plus'
    onChange={handleChangeCounter}
  />
);

// Good
return (
  <Counter onChange={handleChangeCounter}>
    <Counter.Decrement icon={'minus'} />
    <Counter.Label>Counter</Counter.Label>
    <Counter.Count max={10} />
    <Counter.Increment icon={'plus'} />
  </Counter>
);
```

- **유연한 마크업 구조**
  - 컴포넌트의 UI가 뛰어난 유연성을 가지고 있고, 하나의 컴포넌트로부터 다양한 케이스를 생성할 수 있다.
  - 예를 들어, 사용자는 SubComponent의 순서를 변경하거나 이 중에서 무엇을 표시할지 정할 수 있다.

```jsx
// Before
return (
  <Counter onChange={handleChangeCounter}>
    <Counter.Decrement icon={'minus'} />
    <Counter.Label>Counter</Counter.Label>
    <Counter.Count max={10} />
    <Counter.Increment icon={'plus'} />
  </Counter>
);

// After, Count와 Label 순서 변경
return (
  <Counter onChange={handleChangeCounter}>
    <Counter.Decrement icon={'minus'} />
    <Counter.Count max={10} />
    <Counter.Label>Counter</Counter.Label>
    <Counter.Increment icon={'plus'} />
  </Counter>
);
```

- **관심사의 분리**
  - 대부분의 로직은 기본?Counter?컴포넌트에 포함되며,?React.Context는 모든 자식 컴포넌트의?states와?handlers를 공유하는 데 사용된다. 따라서 책임 소재를 명확히 분리할 수 있다.
  - 즉, Counter에서 Provider로 감싸주고 value로 비즈니스 로직을 작성해서 전달해주고, 서브 컴포넌트에서는 해당 값들을 사용한다

```jsx
import { Count, Label, Decrement, Increment } from './components';
// Counter

function Counter({ children, onChange, initialValue = 0 }) {
  const [count, setCount] = useState(initialValue);

  const firstMounded = useRef(true);
  useEffect(() => {
    if (!firstMounded.current) {
      onChange && onChange(count);
    }
    firstMounded.current = false;
  }, [count, onChange]);

  const handleIncrement = () => {
    setCount(count + 1);
  };

  const handleDecrement = () => {
    setCount(Math.max(0, count - 1));
  };

  // Counter에서 Provider를 통해서
  return (
    <CounterProvider value={{ count, handleIncrement, handleDecrement }}>
      <StyledCounter>{children}</StyledCounter>
    </CounterProvider>
  );
}

// 외부에서 컴포넌트에 접근할 수 있도록
Counter.Count = Count;
Counter.Label = Label;
Counter.Increment = Increment;
Counter.Decrement = Decrement;
```

---

### 단점

- **과도한 UI 유연성**
  - 유연성이 높다는 것은 예기치 않은 동작을 유발할 가능성이 크다는 것을 의미한다.
  - 예를 들어, 불필요한 자식 컴포넌트가?존재하거나, 필요한 자식 컴포넌트가 없을 수도 있고,?자식 컴포넌트의 순서가 잘못되어 있을 수 있다.
  - 또한, 개발자는 사용자가 컴포넌트를 어떻게 사용하기를 원하는지에 따라, 유연성에 어느 정도 제한을 두고 싶을수도 있다.

---

## Reference

- [리액트 디자인?패턴 (Compound Components Pattern)](https://cocobi.tistory.com/120)
- [리액트 디자인패턴?: Compound Components (컴파운드 컴포넌트 패턴)](https://itchallenger.tistory.com/266)
- [리액트 디자인 패턴 : 컴파운드 컴포넌트 패턴 [Compound Component Pattern] 2](https://itchallenger.tistory.com/710)
- [alexis-regnaud/**advanced-react-patterns**](https://github.com/alexis-regnaud/advanced-react-patterns/tree/main/src)
