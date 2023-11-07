### 객체(Object)

- 자바스크립트에서 객체란 키(Key)와 값(Value)로 구성된 프로퍼티(Property)들의 집합으로, 원시 타입(Primitive Type)을 제외한 나머지(함수, 배열등)이 객체가 된다

- 자바스크립트에서 함수는 일급객체로 다음과 같은 특징을 가지기 때문에 프로퍼티의 값으로 사용될 수 있다

- 일급 객체의 특징

  1. 무명의 리터럴로 표현이 가능하다.

     ```jsx
     // 이름 없이 몸체만 있는 함수를 함수 리터럴이라고 한다
     // 자바스크립트에서는 함수 표현식으로 함수를 정의할 때 함수 리터럴 방식을 사용한다
     // 함수 표현식
     var square = function (number) {
       return number * number;
     };
     ```

  2. 변수나 자료구조(객체, 배열 등)에 저장할 수 있다

  3. 함수의 파라미터(Parameter)로 전달할 수 있다

  4. 반환값(return value)으로 사용할 수 있다.

---

### 객체(Object) 생성 방법

- 객체 리터럴

  - 가장 일반적인 자바스크립트의 객체 생성 방식으로 중괄호 `{}`를 사용해서 간편하게 객체를 생성할 수 있다

  ```jsx
  var Obj = {};
  console.log(typeof Obj); // object

  var person = {
    name: "Kim",
    gender: "male",
    sayHello: function () {
      console.log("Hi! My name is " + this.name);
    },
  };

  console.log(typeof person); // object
  console.log(person); // {name: "Kim", gender: "male", sayHello: ƒ}

  person.sayHello(); // Hi! My name is Kim
  ```

- Object 생성자 함수

  - new 연산자와 Object 생성자 함수를 호출하여 빈 객체를 생성할 수 있다.

  - 빈 객체 생성 이후 프로퍼티 또는 메소드를 추가할 수 있다

  ```jsx
  // 빈 객체의 생성
  var person = new Object();

  // 프로퍼티 추가
  person.name = "Kim";
  person.gender = "male";
  person.sayHello = function () {
    console.log("Hi! My name is " + this.name);
  };

  console.log(typeof person); // object
  console.log(person); // {name: "Kim", gender: "male", sayHello: ƒ}

  person.sayHello(); // Hi! My name is Kim
  ```

  - 객체 리터럴 방식으로 생성된 객체는 결국 빌트인(Built-in) 함수인 Object 생성자 함수로 객체를 생성하는 것을 단순화시킨 축약 표현(short-hand)이다.

  - 다시 말해, 자바스크립트 엔진은 객체 리터럴로 객체를 생성하는 코드를 만나면 내부적으로 Object 생성자 함수를 사용하여 객체를 생성한다.

- 생성자 함수

  - 객체 리터럴 방식과 Object 생성자 함수 방식으로 객체를 생성하는 것은 프로퍼티 값만 다른 여러 개의 객체를 생성할 때 불편하다.

  - 동일한 프로퍼티를 갖는 객체임에도 불구하고 매번 같은 프로퍼티를 기술해야 한다.

  ```jsx
  var person1 = {
    name: "Kim",
    gender: "male",
    sayHello: function () {
      console.log("Hi! My name is " + this.name);
    },
  };

  var person2 = {
    name: "Kim",
    gender: "female",
    sayHello: function () {
      console.log("Hi! My name is " + this.name);
    },
  };
  ```

  - 생성자 함수를 사용하면 마치 객체를 생성하기 위한 템플릿(클래스)처럼 사용하여 프로퍼티가 동일한 객체 여러 개를 간편하게 생성할 수 있다.

  ```jsx
  // 생성자 함수
  function Person(name, gender) {
    this.name = name;
    this.gender = gender;
    this.sayHello = function () {
      console.log("Hi! My name is " + this.name);
    };
  }

  // 인스턴스의 생성
  var person1 = new Person("Lee", "male");
  var person2 = new Person("Kim", "female");

  console.log("person1: ", typeof person1); // object
  console.log("person2: ", typeof person2); // object
  console.log("person1: ", person1); // {name: "Lee", gender: "male", sayHello: ƒ}
  console.log("person2: ", person2); // {name: "Kim", gender: "male", sayHello: ƒ}

  person1.sayHello(); // Hi! My name is Lee
  person2.sayHello(); // Hi! My name is Kim
  ```

