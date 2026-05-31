## Control Props Pattern

- Control Props Pattern은 props를 통해 외부에서 컴포넌트의 상태를 제어(Controlled Component) 할 수 있도록 만드는 방법

- 여기서 비제어 컴포넌트란, loal state로만 컴포넌트의 상태를 관리하기 때문에 부모 컴포넌트가 제어를 할 수 없는 컴포넌트를 말한다

> It is common to call a component with some local state “uncontrolled”. For example, the original Panel component with an isActive state variable is uncontrolled because its parent cannot influence whether the panel is active or not.

- 아래 예제는 비제어(Uncontrolled Component)의 예시이다

```js
// 비제어 컴포넌트(Un-controlled Component)
// props로 전달되는 것 없다
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

- 제어 컴포넌트란, 부모 컴포넌트에서 props로 전달받은 것들을 통해서 상태를 관리할 수 있는 컴포넌트이다

> In contrast, you might say a component is “controlled” when the important information in it is driven by props rather than its own local state.

- 아래 예제는 제어(Controlled Component)로, props로 전달받은 값과 함수를 통해 내부 상태를 관리한다

```js
// 제어 컴포넌트(Controlled Component)

const ControlledCounter = ({ value: valueProp, onChange }) => {
  const [_valueState, _setValueState] = useState(value ?? 0);

  const _onClickUp = function () {
    // value prop이 없으면, value state로 상태를 컨트롤.
    if (valueProp === undefined) {
      const nextValue = _valueState + 1;
      _setValueState(nextValue);
      onChange?.(nextValue);
    }
    // value prop이 있으면, value prop으로 상태를 컨트롤.
    else {
      onChange?.(valueProp + 1);
    }
  };

  const _onClickDown = function () {
    // value prop이 없으면, value state로 상태를 컨트롤.
    if (valueProp === undefined) {
      const nextValue = _valueState - 1;
      _setValueState(nextValue);
      onChange?.(nextValue);
    }
    // value prop이 있으면, value prop으로 상태를 컨트롤.
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

- 비제어 컴포넌트는 컴포넌트 내부 상태만 사용하기 때문에 컴포넌트 외부에서는 어떠한 간섭도 할 수 없다

- 하지만 제어 컴포넌트로 구현하면 컴포넌트 외부에서도 컴포넌트의 상태를 관리할 수 있게 된다.

- **이는 만들어진 컴포넌트를 사용하는 사용자한테 좀 더 유연성과 제어권을 줄 수 있고(IOC, Inversion Of Control), 상태를 한곳에서 관리하는 SSOT(Single Source Of Truth)가 가능해진다.**

- 아래 예시 코드도 위의 코드처럼, 외부로 전달받은 value와 onChange가 없는 경우에만 내부에서 값을 변경시킬수 있도록 한다

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

- 장점

  - 더 많은 제어권 부여: 메인 state가 컴포넌트 밖으로 드러나기 때문에 사용자는 직접적으로 그 컴포넌트를 제어할 수 있다.

  - 즉 부모 컴포넌에서 state를 전달하기 때문

- 단점

  - 구현의 복잡성: 이전에는 한 곳(JSX)에서 구현하는 것으로 컴포넌트 동작이 가능했지만 이제는 3개의 다른 위치(JSX/useState/handleChange)에서 구현이 필요하다.

---

## Reference

- [React Pattern - Control Props Pattern](https://flowergeoji.me/react/react-pattern-control-props/)
- [Controlled and uncontrolled components](https://react.dev/learn/sharing-state-between-components#controlled-and-uncontrolled-components)
- [예제코드](https://github.com/alexis-regnaud/advanced-react-patterns/blob/main/src/patterns/control-props/Usage.js)
