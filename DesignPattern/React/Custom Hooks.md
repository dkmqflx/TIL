## Custom Hook Pattern

- 메인 로직이 커스텀 훅(Hook)으로 전달되고, 훅은 사용자가 접근할 수 있다.

- 또한 훅은 여러 내부 로직(States, Hnadlers)을 포함하여 컴포넌트의 제어가 쉬워지고, 사용자에게 더 많은 통제권을 준다.

### 장점

- 많은 제어권 부여

  - 사용자는 훅과 JSX 컴포넌트 사이에 로직을 추가하여 기본 컴포넌트의 동작을 바꿀 수 있다.

  - 아래 예제코드를 통해서 이를 확인할 수 있다

```js
function Usage() {
  const { count, handleIncrement, handleDecrement } = useCounter(0); // custom hook 사용
  const MAX_COUNT = 10;

  const handleClickIncrement = () => {
    // Put your custom logic
    // 내가 원하는 로직 추가 할 수 있다
    if (count < MAX_COUNT) {
      handleIncrement();
    }
  };

  return (
    <>
      <Counter value={count}>
        <Counter.Decrement
          icon={'minus'}
          onClick={handleDecrement}
          disabled={count === 0}
        />
        <Counter.Label>Counter</Counter.Label>
        <Counter.Count />
        <Counter.Increment
          icon={'plus'}
          onClick={handleClickIncrement}
          disabled={count === MAX_COUNT}
        />
      </Counter>
      <StyledContainer>
        <button onClick={handleClickIncrement} disabled={count === MAX_COUNT}>
          Custom increment btn 1
        </button>
      </StyledContainer>
    </>
  );
}
```

### 단점

- 구현의 복잡성

  - 로직과 렌더링 하는 부분이 분리 되어 있기 때문에, 사용자는 로직과 랜더링 부분을 연결해 주어야 한다.

  - 따라서, 컴포넌트를 올바르게 구현하기 위해 컴포넌트의 동작 방식에 대한 깊은 이해가 필요하다.

---

## Reference

- [어떤 React 디자인 패턴이 적절한 것일까 ?](https://youngmin.hashnode.dev/react)
- [예제코드](https://github.com/alexis-regnaud/advanced-react-patterns/blob/main/src/patterns/custom-hooks/Usage.js)
