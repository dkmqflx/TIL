## State Reducer Pattern

- State reducer pattern�� ����ڿ��� ������Ʈ ������ ���� ����� ������ �� �ִ� ������ ����� �����Ѵ�.

- ����, Custom Hook Pattern�� ����� �������� ����ڰ� Hook�� ���� ���޵� reducer�� �����Ѵٴ� ���̰� ������

- reducer�� ������Ʈ ������ ��� ������ �����ε��Ѵ�.

- ��, �ܺο��� reducer�� �����ϴ� ����̴�

```js
// Usage.js

function Usage() {
  // ����ڰ� ������ reducer
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
    reducer // ������ reducer�� �����Ѵ�, �������� ������ default�� ������ reducer�� ����Ѵ�
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

- reducer�� ���޹޴� custom hook�� �Ʒ��� ����

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

useCounter.reducer = internalReducer; // �⺻�����δ� default Reducer�� ����Ѵ�
useCounter.types = {
  increment: 'increment',
  decrement: 'decrement',
};

export { useCounter };
```

### ����

- �� ���� ����� �ο�

  - ���⵵�� ���� ��쿡�� state reducers�� ����ϴ� ���� ����ڿ��� ������� �Ѱ��ִ� ���� ���� ����̴�.

  - ����, ��� ���� ������ �ܺο��� ������ �� ������ �������̵� �ϴ� �� ���� �����ϴ�.

### ����

- ������ ���⼺

  - ������Ʈ �����ڿ� ����� ��ο��� ���� ���̵��� ���� ���� ����̴�.

- ���ü� ����

  - reducer�� ������ ����� �� �ֱ� ������, ������Ʈ ���� ������ ���� ���ذ� �ʿ��ϴ�.

---

## Reference

- [05. ����Ʈ ������ ���� (State reducer pattern)](https://cocobi.tistory.com/166)
- [advanced-react-patterns/src/patterns/state-reducer/](https://github.com/alexis-regnaud/advanced-react-patterns/tree/main/src/patterns/state-reducer)
