- Javascript의 함수 호출에 따라 결정되는 this에 대해서 정리한 글입니다.

---

- Javascript의 this의 개념을 처음 배울 때 이해가 잘 가지 않는 경우가 있습니다. 그 이유는 this가 만들어진 객체 자기 자신을 가르키는 Java와 달리 Javascript에서 this는 함수의 호출 방식에 따라서 결정되기 때문입니다.

- 즉 this는 자신이 속한 객체를 가르키는 키워드로 상황에 따라 각각 다른 값을 가지게 됩니다.

- 아래 예시를 보면 문맥에 따라서, '나' 가 가르키는 것이 각각 다른 것을 알 수 있습니다. 이처럼 Javascirpt의 this도 아래 문장의 '나'처럼 어떤 문맥이냐에 따라서 그 의미가 다릅니다.

1. 할머니: 나는 허리가 아프다 (나 === 할머니)

2. 아버지: 나는 다리가 아프다 (나 === 아버지)

3. 어머니: 나는 머리가 아프다 (나 === 어머니 )

예를 들어, 아래 code에서 this.name은 전역 변수의 name이 되기도, 또는 obj 객체의 name 값이 되기도 합니다.

```javascript
var name = 'window name';

function log() {
  console.log(this.name); // 'this' is always an object, this는 거의 모든 상황에서 객체이다
}

var obj = {
  name: 'kim',
  logName: log,
};

//상황에 따라서 this.name이 가리키는 값이 바뀌게 된다
log(); // window name
obj.logName(); // kim
```

---

- 이를 이해하기 위해서는, 우선 Javascript에서 함수 내에서 this가 어떻게 바인딩 되는지를 이해 해야 합니다.

- Javascript는 Lexical scope (함수 선언 시에 상위 스코프가 결정되는 방식)을 따르므로, 전역 객체에 함수를 선언하고, 호출하는 경우에는 this가 전역 객체를 가르키게 됩니다.

- 기본적으로 this는 전역 객체를 가르키는데, 내부함수 또는 callback 함수인 경우에도 this는 전역 객체를 가르킵니다.

```javascript
function foo() {
  console.log("foo's this: ", this); // window
  function bar() {
    console.log("bar's this: ", this); // window
  }
  bar();
}
foo();

var obj = {
  foo: function () {
    console.log("foo's this: ", this); // obj
    function bar() {
      console.log("bar's this: ", this); // window
    }
    bar();
  },
};

obj.foo();
```

```javascript
var obj = {
  value: 100,
  foo: function () {
    setTimeout(function () {
      console.log("callback's this: ", this); // window
    }, 1000);
  },
};

obj.foo();
```

- 이를 방지하기 위해 다음과 같은 방법을 사용할 수 있습니다.

  ### 1. that 변수를 사용하는 방법

  - 내부 함수에서 this가 해당 객체를 가르키게 하기 위해서, that이라는 새로운 변수에 this 값을 할당합니다.
  - 이후 내부 함수에서 this를 호출하는 경우에는 전역객체를 가르키지만, this를 호출하는 경우에는 해당 객체를 가르키게 됩니다

```javascript
var value = 1;

var obj = {
  foo: function () {
    var that = this;

    console.log("foo's this: ", this); // obj
    function bar() {
      console.log("bar's this: ", this); // window

      console.log("bar's that: ", that); // obj
    }
    bar();
  },
};

obj.foo();
```

### 2. apply, call, bind 함수를 사용하는 방법

- apply, call, bind 함수를 통해서 호출하고자 하는 함수에 해당 객체를 바인딩하여 호출할 수 있습니다.

```javascript
var obj = {
  value: 100,
  foo: function () {
    console.log("foo's this: ", this); // obj

    function bar(a, b) {
      console.log("bar's this: ", this); // obj
      console.log("bar's this.value: ", this.value); // 100
      console.log("bar's arguments: ", arguments);
    }
    bar.apply(obj, [1, 2]); //100
    bar.call(obj, 1, 2); //100
    bar.bind(obj)(1, 2); //100
  },
};

obj.foo();
```

### 3. 화살표 함수를 사용하는 방법

- 화살표 함수는 자신의 this를 가지지 않고 화살표 함수를 둘러싸는 lexical scope의 this를 사용합니다
- 즉 현재 범위에 존재하지 않는 this를 찾을 때 화살표 함수는 바로 바깥 범위에서 this를 찾는 것으로 검색을 끝내게 됩니다.

```javascript
var obj = {
  value: 1000,
  foo: function () {
    console.log('foo this: ', this.value); // 1000

    const bar = () => {
      console.log('arrow func bar this: ', this.value); //1000
    };

    bar();
  },
};

obj.foo();
```

