- useState를 사용해서 리액트에서는 컴포넌트의 상태를 관리할 수 있다.

- 그리고 useState 이외에도 상태 관리를 할 수 있는 방법이 있는데, 바로 useReducer를 사용해서 상태를 관리하는 것이다.

- [리액트 공식 문서](https://reactjs.org/docs/hooks-reference.html#usereducer)에서는 useReducer를 useState의 대안 라고 설명하고 있다

    <blockquote>
        An alternative to useState. Accepts a reducer of type (state, action) => newState, and returns the current state paired with a dispatch method. (If you’re familiar with Redux, you already know how this works.)
    </blockquote>

- 아래 코드는 useState를 사용해서 count를 1씩 증가, 감소 시키는 코드이다

```jsx
import { useState } from 'react';

const Counter = () => {
  const [count, setCount] = useState(0);
  const onAdd = () => {
    setCount(count + 1);
  };
  const onMinus = () => {
    setCount(count - 1);
  };

  return (
    <div>
      <span>{count}</span>
      <button onClick={onAdd}>+</button>
      <button onClick={onMinus}>-</button>
    </div>
  );
};
const App = () => {
  return <Counter></Counter>;
};
```

- 이처럼 useState를 사용해서 상태를 업데이트 하는 것을 userReducer를 사용해서도 할 수 있다.

- useReducer는 다음과 같이 선언해서 사용한다

  ```jsx
  const [state, dispatch] = useReducer(reducer, initialArg, init);
  ```

- useReducer에는 세개의 인자가 전달되는데 첫번째 인자로 reducer, 두번째 인자로 처음 state가 되는 initionState, 세번째 인자로는 초기 state를 계산하는데 사용되는 함수를 전달해준다.

- 여기서 reducer 는 아래와 같이 선언해주는데 현재 상태와 액션 객체를 파라미터로 받아와서 새로운 상태를 반환해주는 함수이다.

```jsx
function reducer(state, action) {
  // 새로운 상태를 만드는 로직
  // const nextState = ...
  return nextState;
}
```

- 즉, action을 reducer로 전달해주면 현재 상태를 기반으로 새로운 값을 계산해서 return 해주는데, 이렇게 return된 값이 새로운 state가 된다.

- 아래 코드는 앞서 작성한 코드를 useReducer로 다시 작성한 코드이다. 추가적으로 + 버튼을 누르면 증가된 이외에도 `"증가"` 라는 텍스트가 추가되고, - 버튼을 누르면 감소된 숫자이외에도, `"감소"` 라는 텍스트가 함께 표시된다

```jsx
import { useReducer } from 'react';

const Counter = () => {
  const initialState = { text: '', count: 0 };
  const reducer = (state, action) => {
    switch (action.type) {
      case 'INCREMENT':
        return { ...state, text: '증가', count: state.count + 1 };
      case 'DECREMENT':
        return { ...state, text: '감소', count: state.count - 1 };
    }
  };

  const [state, dispatch] = useReducer(reducer, initialState);

  const onAdd = () => {
    dispatch({ type: 'INCREMENT' });
  };
  const onMinus = () => {
    dispatch({ type: 'DECREMENT' });
  };

  return (
    <div>
      <span>{state.text}</span>
      <span>{state.count}</span>
      <button onClick={onAdd}>+</button>
      <button onClick={onMinus}>-</button>
    </div>
  );
};
const App = () => {
  return <Counter></Counter>;
};

export default App;
```

- Reducer를 사용할 때는 별도의 파일을 만들어 export 한 다음 필요한 곳에서 import 해서 사용하는 것이 좋다

```jsx
//reducer/CountReducer.js

export const countInitialState = { text: '', count: 0 };

export const countReducer = (state, action) => {
  switch (action.type) {
    case 'INCREMENT':
      return { ...state, text: '증가', count: state.count + 1 };
    case 'DECREMENT':
      return { ...state, text: '감소', count: state.count - 1 };
  }
};
```

```jsx
import { useReducer } from 'react';
import { countInitialState, countReducer } from './reducer/countReducer';

const Counter = () => {
  const [state, dispatch] = useReducer(countReducer, countInitialState);

  const onAdd = () => {
    dispatch({ type: 'INCREMENT' });
  };
  const onMinus = () => {
    dispatch({ type: 'DECREMENT' });
  };

  return (
    <div>
      <span>{state.text}</span>
      <span>{state.count}</span>
      <button onClick={onAdd}>+</button>
      <button onClick={onMinus}>-</button>
    </div>
  );
};
const App = () => {
  return <Counter></Counter>;
};

export default App;
```

- useState를 사용해서 상태를 관리하는 custom hook을 사용할 수 있는 것 처럼, useReducer를 사용해서도 custom hook을 만들 수 있다.

- 아래는 useState를 사용한 input을 update하는 custom hook이다.

```jsx
import { useState } from 'react';

const useInput = (initialInput) => {
  const [input, setInput] = useState(initialInput);

  const onChange = (e) => {
    const { name, value } = e.target;
    setInput({ ...input, [name]: value });
  };

  return { input, onChange };
};
const App = () => {
  const { input, onChange } = useInput({ user: '' });
  console.log('input< ', input);

  return (
    <div>
      <input type='text' value={input.user} onChange={onChange} name='user' />
    </div>
  );
};

export default App;
```

- 이와 똑같은 기능을 수행하는 custom hook을 useReducer를 사용해서 다음과 같이 구현할 수 있다.

```jsx
import { useReducer } from 'react';

const useInput = (initialInput) => {
  const reducer = (state, action) => {
    switch (action.type) {
      case 'ONCHANGE':
        return { ...state, [action.payload.name]: action.payload.value };
    }
  };

  const [input, dispatch] = useReducer(reducer, initialInput);

  const onChange = (e) => {
    const { name, value } = e.target;
    dispatch({ type: 'ONCHANGE', payload: { name, value } });
  };

  return { input, onChange };
};
const App = () => {
  const { input, onChange } = useInput({ user: '' });

  return (
    <div>
      <input type='text' value={input.user} onChange={onChange} name='user' />
    </div>
  );
};

export default App;
```

- useState와 useReducer는 상황에 따라 각각 유용하게 사용할 수 있다

- 컴포넌트에서 관리하는 state 수가 적다면 useState로 관리하는 것이 더 간편하지만

- 컴포넌트에서 관리하는 state가 많고 state를 변경하는 함수가 많다면 useState를 여러개 사용하는 것 보다 useReducer로 state를 더 편하게 관리할 수 있다

---

## Reference

- [리액트 공식 문서](https://reactjs.org/docs/hooks-reference.html#usereducer)
- [React hooks 심화 useReducer, useContext](https://www.youtube.com/watch?v=hLm9J09wiOI)
- [20. useReducer 를 사용하여 상태 업데이트 로직 분리하기](https://react.vlpt.us/basic/20-useReducer.html)
- [21. 커스텀 Hooks 만들기](https://react.vlpt.us/basic/21-custom-hook.html)
