#

## Redux thunk

- Redux Thunk는 리덕스에서 비동기 작업을 처리 할 때 가장 많이 사용하는 미들웨어.
- 이 미들웨어를 사용하면?**액션 객체가 아닌 함수를 디스패치 할 수 있다.**
- 함수를 디스패치 할 때에는, 해당 함수에서?`dispatch`?와?`getState`?를 파라미터로 받아야 한다.
- 이 함수를?**만들어주는 함수**를 우리는 thunk 라고 부른다

- Redux Thunk의 코드는 대략적으로 아래와 같다

```jsx
const thunk = (store) => (next) => (action) =>
  typeof action === 'function'
    ? action(store.dispatch, store.getState)
    : next(action);
```

- function 키워드를 사용해서 나타내면 아래와 같다

```jsx
function middleware(store) {
  return function (next) {
    return function (action) {
      // 하고 싶은 작업...
    };
  };
}
```

- 첫번째?`store`는 리덕스 스토어 인스턴스로 이 안에?`dispatch`,?`getState`,?`subscribe`?내장함수들이 들어있다.
- 두번째?`next`?는 액션을 다음 미들웨어에게 전달하는 함수이다.
  - `next(action)`?이런 형태로 사용한다.
  - 만약 다음 미들웨어가 없다면 리듀서에게 액션을 전달해준다.
  - 만약에?`next`?를 호출하지 않게 된다면 액션이 무시처리되어 리듀서에게로 전달되지 않는다.
- 세번째?`action`?은 현재 처리하고 있는 액션 객체

- 미들웨어는 위와 같은 구조로 작동한다.
- 리덕스 스토어에는 여러 개의 미들웨어를 등록할 수 있다.
- 새로운 액션이 디스패치 되면 첫 번째로 등록한 미들웨어가 호출된다.
- 만약에 미들웨어에서?`next(action)`을 호출하게 되면 다음 미들웨어로 액션이 넘어간다.
- 그리고 만약 미들웨어에서?`store.dispatch`?를 사용하면 다른 액션을 추가적으로 발생시킬 수 도 있다.

- 아래는 Logger를 사용하는 예시로, 아래처럼 작동한다

```jsx
const myLogger = (store) => (next) => (action) => {
  console.log(action); // 먼저 액션을 출력합니다.
  const result = next(action); // 다음 미들웨어 (또는 리듀서) 에게 액션을 전달합니다.

  // 업데이트 이후의 상태를 조회합니다.
  console.log('\t', store.getState()); // '\t' 는 탭 문자 입니다.

  return result; // 여기서 반환하는 값은 dispatch(action)의 결과물이 됩니다. 기본: undefined
};

export default myLogger;
```

### Thunk를 사용해서 비동기처리 하기

- 미들웨어 안에서는 무엇이든지 할 수 있다.
- 예를 들어서 액션 값을 객체가 아닌 함수도 받아오게 만들어서 액션이 함수타입이면 이를 실행시키게끔 할 수도 있다 (redux-thunk)

```jsx
// thunk
const thunk = (store) => (next) => (action) =>
  typeof action === 'function'
    ? action(store.dispatch, store.getState)
    : next(action);

// 아래처럼 함수를 dispatch 한다
const myThunk = () => (dispatch, getState) => {
  dispatch({ type: 'HELLO' });
  dispatch({ type: 'BYE' });
};

dispatch(myThunk());
// myThunk는 (dispatch, getState)를 인자로 받는 함수를 리턴하기 때문에
// thunk에서 action은 함수가 된다
// 그렇기 때문에 action(store.dispatch, store.getState) 이런 식으로 실행되는 것이다.
```

### ㅇ

- 아래는 thunk를 사용하는 예시이다.

```jsx
// thunk 함수
const getComments = () => (dispatch, getState) => {
  // 이 안에서는 액션을 dispatch 할 수도 있고
  // getState를 사용하여 현재 상태도 조회 할 수 있다.
  const id = getState().post.activeId;

  // 요청이 시작했음을 알리는 액션
  dispatch({ type: 'GET_COMMENTS' });

  // 댓글을 조회하는 프로미스를 반환하는 getComments 가 있다고 가정해보면

  api
    .getComments(id) // 요청을 하고
    .then((comments) =>
      dispatch({ type: 'GET_COMMENTS_SUCCESS', id, comments })
    ) // 성공시
    .catch((e) => dispatch({ type: 'GET_COMMENTS_ERROR', error: e })); // 실패시
};
```

- thunk 함수에서 async/await를 사용할 수 도 있다.

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

### **카운터 딜레이하기**

- 아래는 thunk 함수를 만들고,?`setTimeout`를 사용하여 액션이 디스패치되는 것을 1초씩 딜레이시키는 예시

```jsx
//modules/counter.js

// 액션 타입
const INCREASE = 'INCREASE';
const DECREASE = 'DECREASE';

// 액션 생성 함수
export const increase = () => ({ type: INCREASE });
export const decrease = () => ({ type: DECREASE });

// getState를 쓰지 않는다면 굳이 파라미터로 받아올 필요 없다.
// 아래는 Thunk 함수로 increaseAsync()가 실행되면, 해당 dispatch => {...} 부분이 실행된다
export const increaseAsync = () => (dispatch) => {
  setTimeout(() => dispatch(increase()), 1000);
};
export const decreaseAsync = () => (dispatch) => {
  setTimeout(() => dispatch(decrease()), 1000);
};

// 초깃값 (상태가 객체가 아니라 그냥 숫자여도 상관 없습니다.)
const initialState = 0;

// action으로 thunk 함수가 전달된다
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
윛에;
```

- ㅇ위에서 정의한 아래

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

[리덕스 미들웨어 - 2. 미들웨어 만들어보고 이해하기](https://react.vlpt.us/redux-middleware/02-make-middleware.html)

[리덕스 미들웨어 - 4. redux-thunk](https://react.vlpt.us/redux-middleware/04-redux-thunk.html)

[리덕스 미들웨어 5. redux-thunk로 프로미스 다루기](https://react.vlpt.us/redux-middleware/05-redux-thunk-with-promise.html)
