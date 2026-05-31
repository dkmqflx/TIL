## css helper

styled components에서는 css helper(` **css``** `)를 사용해서 css를 생성할 수 있다. 이 때 css helper는 tagged template literal 방식으로 동작하기 때문에 배열을 return 한다

<blockquote>

A helper function to generate CSS from a template literal with interpolations. You need to use this if you return a template literal with functions inside an interpolation due to how tagged template literals work in JavaScript.

If you're interpolating a string you do not need to use this, only if you're interpolating a function.

</blockquote>

```tsx
interface ComponentProps {
  $complex?: boolean;
  $whiteColor?: boolean;
  width: number;
}

const complexMixin = css<ComponentProps>`
  width: 200px;

  color: ${(props) => (props.$whiteColor ? "white" : "black")};

  background-color: ${(props) => (props.$complex ? "white" : "black")};
`;

console.log("complexMixin", complexMixin);

/*

- (5) ['\n width: 200px;\n\n color: ', ƒ, ';\n\n background-color: ', ƒ, ';\n ', isCss: true]
- 0: "\n width: 200px;\n\n color: "
- 1: (props)=>props.$whiteColor ? "white" : "black"
- 2: ";\n\n background-color: "
- 3: (props)=>props.$complex ? "white" : "black"
- 4: ";\n "
- isCss: true

*/
```

---

## Reference

- [styled components - css](https://styled-components.com/docs/api#css)
