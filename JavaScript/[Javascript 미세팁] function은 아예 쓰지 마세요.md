```javascript

//spread 방식으로 parameter를 전달하면, 배열 형태로 받게 된다
// [1, 2] 리턴 된다

function Foo(...args){
  console.log(this)

  if(this !=== window) this.args = args

  else return args
}

// 일반 함수로 활용
Foo(1, 2)
// this는 window


// 생성자 함수로 활용
const foo = new Foo(3, 4)
console.log(foo)
// foo가 window가 아니라 객체
// 따라서 만들어진 객체에 args 프로퍼티를 추가해주는 조건문이 실행된다


// 객체 메서드로 할당
const bar = {
  method:Foo
}

bar.method(5, 6)
console.log(bar)
// 이번에는 this가 bar가 되고
// bar에 args라는 프로퍼티를 추가하게 된다.


```

- `function` 키워드를 통해서 함수를 작성하면 아래와 같은 방식으로 활용할 수 있다

  - 일반 함수
  - 생성자 함수
  - 객체 메서드

- 이런 식으로 객체 메서드로도 사용할 수 있고 생성자 함수로도 사용할 수 있고 일반함수로도 사용할 수 있다 보니까

- 범용적으로 쓸 수 있다 라는 면에서는 좋지만 오히려 그렇기 때문에 문제가 되는 경우들이 상당히 있는 거 같습니다.

- 어떤 부분이 문제인지를 보기 위해서 일반함수 하나 만들어 놓고 a를 출력을 해 볼게요.

```javascript
function a() {}
console.dir(a);
```

- 펼쳐보면, 여기에 prototype이라고 하는 프로퍼티가 있다.

- 이 프로퍼티는 생성자 함수랑 관련이 있는 것인데, 일반함수로 활용하려는 목적에 의해서는 프로토타입 이라고 하는 프로퍼티가 불필요한 것이다.

- 또한 이 부분에서, this를 바인딩한다 라는 점이 문제가 된다.

- 함수 안에서 this를 출력하면 아까처럼 윈도우가 출력이 되는 건데 객체 메서드로 사용할 경우에는 this가 그 객체, 해당 객체를 가리키게 된다.

- 그렇게 해당 객체를 가리킬 수 있는 이유가 실행컨텍스트 생성 시점에 this를 바인딩하기 때문

- 그래서 this를 쓸 경우에는 좋지만 함수로 쓸 때는 불필요한 정보이다.

- 그리고 이 this 때문에 오히려 혼란스럽게 되고, 동적으로 바인딩 되기 때문에 this가 어떤 식으로 달라지는지에 대해서 정확히 이해를 하더라도 찾아가는 것이 쉬운 방법은 아니다.

- 즉, 일반 함수로 활용 -> prototype 프로퍼티 불필요하다

- this 바인딩은 함수로 쓸 때는 불필요한 정보

---

### 클래스

- 그래서 ES2015에서는 이런 각각의 목적들, 함수로 활용, 생성자 함수로 활용, 객체 메서드로 활용할 때 그 목적에 맞는 정확한 기능들을 대거 추가가 되었다.

- 우선 생성자 함수로 사용할 경우에는 클래스라는게 등장을 했다.

```javascript

function Foo(...args){

  if(this !=== window) this.args = args

  else return args
}

Foo.prototype.getArgs = function(){
  return this.args
}

const foo = new Foo(1, 2)
console.dir(foo)

```

- Foo 함수에서 메서드를 프로토타입으로 할당하려면

- 위에서 처럼 `Foo.prototype.getArgs = function ...` 이런 식으로 할당을 하게 된다.

- 그리고 ES6에서 등장한 클래스는 아래처럼 getArgs 함수를 할당할 수 있다.

```javascript

class Bar{
  constructor(...args){
    if(this !=== window) this.args = args
    else return args
  }

  getArgs(){
    return this.args
  }

}

const bar = new Bar(3, 4)
console.dir(bar)
```

- Foo와 Bar 두 개 모두 상태는 동일해 보이는데 `[[Prototype]]` 이라는 부분을 열어보면 생김새가 다른 부분이 확인이 된다.

- Foo라고 하는 함수로 만든 생성자함수 프로토타입 부분을 보면 getArgs가 진한 색으로 되어 있는데

