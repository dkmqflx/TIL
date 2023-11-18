## index signature로 custom type을 사용할 수 없는 이유

- 아래와 같은 코드처럼 타입스크립트에서 index signature를 사용하게 되면 다음과 같은 에러가 나타난다

> An index signature parameter type cannot be a literal type or generic type. Consider using a mapped object type instead.ts(1337)

```ts
type user = {
  id: "number";
  name: "string";
};

// 에러 발생
const handleChange = (user: { [key: keyof user]: user[key] }) => {};
```

- 이러한 에러가 발생하닌 이유는 타입스크립트에서 index signature를 사용할 때의 타입으로는 string과 number만 허용하기 때문이다.

- 그렇기 때문에 index signature 타입 custom type을 사용하면 mapped type을 사용하라는 에러가 나타나는 것이다.

- 위에서 작성한 코드를 mapped type을 사용해서 아래처럼 수정할 수 있다.

```ts
type user = {
  id: "number";
  name: "string";
};

const handleChange = (user: { [key in keyof user]: user[key] }) => {};
```

## Reference

- [인덱스 서명(Index Signature)](https://radlohead.gitbook.io/typescript-deep-dive/type-system/index-signatures)

- [An index signature parameter type cannot be a literal type or a generic type](https://bobbyhadz.com/blog/typescript-index-signature-parameter-cannot-be-union-type)
