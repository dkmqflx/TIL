## CacheTime

> The time in milliseconds that unused/inactive cache data remains in memory. When a query's cache becomes unused or inactive, that cache data will be garbage collected after this duration. When different cache times are specified, the longest one will be used.

- cacheTime: `number | Infinity`

- Defaults to `5 * 60 * 1000` (5 minutes) or `Infinity` during SSR

## StaleTime

- Defaults to `0`

- The time in milliseconds after data is considered stale. This value only applies to the hook it is defined on.

<br/>

- 기본적으로 CacheTime은 5분, StaleTime은 0으로 설정되어 있다.

- 따라서 Query를 사용하는 컴포넌트가 unmount 된 다음, CacheTime이 지나기 이전에 다시 mount 하게 되면 메모리에 저장되어 있는 데이터를 보여주고 그 동안 새로운 데이터를 가져오게 된다

<br/>

### CacheTime과 StaleTime이 같은 경우

- CacheTime과 staleTime이 같은 경우에는 useQuery를 사용하는 컴포넌트가 unmount 된 이후 mount 될 때 지정한 시간이 지나지 않았다면 cache에 있는 데이터를 보여주고 다시 fetching을 하지 않고, 지정한 시간이 지났다면 cache 된 데이터가 없기 때문에 새롭게 데이터를 fetching 해서 보여준다

- 예를들어 CacheTime이 5분, StaleTime이 5분인 Query가 있다고 할 때, 5분 이내에 컴포넌트가 unmount된 이후에 다시 mount 된다면 메모리에 있는 값을 그대로 불러오고 다시 fetching을 하지 않는다

- 하지만 5분이 지난 이후에 다시 mount 하게 되면 메모리에 더 이상 Query 값이 없기 때문에 새롭게 데이터를 fetching 해서 보여주는 것이다

- 이 방법은 일정한 시간이 지나기 이전에는 cache 된 데이터를 보여주고 시간이 지났을 때 fetching해서 데이터를 보여주고 싶을 때 사용한다

---

## Reference

- [useQuery](https://tanstack.com/query/v4/docs/framework/react/reference/useQuery)

- [React Query의 구조와 useQuery 실행 흐름 살펴보기](https://fe-developers.kakaoent.com/2023/230720-react-query/)
