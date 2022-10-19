- 보통 다음과 같은 방법으로 특정 path와 component를 Route에 넘겨주면, 해당 path로 컴포넌트에 접근할 수 있다.

```jsx
// App.js

import { BrowserRouter, Route, Switch } from 'react-router-dom';
import LoginPage from './pages/LoginPage';

const App = () => {
  return (
    <BrowserRouter>
      <Route path='/login' component={LoginPage} />
    </BrowserRouter>
  );
};

export default App;
```

- 하지만 이 때, `LoginPage`에 props를 전달하고 싶은 경우, 아래처럼 Route에 `auth`를 props로 선언해 주어도 props가 전달되지 않는 것을 확인할 수 있는데 React Route는 이러한 방식으로 선언된 props를 컴포넌트에 전달하지 않기 때문이다.

```jsx
// App.js

import { BrowserRouter, Route, Switch } from 'react-router-dom';
import LoginPage from './pages/LoginPage';

const isAuth = true;
const App = () => {
  return (
    <BrowserRouter>
      <Route path='/login' component={LoginPage} auth={isAuth} />
    </BrowserRouter>
  );
};

export default App;
```

- `console.log`를 통해 `props`를 출력해보면 `auth`가 전달되지 않은 것을 확인할 수 있다

```jsx
//LoginPage.js

import React from 'react';

const LoginPage = (props) => {
  console.log('props: ', props);

  return <div>LoginPage</div>;
};

export default LoginPage;
```

- 이러한 문제를 해결할 수 있는 방법으로는 아래와 같이 component에 컴포넌트를 리턴하는 `inline function`를 선언하는 방법이 있다.

```jsx
// App.js

import { BrowserRouter, Route, Switch } from 'react-router-dom';
import LoginPage from './pages/LoginPage';

const isAuth = true;

const App = () => {
  return (
    <BrowserRouter>
      <Route path='/login' component={() => <LoginPage auth={isAuth} />} />
    </BrowserRouter>
  );
};
```

- 하지만 이러한 방법은 좋은 방법이 아닌데 [React Router의 공식 문서](https://reactrouter.com/web/api/Route/render-func) 에서는 다음과 같이 설명하고 있는 것 처럼, inline 함수를 컴포넌트의 prop으로 전달하면 매번 render가 일어날 때 마다 새로운 컴포넌트를 때문이다

- 즉, 기존의 컴포넌트를 업데이트 하는 대신, 기존의 컴포넌트를 unmounting하고 새로운 컴포넌를 mounting하기 때문에 성능상 좋은 방법이 아니다.

<blockquote>
When you use component (instead of render or children, below) 
the router uses React.createElement to create a new React element from the given component. 
That means if you provide an inline function to the component prop, 
you would create a new component every render. 
This results in the existing component unmounting and the new component mounting 
instead of just updating the existing component. 
When using an inline function for inline rendering, use the render or the children prop (below).
</blockquote>

- 이러한 문제를 `render prop`을 사용해서 해결할 수 있다

- render 함수를 사용하면 컴포넌트가 불필요하게 다시 mounting 되지 않고, 컴포넌트로 props를 전달할 수 있다

```jsx
import { BrowserRouter, Route, Switch } from 'react-router-dom';
import LoginPage from './pages/LoginPage';

const isAuth = true;
const App = () => {
  return (
    <BrowserRouter>
      <Route path='/login' render={() => <LoginPage auth={isAuth} />} />
    </BrowserRouter>
  );
};

export default App;
```

- props 값이 정상적으로 전달된 것을 확인할 수 있다

```jsx
//LoginPage.js

import React from 'react';

const LoginPage = (props) => {
  console.log('props: ', props);

  return <div>LoginPage</div>;
};

export default LoginPage;
```

- 그리고 render 함수의 인자로 `props`를 전달해주면 동시에 해당 컴포넌트에 라우트의 `props`를 전달해 줄 수 있다.

- 즉, 다음과 같이 `props`를 전달해주면 `auth` 이외에도 `match, location, history` 객체가 담겨있는 것을 확인할 수 있다

```jsx
// App.js

import { BrowserRouter, Route, Switch } from 'react-router-dom';
import LoginPage from './pages/LoginPage';

const isAuth = true;
const App = () => {
  return (
    <BrowserRouter>
      <Route
        path='/login'
        render={(props) => <LoginPage {...props} auth={isAuth} />}
      />
    </BrowserRouter>
  );
};

export default App;
```

---

## Reference

- [Mapping Routes in React Router](https://www.digitalocean.com/community/tutorials/react-react-router-map-to-routes)
- [리액트 라우터 component vs render 차이](https://mingcoder.me/2019/12/04/Programming/React/react-router-component-vs-render/)
- [React Router로 렌더링하는 컴포넌트에 prop 전달하기](https://sustainable-dev.tistory.com/117)
- [Pass props to a component rendered by React Router v4](https://ui.dev/react-router-v4-pass-props-to-components/)
- [React Router docs](https://reactrouter.com/web/api/Route/render-func)
- [Using the Route render prop in React](https://dev.to/cesareferrari/using-the-route-render-prop-in-react-k5a)
- [리액트 라우터 컴포넌트의 render prop 활용하기](ttps://url.kr/xu3n5r)
