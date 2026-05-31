## shouldForwardProps

공식문서에는 shouldForwardProps 를 아래와 같이 설명하고 있다

> This is a more dynamic, granular filtering mechanism than transient props. It's handy in situations where multiple higher-order components are being composed together and happen to share the same prop name.`shouldForwardProp` works much like the predicate callback of `Array.filter`. A prop that fails the test isn't passed down to underlying components, just like a transient prop.

그리고 아래와 같은 설명과 `.withConfig` 와 함께 사용해야 한다고 명시하고 있다.

> Keep in mind that, as in this example, other chainable methods should always be executed after `.withConfig`.

여기서 **withConfig**의 속성은 다음과 같다

> In styled-components, the **`withConfig`** function allows you to modify the configuration options for a styled component. It enables you to customize various aspects of a styled component, such as display name, component ID, and other underlying functionalities.

즉, styled component의 optional한 configuration을 정할 때 사용하는 함수라고 할 수 있다.

아랭 코드는 shouldForwardProp를 사용하는 예시로, hidden을 prop으로전달하지만 shouldForwardProp에서 hidden이 전달되지 않도록 처리하고 있기 때문에 hidden prop은 전달되지 않고 hiddne이라는 텍스트가 화면에 보이게 된다

```tsx
const Comp = styled("div")
  .withConfig({
    shouldForwardProp: (prop) => !["hidden"].includes(prop),
  })
  .attrs({ className: "foo" })`
  color: red;
  &.foo {
    text-decoration: underline;
  }
`;

// hidden과 none hidden 모두 화면에 보인다
render(
  <div>
    <Comp hidden>hidden</Comp>
    <Comp hidden>none hidden</Comp>
  </div>
);
```

---

### Reference

- [styled components - shouldForwordProp](https://styled-components.com/docs/api#shouldforwardprop)

- [MDN - hidden](https://developer.mozilla.org/ko/docs/Web/HTML/Global_attributes/hidden)
