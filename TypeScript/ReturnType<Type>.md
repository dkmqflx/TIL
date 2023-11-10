## `ReturnType<Type>`

- 타입스크립트 유틸리티 타입 ReturnType을 사용하면 함수의 Return 타입을 타입으로 지정할 수 있다.

```ts
const foo = (a: string, b: string): => {
  return a + b;
};

type returnTypeFoo = ReturnType<typeof foo>; // string
```

- 함수에 useRouter과 같은 hook을 파라미터로 전달한다고 할 때도 타입을 ReturnType을 사용하면 간단하게 타입을 지정해 줄 수 있다.

```tsx
import { useRouter } from "next/router";

const router = useRouter();

export const getRouterAsparams = (router: ReturnType<typeof useRouter>) => {
  return router.pathname === "/docs" ? "docs" : "default";
};

getRouterAsparams(router);
```

- 어떠한 함수의 리턴 값이 또 다른 함수의 파라미터로 전달되는 경우에도 ReturnType을 사용하면 간단하게 타입을 지정해줄 수 있다.

- 아래 예시처럼 foo 함수의 리턴 값이 bar 함수에 파라미터로 전달된다고 하면 bar 함수의 파라미터의 타입을 `ReturnType<typeof foo>`와 같이 정해주면 된다.

```ts
const foo = (a: number, b: number) => {
  return {
    a,
    b,
  };
};

const bar = (obj: ReturnType<typeof foo>) => {
  console.log("obj", obj);
};

const fooObj = foo(10, 20);

bar(fooObj);
```

- React Query를 함수의 인자로 전달할 때도 아래처럼 ReturnType을 활용할 수 있다.

```tsx
const useGetDataQuery = () => {
  return useQuery({
    queryKey: ["data"],
    queryFn: async () => {
      const { data } = await getData({ params });

      returndata;
    },
  });
};

type queryType = ReturnType<typeof useGetData>;

const getQuery = (query: queryType) => {
  const { data } = query; // (parameter) query: UseQueryResult<void, unknown>
};

getQuery(useGetDataQuery);
```

---

## Reference

- [ReturnType<Type>](https://www.typescriptlang.org/docs/handbook/utility-types.html)
