## @support

- @support 속성은 브라우저의 css 속성 지원 여부에 따라 스타일이 적용되도록 한다.

> The @supports CSS at-rule lets you specify CSS declarations that depend on a browser's support for CSS features. Using this at-rule is commonly called a feature query. The rule must be placed at the top level of your code or nested inside any other conditional group at-rule.

- 예를들 아래오 같이 코드를 작성하면, `display: grid`를 지원하는 경우에만 아래 `display: grid` 속성이 적용된다

```css
@supports (display: grid) {
  div {
    display: grid;
  }
}
```

- 만약 webp 확장자 파일을 사용하는데, 해당 확장자를 지원하지 않는 브라우저에 대응하기 위해서는 아래와 같이 코드를 작성해주면 된다

- 기본적으로 jpg 확장자를 사용하지만, 만약 브라우저가 webp 확장자를 지원하게 되면 jpg 확장자 대신 webp 확장자를 사용한다.

```css
.logo-container {
  background-image: url("logo.jpg");

  @supports (background-image: url("logo.webp")) {
    background-image: url("logo.webp");
  }
}
```

---

## Reference

- [CSS Fallbacks for WebP background images with @supports](https://www.js-craft.io/blog/css-fallbacks-for-webp-background-images-with-supports/)

- [@support - MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/@supports)
