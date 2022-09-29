### display

```css
div,
span {
  width: 80px;
  height: 80px;
  margin: 20px;
}

/*
span은 안에 내용이 있어야 표시된다.
*/

div {
  display: inline;
}
/* display를 inline으로 바꾼다음, <div></div>처럼 태그만 쓰면,  
내용이 없어서 화면에 표시가 안되고, <div>1</div> 처럼 내용을 적어야지 화면에 표시된다 */

div {
  display: inline-block;
}
/* 
inline이 글씨 길이에 따라서 크기가달라지는 것과 달리, 
block은 지정한 박스 width나 height에 따라표기된다

block: 한줄당 한개
inline-block : 한줄에 여러개 블록 
*/

span {
  display: block;
}
/* span 태그의 기본값은 inline, 하지만 display 속성에서 block level로 바꾸어줄 수 있다  */
```

---

### position

```html

<body>
  <article class="container">
    <div class="box"></div>
    <div></div>
    <div></div>
    <div></div>
    <div></div>
</body>

```

```css
/* class="box"의 부모는 class="container" */

.container {
  background: yellow;
}

div {
  width: 50px;
  height: 50px;
  background: red;
}

.box {
  background: blue;
}
```

---

#### position : static

```css
.container {
  background: yellow;
  left: 20px;
  top: 20px;
}
```

- `.container`의 `position`이 `static`인 경우
  `.container`에서 `left`와 `top` 값을 변경시켜도 아무런 변화가 없는데 그 이유는 `position`이 default value가 `static`이기 때문이다
  `static` 속성인 경우에는 html에 정의된 순서대로 차례대로 화면에 표시되기 때문에 아무런 변화가 나타나지 않는다

---

#### position : relative

```css
.container {
  background: yellow;
  top: 20px;
  left: 20px;
  position: relative;
}
```

- `.container`의 `position`을 `relative`로 지정한 다음 `.container`의 `left, top` 값을 변경하면 노란색 박스가 지정한 크기만큼 위, 왼쪽에서 떨어진 것을 확인할수 있다

- `position`을 `relative`로 설정하면 원래 있어야 하는 위치에서 지정한 크기 만큼 이동하게 된다

- 따라서 아래와 같이 `.box`의 `left, top`변경하면, 파란색 박스가 원래 있어야하는 위치에서 위, 아래 `20px`만큼 이동한 것을 알 수 있다.

- 그리고 이동이 일어나면, 이 전에 `position`이 `static` 일 때 위치했던 자리를 아래에 있던 다른 상자들이 이동해서 자리를 채운다

```css
.box {
  background: blue;
  left: 20px;
  top: 20px;
  position: relative;
}
```

---

#### position: absolute

```css
.box {
  background: blue;
  left: 20px;
  top: 20px;
  position: absolute;
}
```

- `.box`의 `position`을 `absolute`로 바꾸면 `.container`를 기준으로 `left, top`에서 `20px`만큼 이동한 것을 확인할 수 있다

- `position`을 `absolute`로 지정하면 내 item이 담겨 있는 item과 가장 가까운 위치에 있는 박스 안에서 위치 변경이 일어난다

- 즉 `absolute`의 경우 부모 박스 중에 가장 근접한 `static`이 아닌 부모 박스의 `position`을 기준으로 움직인다

- 따라서`.box`의 `left, top` 값을 변경하면 `container`를 기준으로 이동한다

---

#### position: fixed

```css
.box {
  background: blue;
  left: 20px;
  top: 20px;
  position: fixed;
}
```

- `position`이 `absolute` 일 때 내가 담겨 있는 상자인 `.container`를 기준으로 움직이는 것과 달리 `.box`의 `position`을 `fixed`로 지정하면, `.container`에서 완전히 벗어나 `window`를 기준으로 움직인다.

---

#### position: sticky

```css
.box {
  background: blue;
  left: 20px;
  top: 20px;
  position: sticky;
}
```

- `.box`의 `position`을 `sticky`로 지정하면 원래 있던 자리에 고정된다
- 따라서 scrolling되어도 없어지지 않고 원래 자리 그대로 박스가 고정되어 있다

---

### [https://flukeout.github.io/](https://flukeout.github.io/)의 문제를 풀고 정리한 내용

```css
/* 형제 관계이면서 바로 뒤에 인접해 있는 인접 형제 선택자는 + 기호를 넣어준다 */
/* plate element를 바로 뒤따르는 apple element 를 선택한다. 
이 때 plate와 apple 사이에 다른 element가 있으면 apple element가 선택되지 않는다 */
plate + apple {
}

/* plate element를 아래 있는 apple element 를 선택한다. 
이 때 plate와 apple 사이에 다른 element가 있어도 apple element가 선택된다  */
plate ~ apple {
}

/* 자손 선택자는 선택자 사이에 아무 기호 없이 공백으로 구분한다 */
/* plate element 아래 있는 여러 elment 중에 apple element 를 선택한다  */
plate apple {
}

/* 자식 선택자는 > 기호를 선택자 사이에 넣어준다 */
/* plate element의 바로 아래의 자식 element인 apple element 를 선택한다  */
plate > apple {
}

/* Select direct children of an element */

plate orange:first-child {
}

plate apple:only-child,
plate pickle:only-child {
}

plate apple:last-child {
}

plate apple:nth-child(3) {
}

plate apple:nth-last-child(2) {
}

apple:first-of-type {
}

plate:nth-of-type(even) {
}

plate:nth-of-type(2n + 3) {
}

/* 같은 type의 element가 없을 때 적용된다
  예를들어, apple element가 두개 있는 곳에는 적용 안 됨 */
apple:only-of-type {
}

apple:last-of-type,
orange:last-of-type {
}

bento:empty {
}

apple:not(.small) {
}

/* 속성 값이 for을 가지는 모든 element */
[for] {
}

/* plate element 중 속성 값으로 for을 가지는 것들 */
plate[for] {
}

/* for 속성 중, 값으로 Vitaly를 가지는 element들 */
[for='Vitaly'] {
}

/* Start with 'Sa' */
[for^='Sa'] {
}

/* end with 'ato' */
[for$='ato'] {
}

/* contain 'obb' */
[for*='obb'] {
}
```

---

## Reference

- [CSS 레이아웃 정리 display, position 완성 | 프론트엔드 개발자 입문편: HTML, CSS, Javascript
  ](https://www.youtube.com/watch?v=jWh3IbgMUPI&t=535s)
- [MDN docs - CSS 선택자](https://developer.mozilla.org/ko/docs/Learn/CSS/Building_blocks/%EC%84%A0%ED%83%9D%EC%9E%90)
- [https://flukeout.github.io/](https://flukeout.github.io/)
