## useMediaQuery

- media query를 등록할 때 사용할 수 있는 custom hook으로

- 이전에 정의한 useEventListener hook을 사용해서 구현할 수 있다

```js
// useEventListener.js
import { useEffect, useRef } from 'react';

export default function useEventListener(
  eventType,
  callback,
  element = window // mediaQuery 객체가 전달된다
) {
  const callbackRef = useRef(callback);

  useEffect(() => {
    callbackRef.current = callback;
  }, [callback]);

  useEffect(() => {
    if (element == null) return;
    const handler = (e) => callbackRef.current(e);
    element.addEventListener(eventType, handler);
    // 전달받은 media query 객체에 이벤트를 등록한다
    // 아래 예제에서는 '(min-width: 200px)'가 전달됬으므로
    // width 가 200px로 변할 때  등록한 이벤트가 실행된다

    return () => element.removeEventListener(eventType, handler);
  }, [eventType, element]);
}
```

```js
// useMediaQuery
import { useState, useEffect } from 'react';
import useEventListener from './useEventListener';

// 등록하고 싶은 media query를 전달한다
export default function useMediaQuery(mediaQuery) {
  const [isMatch, setIsMatch] = useState(false);
  const [mediaQueryList, setMediaQueryList] = useState(null);

  useEffect(() => {
    const list = window.matchMedia(mediaQuery); // media query 객체를 반환한다
    /*
     * media는 사용한 미디어쿼리 문자열을 반환하고,
     * matches는 현재 화면이 미디어쿼리의 범위에 들어가면 true, 아니면 false를 반환해준다.
     */
    setMediaQueryList(list);
    setIsMatch(list.matches); // true or false
  }, [mediaQuery]);

  useEventListener('change', (e) => setIsMatch(e.matches), mediaQueryList);

  return isMatch;
  // media query로 전달된 '(min-width: 200px)'에 따라 최소 200 이상인 경우에만 true가 반환된다
  // 즉  media query의 조건을 만족하는 경우에만 true가 반환된다
}
```

### Usage

```js
import useMediaQuery from './useMediaQuery';

export default function MediaQueryComponent() {
  const isLarge = useMediaQuery('(min-width: 200px)'); // true or false 값이 반환된다

  return <div>Large: {isLarge.toString()}</div>;
}
```
