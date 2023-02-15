- 디자인 패턴

  - 코딩할 때 쓰는 개발 방법

- 장점
  - 코드 관리 효율성, 생산성

## 싱글톤 패턴

- 객체의 인스턴스가 오직 1개만 생성되는 패턴을 의미한다.

- 생성자 패턴 카테고리 속한다
- 시스템 로깅이나 애플리케이션 설정 (환경 설정)할 때, 리소스를 관리하는데 쓰인다
- 한 인스턴스에서 관리하고, 애플리케이션에서 전역적으로 접근할 수 있게 도와주는 패턴

**싱글톤 패턴의 특징**

1. 클래스 생성시 constructor는 private

   - new 키워드를 사용해서 생성할 수 없도록 한다

2. constructor에 직접적으로 접근할 수 없기 때문에 static을 사용해서 접근해야 한다

- 따라서 단 하나의 인스턴스만 존재한다는 것을 보장할 수 있다

**싱글톤 패턴의 구조**

- private constructor가 instance를 관리한다
- constructor의 역할은 하나의 인스턴스만 존재할 수 있도록 로직을 관리하는 것

- client가 인스턴스에 접근할 때는 static 멤버함수 getInstance를 사용해서 접근한다

```shell

SingleTon
---------
instance
{...}
----------
static getInstance()

```

- 또 다른 특징 중 하나는 싱글톤은 일 대 다수의 관계를 가지고 있다
- 그래서 클라이언트가 추가되더라도 하나의 인스턴스만 사용한다
- 특정 리소스를 한 군데에서 관리할 수 있다

```ts
class OnlyOne {
  private static instance: OnlyOne;

  public name: string;

  // new 클래스 구문 사용 제한을 목적으로
  // constructor() 함수 앞에 private 접근 제어자 추가
  private constructor(name: string) {
    this.name = name;
  }

  // 오직 getInstance() 스태틱 메서드를 통해서만
  // 단 하나의 객체를 생성할 수 있습니다.
  public static getInstance() {
    if (!OnlyOne.instance) {
      OnlyOne.instance = new OnlyOne('싱글턴 객체');
    }
    return OnlyOne.instance;
  }
}

/* 인스턴스 생성 ------------------------------------------------ */

// [오류]
// [ts] 'OnlyOne' 클래스의 생성자는 private이며 클래스 선언 내에서만 액세스할 수 있습니다.
// constructor OnlyOne(name: string): OnlyOne
let bad_case = new OnlyOne('오류 발생');

let good_case = OnlyOne.getInstance();
let good_case2 = OnlyOne.getInstance(); // 두번째 부터는 인스턴스가 생성되지 않는다

console.log(good_case === good_case2); // true
```

- 장점

  - 하나의 인스턴스에서 리소스를 관리할 수 있다
  - 코드의 중복을 줄일 수 있다
  - 앱 전역에서 싱글톤 클래스에 접근할 수 있다

- 단점
  - 의존 관계상 클라이언트가 구체 클래스에 의존하게 된다.
  - new 키워드를 직접 사용하여 클래스 안에서 객체를 생성하고 있으므로, 이는 SOLID 원칙 중 DIP를 위반하게 되고 OCP 원칙 또한 위반할 가능성이 높다.

---

## Refernce

- [개발자가 알아야할 디자인패턴 | ep1. Singleton Pattern | 자바스크립트 싱글톤 패턴](https://www.youtube.com/watch?v=M4q3sY81gR8&list=PL3xNAKVIm80JldJ6IZBx5eQxck5JA6VuV)
- [싱글턴 패턴 - TypeScript GuidBook](https://yamoo9.gitbook.io/typescript/classes/singleton)
- [싱글톤(Singleton) 패턴이란?](https://tecoble.techcourse.co.kr/post/2020-11-07-singleton/)
