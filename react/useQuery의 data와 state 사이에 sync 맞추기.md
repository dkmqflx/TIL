useQuery 로 받아온 값을 state로 관리하고 있는 경우, useMutation을 호출해서 state로 관리되는 값을 변경하게 되면 이전에 캐싱된 값 때문에 state와 sync가 맞지 않는 문제가 발생할 수 있다.

## 1. [setQueryData](https://www.figma.com/file/rw0p8oRyf1MkPBNRxIIxc1/%ED%9A%8C%EC%9B%90%EC%A0%95%EB%B3%B4-%EA%B8%B0%ED%9A%8D%EC%95%88?node-id=340%3A2265&mode=dev) 사용하기

- 등록된 queryKey에 값을 사용해서 이전에 캐싱된 값을 업데이트 해준다.

- updater에 값을 업데이트 하는 콜백함수를 전달한다.

```tsx
queryClient.setQueryData(queryKey, updater);
```

**Options**

- **`updater: TQueryFnData | undefined | ((oldData: TQueryFnData | undefined) => TQueryFnData | undefined)`**

  - If non-function is passed, the data will be updated to this value

  - If a function is passed, it will receive the old data value and be expected to return a new one.

## 2. useQuery의 refetch를 callback으로 전달하는 방법

- 1번 방법을 사용할 때 data의 구조가 복잡하다면 updater로 처리해야 하는 로직이 복잡해 질 수 있다.

- 그럴 때는 useQuery의 refetch를 useMutation의 onSucess에 callback으로 전달해서 useMutation이 끝나면 다시 useQuery를 호출하는 방식으로 데이터를 업데이트 해줄 수 있다.

## 3. queryClinet로 [refetchQueries](https://tanstack.com/query/v4/docs/react/reference/QueryClient#queryclientrefetchqueries) 사용하기

- 하지만 위와 같은 방법을 사용할 때, 부모 컴포넌트에서 useQuery를 사용하고 자식 컴포넌트에서 useMutation을 사용하고 있다면 불필요한 props 전달된다는 단점이 있다.

- 이 때 useMutation의 onSuccess 콜백 함수에 refetchQuries를 사용해서 query를 다시 refetch 하는 방식으로 문제를 해결할 수 있다.

```tsx
export const useChange = (id: number) => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (body) => {
      const { data } = await changeStatus(id, body);
      return data;
    },

    onSuccess: async () => {
      // onSuccess시, refetchQueries 호출
      await queryClient.refetchQueries({
        queryKey: ["change", queryId],
      });
    },
  });
};
```
