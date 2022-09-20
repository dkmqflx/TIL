- size를 결정하는 단위는 크게 absolute length unit과 relative length unit 두가지로 나눌 수 있다

## absolute length unit

- absolute length unit에서 가장 많이 사용되는 단위는 px이다.
- px는 모니터 위에서 화면에 나타낼 수 있는 가장 작은 단위로써 절대적인 값이다.
- 따라서 font-size를 px로 설정한 경우 브라우저에서 설정에서 글꼴 크기를 바꾸더라도 크기가 바뀌지 않는다
- 또한 컨테이너의 사이즈가 변경되어도 컨텐츠가 고정된 값으로 유지되기 때문에 %를 이용해서 컨테이너의 크기에 상대적으로 변할 수 있도록 설정해준다
- 이러한 문제점을 해결하기 위한 방법으로 %, vh, vw, em, rem과 같은 단위를 쓴다

## relative length unit

### em

- relative to **parent** element
- 현재 지정된 폰트 사이즈를 나타내는 단위
- 같은 폰트 사이즈라고 해서 어떤 폰트 패밀리를 쓰느냐에 따라 사용자에게 보여지는 텍스트의 크기는 달라질 수 있다
- 예를 들어 open sans 를 사용할 때와 roboto 사용할 때 알파벳 m이 사용자에게 보여지는 크기가 달라진다
- em은 선택된 폰트 패밀리에 상관 없이 항상 고정된 폰트 사이즈를 가지고 있다
- 예를 들어 폰트 사이즈가 16px이면 1em은 16px이 된다
- em 단위는 사용된 요소의 폰트 크기에 따라 그 변환된 값이 정해진다

- `em`은 부모의 폰트 사이즈에 상대적으로 크기가 계산이 되어진다

- 아래 예제에서 기본적으로 브라우저에서 `html`에 할당되는 폰트사이즈는 `16px`이므로, 별도로 폰트 사이즈를 변경하지 않으면 `1em`은 `16px`이 된다.

- 따라서 `parent`의 폰트 사이즈는 `16 * 8`인 `128px`, `child`의 폰트 사이즈는 `128px`의 절반인 `64px`이 된다

```html
<style>
  .parent {
    font-size: 8em;
  }
  .child {
    font-size: 0.5em;
  }
</style>

<body>
  <div class="parent">
    Parent
    <div class="child">Child</div>
  </div>
</body>
```

### rem

- relative to **root** element
- 부모에 따라 폰트 사이즈가 결정되는 것이 아니라 루트에 지정된 폰트 사이즈에 따라서 크기가 결정된다.
- 즉, html 요소의 폰트 사이즈가 rem 크기의 기준이 된다
- 아래와 같은 경우, parent의 폰트 사이즈는 `16 *8 `인 `128px`, child의 폰트 사이즈는 em을 사용했을 때와 달리 `16px`의 절반인 `8px`이 된다

```html
<style>
  .parent {
    font-size: 8rem;
  }
  .child {
    font-size: 0.5rem;
  }
</style>

<body>
  <div class="parent">
    Parent
    <div class="child">Child</div>
  </div>
</body>
```

- 기본적으로 html은 다음과 같은 폰트 사이즈의 속성이 지정되어 있기 때문에 브라우저에서 지정된 폰트 사이즈에 따라 폰트 사이즈가 정해진다

  ```css
  html {
    font-size: 100%;
  }
  ```

- 따라서 브라우저 세팅에서 폰트 사이즈 변경하면 가변적으로 변한다

- 반대로 html에서 폰트 사이즈 속성의 값을 변경해서 고정된 폰트사이즈를 사용하면 반응형으로 폰트 사이즈가 변경되지 않는다

  ```css
  html {
    font-size: 32px;
  }
  ```

### vh / vw

- 브라우저 너비와 높이에 대한 속성
- 100vh는 브라우저 높이의 100을 나타낸다
- 50vh는 브라우저 높이의 절반을 나타낸다

### vmin

- 브라우저의 높이와 너비중 작은 값을 기준으로 100분의 1을 한 값이다
- 50 vmin 브라우저 너비와 높이 중에 작은 값의 50%

### vmax

- 브라우저의 높이와 너비 중 큰 값을 기준으로 100분의 1을 한 값이다
- 50 vmax는 브라우저 너비와 높이 중에 큰 값의 50%
- 아래와 같은 예제에서 width:50% 인 경우에는 브라우저의 크기가 변할 때 부모 요소의 50%로 크기가 유지되지만, width: 50vw인 경우에는 부모 요소에 상관없이 브라우저의 너비에 따라 변한다

```html
<style>
  .parent {
    font-size: 8em;
    width: 500px;
  }
  .child {
    font-size: 0.5em;
    width: 50vw;
    background-color: beige;
  }
</style>

<body>
  <div class="parent">
    Parent
    <div class="child">Child</div>
  </div>
</body>
```

---

### reference

- [프론트엔드 필수 반응형 CSS 단위 총정리 (EM과 REM) | Responsive CSS Units
  ](youtube.com/watch?v=7Z3t1OWOpHo&t=11s)
