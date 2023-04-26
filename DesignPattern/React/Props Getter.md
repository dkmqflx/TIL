## Props Getter Pattern

- �θ� ������Ʈ�� �ڽ� ������Ʈ���� �����ϴ� Props�� Getter Function���� �����ϴ� ��������

- �θ��� Props�� Getter�� ���� �����´�.

- ��, native props�� �����ϴ� ��� props getter�� ����� �����Ѵ�.

- Getter Function�� props�� ��ȯ�ϴ� �Լ��̸�, ����ڰ� ���� JSX ��ҿ� ������ �� �ֵ��� �ǹ� �ִ� �̸��� ����ؾ� �Ѵ�.

- �Ʒ� �ڵ带 ���ؼ� Ȯ���� �� �ִµ�, useCounter Hook�� getCounterProps�� Counter ������Ʈ�� Props�� �����ϴµ� ���Ǵ� �Լ��̴�.

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

- �Ʒ�ó�� Spread �����ڿ� �Բ� ����� �� �ִ�.

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

- Counter ������Ʈ�� Props�� ������ ����

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

- �θ� ������Ʈ�� �ڽ� ������Ʈ�� �����ϰ� ������ �� �ִ� ������ �����̴�.

### ����

- ����� ������

  - ������Ʈ�� ����ϴ� ���� ����� �����ϸ�, ������ �κ��� ������ �ִ�.

  - ����ڴ� �ùٸ� getter�� �׿� �´� JSX ��ҿ� �����ϱ⸸ �ϸ� �ȴ�.

- ������

  - ����ڴ� �ʿ��� ��� getter�� ���Ե� props�� �������� �� �ִ�.

### ����

- ���ü��� ����

  - getters�� ���� �߻�ȭ�� ������Ʈ�� ����ϱ� ���� ����������� ���ΰ� ������ �ʰ� �Ǿ�, �ᱹ �� �������ϰ� ������ش�.

  - ������Ʈ�� �������̵� �ϱ� ���ؼ� ����ڴ� getters�� ���� ������ prop ����Ʈ�� �� �� �ϳ��� ����� �� ���� ������ ��ġ�� ������ �˾ƾ߸� �Ѵ�.

---

## Reference

- [04. ����Ʈ ������ ���� (Props Getters Pattern)](https://cocobi.tistory.com/165?category=949444)
- [advanced-react-patterns/src/patterns/props-getters/](https://github.com/alexis-regnaud/advanced-react-patterns/tree/main/src/patterns/props-getters)
- [Props Getter Pattern](https://simsimjae.medium.com/react-design-pattern-props-getter-pattern-5d3cf6f0b495)
