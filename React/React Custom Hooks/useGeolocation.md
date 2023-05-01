## useGelocation

- 사용자의 위치를 알 수 있는 hook

```js
import { useState, useEffect } from 'react';

export default function useGeolocation(options) {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState();
  const [data, setData] = useState({});

  useEffect(() => {
    const successHandler = (e) => {
      setLoading(false);
      setError(null);
      setData(e.coords);
    };
    const errorHandler = (e) => {
      setError(e);
      setLoading(false);
    };

    // 1회성으로 현재 위치를 볼 수 있는 방법
    navigator.geolocation.getCurrentPosition(
      successHandler, // sucess callback
      errorHandler, // fail cakkback
      options
    );

    // 사용자가 움직이는 것을 계속 추적
    const id = navigator.geolocation.watchPosition(
      successHandler,
      errorHandler,
      options
    );
    return () => navigator.geolocation.clearWatch(id);
  }, [options]);

  return { loading, error, data };
}
```

### Usage

```js
import useGeolocation from './useGeolocation';

export default function GeolocationComponent() {
  const {
    loading,
    error,
    data: { latitude, longitude },
  } = useGeolocation();

  return (
    <>
      <div>Loading: {loading.toString()}</div>
      <div>Error: {error?.message}</div>
      <div>
        {latitude} x {longitude}
      </div>
    </>
  );
}
```
