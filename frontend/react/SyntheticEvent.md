## SyntheticEvent

- In React, instead of directly using the browser's native event, a wrapped event object is used.

### React event object

Your event handlers will receive a [React event object](https://ko.legacy.reactjs.org/docs/events.html) It is also sometimes known as a “synthetic event”.

```jsx
<button onClick={e => { console.log(e);
  // React event object
  }} />
버튼
</button>
```

- Your event handlers will be passed instances of SyntheticEvent, a cross-browser wrapper around the browser’s native event.

- It has the same interface as the browser’s native event, including stopPropagation() and preventDefault(), except the events work identically across all browsers.

- It conforms to the same standard as the underlying DOM events, but fixes some browser inconsistencies.

- If you find that you need the underlying browser event for some reason, simply use the **nativeEvent** attribute to get it.

- The synthetic events are different from, and do not map directly to, the browser’s native events.

- For example in onMouseLeave event.nativeEvent will point to a mouseout event.

- The specific mapping is not part of the public API and may change at any time.

<br/>

- The type definition can be verified as follows:

```tsx
interface BaseSyntheticEvent<E = object, C = any, T = any> {
  nativeEvent: E;
  currentTarget: C;
  target: T;
  bubbles: boolean;
  cancelable: boolean;
  defaultPrevented: boolean;
  eventPhase: number;
  isTrusted: boolean;
  preventDefault(): void;
  isDefaultPrevented(): boolean;
  stopPropagation(): void;
  isPropagationStopped(): boolean;
  persist(): void;
  timeStamp: number;
  type: string;
}

interface SyntheticEvent<T = Element, E = Event>
  extends BaseSyntheticEvent<E, EventTarget & T, EventTarget> {}
```

- Also, when checking the type for the event handler, you can see that SyntheticEvent is being used as shown below.

```tsx
// Event Handler Types
// ----------------------------------------------------------------------

type EventHandler<E extends SyntheticEvent<any>> = {
  bivarianceHack(event: E): void;
}["bivarianceHack"];

type ReactEventHandler<T = Element> = EventHandler<SyntheticEvent<T>>;
```

<br/>

- In React, there are cases where type inference may not work correctly when trying to use nativeEvent.

- In the example below, the event object is received, but since the type of the event object is `Event`, an error occurs when trying to access properties present in the `InputEvent` object.

```tsx
const onChange: React.ChangeEventHandler<HTMLInputElement> = (event) => {
  const inputEvent = event.nativeEvent;

  if (inputEvent.inputType === "deleteContentBackward") {
    // Property 'inputType' does not exist on type 'Event'.ts(2339)
  }
};
```

- 이To resolve this, you can either perform type casting,

```tsx
const onChange: React.ChangeEventHandler<HTMLInputElement> = (event) => {
  const inputEvent = event.nativeEvent as InputEvent;

  if (inputEvent.inputType === "deleteContentBackward") {
    //
  }
};
```

- Or use the instanceof operator to implement type guards.

```tsx
const onChange: React.ChangeEventHandler<HTMLInputElement> = (event) => {
  const inputEvent = event.nativeEvent;

  if (
    inputEvent instanceof InputEvent &&
    inputEvent.inputType === "deleteContentBackward"
  ) {
    //
  }
};
```

---

## Reference

- [React- SyntheticEvent](https://legacy.reactjs.org/docs/events.html)

- [React 이벤트 처리 방식과 SyntheticEvent](https://handhand.tistory.com/287)
