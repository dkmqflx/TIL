#

## Redux thunk

- Redux Thunk�� ���������� �񵿱� �۾��� ó�� �� �� ���� ���� ����ϴ� �̵����.
- �� �̵��� ����ϸ�?**�׼� ��ü�� �ƴ� �Լ��� ����ġ �� �� �ִ�.**
- �Լ��� ����ġ �� ������, �ش� �Լ�����?`dispatch`?��?`getState`?�� �Ķ���ͷ� �޾ƾ� �Ѵ�.
- �� �Լ���?**������ִ� �Լ�**�� �츮�� thunk ��� �θ���

- Redux Thunk�� �ڵ�� �뷫������ �Ʒ��� ����

```jsx
const thunk = (store) => (next) => (action) =>
  typeof action === 'function'
    ? action(store.dispatch, store.getState)
    : next(action);
```

- function Ű���带 ����ؼ� ��Ÿ���� �Ʒ��� ����

```jsx
function middleware(store) {
  return function (next) {
    return function (action) {
      // �ϰ� ���� �۾�...
    };
  };
}
```

- ù��°?`store`�� ������ ����� �ν��Ͻ��� �� �ȿ�?`dispatch`,?`getState`,?`subscribe`?�����Լ����� ����ִ�.
- �ι�°?`next`?�� �׼��� ���� �̵����� �����ϴ� �Լ��̴�.
  - `next(action)`?�̷� ���·� ����Ѵ�.
  - ���� ���� �̵��� ���ٸ� ���༭���� �׼��� �������ش�.
  - ���࿡?`next`?�� ȣ������ �ʰ� �ȴٸ� �׼��� ����ó���Ǿ� ���༭���Է� ���޵��� �ʴ´�.
- ����°?`action`?�� ���� ó���ϰ� �ִ� �׼� ��ü

- �̵����� ���� ���� ������ �۵��Ѵ�.
- ������ ������ ���� ���� �̵��� ����� �� �ִ�.
- ���ο� �׼��� ����ġ �Ǹ� ù ��°�� ����� �̵��� ȣ��ȴ�.
- ���࿡ �̵�����?`next(action)`�� ȣ���ϰ� �Ǹ� ���� �̵����� �׼��� �Ѿ��.
- �׸��� ���� �̵�����?`store.dispatch`?�� ����ϸ� �ٸ� �׼��� �߰������� �߻���ų �� �� �ִ�.

- �Ʒ��� Logger�� ����ϴ� ���÷�, �Ʒ�ó�� �۵��Ѵ�

```jsx
const myLogger = (store) => (next) => (action) => {
  console.log(action); // ���� �׼��� ����մϴ�.
  const result = next(action); // ���� �̵���� (�Ǵ� ���༭) ���� �׼��� �����մϴ�.

  // ������Ʈ ������ ���¸� ��ȸ�մϴ�.
  console.log('\t', store.getState()); // '\t' �� �� ���� �Դϴ�.

  return result; // ���⼭ ��ȯ�ϴ� ���� dispatch(action)�� ������� �˴ϴ�. �⺻: undefined
};

export default myLogger;
```

### Thunk�� ����ؼ� �񵿱�ó�� �ϱ�

- �̵���� �ȿ����� �����̵��� �� �� �ִ�.
- ���� �� �׼� ���� ��ü�� �ƴ� �Լ��� �޾ƿ��� ���� �׼��� �Լ�Ÿ���̸� �̸� �����Ű�Բ� �� ���� �ִ� (redux-thunk)

```jsx
// thunk
const thunk = (store) => (next) => (action) =>
  typeof action === 'function'
    ? action(store.dispatch, store.getState)
    : next(action);

// �Ʒ�ó�� �Լ��� dispatch �Ѵ�
const myThunk = () => (dispatch, getState) => {
  dispatch({ type: 'HELLO' });
  dispatch({ type: 'BYE' });
};

dispatch(myThunk());
// myThunk�� (dispatch, getState)�� ���ڷ� �޴� �Լ��� �����ϱ� ������
// thunk���� action�� �Լ��� �ȴ�
// �׷��� ������ action(store.dispatch, store.getState) �̷� ������ ����Ǵ� ���̴�.
```

