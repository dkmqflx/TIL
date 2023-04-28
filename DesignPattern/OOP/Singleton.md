## Singleton Pattern

- 특정 클래스의 인스턴스가 오직 한개만 존재한다는 것을 보장하는 패턴으로

- Singleton 패턴이 적용된 클래스의 인스턴스는 미리 생성해 놓거나 사용될 때 생성하는 것이 가능하다

- 다른 클래스들에서 싱글톤으로 생성된 객체에 접근할 수는 있지만 생성은 할 수 없다.

- 아래와 같은 경우에 필요하다

  - 하나의 오브젝트가 리소스를 많이 차지하거나

  - 해당 오브젝트가 외부 네트워크와 연결되는데, 단 하나만 있어야 하는 경우

<br/>

- 코드로 나타내면 아래와 같이 작성할 수 있다

```js
class Singleton {
  static instance;

  constructor() {
    if (!Singleton.instance) {
      Singleton.instance = this;
    }
    return Singleton.instance;
  }
}

// 모두 같은 오브젝트를 가리킨다
const s1 = new Singleton();
const s2 = new Singleton();

console.log('is same ?', s1 === s2); // true
```

- 아래처럼 static 함수로 인스턴스를 생성할 수 있도록 작성할 수 있다

```js
class Singleton {
  constructor() {
    if (Singleton.instance) {
      return console.warn('Warning: Singleton Class already instantiated');
    }

    Singleton.instance = this;
    this.version = Date.now();
    this.config = 'test';
  }

  static getinstance() {
    if (!this.instance) {
      this.instance = new Singleton();
    }

    return this.instance;
  }
}
// 1. 하나의 객체 인스턴스만 존재
// 2. static 함수로 객체 접근 (private한 constructor 가지기 때문)

const s1 = Singleton.getInstance()
const s2 = Singleton.getInstance()

console.log(s1 ==== s2) // true

```

- 아래는 Singleton으로 패턴이 적용된 클래스의 예시이다

```js
class SingletonCat {
  static instance;

  constructor(name) {
    this.name = name;

    if (!Singleton.instance) {
      Singleton.instance = this;
    }
    return Singleton.instance;
  }

  speak() {
    console.log(this.name);
  }
}

// 모두 cat1으로, cat1이 두번 출력된다
// 즉, 이미 'cat1'이 전달된 인스턴스가 만들어져 있기 때문에 중복되어서 만들어 질 수 없다
const cat1 = new SingletonCat('cat1');
const cat2 = new SingletonCat('cat2');
console.log('is same ?', cat2 === cat2); // true
```

- 타입스크립트로 아래처럼 작성할 수도 있다.

```js

export default class Singleton{
  private constructor(){}

  private static instance : Singleton | undfined

  static getInstance():Singleton{

    if(this.instance ===  undefined) this.intance = new Singleton()

    return this.instance

  }
}


const s = Singleton.getInstance()


```

- `export default new Obj`와 같이 딱 하나의 인스턴스만 생성되도록 해도 싱글턴 방식으로 작동할 수 있지만

- 해당 방법은 프로그램 실행 중에 해당 객체와 연관된 기능이 사용하지 않을지라도 무조건 생성된다는 단점이 있다.

- 하지만 싱글턴 패턴을 적용하면 이런 부분까지도 제어가 가능하다

---

## Reference

- [Singleton 패턴](https://patterns-dev-kr.github.io/design-patterns/singleton-pattern/)
- [디자인패턴, Singleton Pattern, 싱글톤 패턴](https://www.youtube.com/watch?v=-oy5jOd5PBg)
- [개발자가 알아야할 디자인패턴 | ep1. Singleton Pattern | 자바스크립트 싱글톤 패턴](https://www.youtube.com/watch?v=M4q3sY81gR8)
- [TypeScript로 보는 GoF의 디자인 패턴: 9. Singleton](https://www.youtube.com/watch?v=70zEzNF1NHU)
