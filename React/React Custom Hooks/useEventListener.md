## useEventListener

- useEventListener은 이벤트를 등록하기 위한 Custom Hook이다

- 아래와 같이 eventType, callbck, 그리고 이벤트를 등록할 element를 전달할 수 있다

```js
// useEventListener.js
import { useEffect, useRef } from 'react';

export default function useEventListener(
  eventType,
  callback,
  element = window
) {
  useEffect(() => {
    if (element == null) return;
    element.addEventListener(eventType, callback);

    return () => element.removeEventListener(eventType, callback);
  }, [eventType, element, callback]);
}
```

- 다만 이렇게 dependency에 모두 등록해서 한가지가 변하게 되는 경우 useEffect hook을 실행하는 것 보다

- 아래처럼 callback 함수에 대한 hook을 분리할 수 있다

```js
// useEventListener.js

import { useEffect, useRef } from 'react';

export default function useEventListener(
  eventType,
  callback,
  element = window
) {
  const callbackRef = useRef(callback);

  useEffect(() => {
    callbackRef.current = callback;
  }, [callback]);

  useEffect(() => {
    if (element == null) return;
    const handler = (e) => callbackRef.current(e);
    element.addEventListener(eventType, handler);

    return () => element.removeEventListener(eventType, handler);
  }, [eventType, element]);
}
```

### Usage

```js
import useEventListener from './useEventListener';

import { useState } from 'react';
import useEventListener from './useEventListener';

export default function EventListenerComponent() {
  const [key, setKey] = useState('');

  useEventListener('keydown', (e) => {
    setKey(e.key);
  });

  return <div>Last Key: {key}</div>;
}
```