### ��

- �Ʒ��� thunk�� ����ϴ� �����̴�.

```jsx
// thunk �Լ�
const getComments = () => (dispatch, getState) => {
  // �� �ȿ����� �׼��� dispatch �� ���� �ְ�
  // getState�� ����Ͽ� ���� ���µ� ��ȸ �� �� �ִ�.
  const id = getState().post.activeId;

  // ��û�� ���������� �˸��� �׼�
  dispatch({ type: 'GET_COMMENTS' });

  // ����� ��ȸ�ϴ� ���ι̽��� ��ȯ�ϴ� getComments �� �ִٰ� �����غ���

  api
    .getComments(id) // ��û�� �ϰ�
    .then((comments) =>
      dispatch({ type: 'GET_COMMENTS_SUCCESS', id, comments })
    ) // ������
    .catch((e) => dispatch({ type: 'GET_COMMENTS_ERROR', error: e })); // ���н�
};
```

- thunk �Լ����� async/await�� ����� �� �� �ִ�.

```jsx
const getComments = () => async (dispatch, getState) => {
  const id = getState().post.activeId;
  dispatch({ type: 'GET_COMMENTS' });
  try {
    const comments = await api.getComments(id);
    dispatch({ type: 'GET_COMMENTS_SUCCESS', id, comments });
  } catch (e) {
    dispatch({ type: 'GET_COMMENTS_ERROR', error: e });
  }
};
```

### **ī���� �������ϱ�**

- �Ʒ��� thunk �Լ��� �����,?`setTimeout`�� ����Ͽ� �׼��� ����ġ�Ǵ� ���� 1�ʾ� �����̽�Ű�� ����

```jsx
//modules/counter.js

// �׼� Ÿ��
const INCREASE = 'INCREASE';
const DECREASE = 'DECREASE';

// �׼� ���� �Լ�
export const increase = () => ({ type: INCREASE });
export const decrease = () => ({ type: DECREASE });

// getState�� ���� �ʴ´ٸ� ���� �Ķ���ͷ� �޾ƿ� �ʿ� ����.
// �Ʒ��� Thunk �Լ��� increaseAsync()�� ����Ǹ�, �ش� dispatch => {...} �κ��� ����ȴ�
export const increaseAsync = () => (dispatch) => {
  setTimeout(() => dispatch(increase()), 1000);
};
export const decreaseAsync = () => (dispatch) => {
  setTimeout(() => dispatch(decrease()), 1000);
};

// �ʱ갪 (���°� ��ü�� �ƴ϶� �׳� ���ڿ��� ��� �����ϴ�.)
const initialState = 0;

// action���� thunk �Լ��� ���޵ȴ�
export default function counter(state = initialState, action) {
  switch (action.type) {
    case INCREASE:
      return state + 1;
    case DECREASE:
      return state - 1;
    default:
      return state;
  }
}
����;
```

- �������� ������ �Ʒ�

```jsx
// containers/CounterContainer.js

import React from 'react';
import Counter from '../components/Counter';
import { useSelector, useDispatch } from 'react-redux';
import { increaseAsync, decreaseAsync } from '../modules/counter';

function CounterContainer() {
  const number = useSelector((state) => state.counter);
  const dispatch = useDispatch();

  const onIncrease = () => {
    dispatch(increaseAsync());
  };
  const onDecrease = () => {
    dispatch(decreaseAsync());
  };

  return (
    <Counter number={number} onIncrease={onIncrease} onDecrease={onDecrease} />
  );
}

export default CounterContainer;
```

---

## Reference

[������ �̵���� - 2. �̵���� ������ �����ϱ�](https://react.vlpt.us/redux-middleware/02-make-middleware.html)

[������ �̵���� - 4. redux-thunk](https://react.vlpt.us/redux-middleware/04-redux-thunk.html)

[������ �̵���� 5. redux-thunk�� ���ι̽� �ٷ��](https://react.vlpt.us/redux-middleware/05-redux-thunk-with-promise.html)
