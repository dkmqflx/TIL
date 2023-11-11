## useEffect, Clean up 함수

### [Step 3: Add cleanup if needed](https://react.dev/learn/synchronizing-with-effects#step-3-add-cleanup-if-needed)

> React will call your cleanup function each time before the Effect runs again, and one final time when the component unmounts (gets removed). Let’s see what happens when the cleanup function is implemented:

- 즉, useEffect의 clean up 함수는 useEffect가 실행될 때 마다 그리고 컴포넌트가 unmount 될 때 실행된다

- 아래는 버튼을 클릭해서 counter 값을 변경시키는 코드로, counter 값이 변경될 때 마다 return 함수에 있는 console.log가 찍히는 것을 확인할 수 있다.

```tsx
import { useEffect, useState } from "react";
import "./styles.css";

export default function App() {
  const [counter, setCount] = useState(0);

  useEffect(() => {
    console.log(`Effect ${counter}`);

    return () => console.log(`Cleanup ${counter}`);
  }, [counter]);

  return (
    <div>
      <p>Counter: {counter}</p>

      <button onClick={() => setCount(counter + 1)}>Click</button>
    </div>
  );
}

// 처음 mount 되었을 때
// Effect 0

// counter를 1로 증가시켰을 때
// Cleanup 0 -> state가 변경되었으므로 useEffect가 다시 실행되기 전에 실행
// Effect 1 -> useEffect가 실행되면서 찍히는 로그

// Cleanup 1 -> state가 변경되었으므로 useEffect가 다시 실행되기 전에 실행
// Effect 2 -> useEffect가 실행되면서 찍히는 로그
```

---

## Reference

- [useEffect - Step 3: Add cleanup if needed ](https://react.dev/learn/synchronizing-with-effects#step-3-add-cleanup-if-needed)
