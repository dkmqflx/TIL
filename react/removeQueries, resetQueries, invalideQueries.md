## queryClient.removeQueries

> The removeQueries method can be used to remove queries from the cache based on their query keys or any other functionally accessible property/state of the query.

- removeQueries는 cache된 query를 제거할 때 사용한다.

### usage

```tsx
queryClient.removeQueries({ queryKey, exact: true });
```

<br/>

## queryClient.resetQueries

> The resetQueries method can be used to reset queries in the cache to their initial state based on their query keys or any other functionally accessible property/state of the query.

> This will notify subscribers — unlike clear, which removes all subscribers — and reset the query to its pre-loaded state — unlike invalidateQueries. If a query has initialData, the query's data will be reset to that. If a query is active, it will be refetched.

- resetQueries의 경우 cache된 query를 초기 상태로 되돌릴 때 사용한다

- 예를들어 아래와 같은 todos라는 key를 가진 query의 initialTodos라는 값을 initialData로 갖고 있다면, resetQueries를 호출한 이후에는 initialTodos로 initialData 값이 초기화된다

```ts
const result = useQuery({
  queryKey: ["todos"],
  queryFn: () => fetch("/todos"),
  initialData: initialTodos,
  // initialData는 fetch 되기 전에 보여지는 초기데이터
});
```

### usage

```tsx
queryClient.resetQueries({ queryKey, exact: true });
```

<br/>

## queryClient.invalidateQueries

> The invalidateQueries method can be used to invalidate and refetch single or multiple queries in the cache based on their query keys or any other functionally accessible property/state of the query.

> By default, all matching queries are immediately marked as invalid and active queries are refetched in the background.

- queryClient.invalidateQueries는 cache된 query를 invalidate 하고 다시 refetch할 때 사용한다.

```tsx
await queryClient.invalidateQueries(
  {
    queryKey: ["posts"],
    exact,
    refetchType: "active",
  },
  { throwOnError, cancelRefetch }
);
```

### usage

```tsx
await queryClient.invalidateQueries(
  {
    queryKey: ["posts"],
    exact,
    refetchType: "active",
  },
  { throwOnError, cancelRefetch }
);

// Invalidate every query in the cache
queryClient.invalidateQueries();
s;
// Invalidate every query with a key that starts with `todos`
queryClient.invalidateQueries({ queryKey: ["todos"] });
```

---

## Reference

- [QueryClient](https://tanstack.com/query/v4/docs/react/reference/QueryClient)

- [Query Invalidation](https://tanstack.com/query/v4/docs/react/guides/query-invalidation)
