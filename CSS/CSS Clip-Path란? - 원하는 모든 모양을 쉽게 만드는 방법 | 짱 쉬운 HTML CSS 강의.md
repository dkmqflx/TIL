- css로 네모를 만들려면 width와 height를
- 원을 만들려면 border-radius 속성을 추가해주면 된다.
- 별, 말풍선, 화살표와 같은 모양을 만들려면 clip-path 속성을 사용하면 된다.

### clip-path

- 요소의 특정한 범위를 지정해서 바깥부분은 자르고 범위 안쪽 부분만 보여주는 속성이다
- div 뿐 아니라 이미지 속성 또한 원하는 부분을 자를 수 있다

- [clip path generator](https://bennettfeely.com/clippy/)를 사용하면 간단하게 팔요한 css 속성을 알 수 있다.

```css

div{
  height:500px;
  width:500px
  clip-path:circle(50% at 50% 50%);
}

```

```html
<body>
  <div class="box"></div>
</body>
```

```css
body {
  align-items: center;
  display: flex;
  height: 100vh;
  justify-content: center;
  background-color: black;
}

.box {
  clip-path: polygon(
    50% 0%,
    61% 35%,
    98% 35%,
    68% 57%,
    79% 91%,
    50% 70%,
    21% 91%,
    32% 57%,
    2% 35%,
    39% 35%
  );
  background: orange;
  height: 300px;
  width: 300px;
  transition: clip-path 0.5s;
}

.box:hover {
  clip-path: polygon(
    50% 0%,
    75% 18%,
    98% 35%,
    89% 60%,
    79% 91%,
    50% 91%,
    21% 91%,
    11% 63%,
    2% 35%,
    25% 18%
  );
}
```

---

## Reference

- [CSS Clip-Path란? - 원하는 모든 모양을 쉽게 만드는 방법 | 짱 쉬운 HTML CSS 강의](https://www.youtube.com/watch?v=O1zJGvoXL-w&list=PLGk6-UFPJT2US9QlHmZtHrk0zbnv4l9OY&index=3)