- 생성자 함수 이름은 일반적으로 대문자로 작성하는데 이것은 생성자 함수임을 명확하게 하기 위함이다.

- 프로퍼티 또는 메소드명 앞에 기술한 `this`는 생성자 함수가 생성할 인스턴스(instance)를 가리킨다.

- `this`에 연결(바인딩)되어 있는 프로퍼티와 메소드는 `public`(외부에서 참조 가능)하다.

- 생성자 함수 내에서 선언된 일반 변수는 `private`(외부에서 참조 불가능)하다. 즉, 생성자 함수 내부에서는 자유롭게 접근이 가능하나 외부에서 접근할 수 없다.

```jsx
function Person(name, gender) {
  var married = true; // private
  this.name = name; // public
  this.gender = gender; // public
  this.sayHello = function () {
    // public
    console.log("Hi! My name is " + this.name);
  };
}

var person = new Person("Lee", "male");

console.log(typeof person); // object
console.log(person); // Person { name: 'Lee', gender: 'male', sayHello: [Function] }

console.log(person.gender); // 'male'
console.log(person.married); // undefined
```

---

### 프로토타입(Prototype)

- 앞의 설명을 통해 객체가 Object 생성자 함수 또는 정의된 생성자 함수로 만들어지기 때문에 객체는 언제나 함수로 생성되는 것을 알 수 있다

- 프로토타입을 이해하기 위해서는 우선 함수가 정의되는 과정을 이해해야 한다

- 함수가 정의될 때는 2가지 일이 동시에 이루어진다

  1. 해당 함수에 constructor(생성자) 자격 부여

     - constructor 자격이 부여되면 new 키워드를 사용해서 객체를 만들어 낼 수 있게 된다.

     - 이것이 함수만 new 키워드를 사용할 수 있는 이유이다

       ```jsx
       // 일반 객체는 new 키워드 사용하면 에러가 발생한다.
       var obj = {};
       var a = new obj(); // Uncaught TypeError: obj is not a constructor
       ```

  2. 해당 함수의 프로토타입 객체(Prototype Object) 생성 및 연결

     - 함수를 정의하면 함수만 생성되는 것이 아니라 프로토타입 객체(Prototype Object)도 같이 생성이 된다

     ```jsx
     function Person() {} //  생성자 함수
     ```

     <img src="./images/Javascript의 Prototype/2021-01-18-prototype1.png">

     - 그리고 생성된 함수는 `prototype`이라는 속성을 통해 프로토타입 객체에 접근할 수 있다.

     - 프로토타입 객체(Prototype Object)는 일반적인 객체와 같으며 기본적인 속성으로 constructor와 [[prototype]] (`__proto__`)을 가지고 있다

     - constructor 프로퍼티는 프로토타입 객체의 입장에서 자신을 생성한 객체를 가리킨다.

       ```jsx
       function Person(name) {}

       var kim = new Person();

       // Person() 생성자 함수에 의해 생성된 객체를 생성한 객체는 Person() 생성자 함수이다.
       console.log(Person.prototype.constructor === Person); // true
       ```

  - 이러한 개념을 이해하고 난 다음, 다음 코드를 보면 프로토타입을 더 쉽게 이해할 수 있다

  - 아래 코드는 Person이라는 생성자 함수를 통해서 객체를 생성하는 코드로 다음과 같은 과정으로 진행된다

  - 먼저 Person이라는 함수를 정의한 다음 Person.prototype으로 프로토타입 객체에 접근해서 eyes와 nose라는 변수를 추가한다

  - 그리고 생성자 함수를 통해 kim, park이라는 객체를 생성한다

  ```jsx
  function Person() {}

  Person.prototype.eyes = 2;
  Person.prototype.nose = 1;

  var kim  = new Person();
  var park = new Person():

  console.log(Person.prototype) // Person 생성자의 프로토타입 객체
  ```

  - 다음과 같이 Person.prototype 출력해보면 Person 프로토타입 객체에 eyes와 nose가 추가된 것을 확인할 수 있다

  ```jsx
  console.log(Person.prototype);
  ```

  - 이러한 과정을 통해 프로토타입을 다음과 같이 정의할 수 있다

  - 프로토타입(Prototype)

    - kim과 park 객체는 Person함수로부터 생성되었기 때문에 Person 함수의 프로토 타입 객체를 가리키는데 이처럼 자바스크립트의 모든 객체는 자신의 부모 역할을 담당하는 객체와 연결되어 있다.

    - 그리고 이것은 마치 객체 지향의 상속 개념과 같이 부모 객체의 프로퍼티 또는 메소드를 상속받아 사용할 수 있게 한다.

    - 이러한 부모 객체를 프로토타입 객체(Prototype Object) 또는 줄여서 프로토타입(Prototype)이라 하고 자바스크립트에서 이 프로토타입은 상속에 사용된다

    - 다시말해 자바스크립트의 모든 객체는 자신의 원형(Prototype)이 되는 객체를 가지며 이를 프로토타입이라고 한다.

    - 자바스크립트는 엄밀히 말하면 객체지향언어라고 할 수 있는데, prototype based로 객체 지향 프로그래밍을 할 수 있기 때문이다

    - ES6의 추가된 class도 prototype 기반의 문법이다

    - Prototype-based Programming이란 객체지향 프로그래밍을 할 수 있는 한가지 방법(a stype of OOP)으로 프로토타입을 사용(that serve as prototype)해서 행동들을 재 사용할 수 있고(behavior reuase(inheritance)), 기존에 있는 객체들을 재 사용(by reusing existing objects)할 수 있다.

