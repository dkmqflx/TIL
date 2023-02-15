## SOILD 원칙

- SOLID 원칙이란

  - 객체지향 설계 원칙
  - SOLID 원칙을 지키면 직관적이고 유지보수가 쉬운 코드 작성이 가능하다

### 1. SRP (Single Responsibility) 단일 책임 원칙

- 모듈, 함수, 클래스는 단 한개의 책임을 가져야 함

```js
// 아래 두 함수는 각각 하나의 역할만 하고 있는 함수
function add(num1, num2) {
  return num1 + num2;
}

function numrint(num) {
  console.log(num);
}

// 이렇게 두개의 역할 하는 함수 만들필요 없다
function addPrint(num1, num2) {
  num = num1 + num2;
  console.log(num);
}
```

- 아래는 클래스 예제이다

```js
class Cat {
  constructor(age, name) {
    this.age = age;
    this.name = name;
  }

  eat() {}
  walk() {}
  speak() {}

  // print() {
  //   console.log(`age: ${this.age}, name: ${this.name}`);
  // }

  // log() {
  //   console.log(`log, age: ${this.age}, name: ${this.name}`);
  //   console.log(new Date().now);
  // }

  representation() {
    return { age: this.age, name: this.name };
  }
}
```

- 먹기, 걷기, 말하기 동작을 하는 것은 당연한데
- 프린트, 로그 남기기는 우리가 아는 고양이의 기능이 아니다
- 이런 경우엔느 두 함수를 빼주어야 한다
- 대신 고양이의 상태를 반환하는 함수를 정의한 다음, 아래처럼 print, logger 함수를 사용해서 출력해주면 된다

```js
const kitty = new Cat();
console.log(kitty.representation());
logger.log(kitty.representation());
```

- 이렇게 해주면 단칙 책임 원칙을 지킬 수 있게 된다

---

### 2. OCP (Open-Closed) 개방-폐쇄 원칙

- 확장에는 열려있어야 하고, 변경에는 닫혀 있어야 함
- 즉, 기존의 코드를 변경하지 않고 기능을 수정하거나 추가할 수 있도록 설계해야 함

- 아래는 준수 하지 않는 코드

```js
class Animal {
  constructor(type) {
    this.type = type;
  }
}

const kitty = new Animal('Cat');
const bingo = new Animal('Dog');

function hey(animal) {
  if (animal.type === 'Cat') {
    print('meow');
  } else if (animal.type === 'Dog') {
    print('bark');
  } else {
    throw new Error('wrong type');
  }
}

hey(kitty);
hey(bingo);

// 소나 양을 추가할 수 있다

const cow = new Animal('Cow');
const sheep = new Animal('Sheep');
```

- 하지만 에러 발생한다, hey 함수에서는 소와 양에 대한 정보가 없기 때문이다

```js
hey(cow);
hey(sheep);
```

- Animal 클래스에는 동물의 범주 안에는 고양이와 강아지가 있는데, 소와 양에 대해서 확장을 하려고 하니까 hey 함수까지 수정을 해주어야 한다
- 따라서 동물 확장하는데 제한이 있을 수 밖에 없고, 이것이 개방 폐쇄 원칙에 위배 되는 것이다

- 이를 해결할 수 있는 방법이 interface 또는 abstract 클래스를 사용하는 것이다

```js
class Animal {
  constructor(type) {
    this.type = type;
  }
}

class Cat {
  speak() {
    console.log('Cow');
  }
}

class Dog {
  speak() {
    console.log('Dog');
  }
}

const kitty = new Animal();
const bingo = new Animal();

function hey(animal) {
  animal.speak();
}

hey(kitty);
hey(bingo);
```

- 다음과 같이 코드를 수정해준다.
- 이제는 소나 양을 추가할 수 있다

```js
class Sheep {
  speak() {
    console.log('meh');
  }
}

class Cow {
  speak() {
    console.log('moo');
  }
}

const cow = new Animal();
const sheep = new Animal();

hey(cow);
hey(bingo);
```

