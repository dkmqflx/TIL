## BEM (Block Element Modifier)

- 간단한 웹 어플리케이션을 만드는 경우에는, 어떤 스타일로 css 파일을 작성하던간에 큰 문제가 발생하지 않을 수 있지만 규모가 큰 웹 어플리케이션을 만들 때는 어플리케이션의 규모에 따라 유지보수 해야 하는 css 파일의 코드가 복잡해지기 때문에 코드를 읽기 쉽고 관리하기 쉽도록 작성하는 것이 중요하다

- 이 때 사용되는 여러 방법론 중 하나가 바로 BEM

- BEM은 Block Element Modifier의 약자로 클래스 이름을 작성하는 방법을 정의한 규칙

---

- BEM 으로 클래스의 이름을 작성할 때는 `block__element--modifier` 의 순서로 작성

- 예를 들어 카드를 만든다고 하면 카드는 `block`이 되고 카드 안의 타이틀, 버튼, 이미지 등은 `element`가 된다

- 즉, 아래와 같이 클래스 이름을 작성해준다

```css
.card {
}

.card__img {
}

.card__title {
}

.card__description {
}

.card__button {
}
```

- 만약 다른 색상의 카드 존재하면 다음과 같이 `modifier`를 함께 작성해줍니다. 이 때 `modifier`는 `block`이나 `element`의 상태 또는 속성이 될 수 있다

```css
.card--dark {
}
```

- 그리고 카드 안에 다른 색상의 버튼이 존재하면 다음과 같이 클래스 이름을 작성할 수 있다

```css
.card__button--blue {
}

.card__button--red {
}
```

- 만약 button이 카드 안에서 뿐만 아니라 다른 컴포넌트에도 공통적으로 등장한다면, 버튼은 카드라는 블록에 속할 필요가 없으므로 별도의 블록으로 정의해준다.

```css
.button {
}

.button--blue {
}
```

- 여러가지 카드가 하나의 컴포넌트로 묶여있는 경우, `.cards`라는 클래스를 만들고 다음과 같이 `.cards__card__title` 각각의 카드의 클래스 이름을 작성하는 것이 아니라 `.cards`는 `.cards` 대로 클래스를 만들고 `.card`는 `.card` 대로 따로 클래스를 작성한다.

- 그 이유는 `.card`는 그 자체로 하나의 컴포넌트이고 `.cards`는 `.card`를 묶어주는 컨테이너의 역할만 하기 때문

- 그래서 이렇게 따로 클래스를 작성해 주면 `.card`라는 블록이 `.cards`라는 컨테이너에서 사용되거나 또는 다른 부분에서도 사용될 수 있다

- nesting 될수록 단순히 이름을 적는 것 보다 블록 단위로 이름을 작성해야 더 간결하게 코드를 작성하고 코드의 양을 줄 일 수 있다.

---

### Reference

- [http://getbem.com/introduction/](http://getbem.com/introduction/)

- [https://www.slideshare.net/MaxShirshin/bem-it-for-brandwatch](https://www.slideshare.net/MaxShirshin/bem-it-for-brandwatch)
