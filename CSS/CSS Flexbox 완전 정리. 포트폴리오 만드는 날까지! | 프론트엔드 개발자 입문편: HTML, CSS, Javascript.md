## Flexbox

- 예전에는 모든 브라우저에서 호환 가능한 레이아웃을 만들기 위해서 `positoin` 이나 `float` 또는 `table`을 사용했다.

- 하지만 이러한 속성들은 사용해서 작업을 하는 경우, 너무 복잡하고 시간이 많이 소요된다

- 예를 들어 다음과 같은 작업들을 수행하는 것이 까다로웠고 작업을 하는데 제약사항이 있었다

  - 박스 안의 아이템들을 수직으로 정렬
  - 아이템의 사이즈에 상관 없이 동일 한 간격으로 박스를 배치하거나 동일한 높이로 배치

- 그리고 원래 `float`의 목적은 이미지와 텍스트를 어떻게 배치할지 정의하기 위한 것이다

```css
float: left;
/* 이미지 왼쪽배치, 텍스트는 이미지를 감싸면서 배치된다 */

/* 

float: right;
float:center
 
 */
```

- 예를 들어 `float:left` 으로 `float`의 속성을 지정하는 경우 이미지 왼쪽에 배치되고 텍스트가 이미지 감싸는 형태가 된다

- 하지만 예전에는 css 레이아웃을 할 수 있는 기능이 없다보니 `float`을 이용해서 박스를 왼쪽, 가운데, 오른쪽에 배치했지만 이렇게 `float`을 사용하는 것은 원래의 목적에 어긋나는 방법이다.

- `flexbox`의 등장으로 `float`은 원래 목적에 맞게 텍스트와 이미지를 배치하는 용도로만 사용되었고 `flexbox`를 통해서 레이아웃을 간편하게 만들 수 있게 되었다

---

- `flexbox`는 `container`에 적용되는 속성값이 있고, `container` 안의 `item`에 적용되는 속성값이 있다

- `container`에 적용되는 속성 값

  - display
  - flex-directoin
  - flex-wrap
  - flex-flow
  - justify-content
  - align-itmes
  - align-content

- `item`에 적용되는 속성값

  - order
  - flex-grow
  - flex-shirnk
  - flex
  - align-self

- 그리고 `flexbox`에는 `main axis`와 `cross axis`가 있다

  - item이 좌우 정렬이면, 수평축이 `main axis`, 수직축이 `cross axis`

  - item이 상하 정렬이면, 수직축이 `main axis`, 수평축이 `cross axis`

---

### 기본 source code

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <link rel="stylesheet" href="index.css" />
  </head>
  <body>
    <div class="container">
      <div class="item item1">1</div>
      <div class="item item2">2</div>
      <div class="item item3">3</div>
      <div class="item item4">4</div>
      <div class="item item5">5</div>
      <div class="item item6">6</div>
      <div class="item item7">7</div>
    </div>
  </body>
</html>
```

```css
.container {
  background: beige;
  height: 100vh;
  /* 부모에 상관없이 viewport height 100% 다 쓰겠다 */
}

.item {
  width: 40px;
  height: 40px;
}

.item1 {
  background: red;
}

.item2 {
  background: orange;
}
.item3 {
  background: yellow;
}

.item4 {
  background: green;
}
.item5 {
  background: blue;
}

.item6 {
  background: indigo;
}

