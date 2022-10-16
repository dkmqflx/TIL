### Promisea.all

- `Promise.all` 은 여러 개의 프로미스를 동시에 실행시키고 모든 프로미스가 준비될 때까지 기다리는 상황에서 유용하게 사용할 수 있다

- `Promise.all` 메서드에 프로미스를 담은 배열을 전달하게 되면, 배열에 있는 모든 프로미스들이 완료된 후 새로운 프로미스가 fulfilled 된다.

- 이 때 배열에 있는 각각의 **프로미스의 결과값을 담은 배열**이 새로운 새로운 프로미스의 결과 값이 된다.

```jsx
function print() {
  // promise1, promise2 의 결과 값을 담은 배열이 reulst로 전달된다
  return Promise.all([promise1(), promise2()]).then((result) =>
    console.log('result: ', result)
  );
}
```

- 이러한 `Promise.all` 의 특징을 이용해서, 배열 안의 여러 개의 값들을 이용해서 서버로 요쳥을 할 때 `async` , `await` 와 함께 사용할 수 있다.

- 아래는 배열 안의 원소의 `id`를 `getRequest` 라는 서버로 요청을 보내는 함수의 인자로 전달하는 코드이다.

- map 함수 안의 함수 앞에 `async` 를 붙여주면 프로미스를 쓰지 않아도 자동적으로 함수안에 있는 코드 블록이 프로미스로 변환이 되므로 map 함수를 실행하면 각 원소가 프로미스 객체가 된다

- 따라서 아래 코드를 실행시키면 `getRequest()` 요청을 통해 얻어온 결과값들이 출력된다

```jsx
Promise.all(
  requestList.map(async (item) => {
    const result = await getRequest(item.id);
    console.log('result: ', result);
  })
);
```

---

## Reference

- [MDN web docs - async](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Statements/async_function)
- [MDN web docs - await](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Operators/await)
- [MDN web docs - Promise.all](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Promise/all)
- [https://www.youtube.com/watch?v=aoQSOZfz3vQ](https://www.youtube.com/watch?v=aoQSOZfz3vQ)
- [for loop vs .map for making multiple API calls](https://dev.to/askrishnapravin/for-loop-vs-map-for-making-multiple-api-calls-3lhd)
- [프라미스 API](https://ko.javascript.info/promise-api)
- [map, reduce 함수에서 async/await 쓰기](https://velog.io/@minsangk/2019-09-06-0209-%EC%9E%91%EC%84%B1%EB%90%A8-eik06xy8mm)
