## createPortal

- ReactDOM에서 제공하는 Portal은 컴포넌트를 렌더링 할 때, 부모 컴포넌트의 DOM 외부에 존재하는 DOM 노드에 렌더링 할 수 있게 해준다.

  - `createPortal` lets you render some children into a different part of the DOM.

- 이 기능은 Modal 컴포넌트를 만들어야 될 때 매우 유용하게 사용 할 수 있다.

## createPortal을 사용하는 방법

- createPortal 함수의 첫 인자는 컴포넌트를, 두 번쨰 인자는 컴포넌트를 넣어줄 DOM을 넣어준다

- To create a portal, call `createPortal`, passing some JSX, and the DOM node where it should be rendered:

```jsx
<div>
  <SomeComponent />
  {createPortal(children, domNode)}
</div>
```

- Modal을 만들 때 유용하게 사용할 수 있다

- 아래 코드를 developer tool을 사용해서 Element 탭을 보면 p 태그는 div 태그 밖에 위치해있다

```jsx
import { createPortal } from "react-dom";

export default function MyComponent() {
  return (
    <div style={{ border: "2px solid black" }}>
      <p>This child is placed in the parent div.</p>
      {createPortal(
        <p>This child is placed in the document body.</p>,
        document.body
        // developer tool을 사용해서 Element 탭을 보면 p 태그는 div 태그 밖에 위치해있다
      )}
    </div>
  );
}
```

### createPortal을 사용해도 **렌더링 발생 태그만 다를 뿐,** 여전히 일반적인 React 자식처럼 동작한다.

- 렌더링이 다른 곳에 진행되었더라도, 여전히 일반적인 React 자식처럼 동작한다.

- 아래 코드를 실행하고 developer tool의 Element 탭을 보면 id=#root 밖에 Modal 컴포넌트가 위치한 것을 볼 수 있다.

- 하지만 developer tool에 Components 탭을 확인하면 아래 구조로 되어 있는 것을 확인할 수 있다

  - MyComponent

    - Modal

- 그리고 props로 전달된 handleCllick을 자식 컴포넌트로 전달해서 실행할 수 도 있다.

```jsx
// App.jsx
import Modal from "./Modal";

export default function MyComponent() {
  const handleClick = () => {
    console.log("modal Click");
  };
  return (
    <div style={{ border: "2px solid black" }}>
      <p>This child is placed in the parent div.</p>
      <Modal handleClick={handleClick} />
    </div>
  );
}
```

```jsx
// Modal.jsx
import React from "react";
import { createPortal } from "react-dom";

const Modal = ({ handleClick }) => {
  return (
    <div onClick={handleClick}>
      {createPortal(<p>This is Modal.</p>, document.body)}
    </div>
  );
};

export default Modal;
```

---

### Reference

- [React, Portal을 활용해 Modal 만들기](https://dantechblog.gatsbyjs.io/posts/react-portal-modal/)
- [createPortal](https://react.dev/reference/react-dom/createPortal)
- [ReactDOM.createPortal()](https://velog.io/@rkio/React-ReactDOM.createPortal)
- [Portal, Render의 차이점, 활용방안 알아보기!](https://jaeseokim.dev/React/React-Portal_Render%EC%9D%98_%EC%B0%A8%EC%9D%B4%EC%A0%90_%ED%99%9C%EC%9A%A9%EB%B0%A9%EC%95%88_%EC%95%8C%EC%95%84%EB%B3%B4%EA%B8%B0/)
