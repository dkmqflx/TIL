## padStart

> The padStart() method of String values pads this string with another string (multiple times, if needed) until the resulting string reaches the given length. The padding is applied from the start of this string.

```js
const str1 = "test";

const str2 = str1.padEnd(10, "*");
// '******test'

str2.length;
// 10
```

<br/>

## padEnd

> The padEnd() method of String values pads this string with a given string (repeated, if needed) so that the resulting string reaches a given length. The padding is applied from the end of this string.

```js
const str1 = "test";

const str2 = str1.padEnd(10, "*");
// 'test******'

str2.length;
// 10
```

---

## Reference

- [padEnd](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/padEnd)
