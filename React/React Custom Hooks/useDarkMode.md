## useDarkmode

- darkmode에 사용하는 hook으로

- 이전에 사용한 useStorage useMediaQuery를 사용한다

```js
// useDarkMode

import { useEffect } from 'react';
import useMediaQuery from '../16-useMediaQuery/useMediaQuery';
import { useLocalStorage } from '../8-useStorage/useStorage';

export default function useDarkMode() {
  const [darkMode, setDarkMode] = useLocalStorage('useDarkMode');
  const prefersDarkMode = useMediaQuery('(prefers-color-scheme: dark)');
  const enabled = darkMode ?? prefersDarkMode;
  // 처음에는 darkMode 값이 undefined이므로 prefersDarkMode에 따라 설정된다
  // prefersDarkMode는 true

  useEffect(() => {
    document.body.classList.toggle('dark-mode', enabled);
  }, [enabled]);

  return [enabled, setDarkMode];
}
```

### Usage

```js
import useDarkMode from './useDarkMode';
import './body.css';

export default function DarkModeComponent() {
  const [darkMode, setDarkMode] = useDarkMode();

  return (
    <button
      onClick={() => setDarkMode((prevDarkMode) => !prevDarkMode)}
      style={{
        border: `1px solid ${darkMode ? 'white' : 'black'}`,
        background: 'none',
        color: darkMode ? 'white' : 'black',
      }}
    >
      Toggle Dark Mode
    </button>
  );
}
```

```js
// useStorage.js

import { useCallback, useState, useEffect } from 'react';

// key : 'useDarkMode' 전달
export function useLocalStorage(key, defaultValue) {
  return useStorage(key, defaultValue, window.localStorage);
}

export function useSessionStorage(key, defaultValue) {
  return useStorage(key, defaultValue, window.sessionStorage);
}

// key : 'useDarkMode' 전달
function useStorage(key, defaultValue, storageObject) {
  const [value, setValue] = useState(() => {
    const jsonValue = storageObject.getItem(key);
    if (jsonValue != null) return JSON.parse(jsonValue);

    if (typeof defaultValue === 'function') {
      return defaultValue();
    } else {
      return defaultValue;
    }
  });

  // setValue로 value 변경시키면 아래 useEffect hook이 실행된다
  useEffect(() => {
    if (value === undefined) return storageObject.removeItem(key);
    storageObject.setItem(key, JSON.stringify(value));
  }, [key, value, storageObject]);

  const remove = useCallback(() => {
    setValue(undefined);
  }, []);

  // localStorage에 등록된 값과
  // localStorage에 값 등록하는 함수 return 받는다
  return [value, setValue, remove];
}
```

```js
// useMediaQuery.js

import { useState, useEffect } from 'react';
import useEventListener from './useEventListener';

// '(prefers-color-scheme: dark)' 전달
export default function useMediaQuery(mediaQuery) {
  const [isMatch, setIsMatch] = useState(false);
  const [mediaQueryList, setMediaQueryList] = useState(null);

  useEffect(() => {
    const list = window.matchMedia(mediaQuery); // media query 객체

    setMediaQueryList(list);
    setIsMatch(list.matches); // 단순히 설정하는 미디어 쿼리이기 때문에 항상 true 가 된다
  }, [mediaQuery]);

  useEventListener('change', (e) => setIsMatch(e.matches), mediaQueryList);

  return isMatch; // 항상 true 반환
}
```

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
