### Class

- ES6 부터 자바스크립트에는 새롭게 `class` 키워드가 등장하였습니다.

- 자바스크립트의 `class`는 생성자 함수처럼 `new` 키워드를 사용해서 인스턴스를 만들 수 있습니다

- 이때, `new` 키워드와 함께 호출한 Person는 아래 코드에서 확인할 수 있듯이 생성자(constructor)입니다.

```javascript
class Person {}

const person = new Person();

console.log(Object.getPrototypeOf(person).constructor === Person); // true
```

---

### Constructor

- constructor는 `class` 안에서 객체를 생성하고 초기화 하기 위한 메소드 입니다

- constructor를 사용해서 클래스 필드(클래스 내부의 캡슐화된 변수)를 초기화 할 수 있습니다

- 클래스 필드에 선언된 변수는 클래스 외부에서 참조할 수 있습니다

```javascript
class Person {
  constructor(name) {
    // this는 클래스가 생성할 인스턴스를 가리킨다.
    // _name은 클래스 필드이다.
    this._name = name;
  }
}

const me = new Person('Lee');
console.log(me._name); // Lee
```

---

### Getter and Setter

- Getter 함수는 값을 리턴받는 함수로, `get` 키워드로 함수를 정의할 수 있습니다

- Setter 함수는 값을 설정하는 함수로, `set` 키워드로 함수를 정의할 수 있습니다

```javascript
class User {
  constructor(name) {
    this.name = name;
  }

  get Name() {
    return this.name;
  }
  set Name(value) {
    this.name = value;
  }
}

const user1 = new User('Steve');
console.log(user1.Name); // steve

user1.Name = 'bill'; // set 키워드로 정의된 함수에 값을 할당하면 setter 함수가 호출된다
console.log(user1.Name); //bill
```

- 위 코드에서 나이를 입력 받는 기능을 추가해 보겠습니다.

- 이때 입력 값이 0보다 작은 음수를 입력하는 경우가 생길 수 있습니다.

- 사람의 나이가 0보다 작은 것은 불가능하기 때문에 getter와 setter 함수를 통해서 이러한 문제를 해결 할 수 있습니다

```javascript
class User {
  constructor(name, age) {
    this.name = name;
    this.age = age;
  }

  //getter
  get age() {
    return this.age;
  }

  //setter
  set age(value) {
    this.age = value;
  }
}

const user1 = new User('Steve', -1);
console.log(user1.age);
```

- 위 코드는 언뜻보면 이상이 없어보이지만, 코드를 실행하고 나면 `Uncaught RangeError: Maximum call stack size exceeded` 라는 에러가 발생합니다.

- 그 이유는 `this.age = age;` 부분 때문입니다.

- get과 set 키워드를 사용해서 getter와 setter를 정의하고 나면 `this.age`는 getter 인 `get`의 age를 호출하고, `'='` 오른쪽의 age에서는 setter인 `set`의 age를 호출하게 됩니다.

- 이 때, setter를 호출하면 함수안에서 value를 할당하는 `this.age = value;` 부분 때문에 또 다시 setter가 호출되고 `set`의 age 함수가 호출 되면 또 다시 함수 안의 `this.age = age;` 부분 때문에 `set` 의 age 함수가 반복되서 호출됩니다.

- 이러한 과정이 계속해서 반복되기 때문에 결국 call stack이 다 찼다는 `call stack size exceeded`에러가 출력 됩니다

- getter와 setter 안에 쓰이는 변수 이름을 다르게 해줌으로써 문제를 해결 할 수 있습니다

```javascript
class User {
  constructor(name, age) {
    this.name = name;
    this.age = age;
  }

  get age() {
    return this._age;
  }
  set age(value) {
    this._age = value < 0 ? 0 : value;
  }
}

const user1 = new User('Steve', -1);
console.log(user1.age); // 0
```

---

### Static

- 클래스를 통해 만들어지는 Object에 상관없이 동일하게 반복되어 사용되는 고유한 값 또는 메소드가 있을 경우 static 키워드를 사용해서 해당 클래스의 값 또는 메소드로 정의해줍니다.

- static 키워드로 선언된 함수나 메소드는 인스턴스가 아니라 클래스 이름으로 호출합니다.

```javascript
class Foo {
  static x = 1;

  static bar() {
    console.log('static function');
  }
}

const foo = new Foo();
console.log(Foo.x);
console.log(foo.x); //undefeind
console.log(Foo.bar());
console.log(foo.bar); //undefeind
```

---

### 상속(extends)

- 자바(Java)에서 `extends`를 사용해서 상속을 구현하는 것 처럼 자바스크립트에서도 `extends` 키워드를 부모클래스에서 정의된 기능을 자식 클래스에서도 사용할 수 있습니다.

- `super` 키워드는 부모 클래스를 참조할 때, 그리고 부모 클래스의 생성자(Constructor)를 호출할 때 사용합니다.

```javascript
class Shape {
  constructor(width, height, color) {
    this.width = width;
    this.height = height;
    this.color = color;
  }
  draw() {
    console.log(`draw ${this.color} color`);
  }

  getArea() {
    return this.width * this.height;
  }
}

class Rectangle extends Shape {
  constructor(width, height, color) {
    super(width, height, color); // 부모 클래스의 생성자를 호출해서 인수를 전달한다
    // this.width = width;
    // this.height = height;
    // this.color = color;
  }
}

class Triangle extends Shape {
  draw() {
    //  overriding
    super.draw(); // 부모 클래스 참조
  }
  getArea() {
    // overriding
    return (this.width * this.height) / 2;
  }
}

const rectangle = new Rectangle(20, 20, 'blue');
rectangle.draw(); //draw blue color
console.log(rectangle.getArea()); // 400

const triangle = new Triangle(20, 20, 'red');
triangle.draw(); // draw red color
console.log(triangle.getArea()); // 200
```

---

## Reference

- [MDN web docs - super](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Operators/super)
- [MDN web docs = class](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Classes)
- [https://poiemaweb.com/es6-class](https://poiemaweb.com/es6-class)
- [자바스크립트 6. 클래스와 오브젝트의 차이점(class vs object), 객체지향 언어 클래스 정리 | 프론트엔드 개발자 입문편 (JavaScript ES6)](https://www.youtube.com/watch?v=_DLhUBWsRtw&t=1224s)
