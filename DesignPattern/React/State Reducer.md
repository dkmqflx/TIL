## State Reducer Pattern

- State reducer pattern는 사용자에게 컴포넌트 내부의 동작 방식을 변경할 수 있는 발전된 방법을 제공한다.

- 또한, Custom Hook Pattern과 비슷해 보이지만 사용자가 Hook을 통해 전달된 reducer를 정의한다는 차이가 있으며

- reducer는 컴포넌트 내부의 모든 동작을 오버로드한다.

- 즉, 외부에서 reducer를 전달하는 방법이다

```js
// Usage.js

function Usage() {
  // 사용자가 정의한 reducer
  const reducer = (state, action) => {
    switch (action.type) {
      case 'decrement':
        return {
          count: Math.max(0, state.count - 2), //The decrement delta was changed for 2 (Default is 1)
        };
      default:
        return useCounter.reducer(state, action);
    }
  };

  const { count, handleDecrement, handleIncrement } = useCounter(
    { initial: 0, max: 10 },
    reducer // 정의한 reducer를 전달한다, 전달하지 않으면 default로 정의한 reducer를 사용한다
  );

  return (
    <>
      <Counter value={count}>
        <Counter.Decrement icon={'minus'} onClick={handleDecrement} />
        <Counter.Label>Counter</Counter.Label>
        <Counter.Count />
        <Counter.Increment icon={'plus'} onClick={handleIncrement} />
      </Counter>
      <StyledContainer>
        <button onClick={handleIncrement} disabled={count === MAX_COUNT}>
          Custom increment btn 1
        </button>
      </StyledContainer>
    </>
  );
}
```

- reducer를 전달받는 custom hook은 아래와 같ㅋ

```js
// useCounter.js

import { useReducer } from 'react';

// default reducer
const internalReducer = ({ count }, { type, payload }) => {
  switch (type) {
    case 'increment':
      return {
        count: Math.min(count + 1, payload.max),
      };
    case 'decrement':
      return {
        count: Math.max(0, count - 1),
      };
    default:
      throw new Error(`Unhandled action type: ${type}`);
  }
};

function useCounter({ initial, max }, reducer = internalReducer) {
  const [{ count }, dispatch] = useReducer(reducer, { count: initial });

  const handleIncrement = () => {
    dispatch({ type: 'increment', payload: { max } });
  };

  const handleDecrement = () => {
    dispatch({ type: 'decrement' });
  };

  return {
    count,
    handleIncrement,
    handleDecrement,
  };
}

useCounter.reducer = internalReducer; // 기본적으로는 default Reducer를 사용한다
useCounter.types = {
  increment: 'increment',
  decrement: 'decrement',
};

export { useCounter };
```

### 장점

- 더 많은 제어권 부여

  - 복잡도가 높은 경우에도 state reducers를 사용하는 것은 사용자에게 제어권을 넘겨주는 가장 좋은 방법이다.

  - 또한, 모든 내부 동작은 외부에서 접근할 수 있으며 오버라이드 하는 것 또한 가능하다.

### 단점

- 구현의 복잡성

  - 컴포넌트 개발자와 사용자 모두에게 가장 난이도가 높은 구현 방식이다.

- 가시성 부족

  - reducer의 동작이 변경될 수 있기 때문에, 컴포넌트 내부 로직에 대한 이해가 필요하다.

---

## Reference

- [05. 리액트 디자인 패턴 (State reducer pattern)](https://cocobi.tistory.com/166)
- [advanced-react-patterns/src/patterns/state-reducer/](https://github.com/alexis-regnaud/advanced-react-patterns/tree/main/src/patterns/state-reducer)
