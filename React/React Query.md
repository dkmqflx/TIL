### useInfiniteQuery

- [useInfiniteQuery](https://tanstack.com/query/v4/docs/react/reference/useInfiniteQuery)

- [React Query의 useInfiniteQuery에 대해 알아보기](https://jforj.tistory.com/246)

- [eact-query - useInfiniteQuery](https://velog.io/@cnsrn1874/react-query-useInfiniteQuery)

<br/>

### useIsFetching

- useIsFetching is an optional hook that returns **the number of the queries** that your application is loading or fetching in the background (useful for app-wide loading indicators).

<br/>

### useIsMutating

useIsMutating is an optional hook that returns **the number of mutations** that your application is fetching (useful for app-wide loading indicators).

<br/>

### Suspense

- [Suspense](https://tanstack.com/query/v4/docs/react/guides/suspense)

- Global configuration:

```tsx
tsx;
// Configure for all queries
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      suspense: true,
    },
  },
});

function Root() {
  return (
    <QueryClientProvider client={queryClient}>
      <App />
    </QueryClientProvider>
  );
}
```

- Query configuration:

```tsx
tsx;
import { useQuery } from "@tanstack/react-query";

// Enable for an individual query
useQuery({ queryKey, queryFn, suspense: true });
```

<br/>

### Prefetch

- [Prefetching](https://tanstack.com/query/v4/docs/react/guides/prefetching)

```tsx
const prefetchTodos = async () => {
  // The results of this query will be cached like a normal query
  await queryClient.prefetchQuery({
    queryKey: ["todos"],
    queryFn: fetchTodos,
  });
};
```

```tsx
const prefetchTodos = async () => {
  // The results of this query will be cached like a normal query
  await queryClient.prefetchQuery({
    queryKey: ["todos"],
    queryFn: fetchTodos,
  });
};
```

- If data for this query is already in the cache and not invalidated, the data will not be fetched

- If a `staleTime` is passed eg. `prefetchQuery({queryKey: ['todos'], queryFn: fn, staleTime: 5000 })` and the data is older than the specified staleTime, the query will be fetched

- If no instances of useQuery appear for a prefetched query, it will be deleted and garbage collected after the time specified in cacheTime.

- 예를들어, A -> B 페이지로 이동할 수 있는 기능이 있다고 하자.

- A 페이지에서 B 페이지에서 필요한 데이터를 prefetch 하는 로직이 있고

- B 페이지에서는 해당 데이터를 가져오는 useQuery가 있다고 하자

- 만약 B 페이지로 이동한다면, A 페이지에서 prefetch 한 데이터를 보여주고 B 페이지의 useQuery를 통해서 데이터를 다시 받아오는데 그 이유는 prefetch할 때 별도의 옵션이 없으면 stale 하기 때문이다

- 하지만 B 페이지에는 staleTime, cacheTime이 설정되어 있고 refetch와 관련된 옵션들이 모두 false인 경우에는

- A 페이지에서 B 페이지 이동할 때 데이터를 요청하지 않는다

- 하지만 이 때 다시 B 페이지에서 A 페이지로 이동하면 prefetch 로직이 실행되어 다시 데이터를 받아오게 되는데 이는 prefetch에 별도의 옵션이 없기 때문이다

- 그렇기 때문에 아래처럼 prefetch 옵션에 넣어주어야 추가적인 데이터 요청을 하지 않게 된다

```tsx
const prefetchTodos = async () => {
  // The results of this query will be cached like a normal query
  await queryClient.prefetchQuery(["todos"], fetchTodos, {
    stateTime: 60000,
    cacheTime: 100000,
  });
};
```

- 만약 이미 데이터가 있는 경우라면 prefetch 사용할 필요 없이, setQueryData를 사용해서 데이터를 업데이트 해줄 수 있다

```tsx
queryClient.setQueryData(["todos"], todos);
```

<br/>

### Refetch with Key

- key가 변경되어야지 자동으로 Refetch 한다

- 같은 key를 사용하면, stale 하더라도 refetch가 일어나지 않는다

- using the **same key** for every query

- after clicking arrow to load new month

- data is stale(stateTime = 0), but nothing to trigger refetch

  - component remount

  - window refous

  - running refetch function manually

  - automated refetch

- Only fetch new data for **known key** for the above reasons

- Solution

  - New key for each month

  - treat key as dependency arrays

  ```tsx
  function Component() {
    const [filters, setFilters] = React.useState();
    const { data } = useQuery({
      queryKey: ["todos", filters],
      queryFn: () => fetchTodos(filters),
    });

    // ✅ set local state and let it "drive" the query
    return <Filters onApply={setFilters} />;
  }
  ```

  - [TkDodo's blog - Effective React Query Keys](https://tkdodo.eu/blog/effective-react-query-keys)

### Re-fetching, why? When?

- Re-fetch ensures stale data gets updated from serer

  - Seen when we leave the page and refocus

- Stale quries are re-fetched automatically in the background when

  - New instances of the query mount

  - Every time a react component (that has a useQuery call) mounts

  - The window is refocused

  - The network is reconnected

  - configured refetchInterval has expireed

### Re-fetching, How

- Control with global or query-specific options:

  - refetchOnMOunt, refetchOmWindowFocus, refetchOnReconnect, refetchInterval

- Or, imperatively: refetch function in useQuery return object

### Re-Fetch를 막는 방법

- How ?

  - Increate stale time

  - turn off refetchOnMOunt, refetchOmWindowFocus, refetchOnReconnect

- Only for very rarely changed, not mission-critical data

  - 잘 바뀌지 않는 데이터에 대해서만

### refetchInterval

- polling 기능을 구현할 때 사용할 수 있다

- `refetchInterval: number | false | ((data: TData | undefined, query: Query) => number | false)`

- Optional

- If set to a number, all queries will continuously refetch at this frequency in milliseconds

- If set to a function, the function will be executed with the latest data and query to compute a frequency

<br/>

### Error Handling - 전역 오류 핸들러를 지정하는 방법

- **방법 1**

- 아래처럼 전역 오류 핸들러는 `queryClient`에 대한 `defaultOptions` 을 통해 설정할 수 있다

```jsx
new QueryClient({
 defaultOptions: {
		queries: {
			onError: queryErrorHandler,
			}
		})
```

- **방법 2 - 전역 오류 핸들러를 지정하는 더 나은 방법**

- 하지만 위보다 좋은 방법은 [TkDodo의 블로그에 설명된 것처럼](https://tkdodo.eu/blog/react-query-error-handling#the-global-callbacks) 쿼리 기본값 대신 `queryCache` 기본값에 전역 오류 핸들러를 포함하는 것.

```jsx
import { QueryCache, QueryClient } from 'react-query';

export const queryClient = new QueryClient({
		queryCache: new QueryCache({
			 onError: queryErrorHandler,
			}),
		// useMutation에 대한 에러는 아래와 같이 처리 가능
		mutationCache: new MutationCache({
        onError: queryErrorHandler,
      }),
		defaultOptions: {
       ...
      },
		 });
```

- 방법2가 더 나은 이유

  - 개별 쿼리가 아니라 **쿼리 캐시**에 핸들러가 연결되어 있으므로, 재시도가 **모두** 실패했을 때만 오류 핸들러가 트리거 된다.

- 주의할 점은

  - `defaultOptions` 을 통해 전역 오류 콜백을 설정하면 `useQuery` 옵션에서 오류 콜백을 **재정의**할 수 있다.

  - 하지만 `queryCache` 옵션에 콜백을 설정하고 `useQuery` 옵션에 다른 콜백을 설정하면 오류에 **두 가지** 오류 콜백이 실행된다

  - 이를 해결 할 수 있는 방법은 meta 속성을 사용하는 것

    - [Is it possible to disable the global error only for specific requests of query, mutation? #3441](https://github.com/TanStack/query/discussions/3441)

  - Global callbacks

    - [queryCache 공식 문서](https://tanstack.com/query/v4/docs/react/reference/QueryCache)를 통해서 queryCache에 `onError`, `onSuccess` 그리고 `onSettled` 과 같은 콜백 함수를 등록해서 Global Callbask를 처리할 수 있는 방법을 확인할 수 있다

    - The onError, onSuccess and onSettled callbacks on the QueryCache can be used to handle these events on a global level.

    - They are different to defaultOptions provided to the QueryClient because:

    - defaultOptions can be overridden by each Query - the global callbacks will always be called.

    - **defaultOptions callbacks** will be called **once** for each Observer, while the global callbacks will only be called once per Query.

<br/>

### React Queyr with ErrorBoundary

- 전역으로 설정하기

```js
import { QueryClient, QueryClientProvider } from 'react-query'

const App = ({ Component, pageProps }: AppProps) => {
 const queryClientRef = useRef<QueryClient>();
  if (!queryClientRef.current) {
    queryClientRef.current = new QueryClient({
      defaultOptions: {
        queries: {
          useErrorBoundary: true,
        },
      },
    });
  }
   return (
     <QueryClientProvider client={queryClientRef.current}>
       <Component {...pageProps} />
     </QueryClientProvider>
   )
 }

```

- 개별 쿼리에 직접 설정하기

```js
import { useQuery } from "react-query";

useQuery(queryKey, queryFn, { useErrorBoundary: true });
```

<br/>

### Options for pre-populating data

|                 | where to use          | data from? | added to cache? |
| --------------- | --------------------- | ---------- | --------------- |
| prefetchQuery   | method to queryClient | server     | yes             |
| setQueryData    | method to queryClient | client     | yes             |
| placeholderData | option to useQuery    | client     | yes             |
| initialData     | option to useQuery    | client     | yes             |

<br/>

### Select Function (Filtering with the select option)

- 이 때 함수를 useCallback 으로 wrap 하는데 그 이유는 캐싱의 이점을 살리기 위해서이다

- Allow user to filter out data that aren't available

- Why is the select option the bset way to do this ?

  - React Query memo-izes to reduce unnecessary computation

  - tech details:

    - triple equals comparison of select function

    - only run if **data changes** and **the function has changed**

  - need to stable function (useCallback fur anonymous function)

<br/>

### React Query와 인증

- [Udemy - React Query : React로 서버 상태 관리하기](https://kmooc.udemy.com/course/react-query-react/learn/lecture/31621902#overview)
- [completed-apps/lazy-days-spa/client/src/auth/useAuth.tsx](https://github.com/bonnie/udemy-REACT-QUERY/blob/react-query-v4/completed-apps/lazy-days-spa/client/src/auth/useAuth.tsx)

- local storage에서 저장하는 인증관련 기능을 persistQueryClient로 대체할 수 도 있다

  - [persistQueryClient](https://tanstack.com/query/v4/docs/react/plugins/persistQueryClient)

  - 토큰과 같은 인증 데이터 보존에 사용할 수 있다

<br/>

### Dependent Queries

- [Dependent Queries](https://tanstack.com/query/v4/docs/react/guides/dependent-queries)

- Dependent (or serial) queries depend on previous ones to finish before they can execute. To achieve this, it's as easy as using the enabled option to tell a query when it is ready to run:

```tsx
// Get the user
const { data: user } = useQuery({
  queryKey: ["user", email],
  queryFn: getUserByEmail,
});

const userId = user?.id;

// Then get the user's projects
const {
  status,
  fetchStatus,
  data: projects,
} = useQuery({
  queryKey: ["projects", userId],
  queryFn: getProjectsByUser,
  // The query will not execute until the userId exists
  enabled: !!userId,
});
```

<br/>

### invalidateQuries

- Invalidate cached data on mutation

  - so user doesn't have to refresh the page

- invalidateQuries effects:

  - mark query as stale

  - trigger re-fetch if query currently being rendered

```
muatate
	↓
onSucess
  ↓
invalidateQuries
  ↓
refetch

```

<br/>

### Invalide Quries with Prefix

- invalidate all quries related to specific mutation

- invalidateQuries takes a query key prefix

  - invalidate all related quries at once

  - can make it exact with {excate:true }option

- other quryClient method take prefix too (like removeQuries)

```tsx
// 캐시의 모든 쿼리를 무효화함
queryClient.invalidateQueries();
// `todos`로 시작하는 키로 모든 쿼리를 무효화함
queryClient.invalidateQueries({ queryKey: ["todos"] });
```

<br/>

### removeQuries vs cancelQuries

- `queryClient.removeQueries`

  - The removeQueries method can be used to remove queries from the cache based on their query keys or any other functionally accessible property/state of the query.

  ```tsx
  queryClient.removeQueries({ queryKey, exact: true });
  ```

- `queryClient.cancelQueries`

  - The cancelQueries method can be used to cancel outgoing queries based on their query keys or any other functionally accessible property/state of the query.

  - This is most useful when performing **optimistic updates** since you will likely need to cancel any outgoing query refetches so they don't clobber your optimistic update when they resolve.

  ```tsx
  await queryClient.cancelQueries({ queryKey: ["posts"], exact: true });
  Options;
  ```

  - `filters?: QueryFilters: Query Filters`

  - Returns

    - This method does not return anything

<br/>

### Updates from Mutation Responses

- When dealing with mutations that update objects on the server, it's common for the new object to be automatically **returned in the response of the mutation.**

- Instead of refetching any queries for that item and wasting a network call for data we already have, we can take advantage of the object returned by the mutation function and update the existing query with the new data immediately using the Query Client's setQueryData method:

```tsx
const queryClient = useQueryClient();

const mutation = useMutation({
  mutationFn: editTodo,
  onSuccess: (data) => {
    // setQueryData 사용해서 업데이트
    queryClient.setQueryData(["todo", { id: 5 }], data);
  },
});

mutation.mutate({
  id: 5,
  name: "Do the laundry",
});

// The query below will be updated with the response from the
// successful mutation
const { status, data, error } = useQuery({
  queryKey: ["todo", { id: 5 }],
  queryFn: fetchTodoById,
});
```

<br/>

### Optimistic Update

- [Optimistic Updates](https://tanstack.com/query/v4/docs/react/guides/optimistic-updates)

- **Rollback / Cancel Query**

  - useMutation has an onMutate callback

    - return context value that's handed to onError for rollback

    - context value contains previous cache data

  - onMutate function can also cancel refetches-in-progress

    - don't want to overwrite optimistic update with old data from server

    - onMutate 함수는 진행중인 refetch를 취소한다

    - onMutate 는 mutation 함수가 실행되기 전에 실행되고 mutation 함수가 받을 동일한 변수가 전달된다.

- **Rollback / Cancle Query Flow**

  - 1. User triggers update with mutate

  - 2. Send update to server

  - 3. onMutate

    - Cancel quries in progress

    - Update query cache

    - save previous cache value

  - 4. Success ?

    - Yes

      - invalidate query

    - No

      - onError uses context to roll back cache

      - invalidate quries

### Query Cancellation (**Manually Canceling Query**)

- [Query Cancellation](https://tanstack.com/query/v4/docs/react/guides/query-cancellation)

- React Query uses **AbortController** to cancel quries

  - standard JavaScript interface, send AbortSignal to DOM reqeust

  - [MDN - AbortSignal](https://developer.mozilla.org/ko/docs/Web/API/AbortSignal)

  - [AbortController로 요청 취소하기](https://blog.outsider.ne.kr/1602)

- Automaticall canceled quries use this signal "behind the scenes"

  - out-of-data or inactive quries

- Manually cancled axios query

  - pass signal to axios via argument to query function

  - [Axios - Cancellation](https://axios-http.com/docs/cancellation)

- In order to cancel from React Query, query function must return a promise with a cancel property that cancel query

<br/>

### Query Retries

- [Query Retries](https://tanstack.com/query/v4/docs/react/guides/query-retries)

- When a useQuery query fails (the query function throws an error), TanStack Query will automatically retry the query if that query's request has not reached the max number of consecutive retries (defaults to 3) or a function is provided to determine if a retry is allowed.

- You can configure retries both on a global level and an individual query level.

- Setting `retry = false` will disable retries.

- Setting `retry = 6` will retry failing requests 6 times before showing the final error thrown by the function.

- Setting `retry = true` will infinitely retry failing requests.

- Setting `retry = (failureCount, error) => ...` allows for custom logic based on why the request failed.

```tsx
import { useQuery } from "@tanstack/react-query";
```

<br/>

### React Query 도입하기

- **RTK-Query vs Apollo VS SWR**

  - RTK-Query : redux 구조를 그대로 사용해야 한다

  - Apollo : 스키마를 정의해야 한다

  - SWR : enabled 옵션을 제공하지 않는다

- **React Query 도입시 논의해야할 부분**

- Query 작성 방식

  - 여러 파일에 API가 각각 정의되어 있고 각각의 컴포넌트에서는 필요한 API를 가져와서 사용하고 있는 경우를 가정해보자

  - 이러한 경우에는 같은 API라 하더라도 옵션이 다르거나 조합이 필요한 경우 중복해서 쿼리를 생성하게 된다

  - 그 결과 api 변경사항이 생겼을 때 관련된 모든 쿼리를 수정해야 되는 문제가 발생한다

  - 이를 해결하기 위한 방법으로 기본 Query(기본 Mutation)을 정의해줄 수 있다

    - 기본 Query는 더 이상 쪼갤 수 없는 단위

    - 하나의 api와 일대일 관계를 이루고 있다

  - 이렇게 정의한 기본쿼리를 조합해서 아래와 같이 컴포넌트와 Custom hook에서 사용

    - 컴포넌트

      ```js
      export function Component() {
        const { data: 상품정보, isLoading } = use상품정보();
        const { data: 구독정보 } = use구독정보({
          상품정보,
          options: { enabled: !isLoading },
        });

        return <Page 구독정보={구독정보} />;
      }
      ```

    - Custom Hook

      ```js
      export function useData() {
        const { data: 상품정보, isLoading } = use상품정보();
        const { data: 구독정보 } = use구독정보({
          상품정보,
          options: { enabled: !isLoading },
        });

        return 구독정보;
      }
      ```

  - 이 때 기본 Query (기본 Mutataion)에 공통 옵션을 추가하고 싶은 경우가 있다

    - ErrorBoundary나 select와 같은 케이스

  - 이를 해결하기 위한 방법으로는 기본 쿼리를 위한 기본 쿼리를 만들어주었다

    - useQuery + 공통옵션

  - Query 작성 방식

    - 페이지 단위 key 값 추가 -> **페이지 단위 쿼리 초기화 가능**

    - Select에서 실질적인 데이터가 있는 값만 반환 -> **쿼리를 사용할 때 중복 Select 방지**

    - onError 옵션이 있어야 useErrorBoundary를 설정하도록 처리 -> **에러 핸들링 누락 방지**

    ```js
    import { useQuery as useQueryOrigin } from "react-query";

    export default function useQuery(querykey, queryFn, options={}){
      const {...} = options;

      return useQueryOrigin(querykey, queryFnm {...})
    }
    ```

- 폴더 구조 개선

  - 아래처럼 데이터의 요청 형식에 따라 분류해주었다

  ```shell

  - hooks

    - service

      - quries # get

        - 매대데이터 # 파일 이름을 데이터 목적에 따라 나누었다

        - 홈 데이터

      - mutations # post, delete

  ```

- Query Mutation 네이밍
- 프로젝트 기본 옵션
- Query key 작성 규칙

- 사용했을 때 장점

  - Hook 기반을 제공하고 캐싱을 지원한다

  - 비동기 처리를 위한 유용한 도구를 제공한다

    - 비동기 처리 상태

      - isLoading, isFetching, isSuccess

    - Infinte Queries

  - 백그라운드 패칭을 지원한다

    - focus, mount, interval

    - 최신 데이터를 보여줄 수 있다

- 만약 서버사이드 데이터가 거의 없는 경우에는 아래와 같은 도구를 도입하는 것을 고려해볼 수 있다

  - recoil

  - redux

- 서버 사이드 데이터가 더 많아질 때 적용하면 된다

- 아쉬운 점

  - Mutation은 한번만 호출하기 위해 **Wrappper 함수가 필요**하다

    - Redux-saga의 takeLatest 같은

    - 그래서 아래처럼 custom hook을 만들어서 처리해주었다

  ```js

  function useExecuteionOnce(func, delay){
    ...
    return async (...args) => {
      if(!completeRef.current){
        return ;
      }

      completeRef.current = false;

      try{
        await func(...args); // 비동기 작업 대기
        await waitMutating(); // React Query의 useIsMutating 기반 mutations 작업 대기
      }catch(e){
        throw e;
      }
    }
  }

  ```

---

### Reference

- [React Query : React로 서버 상태 관리하기](https://kmooc.udemy.com/course/react-query-react/learn/lecture/31621558#overview)
- [눈에 보이지 않는 개선: My구독의 Redux에서 React-Query 전환 경험 공유 / if(kakao)2022](https://www.youtube.com/watch?v=YTDopBR-7Ac)
