## 상황에 따른 단위 선택

1. 부모 요소의 너비나 높이에 따라서 사이즈가 변경이 되어야 하는 경우 `%`나 `em`을 사용하고, 부모와는 상관없이 브라우저 사이즈에 대해서 변경되어야 하는 겨우 `v*`나 `rem` 같은 단위 사용한다

2. 요소의 너비나 높이에 따라 사이즈가 변경이 되어야 한다면 `%`나 `v*` 같은 단위를 사용하고 폰트 사이즈에 따라 사이즈가 변경되어야 하는 경우 em과 rem을 사용한다

## em vs rem

- em과 rem은 디자인이나 구현해야 하는 기능에 따라 선택해서 사용한다

- 예를 들어 Like 글자가 있는 버튼 컴포넌트를 만든다고 했을 때, 해당 버튼이 가장 상위 컴포넌트에서 사용될 때와 자식 컴포넌트에서 사용될 때 모두 폰트 사이즈가 같아야 하는 경우처럼 어디에서 사용되던지 같은 폰트 사이즈를 가져야 하는 경우에는 rem 단위를 사용한다

- 하지만 부모 요소에 따라서 사이즈가 변경되어야 하는 경우에는 em 단위를 사용한다

## Examples

- 아래 예제처럼 많은 부모 요소가 있는 경우 폰트사이즈가 레벨별로 바로 계산하기 쉽지 않다

```html
<!-- 폰트 사이즈 점점 더 커진다 -->
<style>
  .level1 {
    font-size: 2em;
  }
  .level2 {
    font-size: 2em;
  }
  .level3 {
    font-size: 2em;
  }
  .level4 {
    font-size: 2em;
  }
</style>

<body>
  <div class="level1">
    <h1>level1</h1>
    <div class="level2">
      <h2>level2</h2>
      <div class="level3">
        <h3>level3</h3>
        <div class="level4">
          <h1>level4</h1>
        </div>
      </div>
    </div>
  </div>
</body>
```

- 따라서 이러한 경우 em대신 rem 단위를 사용하면 폰트사이즈를 바로 계산을 할 수 있다
- 즉, 폰트사이즈를 결정할 때는 em 보다는 rem으로 결정하는 것이 더 낫다

```html
<!-- 모든 폰트 사이즈 같다  -->
<style>
  .level1 {
    font-size: 2rem;
  }
  .level2 {
    font-size: 2rem;
  }
  .level3 {
    font-size: 2rem;
  }
  .level4 {
    font-size: 2rem;
  }
</style>

<body>
  <div class="level1">
    <h1>level1</h1>
    <div class="level2">
      <h2>level2</h2>
      <div class="level3">
        <h3>level3</h3>
        <div class="level4">
          <h1>level4</h1>
        </div>
      </div>
    </div>
  </div>
</body>
```

- 또 다른 예제로 아래처럼 패딩으로 em 값을 사용할 수 있다

```html
<style>
  h1 {
    font-size: 5em;
    background-color: burlywood;
    padding: 0.1em;
    display: inline-block;
  }
</style>

<body>
  <h1>Hello</h1>
</body>
```

- 만약 패딩의 크기가 px로 정해져 있다면 폰트 사이즈가 작아지거나 커질 때도 패딩은 변하지 않게 된다

- 폰트 사이즈는 em 을 단위로 하기 때문에 브라우저에 의해 폰트 사이즈가 크거나 작아질 수 있는데 이 때 패딩이 고정되어 있으면 글자가 작아지는 경우 패딩이 너무 크거나, 반대로 플자가 큰 경우에 패딩이 너무 작아보이는 경우가 생길 수 있다

- 즉, 브라우저 - 설정에서 폰트 사이즈를 변경하더라도, 변경된 폰트 사이즈에 맞게 패딩값도 변경이 된다

- 따라서 패딩도 폰트 크기에 따라서 바뀌어야 하기 때문에 픽셀보다는 em단위로 변경시켜 준다

- 패딩을 em 단위로 설정하면 아래처럼 반응형에서도 화면의 크기에 따라 폰트 사이즈가 변경이 될 때 패딩도 변경된다

```css
h1 {
  font-size: 5em;
  background-color: burlywood;
  padding: 0.1em;
  display: inline-block;
}

@media screen and (max-width: 780px) {
  h1 {
    font-size: 3em;
  }
}
```

