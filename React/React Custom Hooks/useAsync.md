## useAcync

- 비동기적인 요청을 처리할 때 사용할 수 있는 hook

```js
// useAsync.js

import { useCallback, useEffect, useState } from 'react';

// 비동기적으로 실행할 callback 함수를 전달한다
export default function useAsync(callback, dependencies = []) {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState();
  const [value, setValue] = useState();

  // 1. dep가 변하면 useCallback 으로 Wrapping한 함수가 변한다
  const callbackMemoized = useCallback(() => {
    setLoading(true);
    setError(undefined);
    setValue(undefined);

    callback()
      .then(setValue)
      .catch(setError)
      .finally(() => setLoading(false));
  }, dependencies);

  // 2. useCallback으로 Wrapping 한 함수가 변하면 다시 useEffect hook이 실행된다
  useEffect(() => {
    callbackMemoized();
  }, [callbackMemoized]);

  return { loading, error, value };
}
```

### Usage

```js
import useAsync from './useAsync';

export default function AsyncComponent() {
  // 비동기적으로 실행할 calback 함수를 전달한다
  const { loading, error, value } = useAsync(() => {
    return new Promise((resolve, reject) => {
      const success = false;
      setTimeout(() => {
        success ? resolve('Hi') : reject('Error');
      }, 1000);
    });
  });

  return (
    <div>
      <div>Loading: {loading.toString()}</div>
      <div>{error}</div>
      <div>{value}</div>
    </div>
  );
}
```

- 동적으로 script를 추가할 때도 hook을 사용할 수 있다

```js
import useAsync from './useAsync';

export default function ScriptComponent() {

  const { loading, error, value } = useAsync(() => {
    const script = document.createElement('script');
    script.src = url;
    script.async = true;

    return new Promise((resolve, reject) => {
      script.addEventListener('load', resolve);
      script.addEventListener('error', reject);
      document.body.appendChild(script);
    });
  }, [url]);



  if (loading) return <div>Loading</div>
  if (error) return <div>Error</div>

  return (
    return <div>{window.$(window).width()}</div>
  );
}
```

- 아래처럼 useScript 라는 별도의 Custom Hook으로 처리할 수 있다

```js
import useScript from './useScript';

export default function ScriptComponent() {
  const { loading, error } = useScript(
    'https://code.jquery.com/jquery-3.6.0.min.js'
  );

  if (loading) return <div>Loading</div>;
  if (error) return <div>Error</div>;
  return <div>{window.$(window).width()}</div>;
}
```

```js
import useAsync from '../9-useAsync/useAsync';

export default function useScript(url) {
  return useAsync(() => {
    const script = document.createElement('script');
    script.src = url;
    script.async = true;

    return new Promise((resolve, reject) => {
      script.addEventListener('load', resolve);
      script.addEventListener('error', reject);
      document.body.appendChild(script);
    });
  }, [url]);
}
```
