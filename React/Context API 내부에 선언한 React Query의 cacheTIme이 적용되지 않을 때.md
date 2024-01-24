- React Query의 cache time은 기본적으로 5분으로, cache time 이내에 요청을 하면 cache에 저장된 데이터를 반환한다

> The time in milliseconds that unused/inactive cache data remains in memory. When a query's cache becomes unused or inactive, that cache data will be garbage collected after this duration. When different cache times are specified, the longest one will be used.

- 예를들어, 컴포넌트에서 useQuery로 데이터를 요청한 다음 컴포넌트가 unmount 되었다고 하자,

- 이 때 다시 mount 되더라도 기본 cache time이 5분되어 있는 경우에는 5분 이내에 mount 된다면 cache 된 데이터를 보내준다

- 하지만 cache time을 0으로 설정하게 되는 경우에는 unmount 하게 되면 inactvie 된 상태가 되기 때문에, 다시 mount 하더라도 이전에 cache 된 데이터가 아닌 서버에서 새로 요청받은 데이터를 받게 된다.

<br/>

- 다만 여기서 주의할 점은 아래와 같이 context api에서 staleTime을 0으로 설정한 경우이다

```tsx
  const Test = () => {

  const {data} = useQuery(({
    queryKey:['key',id]
    queryFn:fetch(id),
    staleTime:0
  }))

  return <Test.Provider value={test}>{children}</Test.Provider>;
  };
```

- Provider로 감싼 children 컴포넌트가 mount되고, unmount 되더라도 새로운 데이터를 불러우지 않는데, 그 이유는 Provider 내부에서 useQuery를 사용하고 있는 만큼, Provider 컴포넌트 자체가 unmount 되어야 하기 때문이다.

- 예를들어 만약 page 전체를 Provider가 감싸고 있다면, 페이지를 아예 이동해야지 inactive 상태가 된다.

- 즉, 다른 페이지로 이동한 다음, 다시 페이지를 돌아와야지 새로운 데이터를 받게되는 것이다

---

## Reference

- [Caching Examples](https://tanstack.com/query/v4/docs/react/guides/caching)

- [useQuery](https://tanstack.com/query/v4/docs/react/reference/useQuery)
