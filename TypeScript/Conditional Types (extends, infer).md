## extends

- 아래 코드에서 제네릭 T의 타입이 무엇인지 알 수 없기 때문에 에러가 발생한다

```ts
type MessageOf<T> = T["message"];
// Type '"message"' cannot be used to index type 'T'.
```

- extends 키워드를 통해서 이러한 문제를 해결할 수 있는데 타입스크립트에서 extends 키워드를 사용하면 타입을 제한시킬 수 있다.

```ts
type MessageOf<T extends { message: unknown }> = T["message"];

interface Email {
  message: string;
}

type EmailMessageContents = MessageOf<Email>;

type EmailMessageContents = string;
```

<br/>

- 자바스크립트에서 삼항연산자를 통해서 조건에 따라 다른 값을 할당할 수 있는 것처럼 타입스크립트에서도 extends와 함께 삼항연산자를 사용해서 조건에 따른 다른 타입을 할당할 수 있다

```ts
type NameOrId<T extends number | string> = T extends number
  ? IdLabel
  : NameLabel;

function createLabel<T extends number | string>(idOrName: T): NameOrId<T> {
  throw "unimplemented";
}

let a = createLabel("typescript");
// NameLabel;

let b = createLabel(2.8);
// IdLabel;

let c = createLabel(Math.random() ? "hello" : 42);
// NameLabel | IdLabel;
```

- 아래처럼 리터럴 타입과 함께 사용할수 있다.

```ts
export const useGetData = <T extends "type1" | "type2">(params: T) => {
  return useQuery({
    queryKey: ["key"],
    async queryFn() {
      const { data } = await restApi.get<T extends "type1" ? Type1 : Type2>(
        "url"
      );

      return data;
    },
  });
};

const { data } = useGetData("type1"); // Type1
```

<br/>

## infer

- infer는 타입스크립트가 타입을 추론하도록 할 때 사용하는 키워드

- infer는 키워드는 extends와 함께 사용할 수 있고, 조건부 타입에서도 참일 경우에만 사용이 가능하다

- 예를 들어, 배열의 요소들의 타입을 추론하고 싶다면 아래와 같이 사용할 수 있다

```ts
type ArrayElement<T> = T extends (infer E)[] ? E : never;

type StringArray = string[];
type Element = ArrayElement<StringArray>; // 'string'
```

<br/>

- 아래는 파라미터의 타입을 추론하는 유틸리티 타입

- 함수의 파라미터로 전달되는 args에 대해서, 타입 P가 추론이 되면 P 아니면 never

```ts
type Parameters<T extends (...args: any) => any> = T extends (
  ...args: infer P
) => any
  ? P
  : never;

// 추론조건 ? 추론 성공시의 값 : 추론 실패시의 값
// any ? P : never;
// 즉 infer로 매개변수를 P로 추론되면 P 타입을 쓰고 아니면 쓰지 말라는 뜻

const z = (
  x: number,
  y: string,
  z: boolean
): { x: number; y: string; z: boolean } => {
  return { x, y, z };
};

type params = Parameters<typeof z>; // [x: number, y: string, z: boolean]
type first = params[0];
```

- 아래는 함수의 return 타입을 추론하는 유틸리티 타입으로 반환되는 값 R에 대해서 infer을 통해서 타입을 추론한다

```ts
type ReturnType<T extends (...args: any) => any> = T extends (
  ...args: any
) => infer R
  ? R
  : any;

// Parameters와 달리 return 부분에서 infer를 사용해서 return type을 추론하고 있다.
```

---

## Reference

- [Inferring types in a conditional type](https://learntypescript.dev/09/l2-conditional-infer)