.item7 {
  background: purple;
}
```

---

- 우선 `flexbox`를 사용하기 위해서는 다음과 같이 `display: flex`를 선언해준다

```css
.container {
  display: flex;
}
```

## Container 속성 값들

### flex-direction

- `flex-direction`을 사용해서 `flexbox`의 정렬 방향을 정할 수 있다
  - row
  - row-reverse
    - row 끝에 붙어서 반대로 정렬된다. item 순서가 가장 오른쪽이 1번이 된다
  - column
  - column-reverse
    - column 끝에 붙어서 정렬된다

```css
.container {
  display: flex;
  flex-direction: row;
}
```

---

### flex-wrap

- 화면크기에 따라 `item`들을 한줄에 배치할지, 여러줄에 나누어 배치할지 정해준다

- nowrap
  - 기본 값으로, `item`들이 많아지게 되더라도 한 줄에 모두 배치된다
- wrap
  - 화면 줄어들 때 `item` 들이 다른 줄로 넘어간다
- wrap-reverse
  - 아래에서 위로 `item`들이 반대 방향으로 정렬된다. 예를들어 화면이 줄어들게 되면 1,2,3이 맨 아래줄 4,5,6이 그 위에 줄에 배치된다

```css
.container {
  display: flex;
  flex-direction: row;
}
```

---

### flex-flow

- 다음과 같이 `flex-flow`에 `flex-direction, flex-wrap`속성 한번에 쓸 수 있다.

```css
flex-flow: column nowrap;
```

---

### justify-content

- `main-axis`에서 `item`들을 어떻게 배치할지를 정의할 수 있다

  - flex-start

    - 기본 값으로 `flex-direction:row` 기준으로는 왼쪽부터 정렬한다

  - flex-end

    - 가장 끝에에 붙어서 정렬한다. `flex-directon:row-reverse`와 다른 점은, `flex-end`를 사용하면 단순히 끝에 붙어서 정렬되기 때문에 가장 끝에 있는 `item`은 10이다

  - center : 가운데 정렬

  - space-around : `item`을 둘러싼 space를 넣어준다. 가장 오른쪽과 가장 왼쪽의 space는 space가 하나만 존재하니까 `item`간의 space 간격 더 작다

  - space-evenly : 모든 `item`간의 간격이 일정하다

  - space-between : 가장 끝 공간의 간격은 없고 다른 `item`간의 사이에만 space가 존재한다

```css
.container {
  display: flex;
  flex-direction: row;
  flex-wrap: nowrap;
  justify-content: flex-start;
}
```

---

### align-items

- `justify-items`가 `main-axis`에서 아이템들을 배치한다면, `align-items`는 `cross-axis`에서 어떻게 아이템들을 배치할지를 정한다

- 즉, `justify-items`로 정렬된 전체 아이템들을 `cross-axis`에서 배치하는 속성이다

- basline

  - 다음과 같이 첫번째 `item1`에 padding이 추가되어 `item1` 크기가 더 커지도록 바뀌었을 때 `item1` 하나의 크기가 달라도 텍스트의 위치를 균일하게 맞추어서 정렬하도록 한다.

  - 즉, 다른 `item`들이 첫번째 `item`의 가운데를 기준으로 정렬된다

```html
<!-- html -->
<div class="container">
  <div class="item item1">1</div>
  <div class="item item2">2</div>
  <div class="item item3">3</div>
  <div class="item item4">4</div>
</div>
```

```css
/* css */

.item {
  width: 40px;
  height: 40px;
}

.item1 {
  background: red;
  padding: 20px;
}

.item2 {
  background: yellow;
}

.item3 {
  background: green;
}

.item4 {
  background: blue;
}
```

```css
.container {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  justify-content: flex-start;
  align-items: baseline;
}
```

---

### align-content

- `align-content`는 `justify-content`와 유사한데,item들이 여러줄로 있을 때 `flex-wrap` 속성과 함께 사용할 수 있는 속성이다

- `justify-content`가 `main-axis`의 `item`을 정렬한다면, `align-content`은 `cross-axis`의 `item`을 정렬한다

- 여러 `flexbox`들 있을 때 `flex-wrap: wrap`으로 바꾸고 `align-content: space-between` 으로 지정하면 반대축을 기준으로 가장 끝에는 space가 없이 중간에만 space가 생긴다

- `align-content`가 `align-items`와 다른점은, `align-items`는 한 줄에 있는 `flexbox`에 대해서 정렬하는 것이라면 (align-items are for single line flexible boxes), `align-content`는 여러 줄에 있는 `item에` 대해서 정렬해준다

```css
.container {
  display: flex;
  flex-direction: row;
  flex-wrap: nowrap;
  justify-content: flex-start;
  align-items: baseline;
  align-content: space-between;
}
```

---

## Item 속성 값들

### 기본 source code

```css
.container {
  background: beige;
  height: 100vh;
  display: flex;
}

