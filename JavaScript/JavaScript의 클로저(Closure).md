- 자바스크립트의 클로저(Closure)에 대해서 정리한 글 입니다.

---

- 자바스크립트를 공부할 때 헷갈리는 개념 중 하나가 바로 클로저 입니다.
- 우선, 클로저에 대해서 이해하기 위해서는 실행 컨텍스트(Execution Context)에 대한 개념을 갖추고 있어야 합니다.
- 실행 컨텍스트에 대한 개념은 다음 사이트 [실행 컨텍스트와 자바스크립트의 동작원리](https://ibtg.github.io/frontend/2021/01/13/ec/)를 참조하면 이해하는데 도움이 될 것입니다.
- [MDN web docs](https://developer.mozilla.org/ko/docs/Web/JavaScript/Guide/Closures)에 따르면 클로저는 다음과 같이 정의되어 있습니다.
- "A closure is the combination of a function bundled together (enclosed) with references to its surrounding state (the lexical environment)"
- 간단히 말하면, 클로저는 함수와 함수를 둘러싼 상태(렉시컬 환경)의 조합이라고 이라고 말할 수 있습니다
- 렉시컬 환경은 아래의 예제를 통해서 이해할 수 있습니다

```javascript
function outerFunc() {
  var x = 10;
  var innerFunc = function () {
    console.log(x);
  };
  innerFunc();
}

outerFunc(); // 10
```

- 위 코드의 `innerFunc()` 함수에서 `x`를 출력하려고 할 때 외부에 선언되어 있는 `x`를 참조해서 10을 출력할 수 있습니다.
- 이는 자바스크립트에서 스코프는 함수가 어떻게 호출되느냐가 아니라 어디서 선언되느냐에 따라서 결정되기 때문입니다. 이를 렉시컬 스코핑(Lexical Scoping)이라고 합니다.
- 클로저의 정의 '클로저는 함수와 함수를 둘러싼 상태(렉시컬 환경)의 조합'에서 함수는 "내부 함수"를 가리키고, 그 함수의 렉시컬 환경이란 "내부 함수가 선언됐을 때의 스코프"를 의미합니다.
- 즉, 자신을 포함하고 있는 외부함수의 실행이 끝나고 내부함수가 더 오래유지는 경우에 외부 함수 밖에서 내부함수가 호출되더라도 외부함수의 지역변수에 접근 할 수 있는데 이때 그 내부함수를 **클로저**라고 합니다.

---

- 클로저에 대해서 흔히 실수하게 되는 예제가 바로 아래와 같은 경우 입니다.

```javascript
var arr = [];

for (var i = 0; i < 3; i++) {
  arr[i] = function () {
    return i;
  };
}

for (var j = 0; j < arr.length; j++) {
  console.log(arr[j]()); // 3, 3, 3
}
```

- 위 코드를 실행하는 경우 0, 1, 2 가 차례대로 출력될 것이라고 기대하지만 실제로는 3, 3, 3 가 출력됩니다
- 그 이유는 `arr[i]` 배열에는 `i`를 반환하는 함수가 저장되어 있기 때문에 `arr[j]()` 함수를 실행하면 함수는 `i`를 출력하기 위해서 `i` 를 찾게 됩니다
- `arr[j]()` 함수가 실행될 때의 해당 스코프에 `i`가 없고 따라서 `arr[j]()`가 선언되었을 때의 렉시컬 환경을 기억해서 `i`를 해당 스코프에서 찾아서 출력하게 됩니다
- 하지만 이미 `i`는 3까지 증가해서 반복문이 끝난 상태이기 때문에 `i`를 출력하면 3이 출력됩니다.

---

- 이러한 문제는 즉시실행함수(Immediately Invoked Function Expression)를 통해서 해결할 수 있습니다.

```javascript
var arr = [];

for (var i = 0; i < 3; i++) {
  arr[i] = (function (id) {
    // 즉시실행함수의 인자로 전달된 i값이 id에 전달된다
    return function () {
      return id;
    };
  })(i);
}

for (var j = 0; j < arr.length; j++) {
  console.log(arr[j]()); // 0, 1, 2
}
```

- 즉시실행함수를 통해서 해결가능한 이유는 다음과 같이 동작하기 때문입니다
- 첫번째 반복문에서 외부함수인 즉시 실행함수가 실행됨으로써 `id`를 반환하는 내부 함수는 즉시실행 함수를 외부 함수의 스코프로 참조할 수 있게 됩니다.
- 그리고 두번째 반복문에서 `arr[j]()` 함수를 실행하게 되면 `id`를 반환하기 위해서 함수가 선언 되었을 때의 `id`값을 찾게 됩니다.
- 이때 첫번째 반복문에서 `i`값이 증가할 때 마다 즉시실행함수가 실행되었기 때문에 각 `arr[i]`에서 서로 다른 실행 컨텍스트가 만들어지게 되고 이는 `id` 값을 반환하는 함수를 실행하게 될 때 서로 다른 스코프의 `id` 값을 참조하게 됩니다
- 따라서 두번째 반복문의 `arr[j]()` 함수는 서로 다른 스코프를 참조해서 `id` 값을 반환하게 되고, 결국 0, 1 ,2 가 출력됩니다

---

- 또 다른 해결 방법으로는 ES6에서 새로 등장한 `let` 키워드를 사용하는 것입니다.

```javascript
const arr = [];

for (let i = 0; i < 3; i++) {
  arr[i] = function () {
    return i;
  };
}

for (let i = 0; i < arr.length; i++) {
  console.log(arr[i]()); // 0, 1, 2
}
```

- `let` 키워드를 통해서 문제를 해결할 수 있는 이유는 함수 레벨 스코프를(Fuction-level scope)를 가지는 `var` 키워드와 달리 `let` 키워드는 블록 레벨 스코프(Block-level scope)를 가지기 때문입니다
- 즉, 각 for문의 `i`는 `let`키워드로 인해서 서로 다른 스코프를 갖게 됩니다
- 따라서 두번째 반복문에서 `arr[i]()` 함수를 실행해서 `i` 값을 찾게 될 때 서로 다른 스코프의 `i` 값을 참조해서 반환하기 때문에 0, 1, 2가 출력됩니다
- 해당 코드를 [BABEL](https://babeljs.io/repl#?browsers=defaults%2C%20not%20ie%2011%2C%20not%20ie_mob%2011&build=&builtIns=false&spec=false&loose=false&code_lz=MYewdgzgLgBAhgJwTAvDA2gXQNwChcBmIyAFADYCmsAlqjAAzYy0A8MAzE9QNTcCUMAN64Y8JOmqY6BAK5hgUauBgkBw0aIRUZCMMzyiAvnkP4ipSjTqNmMNogQA6SmADmUABZdeakTFCQIJTOIK4kDhKYqnxMAPSxDAA0MACMyQBMuIZAA&debug=false&forceAllTransforms=false&shippedProposals=false&circleciRepo=&evaluate=false&fileSize=false&timeTravel=false&sourceType=module&lineWrap=true&presets=env%2Ces2015%2Creact%2Cstage-2%2Cenv&prettier=false&targets=&version=7.10.2&externalPlugins=)웹 사이트를 이용해서 ES5 문법으로 바꾸면 더 쉽게 이해할 수 있습니다.
- 아래는 `let` 키워드를 사용한 위 코드를 ES5 문법으로 바꾼 결과입니다

```javascript
'use strict';

var arr = [];

var _loop = function _loop(i) {
  arr[i] = function () {
    return i;
  };
};

for (var i = 0; i < 3; i++) {
  _loop(i);
}

for (var _i = 0; _i < arr.length; _i++) {
  console.log(arr[_i]()); // 0, 1, 2
}
```

- 코드를 보면, 두번째 반복문에서 매번 함수를 실행하기 때문에 서로 다른 컨텍스트가 만들어지고, 따라서
  내부 함수 `arr[i]`는 서로 다른 스코프를 참조하게 됩니다
- 그리고 세번째 반복문에서 `arr[_i]()`함수를 실행할 때 서로 다른 스코프를 참조해서 결국 0, 1, 2가 출력됩니다

---

- 아래는 클로저를 활용할 수 있는 예제입니다.

```html
<body>
  <button class="button">+</button>
  <span class="count">0</span>

  <script>
    const Btn = document.querySelector('.button');
    const count = document.querySelector('.count');
    const increase = (function () {
      let counter = 0;

      return function () {
        return ++counter;
      };
    })();

    Btn.addEventListener('click', () => {
      count.innerText = increase();
    });
  </script>
</body>
```

- 전역변수를 사용하는 대신, 즉시 실행함수를 통해 변수를 선언하고 함수를 리턴하면, 반환된 함수를 실행 할 때 마다 즉시 실행 함수 안에 있는 변수에 접근할 수 있기 때문에 전역 변수를 사용할 때 보다 더 안전하게 코드를 작성할 수 있습니다

---

- 또 다른 예제는 아래처럼 정보를 은닉할 수 있습니다.

```html
<script>
  function Count() {
    let count = 0;

    this.increase = function () {
      return count++;
    };

    this.decrease = function () {
      return count--;
    };
  }

  const counter = new Count();
  console.log(counter.increase());
  console.log(counter.decrease());
</script>
```

- count 변수는 this로 선언되지 않았기 때문에 인스턴스를 통해 외부에서 접근할 수 없습니다.
- 하지만 increase와 decrease 함수는 인스턴스 메소드이고, 클로저이기 때문에 count 변수에 접근할 수 있습니다.

---

## Reference

- [MDN web docs](<[https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures)>)
- [https://poiemaweb.com/js-closure](https://poiemaweb.com/js-closure)
- [https://www.youtube.com/watch?v=RZ3gXcI1MZ](https://www.youtube.com/watch?v=RZ3gXcI1MZ)
