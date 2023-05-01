## HOC로 코드 리팩토링 하기

- 컴포지션 패턴은 여러가지 컴포넌트들을 조합해서 또 다른 컴포넌트를 만드는 컨셉으로, 이 때 각각의 컴포넌트는 독립적으로 존재한다

- 객체지향의 상속 패턴에는 구조적인 문제가 있다

- 상속이 깊어지면 부모에 구현된 항목을 한눈에 파악하기가 힘들고

- 또한 원치 않는 기능을 물려 받는 경우가 발생하기도 한다

- 이러한 상속 관계간의 종속성을 없애고 기능만을 따로 떼어내서 조합하는 방법을 데코레이터 패턴이라고 한다

- 함수형 프로그맹이에서는 이 방법을 커링 패턴을 응용한 고차 함수(Higher Order Function)를 사용해서 해결한다

- HOC 이와 같은 고차 함 수 확장 기능을 리액트 컴포넌트에서 구현할 수 있도록 고안한 디자인 패턴이다

<br/>

- 아래 코드는 사용자에게 입력을 받고, 레이블과 에러 메시지를 보여주는 코드이다.

- 코드를 보면 텍스트필드 컴포넌트가 너무 많은 일을 하고 있는데

- 인풋을 렌더링하는 일 이외에도 레이블을 렌더링 해주고 에러 메시지를 보여는 일도 하고 있다

- 그렇기 때문에 해당 코드를 리팩토링 해줄 필요가 있다.

- 리팩토링 포인트는 클린코드 지향적으로 봤을 때 현재 텍스트필드 컴포넌트가 너무 많은 일을 하고 있기 때문에 레이블과 에러를 처리를 하는 컴포넌트를 따로 빼주는 방식으로 처리한다

- 이 때 코드를 HOC 로 리팩토링 한다

```jsx
import { useState } from "react";

const TextField = ({ label, value, onChange, placeholder, error }) => {
  return (
    <div>
      <label>{label}</label>
      <input
        value={value}
        type="text"
        placeholder={placeholder}
        onChange={(e) => onChange(e.target.value)}
      />
      <div>{error}</div>
    </div>
  );
};~

const Home = () => {
  const [value, setValue] = useState(second);
  const [error, setError] = useState(second);

  return (
    <div>
      <TextField
        label="label Text"
        value={value}
        onChange={setValue}
        placeholder="please Enter"
        error={error}
      />
    </div>
  );
};
export default Home;
```

- HOC를 사용해서 코드를 아래처럼 수정해 줄 수 있다.

- withLabel 함수는 컴포넌트를 인자로 전달받고, ({children, …rest}) ⇒ {} 부분을 리턴한다

- 그렇기 때문에 children과 props를 전달할 수 있다.

- withLabel(TextField) 를 통해서 TextField 컴포넌트를 감싸준다음,

- return 부분에서는 이전에 TextField 컴포넌트에 있던 label 태그를 제거해준다

```jsx
import { useState } from "react";

const TextField = ({ value, onChange, placeholder, error }) => {
  return (
    <div>
      <input
        value={value}
        type="text"
        placeholder={placeholder}
        onChange={(e) => onChange(e.target.value)}
      />
      <div>{error}</div>
    </div>
  );
};

// 레이블 추가하는 컴포넌트
// HOC 컴포넌트의 경우에는 with로 시작하도록 컴포넌트 이름을 작성한다
const withLabel = (Component) => {
	// children 이외의 나머지 props는 rest 파라미터로 받는다.
  return ({ children, ...rest }) => (
  <>
    <label>{children}</label>
    <Component props={...rest}/>
  </>
  )
};

// withLabel 컴포넌트로 Wrapping 해준다
const TextFieldWithLabel = withLabel(TextField)

const Home = () => {
  const [value, setValue] = useState(second);
  const [error, setError] = useState(second);

  return (
    <div>
      <TextFieldWithLabel
        value={value}
        onChange={setValue}
        placeholder="please Enter"
        error={error}
      >
			{'label is'}
      </TextFieldWithLabel>
    </div>
  );
};

export default Home;

```

- 이렇게 코드를 작성하는 것은 장점은 유연하게 코드를 작성할 수 있다는 것이다.

- children으로 string 뿐 아니라 다음처럼 `<h2>heading label</h2>`로 태그를 사용해서 children을 전달할 수 있다

- error 관련컴포넌트도 withError라는 이름으로 정의해준다

