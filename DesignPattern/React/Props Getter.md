## Props Getter Pattern

- 부모 컴포넌트가 자식 컴포넌트에게 제공하는 Props를 Getter Function으로 제공하는 패턴으로

- 부모의 Props를 Getter를 통해 가져온다.

- 즉, native props를 노출하는 대신 props getter의 목록을 제공한다.

- Getter Function은 props를 반환하는 함수이며, 사용자가 쉽게 JSX 요소에 연결할 수 있도록 의미 있는 이름을 사용해야 한다.

- 아래 코드를 통해서 확인할 수 있는데, useCounter Hook의 getCounterProps는 Counter 컴포넌트의 Props를 전달하는데 사용되는 함수이다.

```js
// useCounter.js

//props getter for 'Counter'
const getCounterProps = ({ ...otherProps } = {}) => ({
  value: count,
  'aria-valuemax': max,
  'aria-valuemin': 0,
  'aria-valuenow': count,
  ...otherProps,
});
```

- 아래처럼 Spread 연산자와 함께 사용할 수 있다.

```js
// Usage.js
function Usage() {
  const { count, getCounterProps, getIncrementProps, getDecrementProps } =
    useCounter({
      initial: 0,
      max: MAX_COUNT,
    });

  const handleBtn1Clicked = () => {
    console.log('btn 1 clicked');
  };

  return (
    <>
      <Counter {...getCounterProps()}>
        <Counter.Decrement icon={'minus'} {...getDecrementProps()} />
        <Counter.Label>Counter</Counter.Label>
        <Counter.Count />
        <Counter.Increment icon={'plus'} {...getIncrementProps()} />
      </Counter>
      <StyledContainer>
        <button {...getIncrementProps({ onClick: handleBtn1Clicked })}>
          Custom increment btn 1
        </button>
      </StyledContainer>
      <StyledContainer>
        <button {...getIncrementProps({ disabled: count > MAX_COUNT - 2 })}>
          Custom increment btn 2
        </button>
      </StyledContainer>
    </>
  );
}
```

- Counter 컴포넌트의 Props는 다음과 같다

```js
function Counter({ children, value: count, onChange }) {
  const firstMounded = useRef(true);
  useEffect(() => {
    if (!firstMounded.current) {
      onChange && onChange(count);
    }
    firstMounded.current = false;
  }, [count, onChange]);

  return (
    <CounterProvider value={{ count }}>
      <StyledCounter>{children}</StyledCounter>
    </CounterProvider>
  );
}
```

- 부모 컴포넌트와 자식 컴포넌트를 유연하게 연결할 수 있는 디자인 패턴이다.

### 장점

- 사용의 간편함

  - 컴포넌트를 사용하는 쉬운 방법을 제공하며, 복잡한 부분은 가려져 있다.

  - 사용자는 올바른 getter를 그에 맞는 JSX 요소에 연결하기만 하면 된다.

- 유연성

  - 사용자는 필요한 경우 getter에 포함된 props를 재정의할 수 있다.

### 단점

- 가시성의 부족

  - getters를 통한 추상화로 컴포넌트를 사용하기 쉽게 만들어주지만 내부가 보이지 않게 되어, 결국 더 불투명하게 만들어준다.

  - 컴포넌트를 오버라이드 하기 위해서 사용자는 getters에 의해 제공된 prop 리스트와 그 중 하나가 변경될 때 내부 로직의 미치는 영향을 알아야만 한다.

---

## Reference

- [04. 리액트 디자인 패턴 (Props Getters Pattern)](https://cocobi.tistory.com/165?category=949444)
- [advanced-react-patterns/src/patterns/props-getters/](https://github.com/alexis-regnaud/advanced-react-patterns/tree/main/src/patterns/props-getters)
- [Props Getter Pattern](https://simsimjae.medium.com/react-design-pattern-props-getter-pattern-5d3cf6f0b495)
