## Control Props Pattern

- Control Props Pattern�� props�� ���� �ܺο��� ������Ʈ�� ���¸� ����(Controlled Component) �� �� �ֵ��� ����� ���

- ���⼭ ������ ������Ʈ��, loal state�θ� ������Ʈ�� ���¸� �����ϱ� ������ �θ� ������Ʈ�� ��� �� �� ���� ������Ʈ�� ���Ѵ�

> It is common to call a component with some local state ��uncontrolled��. For example, the original Panel component with an isActive state variable is uncontrolled because its parent cannot influence whether the panel is active or not.

- �Ʒ� ������ ������(Uncontrolled Component)�� �����̴�

```js
// ������ ������Ʈ(Un-controlled Component)
// props�� ���޵Ǵ� �� ����
const UncontrolledCounter = () => {
  const [_valueState, _setValueState] = useState(0);

  const _onClickUp = function () {
    _setValueState((prev) => (prev ? prev + 1 : 1));
  };

  const _onClickDown = function () {
    _setValueState((prev) => (prev ? prev - 1 : -1));
  };

  return (
    <div>
      <span>{_valueState}</span>
      <button onClick={_onClickUp}>up</button>
      <button onClick={_onClickDown}>down</button>
    </div>
  );
};
```

---

- ���� ������Ʈ��, �θ� ������Ʈ���� props�� ���޹��� �͵��� ���ؼ� ���¸� ������ �� �ִ� ������Ʈ�̴�

> In contrast, you might say a component is ��controlled�� when the important information in it is driven by props rather than its own local state.

- �Ʒ� ������ ����(Controlled Component)��, props�� ���޹��� ���� �Լ��� ���� ���� ���¸� �����Ѵ�

```js
// ���� ������Ʈ(Controlled Component)

const ControlledCounter = ({ value: valueProp, onChange }) => {
  const [_valueState, _setValueState] = useState(value ?? 0);

  const _onClickUp = function () {
    // value prop�� ������, value state�� ���¸� ��Ʈ��.
    if (valueProp === undefined) {
      const nextValue = _valueState + 1;
      _setValueState(nextValue);
      onChange?.(nextValue);
    }
    // value prop�� ������, value prop���� ���¸� ��Ʈ��.
    else {
      onChange?.(valueProp + 1);
    }
  };

  const _onClickDown = function () {
    // value prop�� ������, value state�� ���¸� ��Ʈ��.
    if (valueProp === undefined) {
      const nextValue = _valueState - 1;
      _setValueState(nextValue);
      onChange?.(nextValue);
    }
    // value prop�� ������, value prop���� ���¸� ��Ʈ��.
    else {
      onChange?.(valueProp - 1);
    }
  };

  return (
    <div>
      <span>{valueProp ?? _valueState}</span>
      <button onClick={_onClickUp}>up</button>
      <button onClick={_onClickDown}>down</button>
    </div>
  );
};
```

- ������ ������Ʈ�� ������Ʈ ���� ���¸� ����ϱ� ������ ������Ʈ �ܺο����� ��� ������ �� �� ����

- ������ ���� ������Ʈ�� �����ϸ� ������Ʈ �ܺο����� ������Ʈ�� ���¸� ������ �� �ְ� �ȴ�.

- **�̴� ������� ������Ʈ�� ����ϴ� ��������� �� �� �������� ������� �� �� �ְ�(IOC, Inversion Of Control), ���¸� �Ѱ����� �����ϴ� SSOT(Single Source Of Truth)�� ����������.**

- �Ʒ� ���� �ڵ嵵 ���� �ڵ�ó��, �ܺη� ���޹��� value�� onChange�� ���� ��쿡�� ���ο��� ���� �����ų�� �ֵ��� �Ѵ�

```js
import React, { useState, useRef, useEffect } from 'react';
import styled from 'styled-components';
import { CounterProvider } from './useCounterContext';
import { Count, Label, Decrement, Increment } from './components';

function Counter({ children, value = null, initialValue = 0, onChange }) {
  const [count, setCount] = useState(initialValue);

  const isControlled = value !== null && !!onChange;

  const getCount = () => (isControlled ? value : count);

  const firstMounded = useRef(true);
  useEffect(() => {
    if (!firstMounded.current && !isControlled) {
      onChange && onChange(count);
    }
    firstMounded.current = false;
  }, [count, onChange, isControlled]);

  const handleIncrement = () => {
    handleCountChange(getCount() + 1);
  };

  const handleDecrement = () => {
    handleCountChange(Math.max(0, getCount() - 1));
  };

  const handleCountChange = (newValue) => {
    isControlled ? onChange(newValue) : setCount(newValue);
  };

  return (
    <CounterProvider
      value={{ count: getCount(), handleIncrement, handleDecrement }}
    >
      <StyledCounter>{children}</StyledCounter>
    </CounterProvider>
  );
}

const StyledCounter = styled.div`
  display: inline-flex;
  border: 1px solid #17a2b8;
  line-height: 1.5;
  border-radius: 0.25rem;
  overflow: hidden;
`;

Counter.Count = Count;
Counter.Label = Label;
Counter.Increment = Increment;
Counter.Decrement = Decrement;

export { Counter };
```

- ����

  - �� ���� ����� �ο�: ���� state�� ������Ʈ ������ �巯���� ������ ����ڴ� ���������� �� ������Ʈ�� ������ �� �ִ�.

  - �� �θ� �����Ϳ��� state�� �����ϱ� ����

- ����

  - ������ ���⼺: �������� �� ��(JSX)���� �����ϴ� ������ ������Ʈ ������ ���������� ������ 3���� �ٸ� ��ġ(JSX/useState/handleChange)���� ������ �ʿ��ϴ�.

---

## Reference

- [React Pattern - Control Props Pattern](https://flowergeoji.me/react/react-pattern-control-props/)
- [Controlled and uncontrolled components](https://react.dev/learn/sharing-state-between-components#controlled-and-uncontrolled-components)
- [�����ڵ�](https://github.com/alexis-regnaud/advanced-react-patterns/blob/main/src/patterns/control-props/Usage.js)
