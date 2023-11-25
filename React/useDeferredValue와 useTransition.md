## useDeferredValue

**`useDeferredValue`** is a React Hook that lets you defer updating a part of the UI.

During the initial render, the **deferred value** will be the same as the **value** you provided.

During updates, the **deferred value** will “lag behind” the latest **value**. In particular, React will first re-render _without_ updating the deferred value, and then try to re-render with the newly received value in background.

### Caveat

- The values you pass to `useDeferredValue` should either be **primitive values (like strings and numbers) or objects created outside of rendering**. If you create a new object during rendering and immediately pass it to `useDeferredValue`, it will be different on every render, causing unnecessary background re-renders.

- `useDeferredValue` is integrated with Suspense If the background update caused by a new value suspends the UI, the user will not see the fallback. They will see the old deferred value until the data loads.

  - 즉, 비동기 fetching을 하는 컴포넌트를 Suspense로 감싸주면, Suspend 상태에는 Suspense의 fallback으로 전달된 컴포넌트를 보게 되지만

  - `useDeferredValue를` 사용하게 되면, 이전 값을 가지고 있기 때문에 Suspend 상태에 이전 값을 보게 된다

### Example

- 아래와 같은 코드가 있다고 할 때, 클릭 버튼을 누르면 `deferredValue` 가 가장 마지막에 업데이트 되는 것을 확인할 수 있다.

- useDeferredValue를 사용하게 되면 해당하는 값은 뒤로 미루고 다른 값들을 먼저 우선적으로 업데이트해준다

```jsx
import { useState, useDeferredValue } from "react";

export default function App() {
  const [count1, setCount1] = useState(0);
  const [count2, setCount2] = useState(0);
  const [count3, setCount3] = useState(0);
  const [count4, setCount4] = useState(0);

  const deferredValue = useDeferredValue(count2);

  const onIncrease = () => {
    setCount1(count1 + 1);
    setCount2(count2 + 1);
    setCount3(count3 + 1);
    setCount4(count4 + 1);
  };

  console.log({ deferredValue });
  console.log({ count1 });
  console.log({ count2 });
  console.log({ count3 });
  console.log({ count4 });

  // {count1: 0}
  // {count2: 0}
  // {count3: 0}
  // {count4: 0}
  // {deferredValue: 0}

  // {count1: 1}
  // {count2: 1}
  // {count3: 1}
  // {count4: 1}
  // {deferredValue: 0}

  // {count1: 1}
  // {count2: 1}
  // {count3: 1}
  // {count4: 1}
  // {deferredValue: 1}, 가장 마지막에 값이 업데이트 된다

  return <button onClick={onIncrease}>클릭</button>;
}
```

---

<br>

## useTransition

**`useTransition`** is a React Hook that lets you update the state without blocking the UI.

**`useTransition`** returns an array with exactly two items:

1. The `isPending` flag that tells you whether there is a pending transition.
2. The `startTransition` function that lets you mark a state update as a transition.

### Caveats

- You can wrap an update into a transition only if you have access to the `set` function of that state. If you want to start a transition in response to some prop or a custom Hook value, try useDeferredValue instead.

- The function you pass to `startTransition` must be synchronous. React immediately executes this function, marking all state updates that happen while it executes as transitions. If you try to perform more state updates later (for example, in a timeout), they won’t be marked as transitions.

### Example

- 아래처럼 코드를 실행하면 onChange가 실행될 때 value는 즉각적으로 값이 변경되지만

- startTransition에 콜백함수로 전달한 setText 를 실행하는 함수는 늦게 실행되고 이에 따라 text도 value가 변경된 다음에 변경되는 것을 알 수 있다.

- 즉, useTransition를 통해서 바로 업데이트 되어야할 것과 나중에 업데이트 되어야할 것을 구분해서 처리할 수 있다.

```jsx
import { useState, useTransition } from "react";

export default function App() {
  const [text, setText] = useState("");
  const [value, setValue] = useState("");
  const [isPending, startTransition] = useTransition();

  const onChange = (e) => {
    startTransition(() => {
      setText(e.target.value);
    });
    setValue(e.target.value);
  };

  console.log({ text, isPending });
  console.log({ value });

  // {text: "", isPending: false}
  // {value: ""}

  // {text: "", isPending: true}
  // {value: "1"}

  // {text: "1", isPending: false}
  // {value: "1"}

  return <input type="text" onChange={onChange} />;
}
```

### **Troubleshooting**

**Updating an input in a transition doesn’t work**

You can’t use a transition for a state variable that controls an input:

```jsx
const [text, setText] = useState("");
// ...
function handleChange(e) {
  // ❌ Can't use transitions for controlled input state
  startTransition(() => {
    setText(e.target.value);
  });
}
// ...
return <input value={text} onChange={handleChange} />;
```

This is because transitions are non-blocking, but updating an input in response to the change event should happen synchronously. If you want to run a transition in response to typing, you have two options:

1. You can declare two separate state variables: one for the input state (which always updates synchronously), and one that you will update in a transition. This lets you control the input using the synchronous state, and pass the transition state variable (which will “lag behind” the input) to the rest of your rendering logic.

2. Alternatively, you can have one state variable, and add useDeferredValue which will “lag behind” the real value. It will trigger non-blocking re-renders to “catch up” with the new value automatically.

---

## Reference

- [useDeferredValue](https://react.dev/reference/react/useDeferredValue)

- [useTransition](https://react.dev/reference/react/useTransition)
