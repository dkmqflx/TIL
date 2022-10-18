### Scope

- ES6 이전까지 자바스크립트에서 변수를 선언할 때 var 키워드를 사용했지만 ES6 부터 let, const 키워드가 생겼고 이를 통해서 변수를 선언할 수 있습니다
- `var`과 `let`, `const` 의 가장 큰 차이는 스코프(Scope)의 범위 입니다.
- `var` 키워드는 함수 레벨 스코프(Function-level scope)로 함수의 코드 블록만을 스코프로 가집니다

```javascript
var foo = 'abc'; // 전역 변수
console.log(foo); // "abc"

{
  var foo = 'def'; // 전역 변수
}
console.log(foo); // "def
```

- `var` 키워드는 함수 레벨 스코프를 가지기 때문에 함수가 아닌 블록 안에 선언된 foo 변수는 전역 변수로 선언 됩니다. 따라서 이전에 전역에서 선언된 foo를 새로운 값 "def"로 재할당하여 덮어 쓰기 때문에 블록 밖에서 foo 값으로 "def"가 출력됩니다.

```javascript
function bar() {
  var _bar = 'def';
}

console.log(_bar); //ReferenceError: bar is not defined
```

- 두번째 코드에서는 `var` 키워드로 선언된 `_bar` 변수가 함수 밖에서 출력되지 않는 것을 확인할 수 있습니다

- `let`과 `const`는 블록 레벨 스코프(Block-level scope)를 가지기 때문에 각 블록을 스코프로 가지게 됩니다

```javascript
let foo = 'abc'; // 전역 변수
{
  let foo = 'def'; // 지역 변수
  let bar = 'ghi'; // 지역 변수
}

console.log(foo); // "def"
console.log(bar); // ReferenceError: bar is not defined
```

### Hoisting

- [호이스팅(Hoisting)](https://developer.mozilla.org/ko/docs/Glossary/Hoisting)이란 `var`, `let`, `const`와 같은 키워드로 선언된 변수가 해당 스코프의 최상단에 있는 것 처럼 작동하는 것을 말합니다
- 변수가 함수 내에서 정의되었을 경우 함수의 최상단으로, 함수 바깥에서 정의되었을 때는 전역 컨텍스트의 최상단에 선언 된 것처럼 변수 선언문 이전에 변수를 참조할 수 있습니다
- 자바스크립트에서는 var, let, const와 같은 변수 키워드 뿐 아니라 fuction, class 등과 같은 모든 선언을 호이스팅 합니다
- 따라서 자바스크립트에서 var 키워드로 선언된 변수는 선언문 이전에 참조가 가능합니다
- 하지만 이때, var과 달리 let 키워드로 선언된 변수는 선언문 이전에 참조하면 Reference Error가 발생하는데 이는 let 키워드로 변수를 선언하게 되면 <strong>일시적 사각지대(Temporal Dead Zone)</strong>에 빠지기 때문입니다

- 일시적 사각지대의 개념을 이해하기 위해서는 우선 변수의 생성 과정을 이해햐아 합니다.

---

- 변수가 생성되는 3단계

  1. 선언 단계

     - 변수를 실행 컨텍스트의 변수객체(Variable Object)에 등록한다. 이 변수 객체틑 스코프가 참조하는 대상이 된다

  2. 초기화 단계

     - 변수 객체(Variable Object)에 등록된 변수를 위한 공간을 메모리에 확보한다
     - 이 단계에서 변수는 undefined로 초기화 된다

  3. 할당 단계
     - undefined로 초기화된 변수에 실제 값을 할당한다
     - var 키워드로 선언된 변수는 선언 단계와 초기화 단계가 한번에 이루어 진다

- `var`키워드로 선언된 변수는 해당 변수가 속한 실행 컨텍스트의 생성 과정 중 Variable Instantiation 단계에서 변수를 등록하고(선언 단계) 메모리에 변수를 위한 공간을 확보한 후, undefined로 초기화(초기화 단계)합니다. 그리고 변수 할당문(`=`)에서 값이 할당됩니다(할당 단계).
- 따라서 변수 선언문 이전에 변수에 접근하여도 스코프 체인을 통해서 변수를 찾을 수 있기 때문에 에러가 발생하지 않고 undefined가 출력됩니다

```javascript
console.log(foo); // undefined
//var이라는 변수를 '선언' 함으로써, '선언 단계'와 '초기화 단계'가 동시에 이루어 진다
// 따라서 변수 선언문 이전에 변수를 참조할 수 있다.

var foo;
console.log(foo); // undefined

foo = 1; // 할당문에서 할당 단계가 실행된다.
console.log(foo); // 1
```

- `let`키워드로 선언된 변수는 `var` 키워드로 선언된 변수와 달리 선언 단계와 초기화 단계가 분리되어 진행됩니다
- `let` 키워드로 선언한 변수는 변수 선언문에서 초기화 단계가 실행됩니다.
- 따라서 선언문 이전에 `let`키워드로 선언된 변수에 접근하면 아직 메모리가 확보되지 않았으므로 ReferenceError가 출력됩니다

```javascript
console.log(foo); // ReferenceError: foo is not defined

let foo; // 변수 선언문에서 초기화 단계가 실행된다.
console.log(foo); // undefined

foo = 1; // 할당문에서 할당 단계가 실행된다.
console.log(foo); // 1
```

## 중복 선언

- `var` 키워드로는 동일한 이름의 변수를 중복 선언할 수 있지만, `let` 키워드를 사용하면 동일한 이름의 변수를 중복해서 선언할 수 없습니다
- 그리고 `let` 키워드를 사용한 변수는 다른 값을 할당할 수 있지만, `const` 키워드를 사용한 변수는 재할당이 불가능하고 선언과 동시에 할당이 이루어져야 합니다 .

```javascript
var foo = 123;
var foo = 456; // 중복 선언 가능

let bar = 123;
let bar = 456; // Uncaught SyntaxError: Identifier 'bar' has already been declared
```

```javascript
let foo = 'abc';
foo = 'def';
console.log(foo);

const bar = 'abc';
bar = 'def'; // Uncaught TypeError: Assignment to constant variable.
```

---

## Reference

- [https://poiemaweb.com/es6-block-scope](https://poiemaweb.com/es6-block-scope)
- [MDN web docs - Hoisting](https://developer.mozilla.org/ko/docs/Glossary/Hoisting)
- [MDN web docs - let](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Statements/let)
- [MDN web docs - const](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Statements/const)
