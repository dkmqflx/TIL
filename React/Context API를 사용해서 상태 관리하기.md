- 리액트에서는 컴포넌트의 props를 통해서 state를 다른 컴포넌트로 전달할 수 있다.

- 하지만 컴포넌트의 깊이가 깊은 경우, 특정 컴포넌트에서만 사용하는 함수나 값이 있다면 해당 함수나 값을 처음부터 props로 전달해야 하는 경우가 생긴다.

- 이 때, 리액트의 Context API를 사용하면 명시적으로 컴포넌트에 props를 넘겨주지 않아도 많은 컴포넌트가 해당 값을 공유하도록 할 수 있다.

- 또한 리액트는 Route 처리를 해서 각각의 주소에 따라 다른 컴포넌트가 렌더링 되도록 할 수 있는데 이 때, 서로 다른 컴포넌트에서 같은 data가 필요한 경우, 공통의 컴포넌트에서 부터 props로 내려주는 것이 아니라 Context API를 사용해서 각 컴포넌트에서 필요한 data를 사용할 수도 있다.

- 즉, Context의 주된 용도는 다양한 레벨에 네스팅된 많은 컴포넌트에게 데이터를 전달하는 것이다.

- 하지만 context를 사용하면 컴포넌트를 재사용하기가 어려워지기 때문에 여러 레벨에 걸쳐 props 넘기는 걸 대체하는 데에 context보다 [컴포넌트에서 다른 컴포넌트를 전달하는 방법](https://ko.reactjs.org/docs/composition-vs-inheritance.html)이 더 간단한 해결책일 수도 있다.

- Context를 만들 때는 createContext 함수를 사용한다.

- createContext 함수는 Provider과 Consumer를 반환하는데, Provider에 의해 감싸진 어떤 컴포넌트나 Provider로 전달된 값을 사용할 수 있다.

- 그리고 createContext의 defaultValue는 적절한 Provider를 찾지 못했을 때만 쓰이는 값이다.

```jsx

React.createContext(defaultValue) => {Provider, Consumer}

const FirstContext = createContext("initial")

console.log(FirstContext)

```

- 아래는 Context를 만들고 Provider로 전달하는 코드이다

```jsx
// App.js

import { createContext } from 'react';
import LoginPage from './pages/LoginPage';

export const LoginPageContext = createContext(); // Conext를 만들고 export 해준다

function App() {
  const value = 'LoginContext';
  return (
    <div className='App'>
      <LoginPageContext.Provider value={value}>
        <LoginPage></LoginPage>
      </LoginPageContext.Provider>
    </div>
  );
}

export default App;
```

- Provider로 전달된 Context 값을 Consumer로 조회해서 사용할 수 있다.

```jsx
// LoginPage.js

import React from 'react';
import { LoginPageContext } from '../App'; // 사용할 Context 를 import 해준다

const LoginPage = () => {
  return (
    <div>
      <LoginPageContext.Consumer>
        {(value) => <div>{value}</div>}
      </LoginPageContext.Consumer>
    </div>
  );
};

export default LoginPage;
```

- 만약 아래처럼 Provider로 컴포넌트가 감싸여지지 않은 상태라면, LoginPage 컴포넌트에서 value 값을 조회하면 "defaultContext"가 출력된다

```jsx
// App.js

import { createContext } from 'react';
import LoginPage from './pages/LoginPage';

export const LoginPageContext = createContext('defaultContext');

function App() {
  const value = 'LoginContext';
  return (
    <div className='App'>
      <LoginPage></LoginPage>
    </div>
  );
}

export default App;
```

- 이전에는 이렇게 Consumer가 있었고 하위 provider값을 참조했지만, 이제는 useContext hook을 사용해서 Provider로 전달된 값을 받아올 수 있다

```jsx
// LoginPage.js

import React, { useContext } from 'react';
import { LoginPageContext } from '../App';

const LoginPage = () => {
  const value = useContext(LoginPageContext);

  return <div>{value}</div>;
};

export default LoginPage;
```

- useContext가 가지는 이점은 이전에는 여러개의 context의 값을 전달받으려면, 해당 컨텍스트의 consumer를 중첩으로 사용해서 값을 전달받아야 했지만, useContext를 사용하면 중첩 없이 간편하게 context를 여러개 사용할 수 있다

- 이처럼 Context API를 사용해서 전역 상태 관리를 할 수 있는데, 이 때 상태 관리를 위한 hook인 useReducer와 함께 사용하면 더 유용하게 사용할 수 있다.

- 아래는 + 버튼을 누르면 1씩 증가하고, - 버튼을 누르면 1씩 감소하는 기능을 구현하기 위한 코드이다

- initialState와 reducer를 정의하고 export 해준다

```jsx
// numberReducer.js

export const initialValue = { number: 0 };

export const numberReducer = (state, action) => {
  switch (action.type) {
    case 'ADD':
      return {
        ...state,
        number: state.number + 1,
      };
      break;
    case 'MINUS':
      return {
        ...state,
        number: state.number - 1,
      };
    default:
      return state;
  }
};
```

```jsx
// App.js

import { createContext, useReducer } from 'react';
import LoginPage from './pages/LoginPage';
import { initialValue, numberReducer } from './pages/numberReducer';

export const LoginPageContext = createContext('defaultContext');

function App() {
  return (
    <div className='App'>
      <LoginPageContext.Provider
        value={useReducer(numberReducer, initialValue)}
      >
        <LoginPage></LoginPage>
      </LoginPageContext.Provider>
    </div>
  );
}

export default App;
```

- 전달된 useReducer를 destructuring해서 state와 dispatch를 받아온다.

- 그리고 click 했을 때 상황에 따라 다른 dispatch를 보내도록 하면, 각각 버튼을 눌렀을 때 숫자가 증가, 감소하는 것을 볼 수 있다

```jsx
// LoginPage.js

import React, { useContext } from 'react';
import { LoginPageContext } from '../App';

const LoginPage = () => {
  const [state, dispatch] = useContext(LoginPageContext);

  return (
    <div>
      <div>
        <span>{state.number}</span>
      </div>
      <div>
        <button onClick={() => dispatch({ type: 'ADD' })}>+</button>
        <button onClick={() => dispatch({ type: 'MINUS' })}>-</button>
      </div>
    </div>
  );
};

export default LoginPage;
```

- context API는 재사용한 컴포넌트를 만드는데 사용할 수 도 있다.

- 프론트엔드에서는 공통적으로 사용하는 toggle, selector, accordian, dropdown과 같은 UI 컴포넌트들이 있다.

- 비슷한 기능, UI를 가진 컴포넌트를 반복적으로 만드는 것은 비 효율적이기 때문에 재사용이 가능한 컴포넌트를 만들고 이를 사용하는 것이 좋다

- 예를 들어 accordian 기능을 구현하는 경우, accordian 컴포넌트를 만든 다음 accordian 기능이 필요한 컴포넌트에서 accordian 컴포넌트를 import 한 다음 return 부분에 accordian 컴포넌트를 작성해주면 된다.

- 하지만 accordian 내부적인 값이 있고 이 값을 사용해야 accordian 기능을 구현해야 하는 컴포넌트에서 사용해야 한다면, props로 값을 전달해주어야 하기 때문에 accordian 컴포넌트를 import 해서 사용할 수 있는 것이 아니라 해당 컴포넌트는 accordian 컴포넌트의 return 부분에 작성되는, 즉, accordian 컴포넌트의 하위 컴포넌트가 되어야 한다.

- 그렇다면 accordian 컴포넌트는 재사용한 컴포넌트가 불가능하게 된다

- 따라서 이런 경우에는 accordian 컴포넌트의 Context를 만들고 컴포넌트 안의 return 문에 Context.Provider로 value를 전달한다.

- 그리고 accordian 컴포넌트를 사용하는 쪽에서는 useContext를 사용해서 필요한 value를 받아오는 방식으로 재사용 가능한 컴포넌트를 만들 수 있다

- 예를들어, 특정 버튼을 눌렀을 때 내용이 보여지는 UI를 구현한다고 한다면 다음과 같이 코드를 작성할 수 있다

- 우선 Context를 만들고 해당 Context의 Provider로 전달된 값으 불러 사용할 수 있도록하는 UseAccordian 함수를 정의한다.

```jsx
// Accordian.jsx

import React, { createContext, useContext } from 'react';

const accordianContext = createContext(null);
const UseAccordian = () => useContext(accordianContext);
```

- 그리고 공통의 Accordian을 위한 컴포넌트를 정의한다.

- 이 컴포넌트에는 isOpen 이라는 state가 있는데, 이 state 값에 따라 내용이 보여진다.

- 이 state와 setState 를 value로 Context.provider에 전달한다

```jsx
// Accordian.jsx

import React, { createContext, useContext, useState } from 'react';

const accordianContext = createContext(null);
const UseAccordian = () => useContext(accordianContext);

export const Accordian = ({ children }) => {
  const [isOpen, setIsOpen] = useState(false);
  const value = { isOpen, setIsOpen };

  return (
    <accordianContext.Provider value={value}>
      {children}
    </accordianContext.Provider>
  );
};
```

- 그리고 전달받은 AccordianHeader, AccordianBody 컴포넌트를 정의해준다.

- AccordianHeader 에서 Context.Provider로 전달된 값을 destructuring으로 받아온 다음 onClick 이벤트로 isOpen 값을 바꿀 수 있도록 해주면, button을 클릭 할 때 마다 AccordianBody의 내용이 보여지거나 숨겨지게 된다

```jsx
// Accordian.jsx

import React, { createContext, useContext, useState } from 'react';

const accordianContext = createContext(null);
const UseAccordian = () => useContext(accordianContext);

export const Accordian = ({ children }) => {
  const [isOpen, setIsOpen] = useState(false);
  const value = { isOpen, setIsOpen };

  return (
    <accordianContext.Provider value={value}>
      {children}
    </accordianContext.Provider>
  );
};

export const AccordianHeader = ({ children }) => {
  const { isOpen, setIsOpen } = UseAccordian();
  return (
    <div>
      <div>{children}</div>
      <button onClick={() => setIsOpen(!isOpen)}>Header Open</button>
    </div>
  );
};

export const AccordianBody = ({ children }) => {
  const { isOpen } = UseAccordian();

  return <div>{isOpen && <div>{children}</div>}</div>;
};

export default Accordian;
```

- 이처럼 Context API를 사용해서 UI 재사용을 위한 컴포넌트를 작성할 수 있고 텍스트 변경 및 스타일 변경도 자유롭게 할 수 있다

---

## Reference

- [https://ko.reactjs.org/docs/context.html](https://ko.reactjs.org/docs/context.html)
- [React 강좌 trendy React 3-1. useContext 알아보기](https://velog.io/@public_danuel/trendy-react-usecontext)
- [https://www.youtube.com/watch?v=hLm9J09wiOI](https://www.youtube.com/watch?v=hLm9J09wiOI)
- [React hooks 심화 (useReducer, useContext)](https://www.youtube.com/watch?v=hLm9J09wiOI)
- [contextAPI 로 리액트 상태 관리 레벨업 하기!](https://www.youtube.com/watch?v=sqz45pnvJHg)
- [contextAPI + styled-components 로 재사용 컴포넌트 만들기](https://www.youtube.com/watch?v=5RhCxzmp2yw)
- [02. Context API 를 활용한 상태 관리](https://react.vlpt.us/mashup-todolist/02-manage-state.html)
- [22. Context API 를 사용한 전역 값 관리](https://react.vlpt.us/basic/22-context-dispatch.html)