```jsx
import Head from 'next/head';
import Image from 'next/image';
import { useState } from 'react';

// 레이블 추가하는 컴포넌트
const withLabel = (Component) => {
  // children 이외의 나머지 props는 rest 파라미터로 받는다.
  return ({ children, ...rest }) => (
    <>
      <label>{children}</label>
      <Component {...rest} />
    </>
  );
};

// 에러 추가하는 컴포넌트
const withError = (Component) => {
  return ({ error = '', ...rest }) => (
    <>
      <Component {...rest} />
      <div>{error}</div>
    </>
  );
};

const TextField = ({ value, onChange, placeholder }) => {
  return (
    <div>
      <input
        value={value}
        type='text'
        placeholder={placeholder}
        onChange={(e) => onChange(e.target.value)}
      />
    </div>
  );
};

const TextFieldWithLabel = withError(withLabel(TextField));
// withLabel(withError(TextField));, 순서 바뀌어도 상관 없다
// withError가 먼저면 error props 먼저
// withLabel이 먼저면 children props 먼저 처리하고
// 나머지 props를 rest 파라미터로 받을 수 있기 때문이다

const Home = () => {
  const [value, setValue] = useState(second);
  const [error, setError] = useState(second);

  return (
    <div>
      <TextFieldWithLabel
        value={value}
        onChange={setValue}
        placeholder='please Enter'
        error={error}
      >
        label is
      </TextFieldWithLabel>
    </div>
  );
};

export default Home;
렇게;
```

- 이렇게 분리한 컴포넌트들은 각각의 컴포넌트 독립적으로 존재한다

- 기본 TextField 컴포넌트만 사용할 수 있고 필요에 따라 label이나 error 보여줄 수 있도록 처리할 수 있다

<br/>

- 한가지 주의할 점은 HOC 는 인자로 하나만 전달받야 한다는 것이다

- 아래처럼 로딩 상태를 나타나는 HOC가 있다고 하자

```js
const withLoading = (Component) => {
  return (props) => {
    const isLoading = props.isLoading;

    if (isLoading) {
      return '로딩 중..';
    }

    return <Component {...props} />;
  };
};

const InputWithLoading = withLoading(Input);

const App = () => {
  return (
    <>
      <InputWithLoading isLoading />
    </>
  );
};
```

- 다른 형태의 로딩 메시지 보여주고 싶다면 아래처럼 HOC 컴포넌트에 인자를 두개 전달하도록 코드를 작성할 수 있다.

- 즉, 아래는 loading 상태에 따라 다른 UI가 렌더링 되는 경우이다

```js
const withLoading = (Component, msg) => {
  return (props) => {
    const isLoading = props.isLoading;

    if (isLoading) {
      return msg;
    }
    return <Component {...props} />;
  };
};

const InputWithLoading = withLoading(Input, <h2>로딩 중 </h2>);
```

- 하지만 이렇게 작성하지 않고, 커링을 사용해서 HOC를 반환하도록 구현해준다

```js
const withLoading = (msg = '로딩중') => {
  (Component) => {
    return (props) => {
      const isLoading = props.isLoading;

      if (isLoading) {
        return msg;
      }
      return <Component {...props} />;
    };
  };
};
```

- 그리고 아래와 같이 작성할 수 있다

```js
const InputWithLoading = withLoading('새로운 로딩메시지')(Input); // 커링 형태로 로딩 메시지 미리 받는다

<Loading isLoading />;
```

<br/>

- 위에서 `const TextFieldWithLabel = withError(withLabel(TextField));` 처럼 함수를 중첩해서 확장할 수 있지만

- 조합 함수 Compose를 사용하면 구조를 더 간결하게 사용할 수 있다

```js
const compose = (...args) => {
  return args.reduce(
    (prevFunc, nextFunc) => {
      return (...values) => {
        return nextFunc(prevFunc(...values));
      };
    },
    (k) => k
  );
};

compose();
```

- withLoading과 WithError를 조합해서 아래처럼 코드를 작성할 수 있다

```jsx
const InputWithLoadingAndError = compose(
  withLoading(<h2>처리중</h2>),
  withError
)(Input); // Input이 (...values)의 인자가 된다
```

- 이렇게 코드를 작성할 수 있지만,

- HOC가 가진 다중 조합성의 문제 `(compose(withState('value1'),withState('value2'), branch() ... ))` 문제가 있고

- 대체 해결 채긍로 인한 Hook로 대체할 수 있다

---

## Reference

- [이럴때는 컴포지션 쓰세요 [React]](https://www.youtube.com/watch?v=VTFr_kB28UI)
- [하이어오더 컴포넌트 파헤치기 - Higher-order Component: Do it! 리액트 프로그래밍 정석](https://www.youtube.com/watch?v=rbfQsKqhwTw&t=22s)
