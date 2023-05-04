# 제어의 역전(Inversion Of Control)

## 제어의 역전

- 제어의 역전이란 컴포넌트 사용자에게 주어지는 유연성과 제어권이라고 할 수 있다

- 리액트로 개발을 하다 보면 컴포넌트가 기본 기능대로만 동작하기보다는, 원하는 방식으로 확장되어 동작하길 바랄 때가 종종 있다.

- 이럴 때 우리는 IoC(Inversion of Control) 즉, 제어 역전 패턴을 통해 **컴포넌트를 사용하는 개발자에게 컴포넌트의 제어권을 넘겨줌으로써**, 개발자가 원하는 대로 컴포넌트를 컨트롤하도록 할 수 있다.

  - 아래 링크에서 리액트의 다양한 컴포넌트 IoC 패턴들에 대해 알 수 있다

    - [이제부터 이 컴포넌트는 제 겁니다](https://fe-developers.kakaoent.com/2022/221110-ioc-pattern/)

### 제어의 역전 코드를 적용한 예시

- 계산기 기능을 구현한다고 할 때 아래와 같이 코드를 작성할 수 있다

```jsx
function calculator(a, b, option) {
  switch (option) {
    case "add":
      return a + b;
    case "sub":
      return a - b;
    case "mul":
      return a * b;
    case "div":
      return a / b;
    case "power":
      return a ** 2 + b ** 2;
    case "abs":
      return Math.abs(a - b);
    default:
      return 0;
  }
}
```

- 하지만 기능을 추가할 수록 코드의 양이 늘어나게 된다

- 이 때 제어의 역전을 통해 아래와 같이 코드를 작성하면 사용자에게 컨트롤을 넘겨줌으로써 코드를 간략하게 수정할 수 있다

```jsx
function IOCCalculator(a, b, callback) {
  return callback(a, b);
}
```

- js에서 사용하는 map, filter와 같은 함수들도 제어의 역전이 적용되었다고 할 수 있다

### 리액트에서 제어의 역전 사용하기

- 아래와 같이 Dialog 컴포넌트가 있다고 하자

```jsx
<Dialog
  title="안내"
  description="이것은 멋진 내용을 담고 있는 안내입니다."
  button={{
    label: '확인',
    onClick: doSomething,
  }}
/>
```

- 기능이 추가됨으로써 아래처럼 props가 증가될 수 있다

- 이렇게 props가 많아짐으로써 생기는 문제점은 다음과 같다

    - 각 props가 어떤 역할을 하는지 파악하기 어려워진다

    - 파악하기 어려운 props를 설명하기 위한 주석이나 문서 작성 및 관리가 필요하다

    - 요구사항이 복잡할수록 props 이름을 작성하는 것도 어려워지고, 한눈에 파악하기 힘든 props 이름이 만들어질 수 있다

- 결과적으로 Dialog 컴포넌트는 재사용성은 갖추었지만 유연성은 갖추지 못하였다

- 이렇게 유연하지 못하게된 이유는 비즈니스 로직이 컴포넌트 안에 모두 들어있기 때문이다

```jsx
<Dialog
  title="안내"
  description="이것은 멋진 내용을 담고 있는 안내입니다."
  buttonPosition="top"
  buttons={[
    {
      label: '확인',
      onClick: doSomething,
      variant: 'primary',
    }, {
      label: '취소',
      onClick: doSomethingElse,
      variant: 'secondary',
    },
  ]}
  buttonAlign="vertical"
  iconAboveTitle="fancy-icon"
/>

/**************************/
/********* 6개월 뒤 *********/
/**************************/

<Dialog
  {...프많쓰않} // 프롭스가 많지만 쓰지 않는다
/>
```

- 이렇게 작성된 코드를 제어의 역전을 통해 아래와 같이 수정할 수 있다

```jsx
Dialog.Content = ({ title, description }) => (
  <React.Fragment>
    <Dialog.Title>
      {title}
    </Dialog.Title>
    <Dialog.Description>
      {description}
    </Dialog.Description>
  </React.Fragment>
)

function Page() {
  return (
    <Dialog>
      <Dialog.Content
        title="안내"
        description="이것은 멋진 내용을 담고 있는 안내입니다."
      />
      <Dialog.ButtonContainer align="vertical">
        <Dialog.Button type="secondary" onClick={doSomethingElse}>
          취소
        </Dialog.Button>
        <Dialog.Button type="primary" onClick={doSomething}>
          취소
        </Dialog.Button>
      </Dialog.ButtonContainer>
    <Dialog>
  )
}
```

- 위 예시처럼 코드를 수정할 수 있다

- 위처럼 리액트 디자인 패턴 중 Compound Component 패턴도 이런 제어의 역전을 적용한 것이다

---

### Reference

- [제어의 역전(Inversion of Control)](https://velog.io/@ja960508/%EC%A0%9C%EC%96%B4%EC%9D%98-%EC%97%AD%EC%A0%84Inversion-of-Control)
- [단단한 컴포넌트 부수기(feat. 조합, IoC)](https://brunch.co.kr/@finda/556)
- [Inversion of Control](https://kentcdodds.com/blog/inversion-of-control)