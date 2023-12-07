타입을 모를 때 Generic을 사용하는게 더 안전하다

아래처럼 parameter의 타입을 지정하지 않으면 any로 추론되지만, Generic을 사용하게 되면, 런타임에 T 타입이 정해진다

```tsx
const foo = (value) => {
  return value;
};

const a = foo(1);
type A = typeof a; // any

const foo2 = <T,>(value: T) => {
  return value;
};

const b = foo2(1); // 1
type B = typeof b; // 1
```

타입을 더 구체적으로 제한하고 싶은 경우 `extends` 키워드를 사용한다

```tsx
const foo2 = <T extends string>(value: T) => {
  return value;
};

const b = foo2(1); // error

const b = foo2("1"); // 1
```
