## useLocalStorage

```js
// useStorage.js
import { useCallback, useState, useEffect } from 'react';

// localStorage를 사용할 때 사용하는 hook
export function useLocalStorage(key, defaultValue) {
  return useStorage(key, defaultValue, window.localStorage);
}

// sessionStorage를 사용할 때 사용하는 hook

export function useSessionStorage(key, defaultValue) {
  return useStorage(key, defaultValue, window.sessionStorage);
}

function useStorage(key, defaultValue, storageObject) {
  // storageObject는 localStorage or storageObject
  // useState 안에 함수를 전달하면, 일반 값을 전달할 때 처럼 처음 렌더링 될 때 단한번만 실행된다
  const [value, setValue] = useState(() => {
    const jsonValue = storageObject.getItem(key); // key에 해당하는 값을 받아온다
    if (jsonValue != null) return JSON.parse(jsonValue);

    if (typeof defaultValue === 'function') {
      return defaultValue(); // defaultValue가 함수인 경우에는 함수 실행
    } else {
      return defaultValue; // item이 없는 경우에는 initialValue 반환
    }
  });

  // setValue로 value 변경시키면 아래 useEffect hook이 실행된다

  useEffect(() => {
    // remove 해서 undefined 되면 아예 제거할 것
    if (value === undefined) return storageObject.removeItem(key);
    storageObject.setItem(key, JSON.stringify(value));
  }, [key, value, storageObject]);

  // 초기화하는데 사용하는 함수
  const remove = useCallback(() => {
    setValue(undefined);
  }, []);

  return [value, setValue, remove];
}
```

### Usage

```js
import { useSessionStorage, useLocalStorage } from './useStorage';

export default function StorageComponent() {
  const [name, setName, removeName] = useSessionStorage('name', 'Kyle');
  const [age, setAge, removeAge] = useLocalStorage('age', 26);

  return (
    <div>
      <div>
        {name} - {age}
      </div>
      <button onClick={() => setName('John')}>Set Name</button>
      <button onClick={() => setAge(40)}>Set Age</button>
      <button onClick={removeName}>Remove Name</button>
      <button onClick={removeAge}>Remove Age</button>
    </div>
  );
}
```
