## createPortal

- ReactDOM���� �����ϴ� Portal�� ������Ʈ�� ������ �� ��, �θ� ������Ʈ�� DOM �ܺο� �����ϴ� DOM ��忡 ������ �� �� �ְ� ���ش�.

  - `createPortal` lets you render some children into a different part of the DOM.

- �� ����� Modal ������Ʈ�� ������ �� �� �ſ� �����ϰ� ��� �� �� �ִ�.

## createPortal�� ����ϴ� ���

- createPortal �Լ��� ù ���ڴ� ������Ʈ��, �� ���� ���ڴ� ������Ʈ�� �־��� DOM�� �־��ش�

- To create a portal, call `createPortal`, passing some JSX, and the DOM node where it should be rendered:

```jsx
<div>
  <SomeComponent />
  {createPortal(children, domNode)}
</div>
```

- Modal�� ���� �� �����ϰ� ����� �� �ִ�

- �Ʒ� �ڵ带 developer tool�� ����ؼ� Element ���� ���� p �±״� div �±� �ۿ� ��ġ���ִ�

```jsx
import { createPortal } from "react-dom";

export default function MyComponent() {
  return (
    <div style={{ border: "2px solid black" }}>
      <p>This child is placed in the parent div.</p>
      {createPortal(
        <p>This child is placed in the document body.</p>,
        document.body
        // developer tool�� ����ؼ� Element ���� ���� p �±״� div �±� �ۿ� ��ġ���ִ�
      )}
    </div>
  );
}
```

### createPortal�� ����ص� **������ �߻� �±׸� �ٸ� ��,** ������ �Ϲ����� React �ڽ�ó�� �����Ѵ�.

- �������� �ٸ� ���� ����Ǿ�����, ������ �Ϲ����� React �ڽ�ó�� �����Ѵ�.

- �Ʒ� �ڵ带 �����ϰ� developer tool�� Element ���� ���� id=#root �ۿ� Modal ������Ʈ�� ��ġ�� ���� �� �� �ִ�.

- ������ developer tool�� Components ���� Ȯ���ϸ� �Ʒ� ������ �Ǿ� �ִ� ���� Ȯ���� �� �ִ�

  - MyComponent

    - Modal

- �׸��� props�� ���޵� handleCllick�� �ڽ� ������Ʈ�� �����ؼ� ������ �� �� �ִ�.

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

- [React, Portal�� Ȱ���� Modal �����](https://dantechblog.gatsbyjs.io/posts/react-portal-modal/)
- [createPortal](https://react.dev/reference/react-dom/createPortal)
- [ReactDOM.createPortal()](https://velog.io/@rkio/React-ReactDOM.createPortal)
- [Portal, Render�� ������, Ȱ���� �˾ƺ���!](https://jaeseokim.dev/React/React-Portal_Render%EC%9D%98_%EC%B0%A8%EC%9D%B4%EC%A0%90_%ED%99%9C%EC%9A%A9%EB%B0%A9%EC%95%88_%EC%95%8C%EC%95%84%EB%B3%B4%EA%B8%B0/)
