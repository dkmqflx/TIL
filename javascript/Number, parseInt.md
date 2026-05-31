## Number

- Number 원시 객체는 인자로 전달된 문자열을 숫자로 변환할 때 사용한다

- 이 때 전달된 문자열에 숫자가 없는 경우에는 NaN을 반환한다

> When used as a function, Number(value) converts a string or other value to the Number type. If the value can't be converted, it returns NaN.

```js
Number("123"); // returns the number 123
Number("123") === 123; // true

Number("unicorn"); // NaN
Number(undefined); // NaN

Number(10.123); // 10.123
```

## parseInt

- parseInt는, 특정 진수로 숫자를 변환할 때 사용한다

- 이 때 두번째 인수로 전달되는 진수에 해당하는 radix가 전달되지 않으면 기본적으로 10진수로 변환한다

> The parseInt() function parses a string argument and returns an integer of the specified radix (the base in mathematical numeral systems).

```js
parseInt(string);
parseInt(string, radix);

parseInt(10.123); // 10
```

- parseInt는 Number 객체와 달리 문자열에 숫자가 아닌 다른 값이 있으면, 숫자에 해당하는 값만 숫자로 변환한다

```js
Number("1000원"); // NaN

parseInt("1000원"); // 1000
```

- 다만 Number 객체와 parseInt 함수 모두 문자로 시작되는 문자열이 전달되면 NaN이 반환된다

```js
Number("약1000원"); // NaN

parseInt("약1000원"); // NaN
```

---

## Reference

- [Number](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number)

- [parseInt()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/parseInt)
