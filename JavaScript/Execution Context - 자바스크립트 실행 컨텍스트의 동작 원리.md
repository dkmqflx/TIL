## 실행 컨텍스트

- 실행 컨텍스트란 코드가 실행되기 위한 환경입니다 (Execution context (EC) is defined as the environment in which the JavaScript code is executed)

- 실행컨텍스트는 함수가 실행되는 순서에 따라, 예를 들어 A함수 안에 B함수가 실행되고 B 함수 안에 C함수가 실행되면 순서대로 실행 컨텍스트가 생성되어 stack에 쌓이게 됩니다

<img src='./images/2021-01-13-ec1.png' width="200" height="400">

- 실행 컨텍스트는 3가지 객체를 가지는데 바로 Variable Object(변수 객체), Scope Chain, this입니다

- 변수 객체(Variable Object)

  - 실행 컨텍스트가 실행되면 자바스크립트 엔진은 실행에 필요한 여러 정보를 담을 객체를 생성하는데 이를 Variable Object라고 합니다

  - Variable Object는 다음과 같은 정보를 담고 있습니다.
    - 변수
    - Parameter, Arguments
    - 함수 선언 (함수 표현식은 제외)
  - Variable Object는 실행 컨텍스트의 프로퍼티이므로 다른 객체를 값으로 갖습니다.

  - 이 때 전역 컨텍스트인 경우에는 전역 객체(Global Object)를 값으로 갖고 함수가 실행될 때 생성되는 함수 컨텍스트의 경우에는 활성 객체(Activation Object)를 값으로 같습니다.

  - 전역 객체(Global Object)는 전역에 선언된 전역 변수와 전역 함수 정보를 포함하는 객체입니다

  - 활성 객체(Activaton Object)는 해당 함수의 arguments 및 해당 함수 내에 선언된 변수와 함수 정보를 포함하는 객체 입니다.

- 스코프 체인 (Scope Chain)

  - 스코프 체인이란 일종의 리스트로 객체 정보를 담고 있습니다

  - 여기서 말하는 객체 정보란 현재 실행되고 있는 컨테스트의 활성 객체(Activation Object)와 함수가 중첩된 경우에는 상위 컨텍스트의 활성 객체(Activation Object)의 정보 그리고 전역 컨텍스트의 전역 객체(Global Object)의 정보를 담고 있습니다.

  - 자바스크립트 엔진은 스코프 체인을 통해서 렉시컬 스코프를 파악합니다.

  - 함수 실행 중에 변수를 만나게 되면 해당 컨텍스트의 활성 객체에서 검색해 보고 없으면 상위 컨텍스트의 활성 객체에서 찾아보는 방식으로 검색을 이어갑니다.

