## Template Literal

- Template literals are literals delimited with backtick (`) characters, allowing for multi-line strings, string interpolation with embedded expressions, and special constructs called tagged templates.

### Syntax

```js
`string text ${expression} string text`;
```

## Tagged Template Literal

- A more advanced form of template literals are tagged templates.

- Tags allow you to parse template literals with a function. The first argument of a tag function contains an array of string values. The remaining arguments are related to the expressions.

- The tag function can then perform whatever operations on these arguments you wish, and return the manipulated string. (Alternatively, it can return something completely different, as described in one of the following examples.)

- The name of the function used for the tag can be whatever you want.

- Tagged Template Literal 문법에서는 `function()`이 아닌 ` function`` `과 같은 방식으로 함수를 호출하고

- 내부의 각 `${표현식}`을 구분자로 하여 string이 split 된다.

### Syntax

```js
const userName = "Mike";
const age = 28;

// 첫번째 인자에는 ``안에 있는 string이 배열로 전달되고
// 나머지 두번째 부터는 변수들이 들어온다
function transform(staticData, ...dynamicData) {
  console.log(staticData); // ["Hi, ", " and I am ", ".", raw: ['Hi, ', ' and I am ', '.']]
  console.log(dynamicData); // ["Mike", 28]
}

transform`Hi, ${userName} and I am ${age}.`;
// Hi, Mike and I am 28
```

## Tagged Template Literal With Styled Component

- styled-component에서 tagged template literal 문법이다

- 아래와 같이 `` 내부에 string과 변수가 전달되면,

- 내부적으로 값을 할당해 주는 방식으로 작동한다

```js
const Button = styled.button`
  font-size: ${(props) => (props.primary ? "2em" : "1em")};
`;
```

- 대략적인 동작 과정을 코드로 나타내면 다음과 같다

```js
function styled(css, ...variables) {
  const computedCss = css
    .map((chunk, index) => `${chunk}${variables[index] || ""}`)
    .join("");
  return computedCss;
}

const Button = styled`
  background: ${theme.colors.secondary};
  margin-bottom: ${theme.spacing.min};
  span {
    padding: 0.25em 1em;
    color: ${theme.colors.primary};
  }
`;
```

---

## Reference

- [MDN - Template literals (Template strings)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals#tagged_templates)

- [Tagged Template Literals 문법](https://mygumi.tistory.com/395)

- [The magic behind 💅 styled-components](https://mxstbr.blog/2016/11/styled-components-magic-explained/)

- [Styled Component Syntax 이해하기](https://kschoi.github.io/cs/styled-component-syntax/)