---

- javascript에서 함수를 실행 방식은 아래와 같이 4가지가 있습니다 this를 이용하는 해당 함수를 4가지 방법 중 어떤 방식으로 실행하느냐에 따라서 this 값이 바뀌게 됩니다.

  1. Regular function call
  2. Dot Notation
  3. call, apply, bind 함수
  4. 'new' keyword

---

### 1. Regular function call (일반 함수 실행 방식)

- 일반 함수 호출 방식은, 함수명을 통해서 함수를 호출 하는 방법입니다.

```javascript
function foo() {
  console.log(this); // 'this' === global object (브라우저상에선 window 객체)
}

foo(); // global object
```

- strict mode에서 일반 함수 실행시, this는 undefined이 되는데, 이는 this를 window를 가르키기 위해 의도적으로 쓴다는 것은 말이 되지 않기 때문입니다. 따라서 strict mode에서는 이러한 경우를 방지하기 위해서 this가 아닌 window를 써서 명시적으로 표시해줍니다.

```javascript
'use strict';

var name = 'kim';

function foo() {
  console.log(this.name); // 'this' === undefined
  // kim을 출력하기 위해서는 window.name을 사용해야 한다.
}
foo();
```

- bar 함수를 일반함수 실행방식으로 실행시켰으므로
  this는 window가 되고, 따라서 전역변수인 age의 값인 100이 출력된다

```javascript
var age = 100;

function foo() {
  var age = 99;
  bar(); // 일반함수 실행방식
}

function bar() {
  console.log(this.age); // 100
}

foo();
```

---

### 2. Dot Notation

- Dot Notation은, 객체명과 함께 함수를 호출하는 방식으로 아래와 같이 함수를 호출 합니다
- 이 때, this는 .(dot) 앞에 있는 객체가 됩니다.

```javascript

//Example 1

var age = 100;

var kim = {
age: 25,
foo: function foo() {
  console.log(this.age);
  }
};

kim.foo(); // this는 .앞에있는 객체


//Example 2

function foo() {
  console.log(this.age);
  }

var age = 100;

var kim = {
  age: 25,
  foo: foo
  ;

var park = {
  age: 21,
  foo: foo
  };

kim.foo(); //25
park.foo(); // 21
// foo 함수가 선언된 곳의 객체가 this가 된다.


//Example 3

var age = 100;

var kim = {
  age: 25,
  foo: function bar() {
    console.log(this.age);
    }
    };

var park = {
age: 21,
foo: kim.foo
};

var foo = kim.foo;

kim.foo(); // 25
park.foo(); //21

foo(); // 100
//일반함수 호출 방식에서 this는 전역객체를 가리키므로

```

---

### 3. Function.prototype.call, Function.prototype.bind, Function.prototype.apply 메소드 사용하는 경우

- 호출하고자 하는 함수를 call, bind, apply 메소드를 통해서 호출하는 경우 this를 원하는 객체에 바인딩 할 수 있습니다.

```javascript


//Example 1

var age = 100;

function foo(){
  console.log(this.age);
}

var kim = {
  age : 25
};

var park {
  age : 21
  };

foo(); // 전역 변수 100

//모든 함수에는 call, apply라는 메소드를 쓸 수 있다

foo.call(kim); // 25
foo.apply(park); // 21

// call과 apply 함수의 차이
// call : 인수 목록
// apply : 단일 리스트


//Example 2

var age = 100;

function foo(a,b,c,d,e){
  console.log(this.age);
  console.log(arguments);
}

var kim = {
  age:25
  }

foo.call(kim, 1, 2, 3, 4, 5); // 25, 1,2,3,4,5
//call은 인자의 수가 정해져 있지 않다

foo.apply(kim, [1,2,3,4,5]); //25, 1,2,3,4,5
//apply는 항상 인자를 두개만 받는다
// 첫번째는 객체로 지정하고 싶은 값
// 두번째는 배열로 배열 안에 있는 요소들이 각각의 인자가 된다


// Example 3

var age = 100;

function foo(){
  console.log(this.age);
}

var kim = {
  age: 25
}

var bar = foo.bind(kim);
bar(); // 25
// bind도 모든 함수에 쓸수 있는 함수
// bind는 해당함수를 바로 실행시키지 않는다
// this를 kim으로 설정을 해놓은 함수를 반환한다



//Example 4

var age = 100;

function foo(){
  console.log(this.age);
  console.log(arguments);
}

var kim = {
  age: 25
  };

var bar = foo.bind(kim);

bar(1,2,3,4,5);
// foo라는 함수에 5개의 인자가 넘어간다
// 5
// 1,2,3,4,5


```

