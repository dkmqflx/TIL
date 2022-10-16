- 화살표 함수는 ES6에서 새로 추가된 문법으로 다음과 같은 특징을 가집니다.
- 첫번째로, 화살표 함수에는 `함수 이름`이 없습니다.
- 기존에 함수는 다음과 같이 함수 선언식 방식으로 함수를 선언할 수 있었습니다.

```jsx
// 함수 선언식
function func() {}
```

- 화살표 함수는 이름이 없기 때문에 함수 표현식 방법처럼 함수를 선언합니다.

```jsx
// 함수 표현식
var func = function () {};

//화살표 함수
var func = () => {};
```

---

- 두번째 특징으로 화살표 함수에는 `this`가 없습니다,

- 함수는 함수가 실행될 때 함수 자신의 스코프 안에 `this`라는 것이 존재합니다.

- 아래 코드처럼 dot notaion 방식으로 함수를 실행하면 setCounter 함수에서 this는 Obj가 되기 때문에 `3`이 출력됩니다

```jsx
var Obj = {
  count: 3,
  setCounter: function () {
    console.log(this.count); //3
  },
};

Obj.setCounter();
```

- 또 다른 예시로, 다음과 같은 경우 이 때 this는 button 태그가 출력됩니다

```html
<body>
  <button class="btn">+</button>
  <script>
    const btn = document.querySelector('.btn');
    var Obj = {
      count: 3,
      setCounter: function () {
        console.log(this.count); //3
        btn.addEventListener('click', function () {
          console.log(this); // 버튼 태그가 출력된다
        });
      },
    };

    Obj.setCounter();
  </script>
</body>
```

- 먄약 `this`가 Obj를 가리키도록 하고 싶은 경우에는 bind를 사용해서 `this`를 정해줍니다.

```html
<body>
  <button class="btn">+</button>
  <script>
    const btn = document.querySelector('.btn');
    var Obj = {
      count: 3,
      setCounter: function () {
        console.log(this.count); //3
        btn.addEventListener(
          'click',
          function () {
            console.log(this); // Obj 객체가 출력된다
          }.bind(this)
        );
      },
    };

    Obj.setCounter();
  </script>
</body>
```

- 하지만 화살표 함수에는 자신만의 `this`가 없기 때문에 기존 함수 선언 방식에서는 call, apply, bind를 사용해서 `this`를 정해줄 수 있었지만 화살표 함수에서는 불가능합니다

- 따라서 아래 코드처럼 화살표 함수 안에 `this`가 있는 경우 자기 스코프에 `this`가 없기 때문에 스코프 체인을 검색해서 찾게 되므로 this는 Obj가 됩니다

- 따라서 버튼을 클릭하면 Obj의 count 값을 1씩 증가시킬 수 있습니다.

```html
<body>
  <button class="btn">+</button>
  <script>
    const btn = document.querySelector('.btn');
    var Obj = {
      count: 0,
      setCounter: function () {
        console.log(this.count); //3
        btn.addEventListener('click', () => {
          console.log(++this.count);
        });
      },
    };

    Obj.setCounter();
  </script>
</body>
```

---

- `this`가 없기 때문에 생성자 함수로 사용될 수가 없습니다

- 아래처럼 기존에는 생성자 함수를 사용해서 인스턴스를 만들 수 있습니다

```javascript
function Func(name) {
  this.name = name;
}
const func = new Func('kim');
console.log(func.name); // kim
```

- 하지만 아래 처럼 화살표 함수를 사용하면 `Uncaught TypeError: Func is not a constructor` 와 같은 에러가 발생하게 됩니다

```javascript
const Func = () => {
  this.name = name;
};
const func = new Func('kim');
console.log(func.name);
```

---

- 마지막으로 화살표 함수에는 `arguments` 프로퍼티가 없습니다

- 함수는 함수 호출시 전달된 `arguments` 들의 정보를 담고 있는 객체를 가지고 있습니다.

- 이 `arguments` 객체는 유사 배열 객체이며 함수 내부에서 지역변수처럼 사용됩니다.

```javascript
const func = function () {
  console.log(arguments); // Arguments 객체 출력
};
func(1, 2, 3, 4);
```

- 하지만 다음과 같이 화살표 함수를 사용하게 되면 `Uncaught ReferenceError: arguments is not defined` 와 같은 에러 메시지가 출력됩니다

```javascript
const func = () => {
  console.log(arguments); // Arguments 객체 출력
};
func(1, 2, 3, 4);
```

- 만약 다음과 같이 화살표 함수 바깥에 또 다른 함수가 있는 경우에는 arguments의 결과가 출력되는데 그 이유는 스코프 체인을 통해서 외부에서 this를 찾기 때문입니다

```javascript
function outerFunc() {
  const func = () => {
    console.log(arguments); // Arguments객체 출력
  };
  func();
}

outerFunc(1, 2, 3, 4);
```

- 화살표 함수의 인자를 배열로 받고 싶은 경우에는 Rest Parameter를 사용합니다

- Rest Parameter는 매개변수 앞에 점 `...` 세개를 붙여서 정의한 매개변수로, Rest Parameter는 함수에 전달된 Arguments의 목록을 배열로 전달 받습니다.

- 이 때 전달되는 args값은 실제 배열입니다.

```javascript
const func = (...args) => {
  console.log(args); // [1,2,3,4]
};

func(1, 2, 3, 4);
```

---

## Reference

- [poiemaweb - Arrow Function](https://poiemaweb.com/es6-arrow-function)
- [MDN - docs](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Functions/%EC%95%A0%EB%A1%9C%EC%9A%B0_%ED%8E%91%EC%85%98)
- [ES6 화살표 함수에 없는 3가지?](https://www.youtube.com/watch?v=4zjKltnIBug)
