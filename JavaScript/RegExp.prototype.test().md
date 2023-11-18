### RegExp.prototype.test()

- 자바스크립트에서는 정규식의 test 함수를 통해, test 함수의 인자로 전달된 값이 정규식에 매챙 되는지를 확인할 수 있다

> The **`test()`** method of `[RegExp](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp)` instances executes a search with this regular expression for a match between a regular expression and a specified string. Returns `true` if there is a match; `false` otherwise.

- 만약 소수점 둘째자리까지의 숫자만 매칭되도록 하고 싶다면 아래와 같이 정규식을 작성하고 test 함수를 호출하면 된다

```tsx
const 소수점_둘째자리까지_숫자인지_확인 = /^\d*.?\d{0,2}$/;

소수점_둘째자리까지_숫자인지_확인.test(10); // true
소수점_둘째자리까지_숫자인지_확인.test(10.12); // true
소수점_둘째자리까지_숫자인지_확인.test(10.123); // false
```

---

## Reference

- [MDN - RegExp.prototype.test()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/test)
