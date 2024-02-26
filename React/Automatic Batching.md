## Automatic Batching

> Batching is when React groups multiple state updates into a single re-render for better performance. Without automatic batching, we only batched updates inside React event handlers. Updates inside of promises, setTimeout, native event handlers, or any other event were not batched in React by default. With automatic batching, these updates will be batched automatically:

<br/>

- Batch Update로 인해 setFirst, setSecond가 한번에 처리되기 때문에 한번만 렌더링이 일어난다.

```jsx
import React, { useState } from "react";

const Test = () => {
  const [first, setFirst] = useState(0);
  const [second, setSecond] = useState(0);

  const handleClick = async () => {
    setFirst(1);
    setSecond(1);
\
  };

  // setFirst, setSecond가 한번에 처리되기 때문에,
  console.log("first", first);
  console.log("second", second);


  // first 1
  // second 1


  return (
    <div style={{ marginTop: "300px" }}>
      <button onClick={handleClick}>Test</button>
    </div>
  );
};

export default Test;
```

<br/>

- 그리고 React.18에서는 Automatic Batching으로 인해, 비동기 함수 안에서 State를 업데이트하더라도 Batch Update가 일어나기 때문에, 렌더링이 한번만 일어난다

```jsx
import React, { useState } from "react";

const Test = () => {
  const [first, setFirst] = useState(0);
  const [second, setSecond] = useState(0);

  const handleClick = async () => {
    Promise.resolve(1).then(() => {
      setFirst(1);
      setSecond(1);
    });
  };

  console.log("first", first);
  console.log("second", second);

  // first 1
  // second 1

  return (
    <div style={{ marginTop: "300px" }}>
      <button onClick={handleClick}>Test</button>
    </div>
  );
};

export default Test;
```

<br/>

- 하지만 아래처럼 State를 업데이트 하는 로직이 비동기 함수 안과 밖에 나누어져 있다면, 별도의 Batch Update를 하기 때문에 두번의 렌더링이 일어나게 된다

```jsx
import React, { useState } from "react";

const Test = () => {
  const [first, setFirst] = useState(0);
  const [second, setSecond] = useState(0);

  const handleClick = async () => {
    setFirst(1);

    Promise.resolve(1).then(() => {
      setSecond(1);
    });
  };

  console.log("first", first);
  console.log("second", second);

  // first 1
  // second 0
  // first 1
  // second 1

  return (
    <div style={{ marginTop: "300px" }}>
      <button onClick={handleClick}>Test</button>
    </div>
  );
};

export default Test;
```

---

- [New Feature: Automatic Batching ](https://react.dev/blog/2022/03/29/react-v18#new-feature-automatic-batching)

- [Automatic batching for fewer renders in React 18](https://github.com/reactwg/react-18/discussions/21)