.item {
  width: 40px;
  height: 40px;
  border: 1px solid black;
}

.item1 {
  background: red;
}

.item2 {
  background: orange;
}
.item3 {
  background: yellow;
}
```

---

### order

- `order`속성을 통해서 html에서 보이는 요소의 순서를 바꿀 수 있다. 잘 쓰여지지는 않는다

```css
.item1 {
  background: #ff6f00;
  order: 2;
}

.item2 {
  background: #ff6f00;
  order: 3;
}

.item3 {
  background: #ff6f00;
  order: 1;
}
```

---

### flex-grow

```css
.item1 {
  background: #ff6f00;
  flex-grow: 1;
}
```

- `flex-grow`가 정의되어 있지 않으면, `container` 의 크기가 변하더라도 `item의` 크기는 고정되다가, `container` 의 크기가 아주 작아지면 `item의` 크기가 변하게 된다

- 하지만 `flex-grow`가 정의되어 있으면, `container` 의 크기가 커짐에 따라 `item의` 크기가 변하게 된다.

- 그리고 각각의 `item1, item2, item3`가 의 `flex-grow:1`로 지정되면, `container` 의 크기가 커질 때 마다 세 `item`이 같은 비율로 변하게 된다

---

### flex-shrink

- `container`의 크기가가 줄어들 때, 어떻게 작아지지는지
  `item1`만 값을 2로 하면, 다른 `item`보다 `container`가 작아질 때, 2배로 더 작아진다

---

### flex-basis

- `item`의 공간배분 전, 아이템이 공간을 얼마나 차지하는지, 기본 너비를 설정할 수 있다.

- `flex-basis: auto`인 경우, `flex-grow, flex-shrink`가 지정 되어있다면, 지정된 값에 따라 크기가 변하게 되지만, `flex-grow, flex-shrink`말고, 단독으로 각 .`item`에 `flex-basis`를 아래와 같이 지정하면 `container`가 커지고, 작아질 때, 같은 비율을 유지하게 된다

```css
.item1 {
  background: #ff6f00;
  flex-basis: 60%;
}

.item2 {
  background: #ff6f00;
  flex-basis: 30%;
}

.item3 {
  background: #ff6f00;
  flex-basis: 10%;
}
```

- 앞서 설명한 `flex-grow`에서, `item1`의 `flex-grow:2`, 그리고 `item2, item3` 의 `flex-grow:1`로 두면, 사실상 2:1:1 의 크기로 변하는 것이 아니다.

- 그 이유는, `flex-grow`가 커질 때, div안의 컨텐츠를 제외한 여백을 2:1:1로 나누어 가지기 때문이다. 따라서`flex-basis`를 0으로 맞추어야지 2:1:1의 비율로 커지게 된다

---

### align-self

```css
.item1 {
  background: #ff6f00;
  align-self: center;
}
```

- 아이템 별로, 아이템을 정렬할 수 있다. 다음과 같이 `align-self:center`로 지정하면 `item1`만 가운데로 정렬이 된다

---

## Reference

- [flexbox로 만들 수 있는 10가지 레이아웃 - NAVER D2](https://d2.naver.com/helloworld/8540176)
- [CSS Flexbox 완전 정리. 포트폴리오 만드는 날까지! | 프론트엔드 개발자 입문편: HTML, CSS, Javascript](https://www.youtube.com/watch?v=7neASrWEFEM&t=1214s)
- [CSS Flex(Flexible Box) 완벽 가이드](https://heropy.blog/2018/11/24/css-flexible-box/)
