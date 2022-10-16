- 다음과 같이 배열 안의 객체가 date 관련된 값을 가지고 있을 때, date 값을 기준으로 배열을 정렬할 수 있다

```javascript
const date = [
  { date: '2021-04-17' },
  { date: '2021-04-21' },
  { date: '2021-04-29' },
  { date: '2021-05-11' },
  { date: '2021-05-21' },
  { date: '2021-06-21' },
];
```

- `new Date` 를 사용하면 시간의 특정 지점을 나타내는 `Date` 객체를 만들 수 있다

- 따라서, `Date` 객체를 생성해서 각각의 `Date` 객체를 비교하는 방식으로 date 값을 기준으로 배열을 정렬할 수 있다

- 아래는 시간 순으로 배열을 정렬한 결과이다

- sort 함수는 원본 배열을 변경한 후, 변경된 배열을 반환한다

```javascript
const orderedDate = date.sort((a, b) => new Date(a.date) - new Date(b.date));

console.log('orderedDate:', orderedDate);
// 시간의 오름차순으로 정렬된 것을 확인할 수 있다
```

- 아래는 시간 역순으로 정렬한 결과이다

```javascript
const reversedOrderedDate = date.sort(
  (a, b) => new Date(b.date) - new Date(a.date)
);

console.log('reversedOrderedDate:', reversedOrderedDate);
// 시간의 역순으로 정렬된 것을 확인할 수 있다
```

---

## Reference

- [MDN web docs - Array.prototype.sort](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Array/sort)
- [MDN web docs - Date](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Date)
- [Sort array of objects with date field by date](https://stackoverflow.com/questions/40965727/sort-array-of-objects-with-date-field-by-date)
- [How to sort an object array by date property?](https://stackoverflow.com/questions/10123953/how-to-sort-an-object-array-by-date-property)
