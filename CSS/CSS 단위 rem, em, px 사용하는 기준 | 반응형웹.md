- 폰트 사이즈는 `rem`, 나머지 패딩 같은 것들은 `em`로 설정하는데 꼭 그런 것은 아니지만 대부분 이렇게 적용하면 효율적으로 작동한다

- 사실 정답이 있는 문제는 아니고 디자인의 의도에 따라서 결정해야 한다

```html
<!-- html -->
  <body>
    <div class="box">Box</div>
  </body>
</html>
```

```css
/* css */

.box {
  display: inline-block;
  box-sizing: border-box;
  background-color: tomato;
  padding: 64px;
  font-size: 160px;
  font-weight: 900;
}
```

- 기본 디자인 형태가 위와 같이 작성되었다고 할 때, 폰트 사이즈는 `rem`으로 한다

- 폰트 사이즈는 박스 안에서 정의되는 css의 기준점이 되기 때문에 `em`으로 하게 되면 부모 요소가 있다면 부모 요소에 따라 계산이 되기이다.

```css
/* css */

.box {
  display: inline-block;
  box-sizing: border-box;
  background-color: tomato;
  font-weight: 900;

  /* padding:64px; */
  padding: 4rem;

  /* font-size: 160px; */
  /* 160이니까 10rem */
  font-size: 10rem;
}
```

- 아래처럼 폰트 사이즈가 2배로 커진다고해도, 패딩 사이즈도 함께 커지지 않는데 그 이유는 패딩 값을 `rem`으로 설정했기 때문이다.

- 보통 박스나 여백 같은 것들은 폰트 사이즈를 기준으로 설정하기 때문에, 이처럼 폰트 사이즈를 기준으로 디자인이 된 여백이라면 `rem` 대신 `em`을 사용한다

```css
/* css */

.box {
  display: inline-block;
  box-sizing: border-box;
  background-color: tomato;
  font-weight: 900;

  /* padding:64px; */
  /* 64 / 160 = 0.4em */
  padding: 0.4em;

  /* font-size: 160px; */
  font-size: 20rem;
}
```

- 이렇게 `em`으로 수정하게 되면, 폰트 사이즈가 커질 때 패딩 값 또한 함께 커지게 된다

- 만약 이렇게 함께 커지는 것이 아니라 고정되어야 하는 것이라면 `px`을 쓰는 것이 합리적이다

---

## Reference

- [CSS 단위 rem, em, px 사용하는 기준 | 반응형웹](https://www.youtube.com/watch?v=S5uMXoGogkk&list=PLGk6-UFPJT2US9QlHmZtHrk0zbnv4l9OY&index=5)
