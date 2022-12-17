- OOP(Object Oriented Programming)이란 객체(Object)를 기반으로한 인간 중심적 프로그래밍 패러다임이다( a programming paradigm based on the concept of "object" which can contain data and code)

- 여기서 객체란 관련 있는 데이터와 코드를 함께 묶을 수 있는 것을 말한다

- OOP는 다음과 같은 4가지 원칙을 기반으로 한다

- Abstraction (추상화)

  - 공통의 속성이나 기능을 묶어 정의하는 것으로 `OOP`에서는 `클래스`를 통해 이를 구현할 수 있다

  - `Class Person {}`과 같이 `Person`에 대한 `클래스`를 정의하는 경우, `Person`과 관련된 변수와 함수만을 `클래스` 안에 정의한다

  - 추상화를 통해 클래스를 정의하게 되면 내부적으로는 어떻게 클래스가 동작하는지 이해하지 않고도 외부에 제공하는 인터페이스를 통해 객체를 사용할 수 있다

  - 예를 들어 `Person` 클래스에 `Person`과 관련된 메소드가 너무 많이 제공된다면 사용자는 인터페이스를 사용하는데 어려움을 겪을 수 있다

  - 하지만 추상화를 통해 필요한 메소드만 제공함으로써 인터페이스를 간편하게 만들 수 있고 사용자는 더 편하게 인터페이스를 사용할 수 있다

---

- Encapsulation (캡슐화)

  - 캡슐화란 연관있는 변수나 함수를 하나의 객체로 묶는 것을 의미한다.

  - 예를 들어 `A, B, C`라는 기능이 있고 이 기능이 각각 순서대로 호출되어야 한다고 가정하자

  - 이를 수행하기 위한 코드를 작성하려고 할 때 `A클래스, B클래스, C클래스`와 같이 기능에 따라 각각의 클래스로 정의할 수 있다

  - 하지만 각 클래스가 상호 연관이 있는 경우 모든 클래스가 별도로 존재하게 되면 순서에 맞지 않게 클래스가 호출될 수 있다

  - 그 결과 클래스 상호간의 관계가 복잡해 질 수 있으며 이는 프로그램 전체의 복잡도를 높이는 결과를 초래할 수 있다

  - 이러한 문제를 캡슐화를 통해 해결할 수 있다

  - 클래스 대신`A, B, C`기능을 수행하기 위한 함수를 각각 정의한 후, `공통의 클래스`를 정의하고 이 클래스 안에 함수를 정의하는 방식으로 캡슐화를 할 수 있으며 이를 통해 각각의 기능이 순서대로 호출되는 것을 보장할 수 있다

  - 또한 캡슐화는 감싸는 개념이므로 감싸는 대상을 안전하게 감싸는 것이 중요하다

  - 따라서 정보를 은닉해서 감싸는 것이 좋고 결국 캡슐화는 기본적으로 정보은닉을 포함하는 개념이다

---

- Inheritance (상속)

  - `OOP`에서는 이미 정의된 클래스로부터 데이터나 함수등을 상속받아 사용할 수 있다

  - 이 때 상속받는 클래스를 자식 클래스, 상속하는 클래스를 부모 클래스라고 한다

  - 예를 들어 `dog 클래스`와 `cat 클래스`가 있다고 할 때 두 클래스는 모두 `동물`이라는 공통점이 있으므로 `동물 클래스로`부터 필요한 특징들을 상속받아 사용할 수 있다

  - 이러한 상속 관계는 `IS-A` 관계를 가진다

- Polymorphism (다형성)

  - 다형성은 형태가 같지만 다른 기능을 수행하는 것으로 OOP에서는 상속을 통해 기능을 확장하거나 변경하는 것을 가능하게 해준다

  - 다형성을 `오버라이딩(Overriding)`과 `오버로딩(Overloadin)`으로 구현할 수 있다.

  - 오버라이딩은 자식 클래스에서 부모 클래스와 같은 `반환 값, 인자, 이름`을 가진 함수를 다시 정의하는 것을 말한다

  - 오버로딩은 `이름은 같지만 인자가 다른 함수`를 정의하는 것을 말한다

  - 아래 `java`로 작성된 코드를 통해서 다형성이 사용되는 예시를 확인할 수 있다.

  - `AAA, BBB, CCC 클래스`는 상속관계로 이루어져 있으며, 인스턴스 생성을 통해 각각의 함수를 호출하는 코드이다

  ```java

    class AAA
    {
      public void print(){System.out.println("AAA")}
      public void stamp(){System.out.println("stamp")}
    }

    class BBB extends AAA
    {
      public void print(){System.out.println("BBB")}
      public void stamp(int num){System.out.println("int stamp")}
    }

    class CCC extends BBB
    {
      public void print(){System.out.println("CCC")}
      public void stamp(double num){System.out.println("double int stamp")}
    }

  class PrintAndStamp
  {
    public static void main(String[] args)
    {
      AAA ref1 = new CCC();
      BBB ref1 = new CCC();
      CCC ref1 = new CCC();

      ref1.print(); //CCC
      ref2.print(); //CCC
      ref3.print(); //CCC

      ref1.stamp(); // stamp
      ref2.stamp(1); // int stamp
      ref3.stamp(1.2); // double int stamp


    }
  }
  ```

  - 상위 클래스의 참조변수로 하위 클래스를 참조할 수 있기 때문에 `AAA ref1 = new CCC();`, `BBB ref1 = new CCC();`와 같은 선언이 가능하다

  - 해당 코드를 실행하면 print 함수에 대해서는 모두 같은 결과가 출력된다

  - 그 이유는 상속으로 인해 `클래스 CCC`에는 모두 3개의` print 메소드`가 존재하게 되는데 `AAA의 print 메소드`는 `BBB의 print 메소드`에 `오버라이딩` 되고,` BBB의 print의 메소드`는 `CCC의 print 메소드`에 `오버라이딩` 되기 때문에 참조변수의 자료형에 상관없이 마지막으로 오버라이딩 한 메소드만 출력된다

  - 그리고 이와 달리 `stamp` 메소드는 오버로딩 관계를 가지기 때문에 전달되는 매개변수에 따라 호출되는 메소드가 결정되어 각기 다른 결과가 출력된다

---

## Reference

- [난 정말JAVA 를 공부한적이 없다구요](http://www.yes24.com/Product/Goods/3497762)
- [What Are the Four Basics of Object-Oriented Programming?](https://www.indeed.com/career-advice/career-development/what-is-object-oriented-programming)