- 아래는 component라는 부모 요소안에서 em과 rem을 사용하는 경우이다

```html
<section class="component">
  <header class="title">Hello</header>
  <p class="contents">
    Lorem ipsum dolor sit amet consectetur adipisicing elit. Velit quia amet,
    eaque ex, saepe vel modi rem cupiditate ullam officia officiis perferendis
    error pariatur dolore? Architecto totam voluptatem facilis odit.
  </p>
</section>

<style>
  .component {
    width: 50%;
    border: 1px solid burlywood;
    font-size: 2rem;
  }

  .title {
    background-color: burlywood;
    padding: 0.5em;
  }

  .contents {
    font-size: 1rem;
    padding: 0.5em;
  }

  @media screen and (max-width: 780px) {
    .component {
      font-size: 1.5rem;
    }
  }
</style>
```

- component처럼 박스 컨테이너 자체의 사이즈를 만들 때에는 em이나 rem 보다는 %를 사용하는게 좋은데 그 이유는 em과 rem은 가변적으로 크기가 변하지만 폰트 사이즈에 비례해서 크기가 변경되기 때문에 결국 고정적인 값을 가지기 때문이다

- 따라서 컨텐츠를 유동적으로 만들기 위해서는 %를 사용하는 것이 좋다

- 패딩 값으로 em을 썼는데 em은 현재 폰트 사이즈에 따라 상대적으로 크기가 결정된다

- 따라서 `.title` 의 폰트 사이즈는 2rem이므로, 패딩은 16px이 되고 `.contents` 의 폰트 사이즈는 1rem이기 8px이 된다

- `.title`의 패딩은 em을 사용했기 때문에 폰트 사이즈에 따라 패딩 값이 결정되는데, 이 때 `.title`과 `.contents`의 폰트 사이즈가 다르기 때문에 `.title`에 더 큰 패딩이 적용되어 수직적로 정렬이 되지 않는 것을 확인할 수 있다

- 따라서 요소마다 사이즈에 상관없이 고정적인 패딩을 유지해야 되는 경우 rem을 사용해서 아래처럼 수정해준다

```css
/* 좌우 패딩값이 일치하기 때문에 수직적으로 정렬된다 */

.title {
  background-color: burlywood;
  padding: 0.5em 0.5rem;
}

.contents {
  font-size: 1rem;
  padding: 0.5em 0.5rem;
}
```

- `.title` 클래스에서 rem을 사용하는이유는 `.title` 클래스를 사용하는 요소들의 글자들이 어느 컴포넌트안에서 쓰이던지 상관없이 동일한 사이즈를 유지하기 위해서이다

그리고 아래처럼 미디어 쿼리에서도 em을 사용할 수 있다

```css
@media screen and (max-width: 768px) {
  .container {
    flex-direction: column;
  }
}
```

```css
@media screen and (max-width: 48em) {
  .container {
    flex-direction: column;
  }
}
```

- px로 max-width를 정해놓으면 브라우저 - 설정에서 폰트 사이즈를 크게 변경시켜도 동일하게 768px에서 세로로 요소가 정렬되기 때문에 반응형이 적용되기 직전에는 요소에 비해 폰트 사이즈가 너무 커서 레이아웃이 이상해지는 경우가 생길 수 있다

- 따라서 48em과 같이 설정해 주면 더 자연스럽게 반응형으로 레이아웃이 변하게 된다

- 이 때, rem 단위를 사용하지 않는 것이 좋은데 그 이유는 rem은 브라우저의 default font size를 사용하기 때문에 브라우저에 따라 다른 반응형으로 작동할 수 있기 때문이다

- 결론적으로, 박스 자체의 사이즈를 결정할 때는 `%` 나 `v*` 또는 flex 를 이용해서 유동적으로 만드는 것이 좋다.

- 요소의 폰트 사이즈를 결정할 때는 root를 기준으로 사이즈가 변경되어야 하는 경우에는 rem을, 부모 요소에 따라서 사이즈가 변경되어야 하는 경우에는 em을 사용한다

---

### Reference

- [프론트엔드 필수 반응형 CSS 단위 em 과 rem | 예제 프로젝트를 통해 정리 하세요 ✨
  ](https://www.youtube.com/watch?v=xWMKz9NCD0k)
- [✨ 영상에 나온 소스코드들](https://github.com/dream-ellie/css-responsive-units)
