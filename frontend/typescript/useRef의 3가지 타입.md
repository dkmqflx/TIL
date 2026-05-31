### useRef

- useRef의 타입은 총 세가지 이다

- 그렇기 때문에 선언한 곳의 useRef를 클릭해서 어디에서 걸리는지를 확인해보아야 한다

```ts
// 1.
function useRef<T>(initialValue: T): MutableRefObject<T>;

interface MutableRefObject<T> {
  current: T;
}

// 2.
function useRef<T>(initialValue: T | null): RefObject<T>;

interface RefObject<T> {
  readonly current: T | null;
}

// 3.
function useRef<T = undefined>(): MutableRefObject<T | undefined>;
```

- 아래와 같은 코드가 있을 때 useRef를 클릭해 보면 useRef의 첫번째 케이스에 걸리게 되는 것을 확인할 수 있다.

```tsx
import React, { useRef } from "react";

const App = () => {
  const inputRef = useRef(null);

  return (
    <div>
      <input ref={inputRef} />
    </div>
  );
};

export default App;
```

- null을 전달했는데 두번째 케이스가 아니라 첫번째 케이스에 걸리는 이유는 initialValue인 T가 null로 되기 때문이다

- T 또는 null을 갖는 RefObject로 인식하게 만들게 하기 위해서는 제네릭을 사용해야 한다.

```ts
function useRef<null>(initialValue: null): MutableRefObject<null>;
```

- RefObject로 인식하게 하기 위해서는 코드를 아래와 같이 제네릭으로 타입에 대한 정보를 전달해주는 방식으로 수정해주어야 한다.

```ts
const inputEl = useRef<HTMLInputElement>(null);
// RefObject
// null 까지 함께 넣어주어야 한다

// 그 이유는 아래처럼 null이 없으면 T가 undefined가 되어 세번째 케이스에 걸리게 되기 때문이다
// const inputEl = useRef<HTMLInputElement>()
```

- 이처럼 RefObject는 DOM과 같은 요소에 연결하기 위해 사용하는 타입이다.

- 이렇게 코드를 수정한 다음 다시 ref를 클릭해보면 RefObject인 두번째 케이스에 걸리는 것을 확인할 수 있다.

<br/>

- 타입에서 확인할 수 있듯이 RefObject의 current의 readonly 이기 때문에 수정할 수 없다.

- 하지만 MutableRefObject는 이름에서도 알 수 있듯이 Mutable한 Object를 참고할 때 사용하는 용도이기 때문에 아래 예시처럼 값을 저장하는 용도로 사용한다

```ts
const n = useRef(0); // MutableRefObject
n.current += 1;
```