### 4 'new' keyword를 통해서 호출하는 경우

- new 키워드를 사용하면, 해당 함수는 생성자 함수로 동작해서 새로운 객체를 만들게 됩니다. 그리고 이 경우, 생성자 함수임을 명시하기 위해서 대문자로 함수를 선언합니다
- new 키워드를 사용하는 경우

1. 빈 겍체가 생성되고, 이 객체가 this 가 됩니다.
2. 그리고 해당 객체에 프로퍼티 값이 추가 됩니다.
3. 마지막으로, 생성된 객체를 반환 합니다

- 즉, 아래와 같은 방식으로 작동됩니다.

```javascript
function foo() {
  this.name = 'kim';
}

var kim = new foo();

// 1. 빈 객체 생성 및 this 바인딩
this = {};

// 2. this에 프로퍼티 생성
{
  name: 'kim';
}

// 3. 객체 반환
return this;
```

```javascript
//Example 1

function foo(name) {
  this.name = name;
}

var kim = new foo('dail');

console.log(kim.name); // dail

//Example 2

function Person(name, age) {
  this.name = name;
  this.age = age;
}

//Called instance
var kim = new Person('dail', 25);
var park = new Person('sera', 21);

console.log(kim);
console.log(park);
```

---

### Event Hanlder

- 추가적으로, event를 처리 하는 경우에도 event handler 안에서 this 쓰는 것 좋지 않습니다.this는 어떻게 실행되느냐에 따라서 다르기 때문에 this라는 키워드 쓰면 혼란스럽게 만드는 요지를 주기 때문입니다.
- 따라서 target이나 currentTarget처럼 명료하게 쓰는게 가독성이 좋습니다

```javascript
let element = document.querySelector('#vanilla');

element.addEventListener('click', function onclick(ev) {
  console.log(this);
  console.log(ev.target);
  console.log(ev.currentTarget);
});
```

---

### 화살표 함수 (Arrow function)

- `function` 을 이용한 함수 선언 방식에서 함수를 호출하는 방식에 따라 `this`값이 정해지는 것과 달리, ES6에서 새롭게 등장한 `화살표 함수`에서 `this`를 사용하면 항상 상위 스코프의 this를 가리킵니다

- 아래 코드처럼 `new` 키워드를 통해 함수를 호출하면 return된 객체가 `_func`가 되고 `this`는 자신이 return 된 객체를 가리키게 됩니다

- 따라서 `function`으로 선언한 함수의 `this`는 return 된 객체를 가리키기 때문에 `this.name`을 출력하면 `func2`가 출력됩니다

```javascript
function funcOne() {
  this.name = 'func1';
  return {
    name: 'func2',
    func: function () {
      console.log(this.name);
    },
  };
}
// this는 함수가 선언된 곳의 객체이기 때문에 name은 'func2'이다.

const _func = new funcOne(); // 반환된 객체가 _func가 된다
_func.func(); // func2
```

- 첫번째 코드와 달리, 아래 코드에서는 `new` 키워드를 통해 함수를 호출하더라도 `this.name`으로 `func1`가 출력됩니다

- 그 이유는 화살표 함수에서 선언된 `this`는 함수를 정의한 상위 스코프의 `this`를 가르키기 때문에 `this.name`은 `func1`이 됩니다.

- 즉, 화살표 함수는 `this`에 바인딩되는 객체가 동적으로 결정되는 것이 아니라 렉시컬 스코프의 방식처럼 언제나 상위 스코프의`this` 가르킵니다

```javascript
function funcTwo() {
  this.name = 'func1';
  return {
    name: 'func2',
    func: () => {
      console.log(this.name); // this는 상위 스코프인 return 으로 반환되는 객체
    },
  };
}

const _func2 = new funcTwo();
_func2.func(); // func1
```

- 이러한 화살표함수의 특징 때문에 아래 예시처러 화살표 함수를 사용하게 되면, 이 때 this는 전역객체를 가리키게 됩니다

```javascript
const person = {
  name: 'kim',
  sayHi: () => console.log(`Hi ${this.name}`),
};

person.sayHi(); // Hi undefined
```

- 따라서 이러한 경우에는 ES6의 축약메소드 사용방법을 따라 아래와 같이 코드를 작성하는 것이 좋습니다

```javascript
// Good
const person = {
  name: 'kim',
  sayHi() {
    console.log(`Hi ${this.name}`);
  },
};

person.sayHi(); // Hi Kim
```

---

## Reference

- [바닐라코딩 - 자바스크립트 "this" 정리](https://www.youtube.com/watch?v=ayyuU0xdbIU)
- [함수 호출 방식에 의해 결정되는 this](https://poiemaweb.com/js-this)
