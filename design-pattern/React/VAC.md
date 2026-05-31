## VAC

- VAC 패턴이란 VAC는 View Asset Component의 약자로 렌더링에 필요한 JSX와 스타일을 관리하는 컴포넌트를 의미한다

- VAC 패턴은 View 컴포넌트에서 JSX 영역을 Props Object로 추상화하고, JSX를 VAC로 분리해서 개발하는 설계 방법으로 

- 이런 설계는 비즈니스 로직 뿐만 아니라 UI 기능 같은 View 로직에서도 렌더링 관심사를 분리하는데 목적이 있다.

- 즉, VAC 패턴은 JSX 영역을 View 컴포넌트에서 독립적으로 관리하기 위한 목적을 가지고 만들어진 설계 방법이다

### 구현 예제

- 아래와 같이 value를 증가, 감소 시키는 코드가 있다고 하자

```js
const SpinBox = () => {
  const [value, setValue] = useState(0);

  return (
    <div>
      <button onClick={() => setValue(value - 1)}>-</button>
      <span>{value}</span>
      <button onClick={() => setValue(value + 1)}>+</button>
    </div>
  );
};

```

- 위 코드를 아래처럼 Props Object를 정의해준다 

- 즉, View 컴포넌트에서 JSX를 추상화한 Props Object를 생성하고 JSX에서 사용할 상태정보나 이벤트 핸들러를 등록해준다 

- 그리고 나서 정의한 props를 VAC 역할을 하는 컴포넌트로 전달해준다 

```js
// View Component

const SpinBox = () => {
  const [value, setValue] = useState(0);

  const props = {
    value,
    onDecrease: () => setValue(value - 1),
    onIncrease: () => setValue(value + 1),
  };

  // JSX를 VAC로 교체
  return <SpinBoxView {...props} />;
};

```

- 이렇게 하면 props를 전달받은 컴포넌트에서 전달받은 이벤트를 등록하거나 값을 보여준다 

```js
// VAC

const SpinBoxView = ({ value, onIncrease, onDecrease }) => (
  <div>
    <button onClick={onDecrease}>-</button>
    <span>{value}</span>
    <button onClick={onIncrease}>+</button>
  </div>
);

```

- 이 때 주의할 것은 다음과 같이 View 컴포넌트의 기능이나 상태 제어에 VAC가 관여해서는 안된다 

- 올바른 VAC는 핸들러를 이벤트에 바인딩만 할 뿐, 무엇을 하는지에 대해서 관여하지 않는다.

```js

// VAC
const SpinBoxView = ({ value, step, handleClick }) => (
  <div>
    <button onClick={() => handleClick(value - step)}>-</button>
    <span>{value}</span>
    <button onClick={() => handleClick(value + step)}>+</button>
  </div>
);

```

### Props Object를 사용하는 것의 장점 

- 예를 들어 VAC 패턴이 적용되어 있지 않은 아래 코드에서 SpinBox의 최소 값을 0이하로 설정할 수 없는 조건과 증가 감소 버튼을 둥글게 처리하는 디자인 수정이 발생했다고 가정해보자 

- 일반적인 상황이라면 **FE개발자**는 자신의 로컬에서 SpinBox 컴포넌트의 감소 버튼 핸들러를 `onClick={() => setValue(Math.max(value - 1, 0))}` 형태로 기능을 수정한다

```js

const SpinBox = () => {
  const [value, setValue] = useState(0);

  return (
    <div>
      <button onClick={() => setValue(Math.max(value - 1, 0))}>-</button>
      <span>{value}</span>
      <button onClick={() => setValue(value + 1)}>+</button>
    </div>
  );
};

```
- **UI 개발자**는 자신의 로컬에서 SpinBox 컴포넌트의 버튼에 style을 적용할 `className="round"`를 추가한다

```js

const SpinBox = () => {
  const [value, setValue] = useState(0);

  return (
    <div>
      <button className="round" onClick={() => setValue(value - 1)}>
        -
      </button>
      <span>{value}</span>
      <button className="round" onClick={() => setValue(value + 1)}>
        +
      </button>
    </div>
  );
};

```
- 이후 서로의 결과물을 저장소에 push 하면 다음 부분에서 충돌이 발생한다

```js

// FE 수정
<button onClick={() => setValue(Math.max(value - 1, 0))}>-</button>

// UI 수정
<button className="round" onClick={() => setValue(value - 1)}>-</button>
```

- VAC Pattern이 적용되어 있다면 이런 문제가 생기는 것을 방지할 수 있다 

- **FE개발자**는 View 컴포넌트의 Props Object에 있는 onDecrease를 수정한다.

```js

const SpinBox = () => {
  const [value, setValue] = useState(0);

  const props = {
    value,
    onDecrease: () => setValue(Math.max(value - 1, 0)),
    onIncrease: () => setValue(value + 1),
  };

  return <VAC {...props} />;
};

```

- **UI개발자**는 VAC에서 style을 적용한다.

```js
// VAC
const SpinBoxView = ({ value, onIncrease, onDecrease }) => (
  <div>
    <button className="round" onClick={onDecrease}>
      -
    </button>
    <span>{value}</span>
    <button className="round" onClick={onIncrease}>
      +
    </button>
  </div>
);
```

- FE개발자는 View 컴포넌트에서 기능을 수정하였고, UI개발자는 VAC에서 JSX를 수정하여 충돌이 발생하지 않는다


### Presentational 컴포넌트와 VAC

- VAC 패턴은 Container 컴포넌트에 로직을 위임하는 설계 방식을 따르기 때문에 Presentational과 Container 컴포넌트 패턴의 한 종류라고 볼 수 있다. 

- 때문에 VAC가 Presentational 컴포넌트와 동일한 역할을 하는 것 처럼 혼동되는 경우가 있으나, 두 컴포넌트의 근본적인 차이는 컴포넌트가 View 로직(UI 기능, 상태 관리)을 가질수 있는지 여부이다.

- Presentational 컴포넌트는 상황에 따라 View와 관련된 state를 가지고 스스로 상태를 제어하는 것을 허용하지만, 

- VAC는 stateless 컴포넌트로 스스로의 상태를 제어하지 않고 항상 부모 컴포넌트에서 Props Object를 통해 관리한다. 

- 따라서 VAC는 Presentational 컴포넌트보다 더 구체적인 기준을 제시하여 JSX를 처리하는 컴포넌트 관점에서 일관성 있는 설계를 하는데 도움을 줍니다.

---

### Reference

- [React에서 View의 렌더링 관심사 분리를 위한 VAC 패턴 소개](https://wit.nts-corp.com/2021/08/11/6461)
- [VAC 패턴 적용 후기 및 장단점](https://all-dev-kang.tistory.com/entry/%EB%A6%AC%EC%95%A1%ED%8A%B8-VAC-%ED%8C%A8%ED%84%B4-%EC%A0%81%EC%9A%A9-%ED%9B%84%EA%B8%B0-%EB%B0%8F-%EC%9E%A5%EB%8B%A8%EC%A0%90)
- [React VAC Pattern - View 로직과 JSX의 의존성을 최소화 하자!](https://d2.naver.com/news/0568192)