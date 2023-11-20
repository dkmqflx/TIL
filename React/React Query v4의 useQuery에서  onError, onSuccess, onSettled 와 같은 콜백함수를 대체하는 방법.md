- v5에서기존의 onError, onSuccess, onSettled이 제거 되었다.

- tkdodo의 블로그 [Breaking React Query's API on purpose](https://tkdodo.eu/blog/breaking-react-querys-api-on-purpose) 에서는 이와 관련된 내용을 다루고 있는데 결론적으로 말하면 전역적으로 처리할 것을 추천하고 있다

- 그리고 이와 같은 결론에 도달하기 까지의 과정을 대략적으로 요약하자면 다음과 같다.

<brr/>

- 만약 아래와 같은 useQuery 코드가 있고 onSuccess와 같은 콜백 함수가 없다면

```tsx
export const useGetQuery = (id) => {
  return useQuery({
    queryKey: ["repoData", id],
    queryFn: async () => {
      const { data } = await axios.get(
        "https://api.github.com/repos/tannerlinsley/react-query"
      );
      console.log("queryFn", id);
      return data;
    },
  });
};
```

- 다음과 같이 useEffect를 사용해서 성공 후 액션을 처리해야 했을 것이다.

```tsx
function App() {
  const { isSuccess } = useGetQuery(1);

  React.useEffect(() => {
    if (isSuccess) {
      toast.error("success!");
    }
  }, [query.isSuccess]);
}
```

- 그리고 이러한 방식의 문제는 useGetQuery를 여러번 사용하게 되는 경우, 성공적으로 데이터를 받아오게 되면 useEffect 또한 모두 실행되어 중복된 성공 토스트가 보인다는 것이다.

```tsx
function App() {
  const { isSuccess } = useGetQuery(1);
  useGetQuery(1);

  React.useEffect(() => {
    if (isSuccess) {
      toast.success("success!");
    }
  }, [query.isSuccess]);
}
```

- 하지만 아래처럼 v4의 onSucess에 콜백 함수를 등록하면 useQuery가 api call을 하나로 묶어 주는 것 처럼 성공 콜백도 한번만 실행되어 성공 토스트가 한번만 보이게 될 것이라고 생각할 것이다.

```tsx
// queries.js

import {
  QueryClient,
  QueryClientProvider,
  useQuery,
} from "@tanstack/react-query";
import axios from "axios";

export const useGetQuery = (id) => {
  return useQuery({
    queryKey: ["repoData", id],
    queryFn: async () => {
      const { data } = await axios.get(
        "https://api.github.com/repos/tannerlinsley/react-query"
      );
      console.log("queryFn", id);
      return data;
    },

    onSuccess: () => {
      console.log("onSuccess", id);
    },
  });
};
```

- 하지만 실제로 코드를 실행해 보면 onSuccess 함수가 useGetQuery를 호출할 때 마다 실행되는 것을 console.log를 통해 확인할 수 있다.

```tsx
function App() {
  const { isSuccess } = useGetQuery(1);
  useGetQuery(1);

  React.useEffect(() => {
    if (isSuccess) {
      toast.success("success!");
    }
  }, [query.isSuccess]);
}
// queryFn 1
// onSuccess 1
// onSuccess
```

- v5에서는 이러한 문제의 해결 방법으로 [meta 객체](https://tanstack.com/query/v5/docs/react/reference/useQuery)를 사용해서 전역적으로 처리하는 방법을 제안하고 있다

- **`meta: Record<string, unknown>`**

  - Optional

  - If set, stores additional information on the query cache entry that can be used as needed. It will be accessible wherever the **`query`** is available, and is also part of the **`QueryFunctionContext`** provided to the **`queryFn`**.

  - 해당 객체는 v4, v5에 모두 있다.

- useQuery에서 meta 객체를 추가해준 다음

```tsx
import {
  QueryClient,
  QueryClientProvider,
  useQuery,
} from "@tanstack/react-query";
import axios from "axios";

export const useGetQuery = (id) => {
  return useQuery({
    queryKey: ["repoData", id],
    queryFn: async () => {
      const { data } = await axios.get(
        "https://api.github.com/repos/tannerlinsley/react-query"
      );
      console.log("queryFn", id);
      return data;
    },
    meta: {
      successMessage: "Success",
    },
  });
};
```

- 아래와 같이 queryClient에 queryCache와 함께 필요한 옵션을 전달해주면

```tsx
const queryClient = new QueryClient({
  queryCache: new QueryCache({
    onSuccess: (data, query) => {
      console.log("onSuccess");
      console.log("data", data);
      console.log("query", query.meta);
    },
  }),
});
```

- 이전과 달리 코드를 실행했을 때 onSuccess가 한번만 실행되는 것을 확인할 수 있다.

```tsx
function App() {
  const { isSuccess } = useGetQuery(1);
  useGetQuery(1);
}
// queryFn 1
// onSuccess 1
// data {...}
// query {succcessMessage: 'Success'}
```

---

## Reference

- **[Breaking React Query's API on purpose](https://tkdodo.eu/blog/breaking-react-querys-api-on-purpose)**
- **[번역 React Query API의 의도된 중단](https://velog.io/@cnsrn1874/breaking-react-querys-api-on-purpose)**