- this

  - this 프로퍼티에는 this 값이 할당되는데 이 때 함수가 호출 되는 방식에 따라 this 값이 결정됩니다
  - this에 대한 자세한 설명은 [다음 링크](https://ibtg.github.io/frontend/2020/06/09/javascript-this/)에 정리되어 있습니다.

---

- 다음 예제를 통해 실행 컨텍스트가 생성되는 방식을 이해할 수 있습니다.

```jsx
var x = 'xxx';

function firstFunc() {
  var y = 'yyy';

  function secondFunc() {
    var z = 'zzz';
    console.log(x + y + z);
  }
  secondFunc();
}

firstFunc();
```

- 우선 전역 코드에 진입하기 전 전역 객체 (Global Object)가 생성됩니다.

- 초기 상태의 전역 객체에는 빌트인 객체인 (Built-in Object) Object, Math, String, Array 와 BOM, DOM이 설정되어 있습니다.

- 전역 객체가 생성되고 전역 코드로 컨트롤이 진입하게 되면 전역 실행 컨텍스트가 생성되고 실행 컨텍스트 스택에 쌓입니다.

- 그리고 해당 실행 컨텍스트는 다음과 같은 순서로 처리됩니다.

  1. 스코프체인 (Scope Chain) 생성과 초기화
  2. 변수 객체화 (Variable Instantiation) 실행
  3. this value 결정

- 스코프 체인 (Scope Chane) 생성과 초기화

  - 실행 컨텍스트가 생성되면 가장 먼저 스코프 체인의 생성과 초기화가 실행됩니다.

  - 다음과 같이 전역 컨텍스트의 경우 스코프 체인은 전역 객체의 레퍼런스를 포함하는 리스트가 됩니다

  <img src='./images/2021-01-13-ec2.png'  width="500" height="300">

- 변수 객체화 (Variable Instantiation 실행

  - 스코프 체인의 생성과 초기화가 끝나면 변수 객체화가 실행됩니다

  - 변수 객체화란 변수 객체에 프로퍼티와 값을 추가하는 것을 의미합니다

  - 전역 코드인 경우 다음과 같이 변수 객체는 전역 객체를 가르킵니다.

  - 그리고 변수 객체화는 다음과 같은 순서로 진행 됩니다

    1. 매개변수(Parameter)가 변수 객체의 프로퍼티로, 인수(Arguments)가 값으로 설정됩니다.
    2. 코드 내에 함수 선언식 (함수 표현식 제외)으로 선언된 함수의 이름이 변수 객체의 프로퍼티로, 생성된 함수 객체가 값으로 설정됩니다 (함수 호이스팅)
    3. 코드 내에 선언된 변수명이 변수 객체의 프로퍼티로, undefined가 값으로 설정됩니다(변수 호이스팅)

  - 생성된 함수 객체는 `[[Scope]]` 프로퍼티를 가지게 되는데, 이 `[[Scope]]` 프로퍼티는 함수 객체만이 가지고 있는 내부 프로퍼티 (Internal Property)로서 함수 객체가 실행되는 환경, 즉 , 현재 실행 컨텍스트의 스코프체인이 참조하고 있는 객체를 값으로 설정합니다

  - 따라서 내부 함수의 `[[Scope]]`프로퍼티는 자신의 실행 환경(Lexical Environment)의 활성 객체와 자신을 포함하는 외부 함수의 실행 환경의 활성객체 그리고 전역 객체를 가리키기 때문에 자신을 포함하는 외부 함수의 실행 컨텍스트가 소멸되어도 외부 함수의 활성 객체(Activation Object)는 계속해서 참조할 수 있는데 이를 클로저라고 합니다.

  <img src='./images/2021-01-13-ec3.png'  width="500" height="300">

- firstFunc 함수의 선언 처리

  - 지금까지 단계에서 실행 컨텍스트는 아직 코드가 실행되기 이전이지만 스코프체인이 가리키는 변수 객체에 이미 함수가 등록되어 있기 때문에 다음과 같이 firstFunc 함수 선언식 이전에 firstFunc 함수를 호출할 수 있게 됩니다.
  - 이를 함수 호이스팅(Functon Hoisting)이라고 합니다

  ```jsx
  var x = 'xxx';

  firstFunc();

  function firstFunc() {
    var y = 'yyy';

    function secondFunc() {
      var z = 'zzz';
      console.log(x + y + z);
    }
    secondFunc();
  }
  ```

  - 이 때 다음과 같은 코드를 실행해보면 함수명이 name 프로퍼티의 값으로 설정된 것을 확인할 수 있습니다

  ```jsx
  console.dir(firstFunc);
  ```

  - 하지만 다음과 같이 함수 표현식으로 함수를 선언한 다음 코드를 실행해 보면 에러가 발생하게 되는데 함수 표현식으로 선언하는 경우 일반 변수가 선언되는 방식을 따르기 때문에 아직 값이 할당되지 않았기 때문입니다.

  ```jsx
  var x = 'xxx';

  firstFunc();

  var firstFunc = function () {
    var y = 'yyy';
  };
  ```

  <img src='./images/2021-01-13-ec4.png'  width="500" height="300">

- 변수 x의 선언 처리

  - 변수 선언은 변수 객체촤 실행 순서에 따라서 변수명이 변수 객체의 프로퍼티가 되고 변수의 값이 프로퍼티의 값이 됩니다

  - 조금 더 세분화 하면 변수는 다음과 같은 순서로 처리됩니다

  - 선언 단계(Declaration phase)

    - 변수 객체에 변수를 등록합니다.
    - 이 변수 객체는 스코프가 참조할 수 있는 대상이 됩니다

  - 초기화 단계(Initialization phase)

    - 변수 객체에 등록된 변수를 메모리에 할당합니다.
    - 이 단계에서 변수는 undefined로 초기화 됩니다

  - 할당 단계(Assignment phase)

    - undefined로 초기화된 변수에 실제 값을 할당합니다

  - var로 선언된 변수는 선언 단계와 초기화 단계가 한번에 이루어 집니다

  - 따라서 스코프 체인이 가리키는 변수 객체에 변수가 등록되고 이 변수는 undefined로 초기화 되기 때문에 변수 선언문 이전에 변수에 접근하여도 변수 객체에 변수가 존재하기 때문에 에러가 발생하지 않고 undefine가 호출됩니다.

  - 이를 변수 호이스팅 (Variable Hoisting)이라고 합니다.

  - 그리고 y는 변수 할당문에 도달하면 yyy로 값이 할당됩니다.

  ```jsx
  var x = 'xxx';

  function firstFunc() {
    console.log('y: ', y); // undefined

    var y = 'yyy';

    function secondFunc() {
      var z = 'zzz';
      console.log(x + y + z);
    }
    secondFunc();
  }

  firstFunc();
  ```

  <img src='./images/2021-01-13-ec5.png'  width="500" height="300">

- this value 결정

  - 변수 선언 처리가 끝나면 this value가 결정됩니다.

  - this value가 결정되기 이전에 this는 전역 객체를 가리키고 있다가 함수 호출 방식에 의해 this에 할당되는 값이 결정됩니다.

  - 전역 컨텍스트의 this는 전역 객체를 가리킵니다.

  <img src='./images/2021-01-13-ec6.png' width="500" height="300">

---

- 지금까지 단계를 거치고 나면 이제 코드가 실행됩니다.

  ```jsx
  var x = 'xxx';

  function firstFunc() {
    var y = 'yyy';

    function secondFunc() {
      var z = 'zzz';
      console.log(x + y + z);
    }
    secondFunc();
  }

  firstFunc();
  ```

- 변수 값 할당

  - 위 코드를 보면 전역 변수 x에 문자열 'xxx'가 할당되고 firstFunc 함수가 호출됩니다

  - 전역 변수 x에 문자열 'xxx'를 할당할 때 현재 실행 컨텍스트의 스코프체인이 참고하는 변수 객체(Variable Object)를 처음부터 검색해서 변수명에 해당하는 프로퍼티가 발견되면 값을 할당합니다

  <img src='./images/2021-01-13-ec7.png'  width="500" height="300">

- firstFunc 함수 실행

  - firstFunc 함수가 실행되면 새로운 함수 실행 컨텍스트가 생성됩니다.

  - 그리고 이전의 전역 코드와 마찬가지로 다음과 같은 순서대로 진행됩니다.
    1. 스코프 체인의 생성과 초기화
    2. 변수 객체화 실행
    3. this value 결정

  <img src='./images/2021-01-13-ec8.png' width="500" height="300">

- 스코프 체인의 생성과 초기화

  - 함수 코드의 스코프 체인의 초기화는 우선 스코프 체인에서 해당 함수의 실행으로 생성된 활성객체를 가장 먼저 참조하도록 합니다.

  - 그 다음 전역 컨텍스트의 스코프 체인이 참조하고 있는 객체가 스코프 체인에 push 됩니다

  - 따라서 firstFunc 를 실행 직후 실행 컨텍스트의 스코프 체인은 firstFunc 의 실행으로 만들어진 활성 객체와 전역 객체를 순차적으로 참조하게 됩니다.

  - 그리고 나서 arguments 프로퍼티의 초기화를 실행하고 난 다음에 변수 객체화가 실행됩니다.

  <img src='./images/2021-01-13-ec9.png'  width="500" height="300">

- 변수 객체화 실행

  - 스코프체인의 생성과 초기화에서 생성된 활성 객체를 변수 객체로 변수 객체화가 실행됩니다.

  - 즉 활성 객체를 변수 객체로 바인딩합니다.

  - 변수 객체의 프로퍼티인 secondFunc의 값인 함수객체는 `[[Scope]]`프로퍼티를 가지고 이 `[[Scope]]` 프로퍼티의 값은 현재 함수의 실행으로 생성된 활성 객체와 전역 객체를 참조하게 됩니다.
  - 그리고 변수 y 를 변수 객체에 설정하는데 프로퍼티는 y, 값은 undefined가 됩니다.

    <img src='./images/2021-01-13-ec10.png'  width="500" height="300">

- this value 결정

  - 변수 객체화가 끝나고 나면 this value가 결정되는데 this에 할당되는 값은 함수 호출 방식에 따라 결정됩니다

  - 이 경우 firstFunc가 내부 함수이기 때문에 this는 전역객체가 됩니다

- 그리고 firstFunc 코드 블록 이 실행되면 y에 yyy가 할당됩니다. yyy를 할당할 때 현재 실행 컨텍스트의 스코프체인이 참조하고 있는 변수 객체들을 차례 대로 검색해서 변수명에 해당하는 프로퍼티가 발견되면 값을 할당합니다.

<img src='./images/2021-01-13-ec11.png'  width="500" height="300">

---

## Reference

- [실행 컨텍스트와 자바스크립트의 동작 원리](https://poiemaweb.com/js-execution-context)