- Bar는 흐린 색으로 되어 있다.

- property descriptor 속성중에 enumerable 속성이라고 하는 게 있는데 Foo에 있는 prototype.getArgs에 대해 직접 할당한 방식에 의하면 enumerable은 true 값이 잡히게 된다.

- 하지만 클래스로 생성해서 여기에 바로 할당한 경우는 자동으로 false가 들어가게 된다.

- 이것이 의미하는 바는 Foo의 경우는 for in문 같은, 전체를 순회시켜야 되는 경우에 getArgs가 foo라고 하는 객체 자체에 있는 프로퍼티가 아님에도 불구하고 for in문에 의해서는 순회를 돌 수가 있다.

```javascript

for let (prop in foo){
  console.log(prop)
}

```

- 위처럼 출력을 하고 봤을 때 args만 잡히는 게 아니라 getArgs까지 나오게 된다.

- 그러니까 이 프로토타입에 있는 거는 받지 않기 위해서 조건문을 걸어야 된다.

```javascript

for let (prop in foo){
  if(foo.hasOwnProperty(prop)) console.log(prop)
}

```

- 이런 조건문을 걸게 되면 이번에는 args만 나오는게 확인이 된다.

- 이런 조건을 달아서 직접 해야 된다라는 면에서 번거롭다는 단점이 있다.

- 반면에 클래스로 한 경우에는 그냥 for in문만 돌리더라도 프로토타입 프로퍼티들은 enumerable이 false이기 때문에 그냥 해도 args만 출력이 된다

```javascript

for let (prop in bar){
  console.log(prop)
}

```

- getArgs라는 메서드가 나오지 않게 된다.

- 그러니까 클래스는 hasOwnProperty 같은걸 쓰지 않아도 객체 인스턴트 자신에게만 있는 값만 순회를 돌 수가 있어서 그런 면에서 개발자가 신경써야 할 부분이 더 줄어든다는 장점이 있다.

---

- Foo라고 하는 함수는 arguments: null, caller: null 이런 것들이 있다.

- 클래스 Bar의 경우는 arguments가 마우스를 올려보니까 속성 getter를 호출해라- 라고 나온다.

- 눌렀더니 '예외'라고 하는 메세지가 나오는데 복사해보면 `TypeError: 'caller', 'callee', and 'arguments' properties may not be accessed on strict mode functions or arguments objects for call to them` 이라는 것이 출력된다

- 즉, "caller나 callee, 그리고 arguments는 액세스할 수 없습니다" 라고 하고 있다.

- 그래서 Foo의 경우는 기존에는 arguments가 그냥 출력이 됐다면 Bar의 경우는 에러를 던지게 된다.

```javascript
console.log(Foo.arguments); // 정상 출력
console.log(Bar.argumenets); // 에러 출력
```

- 기존에는 가급적이면 에러를 던지지 않게끔 해서 어지간하면 동작이 되게끔 만들었다면 최신 자바스크립트에서는 가능한 친절하게 에러 메세지를 던져줘서 최대한 빠른 시점에 수정을 할 수 있게끔 유도를 하고 있다.

- 또 한가지 차이점은 Foo는 함수로도 쓸 수 있고 생성자 함수로도 쓸 수 있었지만 Bar의 경우는 그냥 호출을 할 수가 없다.

```javascript
Bar(); // 에러 발생
```

- "new 키워드 없이 호출될 수 없습니다." 이렇게 에러를 띄워준다.

- 명확하게 클래스는 클래스의 목적에 맞게 써라 함수로써는 쓸 수 없다.

- 그래서 결론적으로 생성자 함수로 쓰고자 할 때는 그냥 클래스를 쓰면 된다.

---

### 일반 함수

- 일반 함수로 쓸 경우에는 새로 등장한 것이 Arrow Function이라는게 있다.

- arrow function을 간략한 함수일 경우에만 쓰고 그렇지 않을 경우에는 그냥 function이란 키워드를 쓰자라고 하는 사람들도 있는데모든 함수는 다 arrow function으로 쓰면 된다고 본다.

```javascript
function foo(...args) {
  console.log(args);
}

function bar(...args) {
  console.log(args);
}

console.log(foo);
console.log(bar);
```

- foo 함수를 열어 보면 arguments, caller 부분이 둘 다 null로 떨어지고 있다..

