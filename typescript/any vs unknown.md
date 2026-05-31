## any vs unknown

- `unknown = {} | null | undefined`이다.

- 즉, unknown은 모든 타입과 null과 undefined이다.

- unknown은 any와 비슷하게 모든 타입을 대입할 수 있지만, 그 후 어떠한 동작도 수행할 수 없게 된다.

```ts
const a: unknown = "hello";
const b: unknown = "world";
a + b;
// 'a' is of type 'unknown'.
// 'b' is of type 'unknown'.
a.slice();
// 'a' is of type 'unknown'.
```

- 이와 달리 any의 경우에는 에러가 발생하지 않는다

```ts
const a: any = "hello";
const b: any = "world";
a + b;
// 'a' is of type 'unknown'.
// 'b' is of type 'unknown'.
a.slice();
// 'a' is of type 'unknown'.

const c = a;
```

- any 타입의 값은 어느 타입의 변수에도 할당될 수 있으나, unknown 타입의 값은 any와 unknown 타입을 제외한 타입의 변수에는 할당이 불가능하다.

<br/>

- unknown은 형 변환시에도 사용할 수 있다.

- 아래와 같이 string을 number로 변환해서 number 타입의 변수에 값을 할당하려고 하면 에러메세지가 나타난다.

```ts
const a: number = "123" as number;

// Conversion of type 'string' to type 'number' may be a mistake because neither type sufficiently overlaps with the other. If this was intentional, convert the expression to 'unknown' first.
```

- 다만 강제로 변환하는 방법이 있다.

```ts
const a: number = "123" as unknown as number;
```

- 먼저 unknown으로 주장한 후에 원하는 타입으로 다시 주장하면 된다.

### 구조적 서브 타이핑

- 아래와 같은 타입에 대해,

```ts
type Crew {
  name: string;
  language: "Java" | "JavaScript";
  coach: "poco" | "gugu";
}

type Coach {
  name: string;
  language: "Java" | "JavaScript";
}

const crew: Crew = {
  name: "kim",
  language: "JavaScript",
  coach: "gugu",
};
```

- 아래처럼 Coach로 파라미터 타입을 정의하더라도 Crew 타입을 전달해도 실행이 된다

```ts
function doCoding(person: Coach) {
  return `${person.name}이 ${person.language}를 다룬다 `;
}

doCoding(crew);
```

- 이렇게 되는 이유는 아래와 같은 이유 때문이다

  1. 타입 이름이 달라도 같은 타입으로 인식될 수 있다

  2. 같은 속성을 가지기만 하면 같은 타입으로 인식될 수 있다

- 이러한 것을 구조적 서브 타이핑이라고 부른다

- 즉, Super type에 Sub type이 들어갈 수 있는 타입 시스템이다.
  <br/>

- **any**는 구조적 서브 타이핑을 따르지 않는다

- 아래 예시를 통해 아래 두가지를 추론할 수 있다

  1. any는 모든 타입에 할당 가능하다 -> any는 최하위 집합이다

  2. 모든 타입이 any에 할당 가능하다 -> any는 최상위 집합이다

```ts
let numberType: number = 3;
let anyType: any = numberType;

numberType = anyType;
```

- 하지만 1과 2가 충돌하는데 기본적으로 any는 타입 시스템을 따르지 않기 때문이다

- 그렇기 때문에 어떤 타입이 들어올지 모르는 경우 또는 모든 타입이 들어올 수 있는 경우에는

- any가 아닌 unknown을 사용하는 것이 적절하다.

- 집합의 관점에서 볼 때 unknown은 모든 집합의 상위 집합이라고 할 수 있기 때문이다