---

### Prototype Link ([[prototype]])

- 아래 코드에서 kim과 park 내부에는 eyes와 nose가 없지만 값이 출력되는 이유는 Person 함수를 통해 생성된 객체는 Person.prototype을 참조할 수 있기 때문이다

```jsx
console.log(kim.eyes); // 2
console.log(park.eyes); // 2
```

- 여기서 생성된 객체가 Person.prototype을 참조할 수 있는 이유는 바로 생성된 객체 내부에 프로토타입 객체를 참조할 수 있는 프로토타입 링크(Prototype Link, [[Prototype]]) 이라는 것이 있기 때문이다

- `[[Prototype]]` 는 객체를 생성한 함수의 프로토타입 객체(Prototype Object)를 가리킨다

- 앞의 그림에서 볼 수 있는 `__proto__ `가 바로 프로토타입 링크로, 브라우저에서는 `__proto__ ` 속성을 사용해서 자신의 프로토타입 객체를 참조한다.

- prototype 속성은 함수 객체만 가지고 있던 것과는 달리모든 객체는 프로토타입 링크를 가지고 있는데 아래 코드를 통해 확인할 수 있다

```jsx
function Person(name) {}

var kim = new Person();

console.dir(Person); // prototype 프로퍼티와 __proto__ 모두 있다.
console.dir(foo); // prototype 프로퍼티가 없고 __proto__ 만 있다.
```

---

### Prototype Chain

- Person 생성자 함수 Person 프로토타입 객체, 그리고 Person 생성자 함수로 만들어진 객체의 관계를 다음과 같이 나타낼 수 있다

  <img src="./images/Javascript의 Prototype/2021-01-18-prototype2.png">

- Person 생성자 함수로 만들어진 kim객체가 eyes를 직접 가지고 있지 않기 때문에 eyes 속성을 찾을 때 까지 프로토타입 링크를 통해서 상위 프로토타입을 탐색한다.

