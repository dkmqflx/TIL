- 외부에서 컴포넌트를 전달받을 때 아래와 같은 타입을 컴포넌트 타입으로 지정할 수 있다.

  - ReactNode

  - ReactElement

  - JSX.Element

  - PropsWithChildren

## ReactNode

- ReactNode는 ReactElement를 비롯하여 대부분의 자바스크립트 데이터 타입을 아우르는 범용적인 타입이다.

- 즉 `string`, `null`, `undefined` 등을 포함하는 가장 넓은 범위를 갖는 타입.

- 따라서 어떤 props을 받을 건데, 구체적으로 어떤 타입이 올지 알 수 없거나, 어떠한 타입도 모두 받고 싶다면 ReactNode로 지정해주는 것이 좋다.

```tsx
type ReactNode =
  | ReactChild
  | ReactFragment
  | ReactPortal
  | boolean
  | null
  | undefined;

type ReactChild = ReactElement | ReactText;

type ReactText = string | number;
```

## ReactElement

- ReactElement는 type, props, key를 갖는다.

- `ReactNode` 와는 달리 원시 타입을 허용하지 않고 완성된 `jsx` 요소만을 허용한다.

- 위의 `ReactNode` 타입 에서 확인할 수 있듯이 `ReactElement` 타입은 `ReactNode` 타입에 포함된다.

```tsx
interface ReactElement<
  P = any,
  T extends string | JSXElementConstructor<any> =
    | string
    | JSXElementConstructor<any>
> {
  type: T;
  props: P;
  key: Key | null;
}

type JSXElementConstructor<P> =
  | ((props: P) => ReactElement<any, any> | null)
  | (new (props: P) => Component<any, any>);
```

- 여기서 type의 타입인 T는 해당 HTML 태그의 타입이고, P는 그 외의 컴포넌트가 전달 받는 props의 타입이다

### JSX.Element

- JSX.Element는 ReactElement의 제네릭 P와 T 타입을 모두 any로 받아 확장한 인터페이스다.

- 따라서 더 범용적으로 사용할 수 있다.

```tsx
declare global {
  namespace JSX {
    interface Element extends React.ReactElement<any, any> {}
  }
}

declare namespace React {
  interface ReactElement<
    P = any,
    T extends string | JSXElementConstructor<any> =
      | string
      | JSXElementConstructor<any>
  > {
    type: T;
    props: P;
    key: Key | null;
  }
}
```

- 그리고 React 관련 타입은 모두 React의 namespace에서 선언되어 있는데, JSX는 global namespace로 선언되어 있다.

- 따라서 React 내에서 JSX를 import하지 않아도 바로 사용이 가능하다.

## PropsWithChildren

- React 18에서 추가된 타입

- `PropsWithChildren`타입은 말 그대로 `children`을 가진 `props` 타입을 의미한다.

```tsx
type PropsWithChildren<P> = P & { children?: ReactNode | undefined };
```

- `PropsWithChildren`은 아래와 같이 Generic과 함께 사용하면 된다.

```tsx
import { PropsWithChildren } from "react";

type MyComponentProps = PropsWithChildren<{
  title: string;
}>;

function MyComponent(props: MyComponentProps) {
  const { title, children } = props;

  return (
    <div>
      <p>{title}</p>
      {children}
    </div>
  );
}

export default MyComponent;
```

## Reference

- [ReactNode vs. JSX.Element 그리고 ReactElement](https://www.howdy-mj.me/react/react-node-and-jsx-element)

- [ReactNode, ReactChild, ReactElement 타입 비교](https://merrily-code.tistory.com/209)

- [React + TypeScript의 PropsWithChildren](https://www.frontoverflow.com/question/11/React%20+%20TypeScript%EC%9D%98%20PropsWithChildren)
