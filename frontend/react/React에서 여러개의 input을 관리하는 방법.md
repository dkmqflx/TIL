- React에서 다음과 같이 하나의 input 당 state를 설정하는 방식으로 input을 관리할 수 있다

```jsx
import React, { useState } from 'react';

const InputComponent = () => {
  const [state1, setstate1] = useState('');
  const [state2, setstate2] = useState('');
  const [state3, setstate3] = useState('');

  const onChangeInput1 = (e) => {
    setstate1(e.target.value);
  };

  const onChangeInput2 = (e) => {
    setstate2(e.target.value);
  };

  const onChangeInput3 = (e) => {
    setstate3(e.target.value);
  };

  return (
    <div>
      <input type='text' value={state1} onChange={onChangeInput1} />
      <input type='text' value={state2} onChange={onChangeInput2} />
      <input type='text' value={state3} onChange={onChangeInput3} />
    </div>
  );
};

export default LoginPage;
```

- 하지만 이러한 방법은 그렇게 좋은 방법이 아닌데, input 개수가 늘어날 때 마다 해당 input을 관리하기 위한 state와 onChange 함수를 정의해주어야 하기 때문이다

- 따라서 다음과 같이 하나의 state로 input 값들을 사용하도록 코드를 수정할 수 있다

```jsx
import React, { useState } from 'react';

const InputComponent = () => {
  const [input, setInput] = useState({
    input1: '',
    input2: '',
    input3: '',
  });

  const { input1, input2, input3 } = input; // destructuring

  const onChangeInput = (e) => {
    const { name, value } = e.target; // destructuring
    setInput({
      ...input,
      [name]: value,
    });
  };

  return (
    <div>
      <input
        type='text'
        name='input1'
        value={input1}
        onChange={onChangeInput}
      />
      <input
        type='text'
        name='input2'
        value={input2}
        onChange={onChangeInput}
      />
      <input
        type='text'
        name='input3'
        value={input3}
        onChange={onChangeInput}
      />
    </div>
  );
};

export default LoginPage;
```

- input을 위한 하나의 state를 만들고, 값이 바뀔 때 마다 객체 spread 방식으로 값을 update 해준다

---

## Reference

- [여러개의 input 상태 관리하기](https://react.vlpt.us/basic/09-multiple-inputs.html)
- [Handling Multiple Inputs with a Single onChange Handler in React](https://www.pluralsight.com/guides/handling-multiple-inputs-with-single-onchange-handler-react)
- [Spread syntax ... ](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax)