- 이렇게 자바스크립트는 특정 객체의 프로퍼티나 메소드에 접근하려고 할 때 해당 객체에 접근하려는 프로퍼티 또는 메소드가 없다면 `[[Prototype]]`이 가리키는 링크를 따라 자신의 부모 역할을 하는 프로토타입 객체의 프로퍼티나 메소드를 차례대로 검색하는데 이것을 프로토타입 체인(Prototype Chain) 이라 한다.

- 최상위인 Object의 프로토타입 객체 까지 도달했는데도 못찾았을 경우 undefined를 리턴한다

- 이러한 프로토타입 체인 구조 때문에 모든 객체는 Object의 자식이라고 불리고, Object 프로토타입 객체에 있는 모든 속성을 사용할 수 있다.

  <img src="./images/Javascript의 Prototype/2021-01-18-prototype3.png">

- 예를 들어 다음과 같은 코드에서 보면 student 객체에는 hasOwnProperty라는 메소드가 정의되어 있지만 student객체의 프로토타입 링크를 통해 참조할 수 있는 Object 프로토타입 객체에는 hasOwnProperty 함수가 있기 때문에 다음과 같이 정상적으로 작동하는 것이다

```jsx
var student = {
  name: "Lee",
  score: 90,
};

// student에는 hasOwnProperty 메소드가 없지만 아래 구문은 동작한다.
console.log(student.hasOwnProperty("name")); // true

console.dir(student);
```

- 추가적으로, 여기서 하나 확인할 것은 Function.prototype이다

- 함수는 다음과 같이 총 3가지의 방식을 통해 선언할 수 있다

  - 함수선언식(Function declaration)

  - 함수표현식(Function expression)

  - Function() 생성자 함수

- 함수표현식으로 함수를 정의할 때는 함수 리터럴 방식을 사용한다.

  ```jsx
  var square = function (number) {
    return number * number;
  };
  ```

- 함수선언식의 경우 자바스크립트 엔진이 내부적으로 기명 함수표현식(이름이 있는 함수 표현식)으로 변환한다.

  ```jsx
  var square = function (number) {
    return number * number;
  };
  ```

- 이를 통해 함수선언식, 함수표현식 모두 함수 리터럴 방식을 사용하는 것을 알 수 있다

- 함수 리터럴 방식은 Function() 생성자 함수로 함수를 생성하는 것을 단순화 시킨 것이기 때문에 결국 3가지 함수 정의 방식은 결국 Function() 생성자 함수를 통해 함수 객체를 생성한다.

- 따라서 어떠한 방식으로 함수 객체를 생성하여도 모든 함수 객체의 prototype 객체는 Function.prototype이다.

- 그리고 생성자 함수도 함수 객체이므로 생성자 함수의 prototype 객체는 Function.prototype이다.

- 그러므로 위 그림에서 볼 수 있듯이 Person() 생성자 함수의 프로토타입 객체는 Function.prototype가 되고, Function.prototype의 프로토타입 객체는 Object.prototype 객체가 된다.

- 생성된 모든 객체의 프로토타입 객체가 Object.prototype일 뿐 아니라 모든 함수의 프로토타입은 Function.prototype이고, 이 Function.prototype의 프로토타입 객체가 Object.prototype인 것을 통해 알 수 있는 것은 결국은 모든 객체의 부모 객체인 Object.prototype 객체에서 프로토타입 체인이 끝난다는 것이다.

- 따라서 Object.prototype 객체를 프로토타입 체인의 종점(End of prototype chain)이라 하며 자바스크립트의 모든 객체는 Object.prototype을 상속한다는 것을 알 수 있다

---

## Reference

- [JavaScript의 함수는 1급 객체(first class object)이다](https://bestalign.github.io/2015/10/18/first-class-object/)
- [Poiemaweb - 객체](https://poiemaweb.com/js-object#2-%EA%B0%9D%EC%B2%B4-%EC%83%9D%EC%84%B1-%EB%B0%A9%EB%B2%95)
- [[Javascript ] 프로토타입 이해하기](https://medium.com/@bluesh55/javascript-prototype-%EC%9D%B4%ED%95%B4%ED%95%98%EA%B8%B0-f8e67c286b67)
