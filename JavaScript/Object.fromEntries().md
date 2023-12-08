## Object.fromEntries()

Object.entries()가 Object에서 key와 value를 가져와서 [key, value]의 배열을 반환하는 역할을 한다면,

**`Object.fromEntries()`** 메서드는 [key, value] 쌍의 목록을 객체로 바꾼다.

```tsx
const entries = new Map([
  ["foo", "bar"],
  ["baz", 42],
]);

const obj = Object.fromEntries(entries);

console.log(obj);
// Expected output: Object { foo: "bar", baz: 42 }
```

Object.entries()를 사용해서 기존 객체의 값을 수정한 다음, 다시 객체로 바꿔야 할 때 유용하게 사용할 수 있다.

```tsx
const obj = {
  key1: "value-1",
  key2: "value-2",
  key3: "value-3",
};

const convert = (endpoints) => {
  return Object.entries(endpoints).map(([key, value]) => [
    key,
    value.split("-"),
  ]);
};

Object.fromEntries(convert(obj));

/*

	key1: ['value', '1']
	key2: ['value', '2']
	key3: ['value', '3']

*/
```

--

## Reference

- [Object.fromEntries()](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Object/fromEntries)

- [Object.entries()](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Object/entries)
