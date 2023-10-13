- [타입스크립트 타입선언 vs 타입 표명](#타입스크립트-타입선언-타입표명)
- [함수 표현식에 타입을 쓸때](#함수표현식에-타입을-쓸때)
- [타입이 반복될때에는 이렇게 해보세요](#타입이-반복될때에는-이렇게-해보세요)
- [타입스크립트 제네릭 함수 사용법](#타입스크립트-제네릭함수-사용법)
- [HTML element 확장과 쉽게 props 타입 지정 하는 방법 설명 | 리액트+타입스크립트](#타입스크립트-element-props)
- [타입스크립트: 리터럴(literal) 타입 활용 방법과 예시](#타입스크립트-리터럴타입)
- [Polymorphic 컴포넌트를 사용한 유연한 UI 개발 패턴 소개](#타입스크립트-Polymorphic)

## [타입스크립트 타입선언 vs 타입 표명](https://www.youtube.com/watch?v=AG_hB-0ozIE) <a id="타입스크립트-타입선언-타입표명"></a>

- DOM의 특정 property에 접근하려고 할 때 해당하는 property가 없다는 에러가 나타나는 경우가 있다

```ts
const el = document.getElementById("email");
el.value; // (method) Document.getElementById(elementId: string): HTMLElement | null

// property 'value' does not exist on type 'HTMLElement'.ts(2339)
```

- 그 이유는 getElementById의 return 타입을 보면 이해할 수 있는데, getElementById의 return 타입 아래와 같이` HTMLElement | null` 이고 HTMLElement에는 vlalue라는 속성이 없기 때문에 에러가 발생하는 것이다

- 이러한 경우에 **타입 표명 (Type Assertion)**으로 해결할 수 있다

```ts
const el = document.getElementById("email") as HTMLInputElement;

const el = <HTMLInputElement>document.getElementById("email");

el.value;
```

- 일반적으로 DOM에 접근할 때 많이 사용하는 `querySelector`를 사용할 때도 이러한 에러를 마주치게 된다

```ts
const el2 = document.querySelector(".email");
el2?.value;

// (method) ParentNode.querySelector<Element>(selectors: string): Element | null (+4 overloads)
```

- querySelector 같은 경우에는 위 에러에서 확인할 수 있듯이 제네릭을 사용할 수 있는데 querySelector의 타입을 보면 다음과 같다

```ts

querySelector<E extends Element = Element>(selectors: string): E | null;

```

- 따라서 제네릭으로 return 타입을 지정해주면 타입 표명 없이 코드를 작성할 수 있다.

```ts
const el2 = document.querySelector<HTMLInputElement>(".email");
el2?.value;
```

## [함수 표현식에 타입을 쓸때](https://www.youtube.com/watch?v=FuNUjnJhT1w) <a id="함수표현식에-타입을-쓸때"></a>

- 아래는 함수 선언식으로 작성된 코드이다.

```ts
function add(x: number, y: number): number {
  return x + y;
}

function subtract(x: number, y: number): number {
  return x - y;
}
```

- 코드를 보면 유사한 파라미터의 타입과 리턴 타입이 반복되는 것을 확인할 수 있는데

- 이처럼 함수의 파라미터 타입과 리턴 타입이 유사할 때 함수 표현식으로 이를 해결할 수 있다

- 우선 위 코드를 함수 표현식으로 나타내면 아래와 같다

```ts
const add = (x: number, y: number): number => x + y;

const subtract = (x: number, y: number): number => x - y;
```

- 그리고 파라미터와 리턴 타입에 해당하는 타입을 정의해주고, 아래와 같이 코드를 수정해준다

```ts
type MathType = (x: number, y: number) => number;

const add: MathType = (x, y) => x + y;

const subtract: MathType = (x, y) => x - y;
```

- 이렇게 코드를 수정해주면 반복적인 코드를 제거할 수 있고 가독성도 높일 수 있다.

<br/>

- rest parameter의 경우에도 아래처럼 타입을 지정해줄 수 있다

```ts
type SumAllType = (a: number, ...rest: Array<number>) => number;

const sumAll: SumAllType = (a, ...rest) => {
  return rest.reduce((acc, n) => acc + n, a);
};
```

- 아래는 또 다른 예제로 여러개의 파라미터가 전달되고 있다

- 이러한 코드는 확장성을 고려했을 때 가독성과 유지보수 측면에서 좋지 않다

```ts
const printUser = (userId: number, name: string, skills: string[]): string => {
  return `${userId} ${name} ${skills.join(" ")}`;
};
```

- printUser의 인자로 전달되는 user 정보를 담고 있는 객체가 어플리케이션 내부에서 반복적으로 사용되고 공유된다면 별도의 타입으로 지정해주는 것이 좋다

- 코드를 아래와 같이 수정해줄 수 있다.

```ts
interface User {
  userId: number;
  name: string;
  skills: string[];
}

type PrintUserFn = (user: User) => string;

// destructuring 해서 값을 가져올 수 있다.
const printUser: PrintUserFn = ({ userId, name, skills }) => {
  return `${userId} ${name} ${skills.join(" ")}`;
};
```

- 이렇게 코드를 수정해주면 인터페이스 User 타입에 변경이 생기더라도 PrintUserFn의 타입은 수정할 필요가 없다

- printUser의 파라미터에 대해서만 수정을 해주면 된다

<br/>

- 오브젝트 메서드의 경우에도 이렇게 별도로 타입을 정의하고 사용할 수 있다.

- 아래처럼 오브젝트 메서드가 있는 경우 일일이 파라미터와 리턴 타입을 지정해주어야 하기 때문에 직접적으로 타입을 지정하기 어렵고 번거롭다

```ts
const mahtObj = {
  add(a: number, b: number): number {
    return a + b;
  },
};
```

- 그래서 아래처럼 타입을 정의해준 다음에 오브젝트의 타입으로 지정해줄 수 있다

```ts
const mahtObj: MathFn = {
  add(a, b) {
    return a + b;
  },
};

type MathFn = {
  add: (a: number, b: number) => number;
};
```

- 또 다른 방법으로는 함수의 타입을 직접 정의할 수 있다.

```ts
type AddFn = (a: number, b: number) => number;

const mahtObj: {
  add: AddFn;
} = {
  add(a, b) {
    return a + b;
  },
};
```

## [타입이 반복될때에는 이렇게 해보세요](https://www.youtube.com/watch?v=Gm91L9Aq0mM&t=4s) <a id="타입이-반복될때에는-이렇게-해보세요"></a>

- 아래 인터페이스를 보면 firstName, lastName이 반복되고 있다

- 만약 Student 인터페이스에 age와 같이 추가적인 속성이 생긴다고 했을 때 Student 인터페이스 사용하고 있는 모든 곳에서 업데이트 해주어야 한다

```ts
interface Student {
  firstName: string;
  lastName: string;
}

interface StudentWithGrades {
  firstName: string;
  lastName: string;
  grades: number;
}
```

- 이렇게 반복되는 타입을 인터페이스의 `extends` 키워드를 사용할 수 있다

```ts
interface Student {
  firstName: string;
  lastName: string;
}

interface StudentWithGrades extends Student {
  grades: number;
}
```

- type 키워드를 사용해서도 동일한 타입을 정의해 줄 수 있다

```ts
type StudentWithGrades = Student & {
  grades: number;
};
```

- 또 다른 예제는 아래와 같다

- 전역에서 사용되는 Config, 특정 구역에서만 사용되는 MenuConfig가 있고 반복적인 패턴이 보이는 것을 확인할 수 있다

```ts
interface Config {
  appId: number;
  clientSecret: string;
  testUrl: string;
  updated: Date;
}

interface MenuConfig {
  appId: number;
  clientSecret: string;
}

const cfg: Config = {
  appId: 1001,
  clientSecret: "sdfadsf",
  testUrl: "https://www.sdfilaf.com",
  updated: new Date(),
};

const menuCfg: MenuConfig = {
  appId: 1002,
  clientSecret: "sdfadsf",
};
```

- extends를 사용할 수도 있지만 아래처럼 index 사용해서 타입을 참조 하는 방법을 사용할 수 있다

```ts
type MenuConfigIndexed = {
  appId: Config["appId"];
  clientSecret: Config["clientSecret"];
};

const menuCfg: MenuConfigIndexed = {
  appId: 1002,
  clientSecret: "sdfadsf",
};
```

- 하지만 이러한 방법 역시 `Config[" "]` 와 같은 부분이 반복되고 있다

- 이러한 문제를 mapped type 방식으로 해결할 수 있는데 아래처럼 코드를 작성할 수 있다.

  - [Mapped Type 이란 ?](https://joshua1988.github.io/ts/usage/mapped-type.html#%EB%A7%B5%EB%93%9C-%ED%83%80%EC%9E%85-mapped-type-%EC%9D%B4%EB%9E%80)

    - 맵드 타입이란 기존에 정의되어 있는 타입을 새로운 타입으로 변환해 주는 문법을 의미합니다.

    - 마치 자바스크립트 map() API 함수를 타입에 적용한 것과 같은 효과를 가집니다.

```ts
type MenuConfigMapped = {
  [k in "appId" | "clientSecret"]: Config[k];
};

const menuCfg: MenuConfigMapped = {
  appId: 1002,
  clientSecret: "sdfadsf",
};


// 맵드 타입의 기본 문법
{ [ P in K ] : T }
{ [ P in K ]? : T }
{ readonly [ P in K ] : T }
{ readonly [ P in K ]? : T }
```

- 유틸리티 타입(Utility Type)을 사용하는 방법도 있다

- 아래처럼 특정 타입을 뽑아 사용하는 Pick을 사용하거나

```ts
type MenuConfigPick = Pick<MenuConfig, "appId" | "clientSecret">;
```

- Omit을 사용해서 누락할 property를 전달해서 똑같은 타입을 정의할 수 도 있다.

```ts
type MenuConfigOmit = Omit<MenuConfig, "testUrl" | "updated">;
```

## [타입스크립트 제네릭 함수 사용법](https://www.youtube.com/watch?v=vWbvj1iNmzY) <a id="타입스크립트-제네릭함수-사용법"></a>

- 아래와 같은 코드가 있을 때 함수가 리턴하는 data를 제네릭으로 만들고 싶다면

```ts
interface FetchResponse {
  status: number;
  headers: Headers;
  data: any;
}

async function fetchJson(url: string): Promise<FetchResponse> {
  const response = await fetch(url);
  return {
    headers: response.headers,
    status: response.status,
    data: await response.json(),
  };
}
```

- 아래처럼 코드를 수정해주면 된다

```ts
interface FetchResponse<T> {
  status: number;
  headers: Headers;
  data: T;
}

// 함수의 제네릭으로 타입을 전달해줌으로써 Response data의 타입을 지정할 수 있게 된다.
async function fetchJson<T>(url: string): Promise<FetchResponse<T>> {
  const response = await fetch(url);
  return {
    headers: response.headers,
    status: response.status,
    data: await response.json(),
  };
}

interface User {
  id: number;
  name: string;
}

const { data } = await fetchJson<User>("api url");
```

## [HTML element 확장과 쉽게 props 타입 지정 하는 방법 설명 | 리액트+타입스크립트](https://www.youtube.com/watch?v=KlH4p9FbKPg) <a id="타입스크립트-element-props"></a>

- 아래는 button elment를 반환하는 Button 컴포넌트가 있는 코드이다

- Button 컴포넌트 같은 경우에는 확장해서 사용할 수 있는데

- html button 요소에 prop을 전달하거나 상황에 따라 custom prop을 전달해서 많이 사용한다

```tsx
import React from "react";

export const Button = () => {
  return <button></button>;
};

export default function Index() {
  return (
    <div>
      <Button>OK</Button>
    </div>
  );
}
```

- 가장 흔하게 사용되는 prop이 전달되는 아래의 경우에는 props 맞는 타입을 직접 지정해주는 방법이 있다

```tsx
import React from "react";

type ButtonProps = {
  onClick: () => void;
  className: string;
  type: "submit" | "reset" | "button";
};

export const Button = ({ onClick, className, type }: ButtonProps) => {
  return <button onClick={onClick} className={className} type={type}></button>;
};

export default function Index() {
  return (
    <div>
      <Button
        onClick={() => alert("test")}
        className="btn-default"
        type="submit"
      >
        OK
      </Button>
    </div>
  );
}
```

- 하지만 이렇게 코드를 작성할 필요 없이 리액트에서 기본 타입을 제공해주기 때문에 아래처럼 제공되는 유틸리티 타입을 사용하면 된다

```tsx
import React from "react";

type ButtonProps = React.ComponentPropsWithoutRef<"button">;

export const Button = (props: ButtonProps) => {
  const { onClick, className, type } = props;

  return <button></button>;
};

export default function Index() {
  return (
    <div>
      <Button
        onClick={() => alert("test")}
        className="btn-default"
        type="submit"
      >
        OK
      </Button>
    </div>
  );
}
```

- 다만 이렇게 props를 destructuring하는 경우에는 필요한 모든 property를 가져와야 하는 단점이 있기 때문에

- 아래처럼 rest parameter를 사용해준다

- 이렇게 해서 간편하게 props의 타입을 지정해 줄 수 있고 코드도 훨씬 더 깔끔해졌다

```tsx
import React from "react";

type ButtonProps = React.ComponentPropsWithoutRef<"button">;

export const Button = (props: ButtonProps) => {
  const { children, ...rest } = props;

  return <button {...rest}>{children}</button>;
};

export default function Index() {
  return (
    <div>
      <Button
        onClick={() => alert("test")}
        className="btn-default"
        type="submit"
      >
        OK
      </Button>
    </div>
  );
}
```

- 추가적으로 custom prop을 사용하고 싶은 경우가 있을 수 있다

- 아래처럼 useAnimation이라는 props를 전달한다고 하자

- 그러면 간단하게 &를 사용해서 intersection 타입으로 만들어주면 된다

```tsx
import React from "react";

type ButtonProps = React.ComponentPropsWithoutRef<"button"> & {
  useAnimation?: boolean;
};

export const Button = (props: ButtonProps) => {
  const { children, useAnimation, ...rest } = props;

  if (useAnimation) {
    // 필요한 로직 작성
  }
  return <button {...rest}>{children}</button>;
};

export default function Index() {
  return (
    <div>
      <Button
        useAnimation={true}
        onClick={() => alert("test")}
        className="btn-default"
        type="submit"
      >
        OK
      </Button>
    </div>
  );
}
```

## [타입스크립트: 리터럴(literal) 타입 활용 방법과 예시](https://www.youtube.com/watch?v=BQTB9KWYb6A&t=18s) <a id="타입스크립트-리터럴타입"></a>

- 리터럴 타입이란 값 자체를 타입으로 사용하는 것으로

- 리터럴 타입의 `const assertion (as const)` 문법은 리터럴 타입을 사용할 수 있는 방법 중 하나이다

- 리터럴 타입을 사용하는 가장 간단한 예제는 다음과 같다

```ts
type ImageType = "png";

const imageType: ImageType = "png";

const imageTyp2: ImageType = "jpg"; // 에러 발생
```

- 유니언(union) 타입을 지정할 때도 리터럴 타입이 많이 사용된다

```ts
type Direction = "left" | "right" | "up" | "down";

function naviage(dir: Direction) {
  console.log(dir);
}

naviage("left");

naviage("back"); // 에러 발생
```

- UI 작업할 때 스타일 타입을 지정할 때도 유용하게 사용할 수 있다

- 아래는 버튼의 스타일의 타입을 정의하는 케이스이다

```ts
type btnType = "btn-default" | "btn-error" | "btn-success"; // 타입

type btnSize = "sm" | "md" | "lg"; // 사이즈

type btnColor = "red" | "blue" | "green"; // 색상

// 3 * 3 * 3 총 27가지 조합이 전달될 수 있다

// 템플릿 스트링 활용해서 만든다

// 하나의 타입으로 다양한 조합을 전달할 수 있게 된다
```

- 3가지 타입이 있으몰 `3 * 3 * 3` 총 27가지의 조합이 전달될 수 있다

- 이러한 경우 템플릿 리터럴을 활용해서 아래처럼 리터럴 타입을 지정하게 되면 하나의 타입으로 다양한 조합을 전달할 수 있게 된다

```ts
type buttonStyle = `${btnType}-${btnSize}-${btnColor}`;
```

- css, className 또는 스타일을 조합해서 다른 변수나 함수에 전달할 때 유용하게 사용할 수 있다

- 예를들어 아래와 같이 class를 추가하는 함수가 있을 때 위에서 정의한 스타일 타입을 사용할 수 있다

```ts
const addStyle = (el: HTMLElement, style: buttonStyle) => {
  el?.classList.add(style);
};
```

- 리터럴 타입에 `as const`를 사용할 수 도 있다

- 아래와 같은 객체가 있다고 하자

```ts
const languageCode = {
  en: "English",
  es: "Spanish",
  fr: "French",
  kr: "Korean",
};
```

- 객체에는 타입 적용이 안 되어있기 때문에 타입을 보면 아래와 같다

```ts
const languageCode = {
  en: "string",
  es: "string",
  fr: "string",
  kr: "string",
};
```

- const나 let일 때 모두 객체의 속성은 변경할 수 있기에 타입스크립트가 string으로 추론한 것이다.

- 아래처럼 객체의 property의 값을 string으로 변경할 수 있다

```ts
languageCode.en = "ENGLISH";
```

- 하지만 `as const` 를 사용하게 되면 리터럴 타입이 되고

```ts
const languageCode = {
  en: "English",
  es: "Spanish",
  fr: "French",
  kr: "Korean",
} as const;
```

- 타입을 확인해보면 아래와 같이 되어 있는 것을 확인할 수 있다

```ts
const languageCode: {
  readonly en: "English";
  readonly es: "Spanish";
  readonly fr: "French";
  readonly kr: "Korean";
};
```

- readonly 속성 에다가 값 자체가 타입이 되기 때문에 아래처럼 객체의 property를 수정할 수 없게 된다

```ts
languageCode.en = "ENGLISH"; // 에러 발생
```

## [Polymorphic 컴포넌트를 사용한 유연한 UI 개발 패턴 소개](https://www.youtube.com/watch?v=BUlvBT8lhFc&list=PL3xNAKVIm80LIjR0lOHauH6ZRkfCXbsyW&index=6) <a id="타입스크립트-Polymorphic"></a>

- Polymorphic(다형성)이란 다양한 형태로 변형이 되는 것으로,

- 하나의 컴포넌트가 있고 다양한 형태로 변형되서 사용할 수 있게 만들어주는 패턴을 말한다

```tsx
/* Polymorphic Component

Text 컴포넌트 생성

요구사항
1. Text 컴포넌트는 as (prop)을 통해 다양한 태그를 렌더링 할 수 있어야 한다
2. as prop의 기본 값은 span으로 지정한다
3. as prop의 값에 따라 다른 태그를 렌더링 할 수 있어야 한다.

*/

const Text = () => {};

// Text 컴포넌트는 아래처럼 사용할 수 있어야 한다.
export default function Index() {
  return (
    <>
      <Text>Hello</Text>
      <Text as="h1">Title Text</Text>
      <Text as="b">Bold Text</Text>
      <Text as="a" href="google.com">
        Link Text
      </Text>
    </>
  );
}
```

- 위와 같이 사용할 수 있는 Text 컴포넌트를 아래처럼 필요한 props를 전달받는 방식으로 만들어 줄 수 있다.

```tsx
const Text = ({ as, children }) => {
  const Component = as || "span";

  return <Component>{children}</Component>;
};
```

- 하지만 이러한 방법은 굉장히 제한적이고,

- 타입스크립트 환경이기 때문에 타입 지정을 해주어야 하는데 as의 element의 타입이 무엇인지 알지 못한다는 문제가 있다

- any, unknown으로 지정하는 것도 좋지 않고 또한 as를 전달할 때 올바른 html element 인지도 알 수 없다.

- 사용가능한 모든 element를 타입으로 지정할 수도 없는 노릇

- 또한 아래처럼 as로 div를 선달해서 div 태그를 사용한다고 해도 실수로 a 태그의 href 속성을 전달할 수 도 있다

```tsx
<Text as="div" href="google.com">
  Link Text
</Text>
```

- 이러한 문제를 해결하기 위한 방법은 제네릭이 있다.

- Text 컴포넌트의 as로 전달되는 element가 일정하지 않기 때문에 이 부분을 일반화를 시켜주어야 한다

- 어떤 element를 전달하던지 그에 맞게 유연하게 타입처리를 해줄 수 있어야 한다

- 여기서 as는 우리가 제네릭으로 전달되는 T를 통해 타입이 결졍된다

```tsx
type TextProps<T extends React.ElementType> = {
  as?: T;
  children: React.ReactNode;
};

const Text = ({ as, children }) => {
  const Component = as || "span";

  return <Component>{children}</Component>;
};
```

- 중요한 것은 우리가 전달하는 element에 따라서 props로 전달될 수 있는 속성들의 타입을 지정해주어야 한다

- 예를들어 as로 a 태그를 전달하면 href를 prop으로 전달하고 사용할 수 있어야 한다

```tsx
type TextProps<T extends React.ElementType> = {
  as?: T;
  children: React.ReactNode;
} & React.ComponentPropWithoutRef<T>;

const Text = ({ as, children }) => {
  const Component = as || "span";

  return <Component>{children}</Component>;
};
```

- 여기서 추가적으로 해야할 것은 prop들을 전달할 때 유틸리티 타입인 Omit을 사용해서 우리가 정의한 props 타입을 제거해주어야 한다

- 즉, 이렇게 해주면 우리가 지정한 TextProps에서 as와 children는 처리를 해주고 나머지가 `Omit<React.ComponentPropWithoutRef<T>, "as" | "children">` 로 처리되는 것이다

```tsx
type TextProps<T extends React.ElementType> = {
  as?: T;
  children: React.ReactNode;
} & Omit<React.ComponentPropsWithoutRef<T>, "as" | "children">;

const Text = ({ as, children }) => {
  const Component = as || "span";

  return <Component>{children}</Component>;
};
```

- 그리고 마지막으로 Text 컴포넌트로 제네릭을 지정을 아래와 같이 해준다

```tsx
type TextProps<T extends React.ElementType> = {
  as?: T;
  children: React.ReactNode;
} & Omit<React.ComponentPropsWithoutRef<T>, "as" | "children">;

// 여기서 Text 컴포넌트에 제네릭을 사용하는 이유는 TextProps에 제네릭이 사용되고 있기 때문에
// TextProps의 T에 해당하는 타입을 전달 해주어야 하기 때문이다
const Text = <C extends React.ElementType>({ as, children }: TextProps<C>) => {
  const Component = as || "span";

  return <Component>{children}</Component>;
};
```

- 또한 reset parameter를 사용할 수 있기 때문에 아래처럼 코드를 추가해줄 수 있다

```tsx
type TextProps<T extends React.ElementType> = {
  as?: T;
  children: React.ReactNode;
} & Omit<React.ComponentPropsWithoutRef<T>, "as" | "children">;

const Text = <C extends React.ElementType>({
  as,
  children,
  ...rest
}: TextProps<C>) => {
  const Component = as || "span";

  return <Component {...rest}>{children}</Component>;
};
```

- 이렇게 작성된 코드를 아래처럼 사용할 수 있다

```ts
type TextProps<T extends React.ElementType> = {
  as?: T;
  children: React.ReactNode;
} & Omit<React.ComponentPropsWithoutRef<T>, "as" | "children">;

const Text = <C extends React.ElementType>({
  as,
  children,
  ...rest
}: TextProps<C>) => {
  const Component = as || "span";

  return <Component {...rest}>{children}</Component>;
};

export default function Index() {
  return (
    <>
      <Text>Span TExt</Text>
      <Text as="h1">h1 Text</Text>
      <Text as="div">div Text</Text>
      <Text as="a" href="https://google.com">
        This is anchor Text
      </Text>
    </>
  );
}
```
