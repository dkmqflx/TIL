## SyntheticEvent

- 리액트에서는 브라우저의 native event를 직접 사용하는 것이 아니라 래핑된 이벤트 객체를 사용한다

- 공식문서에서 이를 확인할 수 있다

### React event object

Your event handlers will receive a _React event object._ It is also sometimes known as a “synthetic event”.

```html
<button onClick={e => { console.log(e); // React event object }} />
```

<blockquote>
It conforms to the same standard as the underlying DOM events, but fixes some browser inconsistencies.

<br/>

Some React events do not map directly to the browser’s native events. For example in `onMouseLeave`, `e.nativeEvent` will point to a `mouseout` event. The specific mapping is not part of the public API and may change in the future. If you need the underlying browser event for some reason, read it from `e.nativeEvent`.

</bloquote>

타입 정의를 아래처럼 확인할 수 있다.

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

그리고 이벤트 핸들러에 대한 타입을 확인해보면 SyntheticEvent가 아래처럼 사용되고 있는 것을 확인할 수 있다.

```tsx
// Event Handler Types
// ----------------------------------------------------------------------

type EventHandler<E extends SyntheticEvent<any>> = {
  bivarianceHack(event: E): void;
}["bivarianceHack"];

type ReactEventHandler<T = Element> = EventHandler<SyntheticEvent<T>>;
```

---

## Reference

- [React event object](https://react.dev/reference/react-사dom/components/common#react-event-object)

- [React 이벤트 처리 방식과 SyntheticEvent](https://handhand.tistory.com/287)
