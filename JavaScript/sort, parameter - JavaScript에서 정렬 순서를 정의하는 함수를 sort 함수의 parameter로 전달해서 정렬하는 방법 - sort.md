---
layout: post
title: 'JavaScript에서 정렬 순서를 정의하는 함수를 sort 함수의 parameter로 전달해서 정렬하는 방법'
subtitle: 'javascript sort paramter'
categories: frontend
tags: javascript
comments: true
---

- JavaScript에서 정렬 순서를 정의하는 함수를 sort 함수의 parameter로 전달해서 정렬하는 방법에 대해 정리한 글입니다.

---

- 다음과 같이 배열 안의 객체가 있을 때, 각각의 객체의 값을 기준으로 정렬할 수 있다

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
console.log("sorted - id2: ", data.sort(sortFunc('id2')))
  }
```

---

## Reference

- [MDN web docs - Array.prototype.sort](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Array/sort)
- [Any way to extend javascript's array.sort method to accept another parameter?](https://stackoverflow.com/questions/8537602/any-way-to-extend-javascripts-array-sort-method-to-accept-another-parameter)
