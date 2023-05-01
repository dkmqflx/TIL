## useDebounce 1

- useDebounde hook은 debounce를 구현한 Hook으로

- 짧은 시간 내의 연속된 함수나 event 호출 시, 호출되는 모든 함수를 모두 처리하지 않고

- 정해진 딜레이 이후에 한번만 처리하는 패턴이다

- Use Case

  - 겁색어 (input) 입력과 동시에 네트워크 요청을 통해 겁색 결과를 가져와야 할 때

  - 스크롤 / resize 이벤트 바탕으로 작업해야 할 때

  - 문서 편집 자동 저장

- 장점

  - 전반적인 성능 향상

  - 비용 절약 (API / 서비스 사용)

```js
// useDebounce.js
import { useEffect, useState } from 'react';

function useDebounce(value, delay = 500) {
  const [debounceVal, setDebounceVal] = useState(value);

  // 사용자가 계속 입력할 때 마다 새로운 value가 전달되어
  // 아래 hook은 계속해서 새로운 handler를 등록하게 된다
  // 그리고 마지막 입력이 끝난 후 delay가 지나면 새로운 debounceVal을 set 한다
  useEffect(() => {
    const handler = setTimeout(() => {
      setDebounceVal(value);
    }, delay);

    // umount 시 clear
    return () => {
      clearTimeout(handler);
    };
  }, [value, delay]);

  return debounceVal;
  // delay가 지난 다음에 변경된 값이 return 된다
}

export default useDebounce;
```

### Usage 1

```js
import { useEffect, useState } from 'react';
import './App.css';

import useDebounce from './useDebounce';

function CountryList({ countries }) {
  if (!countries) return;
  return countries.map((country) => {
    return (
      <div key={`${country.area}`}>
        <span>{country.name.official}</span>{' '}
        <img
          style={{ width: '120px', height: '80px' }}
          src={country.flags.png}
          alt={country.name.common}
        />
      </div>
    );
  });
}

export default function App() {
  const [search, setSearch] = useState('');
  const [countries, setCountries] = useState(null);

  // 사용자가 값을 입력할 때 마다 onChange 함수가 실행되고
  // 변경된 search 값이 전달된다.
  // 마지막 입력이 끝난 다음 delay 후에 update된 값이 반환된다
  const debounceValue = useDebounce(search);

  // debounceValue 는 search가 변경될 때 마다 바뀌는 것이 아니라
  // 마지막 입력이 끝난 다음 delay 후에 update된 값이기 때문에,
  // 마지막 입력이 끝나게 되면 아래 useEffect hook이 실행된다
  useEffect(() => {
    const getCountries = async () => {
      return await fetch(`https://restcountries.com/v3.1/name/${debounceValue}`)
        .then((res) => {
          if (!res.ok) {
            return new Promise.reject('no country found');
          }
          return res.json();
        })
        .then((list) => {
          setCountries(list);
        })
        .catch((err) => console.error(err));
    };
    if (debounceValue) getCountries();
  }, [debounceValue]);

  return (
    <div className='App'>
      <input
        type='search'
        placeholder='Search Countries'
        onChange={(e) => setSearch(e.target.value)}
      />
      <hr />
      {search ? <CountryList countries={countries} /> : ''}
    </div>
  );
}
```

## useDebounde 2

- Custom hook으로 정의한 useTimeout을 사용해서 useDebounce를 구현할 수도 있다.

```js
// useTimeout.js

import { useCallback, useEffect, useRef } from 'react';

export default function useTimeout(callback, delay) {
  const callbackRef = useRef(callback); // callback 함수 등록
  const timeoutRef = useRef();

  // callback 함수가 변경될 때 마다 실행되는 hook
  useEffect(() => {
    callbackRef.current = callback;
  }, [callback]);

  // 아래 함수에서 useCallback으로 감싸준 이유는
  // useTimeout을 사용하는 외부 컴포넌트에서 다시 렌더링 될 때 마다
  // callback 함수도 반복해서 전달되기 때문에, 불필요한 렌더링을 막기 위해서 useCallback을 사용했다.

  // timeout set
  const set = useCallback(() => {
    // delay 후에 실행된다
    timeoutRef.current = setTimeout(() => callbackRef.current(), delay);
  }, [delay]);

  // timeout clear
  // reset 실행하더라도, clear 함수실행해서 timeout을 없애면, reset이 실행되지 않는다
  const clear = useCallback(() => {
    timeoutRef.current && clearTimeout(timeoutRef.current);
  }, []);

  useEffect(() => {
    set();
    // set 함수 실행하면, setTimeout에 등록한 콜백 함수 실행된다
    return clear;
    // unmount시, 등록한 setTimeout clear 해준다.
  }, [delay, set, clear]);

  // 다시 timeout reset 하는 함수
  const reset = useCallback(() => {
    clear(); // timeout clear
    set(); // 다시
  }, [clear, set]);

  return { reset, clear };
}
```

```js
// useDebounce.js
import { useEffect } from 'react';
import useTimeout from '../2-useTimeout/useTimeout';

export default function useDebounce(callback, delay, dependencies) {
  const { reset, clear } = useTimeout(callback, delay);
  useEffect(reset, [...dependencies, reset]); // dep 값이 바뀔 때 마다 reset 해준다
  useEffect(clear, []);
  // clear 해주는 이유는 useTimeout에 callback 함수를 전달하는데
  // 위에서 reset 함수를 실행하더라도 clear(), set()으로 다시 set 되기 때문에
  // clear를 해주어야 처음 실행되지가 않는다
  // 만약 해당 부분 주석 처리하면, clear() 후 set()이 실행되어  바로 callback 함수가 실행된다
  // 따라서 이렇게 clear 해주는 것은 처음에 callback 함수가 실행되지 않도록 하기 위함이다
}
```

### Usage 2
