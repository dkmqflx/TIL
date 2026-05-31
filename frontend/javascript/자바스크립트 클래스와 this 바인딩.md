- 아래는 버튼에 이벤트 리스너를 등록하고 버튼을 클릭할 때 마다 `number` 클래스의 숫자를 출력하는 코드입니다.

```html
<!-- index.html -->
<body>
  <button class="button">button</button>
  <span class="number">0</span>
</body>
```

```javascript
// index.js
class Field {
  constructor() {
    this.button = document.querySelector('.button');
    this.number = document.querySelector('.number');
    this.button.addEventListener('click', this.onClick);
  }

  onClick(event) {
    console.log(this.number.innerText);
  }
}

const field = new Field();
```

- 하지만 버튼을 클릭해도 이벤트가 작동하지 않고 에러 메시지가 발생합니다.

- 그 이유는 어떤 클래스 안에 있는 함수를 다른 콜백으로 인자로 전달할 때 `class` 정보는 함께 전달되지 않기 때문입니다

- 위 코드에서 `console.log(this)`로 바꿔 `this` 값을 출력하면 출력하면 `<button class="button">button</button>`이 출력되는 것을 확인할 수 있습니다.

- 따라서 `onClick` 함수 안의 `this`는 이 클래스 객체를 가르키지 않는다는 것을 알 수 있습니다.

- 자바스크립트에서 함수를 누군가에게 전달해 줄 때는 클래스 정보가 무시되기 때문에 함수를 클래스와 바인딩을 해주어야 합니다.

- 함수를 클래스와 바인딩하는 방법으로는 `bind` 함수를 사용하는 방법이 있습니다.

- 다음과 같이 `bind` 함수를 사용해서 함수에 객체를 바인딩해주면 `this`가 `Field` 클래스가 되기 때문에 버튼을 클릭하면 `Field` 클래스의 this.number 안의 값이 출력됩니다

```javascript
class Field {
  constructor() {
    this.button = document.querySelector('.button');
    this.number = document.querySelector('.number');
    this.onClick = this.onClick.bind(this);
    this.button.addEventListener('click', this.onClick);
  }

  onClick(event) {
    console.log(this.number.innerText);
  }
}

const field = new Field();
```

- 또 다른 방법으로는 화살표 함수를 사용할 수 있습니다.

- 아래처럼 화살표 함수 안에 실행하고자 하는 함수를 넣어 콜백 함수로 전달하면 화살표 함수에는 `this`가 없기 때문에 스코프 체인을 따라서 `this`를 찾게 됩니다.

- 따라서 `this`가 `Field` 클래스가 되고, onClick 함수의 `this`는 함수가 선언된 렉시컬 스코프를 따라 `Field` 클래스가 되므로 this.number의 숫자가 출력 됩니다.

```javascript
class Field {
  constructor() {
    this.button = document.querySelector('.button');
    this.number = document.querySelector('.number');
    this.button.addEventListener('click', () => {
      this.onClick(event);
    });
  }

  onClick(event) {
    console.log(this.number.innerText);
  }
}

const field = new Field();
```

- 함수를 정의할 때 화살표 함수를 사용하는 방법도 있습니다.

- 화살표 함수는 `this`를 가지지 않기 때문에 `this`가 있는 경우 스코프 체인을 따라 `this`를 찾기 때문에 아래 코드에서는 `Field` 클래스가 `this`가 됩니다.

- 즉, 클래스 안에 있는 어떤 함수를 다른 콜백으로 전달할 때는 아래처럼 처음부터 화살표 함수로 전달할 함수를 정의하면 화살표 따라서 bind 함수나 콜백 함수안에서 화살표 함수를 사용하지 않아도 결과값이 출력됩니다.

```javascript
class Field {
  constructor() {
    this.button = document.querySelector('.button');
    this.number = document.querySelector('.number');
    this.button.addEventListener('click', this.onClick);
  }

  onClick = (event) => {
    console.log(this.number.innerText);
  };
}

const field = new Field();
```
