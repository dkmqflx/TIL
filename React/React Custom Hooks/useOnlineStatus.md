## useOnlineStatus

- 현재 브라우저가 온라인인지, 오프라인 상태인지 알 수 있는 hook

- useEventListner hook과 사용한다

```js
import { useState } from 'react';
import useEventListener from './useEventListener';

export default function useOnlineStatus() {
  const [online, setOnline] = useState(navigator.onLine);

  useEventListener('online', () => setOnline(navigator.onLine));
  useEventListener('offline', () => setOnline(navigator.onLine));

  return online;
}
```

### Usage

```js
import useOnlineStatus from './useOnlineStatus';

export default function OnlineStatusComponent() {
  const online = useOnlineStatus();

  return <div>{online.toString()}</div>;
}
```
