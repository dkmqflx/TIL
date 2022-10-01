## Container

```html
<body>
  <div class="card-container">
    <div class="title"></div>
  </div>
</body>
```

- 현재는 아래처럼 브라우저 사이즈에 따라서 스타일이 각각 적용되도록 처리한다

```css
@media (max-width: 768px) {
  .text {
    font-size: 16px;
  }
}
```

- 하지만 아래처럼 `container` 속성을 사용하면 브라우저 사이즈가 아니라 부모 요소인 card-container의 사이즈에 따라서 `.title` 클래스의 요소의 스타일이 변경된다
- 즉, 최대 `350px` 까지는 아래 `@container` 속성해서 정의한 `.title`의 스타일이 적용된다

```css
.card-container {
  contain: style layout inline-size;
  width: 50%;
  border: 1px soild red;
}

.title {
  font-size: 30px;
}

@container (max-width:350px) {
  .title {
    font-size: 15px;
    color: grey;
  }
}
```

---

## Scope

- 그냥 클래스를 정의하면, 해당 클래스에 해당하는 스타일이 html 파일 모든 곳에 적용된다
- 하지만 아래처럼 `@scope`에서 스타일을 정의하면 특정 컴포넌트에서만 적용된다.
- 즉, `.card-container` 부터 `.content` 까지만 스타일이 적용된다

```css
@scope (.card-container) to (.content) {
  .title {
    font-size: 16px;
  }
}
```

---

## nesting

- 이후에는 sass와 같은 전처리기에서 사용할 수 있는 것처럼, nesting 문법도 지원할 예정이다.

```css
.card-container {
  .title {
    font-size: 16px;
  }
}
```

---

## scroll-based 애니메이션

- 현재는 아래처럼 시간 흐름에 따른 애니메이션이 작동한다
- 만약 스크롤에 따라 애니메이션을 실행하려면 자바스크립트를 통해서 스크롤 위치에 따라 원하는 애니메이션이 작동하도록 코드를 작성해주어야 한다

```css
@keyframes shake {
  0% {
  }
  50% {
  }
  100% {
  }
}
```

- 하지만 scroll-based 애니메이션도 추가예정이다

---

## Reference

- [올해부턴 CSS 다르게 짬 ㅅㄱ (2022년 CSS 채신기술)](https://www.youtube.com/watch?v=4Vq8CQf-egI&list=PLGk6-UFPJT2US9QlHmZtHrk0zbnv4l9OY&index=5)
