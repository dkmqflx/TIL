## SORT 쉽게 사용하기! 자바스크립트 짤막 팁, 브라우저별 속도 차이까지!

- 아래와 같은 배열이 있다고 하자

```js
const numbers = [1, 5, 3, 4, 7, 9, 11, 33, 44, 32];
```

- 이 때 sort 함수를 적용하면 순서대로 정렬되는 것이 아니라 아래와 같이 결과가 출력된다

```js
console.log(numbers.sort()); // [1, 11, 3, 32, 33, 4, 44, 5, 7, 9]
```

- sort 함수를 사용할 때는 함수를 통해서 두 인자를 비교해주어야 한다

- 아래처럼 1을 console.log를 통해서 a와 b를 출력하고 1을 반환 하는 함수를 전달했다고 하자

```js
numbers.sort((a, b) => {
  console.log(a, b);
  return 1; // 선언한 순서대로 출력된다
  // return -1; // 선언한 순서의 역순으로 출력된다
});
```

- 이 때 a, b는 아래와 같이, 다음 위치에 오는 숫자와 이전 위치에 오는 숫자가 출력된다

```shell
  5 1
  3 5
  4 3
  7 4
  9 7
  11 9
  33 11
  44 33
  32 44
```

- 즉, sort는 전달된 함수의 두 인자 a, b를 비교해서 결과값이 1과 같이 양수가 되면 그대로 순서가 유지되고

- -1과 같이 음수가 되면 순서를 바꾸게 된다

- 만약 오름차순대로 정렬고 싶다면 아래와 같이 코드를 작성하면 된다

```js
numbers.sort((a, b) => {
  return a - b;
});
```

- 작성된 코드는 다음과 같이 작동한다

- return a-b를 하게되면

- 5 1을 비교하니까 a - b값이 5 - 1이 되는데

- 이 값이 양수가 되니까

- 1이 5에 앞에 있게 되는 것이다

- 반대로 내림차순대로 정렬을 한다고 하면

- return b - a를 하게 되면

- 5와 1을 비교할 때 1 - 5가 음수가 되니까

- 기존의 1, 5의 위치에서 5,1로 위치가 바뀌게 되는 것이다

- 즉, 위에서 작성된 코드는 아래와 가다

```js
numbers.sort((a, b) => {
  if (a > b) return 1; // a가 b보다 크면 1 반환, 순서 그대로 유지된다
  else if (a < b)
    return -1; // b가 a보다 크면 -1 반환, 순서 그대로 유지 되지 않는다
  else return 0;
});
```

- 즉 a와 b가 어떤 값이 될 지는 모르지만

- 비교했을 때 a가 b보다 큰 경우 1이 된다는 말은 순서가 유지된다는 말이고

- 비교했을 때 a가 b보다 작은 경우 -1이 된다는 말은 순서가 바뀐 다는 말이다

- 이것을 내림 차순에도 적용할 수 있는데

- 비교했을 때 a가 b보다 큰 경우 -1이 된다는 말은 순서가 바뀐다는 말이고

- 비교했을 때 a가 b보다 작은 경우 1이 된다는 말은 순서가 유지 된다는 말이다

- 다만 이런 sort 알고리즘은 브라우저별로 다르게 적용한다

- 그렇기 때문에 위 sort 내에 있는 log도 브라우저 마다 실제로 다르게 출력된다

- 제일 처음 작성된 return 1을 반환하는 함수, 그리고 a-b, b-a을 return 하는 함수 모두 console.log를 보면 a와 b가 브라우저 별로 다른 것을 확인할 수 있다

- 객체도 sort 함수를 사용해서 비교할 수 있다

```js
const animals = [
  { name: 'monkey', size: 'medium', weight: 7 },
  { name: 'cat', size: 'small', weight: 5 },
  { name: 'lion', size: 'big', weight: 30 },
  { name: 'mouse', size: 'small', weight: 12 },
  { name: 'monkey', dog: 'medium', weight: 28 },
];

console.time();
animals.sort((a, b) => {
  console.log(`a: ${a.name} b: ${b.name}`);
  return a.name > b.name ? 1 : -1;
});
console.timeEnd();
```

- 그리고 console.time과 console.timeEnd를 사용해서 브라우저별로 실행해보면

- 실제로 브라우저별로 결과가 다르게 출력되는 것을 확인할 수 있다

- 그리고 sort 알고리즘은 브라우저별로 다르게 적용하기 때문에

- 위 animal sort 내에 있는 log도 브라우저 마다 실제로 다르게 출력된다

<br/>

- 또 다른 예시로 다음과 같이 배열 안의 객체가 있을 때, 각각의 객체의 값을 기준으로 정렬할 수 있다

```javascript
const data = [
  { date: '2021-04-17', id: 5, id2: 11 },
  { date: '2021-04-21', id: 3, id2: 3 },
  { date: '2021-04-29', id: 2, id2: 21 },
  { date: '2021-05-11', id: 7, id2: 19 },
  { date: '2021-05-21', id: 7, id2: 18 },
  { date: '2021-06-21', id: 9, id2: 18 },
];
```

- `id`를 기준으로 정렬

  ```javascript
  console.log(data.sort((a, b) => a.id - b.id));
  ```

- `id2`를 기준으로 정렬

  ```javascript
  console.log(data.sort((a, b) => a.id2 - b.id2));
  ```

- 하지만 상황에 따라 다른 기준으로 원소를 정렬해야할 때가 있는데, 이 때 sort 함수에 정렬의 기준이 되는 함수를 전달하는 방식으로 각각 다른 기준으로 원소를 정렬할 수 있다

- [MDN 문서의 sort](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Array/sort)를 확인해 보면 다음과 같이 sort 함수에는 `compare function`이 전달되는 것을 확인할 수 있다

  ```jsx
  arr.sort([compareFunction]);
  ```

- 이 때, sort 함수는 직접적으로 a, b 를 제외한 인자를 받을 수 없기 때문에, 함수를 전달하는 함수를 만들고 그 안에서 정렬 기준이 되는 변수를 사용한다

- 아래 함수는 정렬 기준이 되는 함수로,`sortby`에 정렬이 되는 값을 전달함으로써 각각 다른 기준으로 데이터를 정렬할 수 있다

```jsx
// compare function
const sortFunc = (sortby) => (a, b) => a[sortby] > b[sortby] ? 1 : -1;
```

```javascript
// id를 기준으로 정렬
console.log('sorted - id: ', data.sort(sortFunc('id')));
```

```javascript
// id2를 기준으로 정렬
console.log('sorted - id2: ', data.sort(sortFunc('id2')));
```

---

## Reference

---

### Reference

- [SORT 쉽게 사용하기! 자바스크립트 짤막 팁, 브라우저별 속도 차이까지!](https://www.youtube.com/watch?v=scjyeC74_4k&list=PLGk6-UFPJT2XTiBhMH7v9LXlX_JHEUmfg&index=12)
- [MDN web docs - Array.prototype.sort](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Array/sort)
- [Any way to extend javascript's array.sort method to accept another parameter?](https://stackoverflow.com/questions/8537602/any-way-to-extend-javascripts-array-sort-method-to-accept-another-parameter)
