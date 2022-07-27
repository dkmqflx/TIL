- Immutability

  - 데이터의 원본이 훼손되는 것을 막는 것

- 이름에 대한 불변함

  - var VS const

### 내용에 대한 불변함

- Primitive
  - Number
  - String
  - Boolean
  - Null
  - Undefined
  - Symbol
- Object
  - Object
  - Array
  - Function

---

```jsx
var p1 = 1;
var p2 = 1;
console.log(p1 === p2); // true

// 1은 원시데이터 타입에 속한다
// 원시데이터 값 같으면 같은 곳을 가르킨다
// 1은 언제나 1이기 때문에 값을 바꿀 수 없다 -> 불변하다

var o1 = { name: "kim" };
var o2 = { name: "kim" };

console.log(o1 === o2); // false

// 객체는 별도의 데이터를 만들고 각각 따로 가리킨다
// 객체 안의 값은 바꿀 수 있다
```

```jsx
var p1 = 1;
var p2 = 1;
var p3 = p1;
//p1, p2, p3 모두 같은 곳 가리킨다

var p3 = 2;
// p3는 이제 2를 가리킨다

// 1은 원시데이터 타입에 속한다
// 원시데이터 값 같으면 같은 곳을 가르킨다
// 1은 언제나 1이기 때문에 값을 바꿀 수 없다 -> 불변하다

var o1 = { name: "kim" };
var o2 = { name: "kim" };

o3 = o1;
//o3와 o1은 같은 값을 가리킨다

o3.name = "lee";
//o1이 가리키는 데이터의 값도 바뀐다

console.log(o1 === o2); // false

// 객체 안에 객체가 있으면 값이 아니라 주소를 복사한다
// 객체는 별도의 데이터를 만들고 각각 따로 가리킨다
// 객체 안의 값은 바꿀 수 있다
```

---

```jsx
var o1 = { name: "kim" };
var o2 = o1;

o2.name = "lee";

// o2의 값을 바꾸면 o1도 값이 바뀌는 문제가 생긴다.
// o1의 불변성을 지키기 위해서
var o1 = { name: "kim" };
var o2 = Object.assign({}, o1);

//o1과 o2는 각각의 객체를 가리킨다
console.log(o1 === o2); // false

o2.name = "lee";
//original; 데이터에 영향을 주지 않는 것을 통해 원본데이터가 immutable 것을 알 수 있다
```

---

### Nested Object

- 이 때 중요한 것이, o1과 o2는 각각의 메모리를 가리키기 때문에 서로의 주소 값은 다르다.
- 하지만 각각의 메모리 안에는 같은 주소 값이 들어있다
- 그리고 그 주소 값은 같은 공간을 가리킨다.
- 하지만 원시타입인 경우 값을 변경하게 되면 새로운 메모리가 할당되고, 그 메모리의 주소값을 가리키게 되므로 아래와 같은 결과가 나오게 된다.

```jsx
var a1 = { name: "kim", score: 1 };
var a2 = Object.assign({}, a1);

console.log(a1.score === a2.score); // true

a1.score = 2;

console.log(a1.score === a2.score); // false
```

- 하지만 객체 타입의 경우에는 주소값을 가지기 때문에 해당 주소 값이 가리키는 값을 변경하더라도 같은 결과를 갖는다.
- 아래 예시에서 score는 주소값을 가지기 때문에 score 값을 변경하더라도 b1의 score가 가리키는 주소값은 b2가 가리키는 주소값과 같다.
- score 객체의 경우에는 값을 변경해도 score가 가리키는 메모리의 값에 있는 주소값이 변경되는 것이 아니라,
- 해당 메모리에 있는 주소 값이 가리키고 있는 메모리가 재할당되는 것이기 때문에 a1의 score와 b2의 score는 같은 것이다

```jsx
var b1 = { name: "kim", score: [1, 2] };
var b2 = Object.assign({}, b1);

console.log(b1.score === b2.score); // true

b2.score.push = 3;

console.log(b1.score === b2.score); // true
```

- 따라서 불변성을 위해 아래처럼 코드를 작성할 수 있다
- c2에 새로운 객체가 할당되기 때문에 c2의 score의 주소값 자체가 변경이 된다.
- 따라서 c1의 score와 c2의 score의 주소값이 달라지기 때문에 false가 되는 것이다

```jsx
var c1 = { name: "kim", score: [1, 2] };
var c2 = Object.assign({}, c1);

console.log(c1.score === c2.score); // true

c2.score = [...c2.score, 3];

console.log(c1.score === c2.score); // false
```

- o1과 o2는 각각의 메모리를 가리키기 때문에 서로의 주소 값은 다르기 때문에 false가 출력된다

```jsx
var o1 = { name: "kim", score: [1, 2] };
var o2 = Object.assign({}, o1);
o2.score.push(3); // 원본도 같이 바뀐다
console.log(o1, o2, o1 === o2, o1.score === o2.score); //false, true
```

- 불변성을 지키는 방법

```jsx
var o1 = { name: "kim", score: [1, 2] };
var o2 = Object.assign({}, o1);
o2.score = o2.score.concat();
o2.score.push(3);
console.log(o1, o2, o1 === o2, o1.score === o2.score); //false, false
```

---

### 불변의 함수

```jsx
function fn(person) {
  person = Object.assign({}, person);
  person.name = "lee";
  return person;
}
var o1 = { name: "kim" };
var o2 = fn(o1);
console.log(o1, o2);

console.log(o1 === o2); // false
console.log(o1.name === o2.name); // false;
```

```jsx
function fn(person) {
  person.name = "lee";
}
var o1 = { name: "kim" };
var o2 = Object.assign({}, o1);
fn(o2);
console.log(o1, o2);
```

- 원본을 바꾸는 방법

```jsx
var score = [1, 2, 3];
score.push(4);
console.log(score);
```

- 원본을 바꾸지 않는 방법

```jsx
var score = [1, 2, 3];
var a = score;
var b = score;
// 이처럼 a,b 그리고 그 이상의 값들이 score를 가리키고 있는 경우. score 값을 바꾸면 모든 값이 바뀐다`
var score2 = score.concat(4); // 값을 리턴함
console.log(score, score2, a, b);
```

---

### 객체를 불변하게 만들기 (Object freeze)

- freez는 객체의 프로퍼티를 불변하게 만든다

```jsx
var o1 = { name: "kim", score: [1, 2] };
Object.freeze(o1);
Object.freeze(o1.score);
o1.name = "lee";
o1.city = "seoul";
o1.score.push(3);
console.log(o1); // 변하지 않음
```

---

- const와 object.freez의 차이

```jsx
const o1 = { name: "kim" };
Object.freeze(o1);
const o2 = { name: "lee" };
// o1 = o2; -> const는 다른 객체를 참조하지 못하게 하는 것 , error 발생
o1.name = "park"; // freez는 값을 바꾸지 못하게 하는 것
console.log(o1);
```

---

## Reference

- [JavaScript Immutability - 생활코딩](https://opentutorials.org/module/4075)
