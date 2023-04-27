## onChange 함수에서 커링 사용하기

- 리액트에서 아래처럼 onChange 를 사용해서 event value를 처리하는 경우가 많다

- 이 때 event 뿐 아니라 다른 파라미터가 있으면 아래처럼 처리하는데 이렇게 작성한 코드를 더 간결하게 처리할 수 있는 방법이 있따

```js
export default function Home() {
  const handleChange = (e, value) => {
    console.log(e, value);
  };

  return (
    <>
      <input type='text' onChange={(e) => handleChange(e, 1)} />
      <input type='text' onChange={(e) => handleChange(e, 2)} />
      <input type='text' onChange={(e) => handleChange(e, 3)} />
    </>
  );
}
```

- 바로 커링(Currying) 기법이다

- 커링은 하나 이상의 매개변수(Parameter)를 갖는 함수를 부분적으로 나누어 각각 단일 매개변수를 갖는 함수로 설정하는 방법으로

  - f(a, b, c) -> f(a)(b)(c)

- 즉, 함수의 일부 인자를 고정시키는 새로운 함수를 만드는 기법이다.

- 아래와 같이 event를 받는 함수를 return 하는 함수를 만들어주면 코드를 더 간결하게 작성할 수 있다

```js
export default function Home() {
  const [state, setState] = useState();

  const handleChange = (value) => {
    return (e) => console.log(e, value);
  };

  // 아래서 handleChange(1)을 실행함으로써 value는 1로 고정이 되어 있다.
  return (
    <>
      <input type='text' onChange={handleChange(1)} />
      <input type='text' onChange={handleChange(2)} />
      <input type='text' onChange={handleChange(3)} />
    </>
  );
}
```

---

## Reference

- [10 React Antipatterns to Avoid - Code This, Not That!](https://www.youtube.com/watch?v=b0IZo2Aho9Y&list=PLGk6-UFPJT2WTTo0UhJILIvnpKyRkk2TW&index=9)