- 근데 arrow 함수의 경우는 invoke를 시켜야만 값을 알 수 있다. (`(...)` 형태로 되어 있따.)

- getter를 호출해야 되는 형태, 그러면 에러 메시지를 받을 수 있게 된다.

- 그리고 prototype이 있는데 arrow 함수의 경우는 prototype이 없다.

- bar라고 하는 함수는 arrow함수는 생성자함수로 쓸 수 없다는 얘기.

- 그리고 prototype이 없으니까 더 가볍게 쓸 수 있는 것.

- 생성자함수로 쓸 경우를 고려를 하지 않으니까

- 또 한 가지가 arrow 함수에 대해서 얘기가 나올 때 가장 대표적으로 나오는 얘기중의 하나가 this 바인딩을 하지 않는다는 것.

- 기존에는 call, apply, bind 메소드 같은 걸 이용해서 this를 직접 할당 해줄 수 있었다면 arrow 함수의 경우는 그럴 수가 없는 것.

- 근데 애초부터 '함수'로 쓴다고 하면 this를 신경쓸 이유가 없기 때문에 그러니까 this를 써야된다면 객체 메서드 선언 방식을 쓰면 되는 것.

- this를 신경 쓰지 않고 함수로써 써야 한다고 하면은 arrow function만으로 충분하다.

- 그래서, 함수로써 쓰고자 할 때는 function보다 가벼운 arrow function을 쓰면 된다.

---

### 객체 메서드

- 메서드에 대해서도 새로운 게 나왔죠. '메서드 축약형' 이라고 합니다.

```javascript
const obj1 = {
  name: 'n1',
  method: function () {
    console.log(this.name);
  },
};

const obj2 = {
  name: 'n2',
  method() {
    console.log(this.name);
  },
};

const obj3 = {
  name: 'n3',
  method:()=> {
    console.log(this.name);
  },
};


```

- 기존 방식 obj1과 메서드 축약형을 쓴 obj2를 가지고 한 번 비교를 해보면.

- 둘 다 method(), method() 라고 나오고 있다

- 기존 방식의 method 할당 방식, 이렇게 function을 그대로 가지고 쓰는 경우에는 똑같이 arguments: null, caller: null, 또 prototype 있고

- 반면 obj2의 경우는 arguments, caller는 호출을 해야 되고(`(...) 형태로 되어 있다`) prototype는 없다.

- arrow 함수랑 생김새가 거의 비슷하다 하나의 차이점이라면 메서드 축약형은 method로서의 목적을 가지고 있기 때문에 this 바인딩이 된다.

```javascript
obj1.method();
obj2.method();
obj3.method(); // undefined, 화살표 함수의 경우, 렉시컬 스코프에 따라 상위 스코프에서 this를 찾는데, 외부에 name이라는 값이 없기 때문에  undefined가 출력된다
```

- 그러면 둘 다 n1, n2 잘 나오고 있는게 확인이 된다.

- this로 접근이 가능하다는 것,

- 그러니까 객체에서의 메서드는 메서드 축약형을 쓰면 arrow함수처럼 가벼워졌지만

- this 바인딩만큼은 되는 것

- 마찬가지로 또 이 축약형의 경우는 생성자 함수로 쓸 수 없다.

```javascript
new obj2.method(); // 에러 발생

console.log(new obj1.method()); // 객체 생성
```

- obj1의 경우는여기에 메서드로 할당이 되어 있지만 여전히 함수이기 때문에 된다다.

- 출력을 하면 보면 method라고 하는 생성자함수로 만들어진 객체가 생성된다.

- 예외적으로 반드시 function이라고 하는 키워드를 반드시 써야만 하는 경우가 딱 하나가 있다.

- 언제냐면 generator, 이 generator의 경우는 function이라는 키워드를 쓰지 않을 수가 없다.

- 이게 함수 형태의 generator에서만 아래처럼 function 키워드가 필요하고,

```javascript

function generator(){
  yield 1
  yield 2
}

console.dir(generator)

const gene = generator()
console.log(gene.next().value) // 1
console.log(gene.next().value) // 2
console.log(gene.next().value) // undefined

```

- 마찬가지로 객체 안에서 generator를 만들 경우는 이런 식으로 된다.

