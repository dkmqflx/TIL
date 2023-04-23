## Compound Component Pattern

- ���Ŀ�� ������Ʈ�� ������Ʈ�� ����� ���� �� �ϳ���,
- �� ������ ����ϸ� ���ʿ���?���� �帱��(prop drilling)?����?**ǥ����(expressive)�̰� ��������(declarative) ������Ʈ**
  �� ���� �� �ִ�.
- �׸��� �ڽ� ������Ʈ�� �����ϰ� ���յǾ� �ֱ� ������ ���� ������Ʈ�� ������ ���� �ʴ´�

### ��뿹��

- �켱 �Ʒ�ó�� ������ �Ǵ� Counter ������Ʈ�� �������ְ�, �ش� ������Ʈ �ȿ��� ����� �� �ִ� ���� ������Ʈ�� Count, Label���� import ���ش�
- �׸��� Counter Provider�� �����ְ� �ܺο��� ���� ������Ʈ�� �ҷ��ͼ� ����� �� �ֵ��� `Counter.Count = Count` �� ���� �������ش�

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

  // Counter���� Provider�� ���ؼ�
  return (
    <CounterProvider value={{ count, handleIncrement, handleDecrement }}>
      <StyledCounter>{children}</StyledCounter>
    </CounterProvider>
  );
}

// �ܺο��� ������Ʈ�� ������ �� �ֵ���
Counter.Count = Count;
Counter.Label = Label;
Counter.Increment = Increment;
Counter.Decrement = Decrement;
```

- ���̷��� �ϸ� �Ʒ�ó�� Counter ���ο� �ִ� ���� ������Ʈ���� �����ͼ� ����� �� �ְ�

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

- ������ Counter�� Provider�� �����־��� ������ useContext�� ����ؼ� �ʿ��� value�� �����ͼ� ����� �� �ִ�.

```jsx
import React from 'react';
import styled from 'styled-components';
import { useCounterContext } from '../useCounterContext';

function Count({ max }) {
  const { count } = useCounterContext(); // context hook�� ����ؼ�

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

### ����

- **API?���⼺ ����**
  - �ϳ��� �θ� ������Ʈ�� ��� props�� ����ְ� ���� UI ������Ʈ�� ���� �������� ���
  - �� prop�� ���� ������ SubComponent ����Ǿ� �ִ�

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

- **������ ��ũ�� ����**
  - ������Ʈ�� UI�� �پ �������� ������ �ְ�, �ϳ��� ������Ʈ�κ��� �پ��� ���̽��� ������ �� �ִ�.
  - ���� ���, ����ڴ� SubComponent�� ������ �����ϰų� �� �߿��� ������ ǥ������ ���� �� �ִ�.

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

// After, Count�� Label ���� ����
return (
  <Counter onChange={handleChangeCounter}>
    <Counter.Decrement icon={'minus'} />
    <Counter.Count max={10} />
    <Counter.Label>Counter</Counter.Label>
    <Counter.Increment icon={'plus'} />
  </Counter>
);
```

- **���ɻ��� �и�**
  - ��κ��� ������ �⺻?Counter?������Ʈ�� ���ԵǸ�,?React.Context�� ��� �ڽ� ������Ʈ��?states��?handlers�� �����ϴ� �� ���ȴ�. ���� å�� ���縦 ��Ȯ�� �и��� �� �ִ�.
  - ��, Counter���� Provider�� �����ְ� value�� ����Ͻ� ������ �ۼ��ؼ� �������ְ�, ���� ������Ʈ������ �ش� ������ ����Ѵ�

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

  // Counter���� Provider�� ���ؼ�
  return (
    <CounterProvider value={{ count, handleIncrement, handleDecrement }}>
      <StyledCounter>{children}</StyledCounter>
    </CounterProvider>
  );
}

// �ܺο��� ������Ʈ�� ������ �� �ֵ���
Counter.Count = Count;
Counter.Label = Label;
Counter.Increment = Increment;
Counter.Decrement = Decrement;
```

---

### ����

- **������ UI ������**
  - �������� ���ٴ� ���� ����ġ ���� ������ ������ ���ɼ��� ũ�ٴ� ���� �ǹ��Ѵ�.
  - ���� ���, ���ʿ��� �ڽ� ������Ʈ��?�����ϰų�, �ʿ��� �ڽ� ������Ʈ�� ���� ���� �ְ�,?�ڽ� ������Ʈ�� ������ �߸��Ǿ� ���� �� �ִ�.
  - ����, �����ڴ� ����ڰ� ������Ʈ�� ��� ����ϱ⸦ ���ϴ����� ����, �������� ��� ���� ������ �ΰ� �������� �ִ�.

---

## Reference

- [����Ʈ ������?���� (Compound Components Pattern)](https://cocobi.tistory.com/120)
- [����Ʈ ����������?: Compound Components (���Ŀ�� ������Ʈ ����)](https://itchallenger.tistory.com/266)
- [����Ʈ ������ ���� : ���Ŀ�� ������Ʈ ���� [Compound Component Pattern] 2](https://itchallenger.tistory.com/710)
- [alexis-regnaud/**advanced-react-patterns**](https://github.com/alexis-regnaud/advanced-react-patterns/tree/main/src)
