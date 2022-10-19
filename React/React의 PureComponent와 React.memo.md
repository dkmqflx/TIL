- 리액트에서 부모 컴포넌트가 다시 렌더링 되면 자식 컴포넌트도 렌더링 된다

- 따라서 아래와 같은 코드에서 `app.js`의 버튼을 button을 클릭하면 `navbar.js`도 다시 렌더링 되기 때문에 `navbar.js`의 `"this is navbar"`와 `"navNum: "`도 출력된다

```jsx
//navbar.js
import React from 'react';

const Navbar = () => {
  console.log('this is havbar');
  console.log('navNum: ', navNum);
  return <div>this is navbar</div>;
};

export default Navbar;
```

```jsx
import { useState } from 'react';
import Navbar from './components/navbar';

function App() {
  console.log('this is App');
  const [num, setNum] = useState(0);
  const [navNum, setNavNum] = useState(0);

  const handleClick = () => {
    setNum(num + 1);
  };

  return (
    <>
      <Navbar navNum={navNum}></Navbar>
      <div>
        {num}
        <button onClick={handleClick}>+</button>
      </div>
    </>
  );
}

export default App;
```

- 만약 `App.js` 파일에 라이프 사이클 메소드(Life Cycle Method)를 사용해서 외부 데이터를 받아온다 거나 조금 무거운 작업을 수행하는 부분을 구현한다면 컴포넌트가 업데이트 될 때 마다 Render가 호출되고, 컴포넌트 라이프 사이클 메소드가 실행된다.

- 이 때 `Navbar.js` 도 계속해서 다시 렌더링 되는데 파일에는 실제로는 관련된 데이터가 전혀 변경되지 않았음에도 render 함수가 호출되는 것은 성능에 좋지 않다

- 이것을 방지할 수 있는 것이 `pureComponent`와 `React.memo`이다

- `pureComponent`와 `React.memo`는 component에 state나 props에 변화가 없다면 다시 렌더링하지 않도록 한다.

- 공식 문서에서 확인해보면 `pureComponent`에는 `shouldComponenetUpdate` 함수가, `React.memo`에는 `areEqual`함수가 구현되어있기 때문에 다시 렌더링하지 않는 것을 알 수 있다

- `shouldComponenetUpdate`는 컴포넌트를 업데이트 해야할 지 안해야 할지를 결정하는 함수로 이 함수에는 이전의 props나 state를 지금 업데이트 된 props나 state와 `얕은 비교(Shallow Comparison)`하는 부분이 구현되어 있다.

- 여기서 얕은 비교라는 것은 객체의 레퍼런스를 비교한다는 뜻이다

- 즉, 내부 안에서 데이터가 변경되는 것과 상관 없이 동일한 레퍼런스를 가지고 있는 객체는 같다고 취급하는 것이다.

- 따라서 props 안에 여러가지 객체가 전달된다고 했을 때, 객체 안의 데이터가 바뀌더라도 동일한 객체라면 render 함수가 호출되지 않는다는 것을 의미한다

- 즉 다음과 같이 코드를 작성하면 `Navbar.js` 컴포넌트가 다시 렌더링되지 않기 때문에 `App.js`의 `"this is app"`만 콘솔에 출력되는 것을 확인할 수 있다

```jsx
// 클래스형 컴포넌트에서는 PureComponent 사용

//navbar.js
import React, { PureComponent } from 'react';

export class Navbar extends PureComponent {
  render() {
    console.log('this is havbar');
    console.log('navNum: ', this.props.navNum);
    return (
      <div>
        <button>handleNav</button>
      </div>
    );
  }
}

export default Navbar;
```

- 함수형 컴포넌트에서는 `React.memo` 사용한다.

- React는 컴포넌트가 `React.memo`로 Wrapping되면 해당하는 컴포넌트를 렌더링 하고 결과를 `메모이징(Memoizing)`한다

- 그리고 다음 렌더링이 일어날 때 props가 같다면 컴포넌트를 다시 렌더링하지 않고 `메모이징` 한, 마지막으로 렌더링 된 값을 재사용한다

```jsx
// 함수형 컴포넌트에서는 memo 사용

//navbar.js
import React, { memo } from 'react';

const Navbar = memo(({ navNum }) => {
  console.log('this is havbar');
  console.log('navNum: ', navNum);

  return (
    <div>
      <button>handleNav</button>
    </div>
  );
});

export default Navbar;
```

---

## Reference

- [React 공식 문서](https://reactjs.org/docs/react-api.html#reactmemo)
- [React.memo() 현명하게 사용하기](https://ui.toast.com/weekly-pick/ko_20190731)