- 개방 폐쇄 원칙을 준수 한다면 소와 양에 대한 확장이 가능하고
- hey 함수는 수정을 할 필요가 없다

- OCP 는 추상화 (인터페이스) 와 상속 (다형성) 등을 통해 구현해낼 수 있다.
- 자주 변화하는 부분을 추상화함으로써 기존 코드를 수정하지 않고도 기능을 확장할 수 있도록 함으로써 유연함을 높이는 것이 핵심이다.

---

### 3. LSP (Liskov Substitution) 리스코프 치환 원칙

- 하위 타입 객체는 상위 타입 객체에서 가능한 행위를 수행할 수 있어야 함
- 즉, 상위 타입 객체를 하위 타입 객체로 치환해도 정상적으로 동작해야 함

- 타입 S가 타입 T에 서브타입일 때, 오브젝트 T는 오브젝트 S로 치환가능하다
- 예를들어 타입 T가 있고 그에 서브 타입 S1, S2, S3가 있다면
- 오브젝트 T는 그의 서브타입 오브젝트들 S1, S2, S3로 바꾸어도 프로그램이 동작해야 한다

- 고양이 클래스 Cat이 있다면
- 그에 서브 타입들인 검은 고양이, 길고양이들이 있다면
- 일반적인 고양이를 검은 고양이, 길고양이로 치환해도 우리가 원하는대로 동작해야 한다는 것

```js
class Cat {
  speak() {
    console.log('meow');
  }
}

class BlackCat {
  speak() {
    console.log('black meow');
  }
}

function speak(cat) {
  cat.speak();
}

const cat = new Cat();

speak(cat); // meow
```

- 아래처럼 서브타입으로 치환해서 speak을 호출하더라도 , 정상적으로 동작한다

```js
const cat = new BlackCat();

speak(cat); // black meow
```

- fish는 말을 못하니까, fish로 치환하면 에러 던진다

```js
class Fish {
  speak() {
    throw new Error('fish cant not speak');
  }
}

const cat = new Fish();

speak(cat); // 에러 발생
```

- 즉, 고양이 하위 타입으로 Fish를 넣는다는 것은, 고양이를 생선으로 치환할 수도 없고 리스코프 치환 법칙을 위배하는 클래스 구조인 것이다

---

### 4. ISP (Interface Segregation) 인터페이스 분리 원칙

- 클라이언트는 사용하지도 않는 메소드들에 의존하도록 만들면안된다
- 큰 인터페이스들을 더 작은 단위로 분리시키는 것이 좋다

- 인터페이스 분리 원칙이란, 인터페이스를 너무 큰 개념으로 잡지 말라는 것
- 수륙양용 차가 있고 이것을 인터페이스로 만들게 된다면, 인터페이스 안에는 지상의 차를 위한 함수, 수중에서 보트를 위한 함수가 모두 있을 것이다
- 이렇게 커져버린 인터페이스를 기반으로 클래스를 만들게 되면, 사용햐지 않을 함수들이 클래스에 정의해주어야 한다
- 자동차에는 수중과 관련된 함수들이, 보트에는 지상과 관련된 함수들이 정의되기 때문이다

- 따라서 이러한 인터페이스를 분리해서 자동차 인터페이스, 보트 인터페이스를 분리해주라는 말이다
- 그리고 수륙양용 필요한 경우에는 두개의 인터페이스를 구현해줄 수 있도록 한다

---

### 4. DIP (Dependency Inversion) 의존 역전 원칙

- 의존성 역전 원칙이란 high-level module이 low-level module에 의존하는 것이 아니라 추상화에 의존하는 것입니다.

- 참고
  - [의존성 역전 원칙(Dependency Inversion Principle)이란](https://dkmqflx.netlify.app/oop-dip/)

---

## Reference

- [디자인패턴 SOLID](https://www.youtube.com/playlist?list=PLDV-cCQnUlIZcWXE4PrxJx6U3qKfRTJcK)