```javascript

const obj = {
  val:[1, 2]
  *gene(){
  yield this.val.shift()
  yield this.val.shift()
  }

}


const gene = obj.gene()
console.log(gene.next().value) // 1
console.log(gene.next().value) // 2
console.log(gene.next().value) // undefined


```

- 객체안에 generator를 이렇게 만들었다라고 하면 앞에 별 붙여 주고 메서드 축약형으로 똑같이 쓰면 된다.

---

- function이란 키워드를 절대 쓰지 마세요 라고 하는 건 아니고,

- 당연히 "나는 var이 좋아", "나는 function이라는 키워드가 너무 좋아" 그리고 "function이 가지는 호이스팅 개념도 너무 좋고 편리해서 자주 쓰고 있어" 라고 하면 그거를 제가 말리고자 하는 거는 아니다.

- 다만 기왕이면 조금이라도 더 빠릿하고 목적이 더 명확히 드러나는 방식을 택하는 게 협업 환경에서 더 좋다고 본다.

- 예를 들어서 남이 만든 어떤 함수 a를 보고서 이 함수 a가 생성자 함수로 쓰려는 것인지 그냥 일반 함수로 쓰려는 것인지 아니면 다른 객체에다가 메서드로 할당하려고 하는 것인지 혹은 call apply bind 메서드를 같은 걸 써서 this를 자유롭게 주입해서 쓰려고 하는 범용적인 함수인지 그런 목적성을 이 함수만 봐서는 알기가 어렵기 때문이다.

- 근데 arrow 함수는, 아 얘는 this 바인딩도 할 수 없고 생성자 함수로도 쓸 수 없으니까 얘는 무조건 그냥 함수로 쓰겠구나!

- 또 call, apply, bind 메서드를 써봤자 어차피 this 바인딩을 할 수 없으니까 그런 경우에도 this를 별로 신경쓰지 않아도 되겠구나! 라는게 이 함수에서 바로 안심이 된다.

- 클래스의 경우는 그냥 클래스 자체로 아 얘는 바로 클래스구나- 생성자함수로만 쓰겠구나! 라는게 명확하다.

- 객체 메서드 축약형도 마찬가지 입니다. 이런 식으로 이 생김새 그 자체만으로 다른 가능성이 있다는 걸 열어두지 않고 한 가지 기능만 할 거라고 생각하는 것이 다른 사람이 내 코드를 봤을 때 좀 더 빨리 이해할 수 있는 지름길이라고 생각한다.

- 사실은 TC39도 그걸 바라고 있다고 봐도 무방하다고 생각한다.

- 하나의 자바스크립트, living standard라는 거를 내세우고 있기 때문에 어쩔 수 없이 힘든 일을 가야 되었다.

- 그래서 function이라고 하는 키워드를 없앨수가 없었지만 그렇기 때문에 "앞으로는 절대 쓰지 마세요" 라고 대놓고 말하지는 못하지만 기왕이면 안 써 주길 바라는 마음에서 이런 것들을 만들었다고 생각한다.

- 그래서 정리를 해 보면 기존에 있던 함수라고 하는 키워드는 다양한 목적에 두루 쓸 수 있는 만능 키워드였습니다. 그러다 보니까 무겁고 상황에 따라서 개발자가 추가로 번거로운 작업을 해 줘야 하거나 안전장치를 마련해 하는 등의 문제가 있었다.

- 그래서 이제부터는 함수로 쓰고자 할 때는 arrow 함수를 생성자함수로 쓰고자 할 때는 클래스를 메서드로 쓰고자 할 때는 메서드 축약형을 써 주시면 좋다고 생각.

- 그럼 function은 언제 쓰느냐 쓸 일이 아예 없다. (generator 제외)

- 남이 짠 코드에서 function이 등장한다면 어쩔 수 없이 봐야겠지만, 직접 작성하실 때는 가급적이면 사용하지 않는 것을 추천.

---

## Reference

- [Javascript 미세팁 function은 아예 쓰지 마세요](https://www.youtube.com/watch?v=LPEwb5plEoU&t=13s)
- [프로퍼티 플래그와 설명자](https://ko.javascript.info/property-descriptors)
- 클래스는 prototype의 편의문법이 아니다.
  - [https://www.bsidesoft.com/5370]
  - [https://roy-jung.github.io/161007_is-class-only-a-syntactic-sugar/]
