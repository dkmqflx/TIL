- 아래는 리액트에서 Modal 창을 간단하게 구현한 코드이다.

- `ModalContainer` 의 `Click` 버튼을 클릭하면 Modal 창을 열고 닫을 수 있다.

---

```jsx
//ModalContainer.jsx

import React, { useState } from 'react';
import Modal from './Modal';

const ModalContainer = () => {
  const [modalOpen, setModalOpen] = useState(false);
  const modalClose = () => {
    setModalOpen(!modalOpen);
  };

  return (
    <>
      <button onClick={modalClose}>Click</button>
      {modalOpen && <Modal modalClose={modalClose}></Modal>}
    </>
  );
};

export default ModalContainer;
```

- `Modal Close` 버튼을 누르면 `ModalContainer` 에서 전달받은 `modalClose` 실행되어 Modal을 열고 닫을 수 있다.

```jsx
// Modal.jsx

import React from 'react';
import './Modal.scss';

const Modal = ({ modalClose }) => {
  return (
    <div className='modal__container'>
      <div className='modal'>
        <button className='modal__button' onClick={modalClose}>
          {' '}
          Modal Close
        </button>
      </div>
    </div>
  );
};

export default Modal;
```

- Modal 창이 열릴 때, Modal 창을 제외한 나머지 부분을 어둡게 하는 방법은, Modal 창을 감싸는 컨테이너 요소를 만들고 해당 요소에 스타일을 적용하는 것이다

- 우선, 아래 코드처럼 `width`, `height` 속성을 전체 브라우저를 다 차지하도록 조정해 준다

- 그리고, `position`, `top`, `left` 속성을 사용해서, 해당 요소가 브라우저를 기준으로, 모든 요소를 다 자치하도록 해준다음, `z-index`의 값으로 높은 값을 주어 가장 위에 있는 요소로 만들어준다

```css
// Modal.scss

.modal__container {
  width: 100%;
  height: 100vh;
  background-color: rgba(0, 0, 0, 0.4);
  z-index: 10;
  position: fixed;
  top: 0;
  left: 0;

  .modal {
    width: 300px;
    height: 150px;
    background-color: #fff;
    // Modal 창 브라우저 가운데로 조정
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
    z-index: 100;

    .modal__button {
      position: relative;
      left: 50%;
      top: 50%;
      transform: translate(-50%, -50%);
    }
  }
}
```

- 그리고 Modal 창을 제외한 나머지 부분을 클릭했을 때도 Modal 창이 닫히도록 하기 위해서, 다음과 같이 코드를 변경시킬 수 있다

```jsx
// Modal.jsx

import React from 'react';
import './Modal.scss';

const Modal = ({ modalClose }) => {
  return (
    <div className='modal__container' onClick={modalClose}>
      <div className='modal'>
        <button className='modal__button' onClick={modalClose}>
          {' '}
          Modal Close
        </button>
      </div>
    </div>
  );
};

export default Modal;
```

- 하지만 코드를 실행시켜보면, Modal 창의 `z-index`가 더 높지만, Modal 창을 내부를 클릭해도 Modal 창이 닫히게 되는데, 그 이유는 바로 부모 - 자식 요소 간에는, 자식 요소가 부모 요소보다 `z-index`가 높다고 해서 더 위에 있는 요소가 되지 않기 때문이다

- 즉, `z-index`는 해당 부모 요소 안의 자식 요소 우선순위를 비교하는 것이기 때문에 자식 요소가 부모 요소보다 `z-index`가 높다고 더 높은 우선순위를 갖지 않는다.

- `z-index`는 부모 요소 안에 자식 요소1과 자식 요소2 child2가 있는 경우, 각각의 자식 요소의 우선순위를 비교할 때 사용되는 속성이다

- 따라서 부모 - 자식 간의 우선순위로 해결할 수 없기 때문에, 이를 해결 위한 방법으로 `event.target`과 `event.currentTarget`을 비교하는 방법이있다.

- 아래 코드처럼, modal의 컨테이너 요소에 `event.target`과 `event.currentTarget`를 비교해주는 함수를 등록한다.

- `onClick` 이벤트는, 컨테이너 요소에 등록되어 있기 때문에, modal 창 내부를 클릭하고 콘솔창의 결과 값을 비교해보면, `event.target`과 `event.currentTarget`가 서로 다른 것을 확인할 수 있다

- 따라서, 컨테이너 요소에 해당하는 부분을 클릭했을 때만 `event.target`과 `event.currentTarget` 가 같아지기 때문에, modal 창을 제외한 나머지 부분을 클릭했을 때 modal 창이 닫히게 된다

```jsx
import React from 'react';
import './Modal.scss';

// Modal.jsx

const Modal = ({ modalClose }) => {
  const onCloseModal = (e) => {
    console.log('e.target: ', e.target);
    console.log('e.tarcurrentTargetget: ', e.currentTarget);
    if (e.target === e.currentTarget) {
      modalClose();
    }
  };
  return (
    <div className='modal__container' onClick={onCloseModal}>
      <div className='modal'>
        <button className='modal__button' onClick={modalClose}>
          {' '}
          Modal Close
        </button>
      </div>
    </div>
  );
};

export default Modal;
```

---

## Reference

- [z-index가 동작하지않는 이유 4가지](https://erwinousy.medium.com/z-index%EA%B0%80-%EB%8F%99%EC%9E%91%ED%95%98%EC%A7%80%EC%95%8A%EB%8A%94-%EC%9D%B4%EC%9C%A0-4%EA%B0%80%EC%A7%80-%EA%B7%B8%EB%A6%AC%EA%B3%A0-%EA%B3%A0%EC%B9%98%EB%8A%94-%EB%B0%A9%EB%B2%95-d5097572b82f)
