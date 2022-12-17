### immutability

- 데이터의 원본이 헤손되는 것을 막는 것

---

### 이름에 대한 불변함

- `const`로 선언된 변수는 값을 재할당할 수 없다.

```javascript
var v = 1;
v = 2;
console.log('v :', v);

const c = 1;
c = 2; // error
```

---

### 내용에 대한 불변함

- 원시 데이터 타입 (Primitive Data Type)

  - Number
  - String
  - Boolean
  - Null
  - Undefined
  - Symbol

- 객체 데이터 타입 (Object Data Type)
  - Object
  - Array
  - Function

* 원시 데이터 타입으로 선언 된 변수는 할당된 값이 같으면 같은 곳을 가르킨다

```javascript
var p1 = 1;
var p2 = 1;
console.log(p1 === p2); // true

// Number 1은 원시 데이터 타입에 속한다
// Number 1은 언제나 1이기 때문에 값을 바꿀 수 없다 -> 불변하다
```

- 객체 데이터 타입으로 선언된 변수는 데이터를 저장하기 위한 별도의 공간을 따로 만든다.

- 변수에 같은 값이 할당되더라도 같은 공간을 가르키지 않는다.

- 객체 안의 값은 바꿀 수 있다

```javascript
var o1 = { name: 'kim' };
var o2 = { name: 'kim' };

console.log(o1 === o2); // false
```

```javascript
var p1 = 1
var p2 = 1
var p3 = p1
//p1, p2, p3 모두 같은 곳 가리킨다

var p3 = 2
// p3는 이제 2를 가리킨다

// 1은 원시 데이터 타입에 속한다
// 원시데이터 값 같으면 같은 곳을 가르킨다
// 1은 언제나 1이기 때문에 값을 바꿀 수 없다 -> 불변하다

var o1 = {name:'kim'}
var o2 = {name: 'kim'}

o3 = o1
//o3와 o1은 같은 값을 가리킨다

o3,.name = 'lee';
//o1이 가리키는 데이터의 값도 바뀐다

console.log(o1 === o2) // false

//객체는 별도의 데이터를 만들고 각각 따로 가리킨다
//객체 안의 값은 바꿀 수 있다

```

- Nested Object

  - 객체 안에 객체가 있으면 값이 아니라 주소를 복사한다.

  - 객체 안에 또 다른 객체가 있는 경우, 원본 객체를 복사해서 다른 변수에 할당하더라도, 복사한 객체 안의 객체를 바꾸면 원본 객체의 값이 바뀐다

```javascript
var o1 = { name: 'kim', score: [1, 2] };
var o2 = Object.assign({}, o1);

o2.score.push(3); // 원본도 같이 바뀐다

console.log(o1, o2, o1 === o2, o1.score === o2.score);
//false, true
```

- 따라서 원본 객체 안의 객체도 별도의 복사본을 만들어주어야 한다

```javascript
var o1 = { name: 'kim', score: [1, 2] };
var o2 = Object.assign({}, o1);

o2.score = o2.score.concat(); // 배열의 복사본을 만든다
o2.score.push(3);

console.log(o1, o2, o1 === o2, o1.score === o2.score); //false, false
```

---

### 불변의 함수

- 함수의 인자가 원시데이터 타입일 때와 객체 데이터 타입일 때의 동작 방법이 다르다

* 객체를 함수의 인자로 전달하고, 전달 받은 객체를 수정하면 원본이 바뀌게 된다

```javascript
function fn(person) {
  person.name = 'lee';
  return person;
}
var o1 = { name: 'kim' };
var o2 = fn(o1);
console.log(o1, o2);
//{name:'lee'} {name:'lee'}
```

- 원본이 바뀌지 않도록 immutable하게 만드는 방법

```javascript
function fn(person) {
  person = Object.assign({}, person);
  person.name = 'lee';
  return person;
}
var o1 = { name: 'kim' };
var o2 = fn(o1);
console.log(o1, o2);
//{name:'kim'} {name:'lee'}
```

```javascript
function fn(person) {
  person.name = 'lee';
}
var o1 = { name: 'kim' };
var o2 = Object.assign({}, o1);
fn(o2);
console.log(o1, o2);
//{name:'kim'} {name:'lee'}
```

- 배열의 원본을 바꾸는 방법
  - `push`를 사용하면 원본 데이터도 바뀐다

```javascript
var score = [1, 2, 3];
score.push(4);
console.log(score);
```

- 배열의 원본을 바꾸지 않는법
  - `concat`을 사용하면 원본 데이터가 바뀌지 않는다

```javascript
var score = [1, 2, 3];
var a = score;
var b = score;

var score2 = score.concat(4);
console.log(score, score2);
// [1, 2, 3] [1, 2, 3, 4]

console.log(a, b);
//[1, 2, 3] [1, 2, 3]
```

---

### 객체를 불변하게 만들기(Object freeze)

- `Object.freeze`는 객체의 프로퍼티를 불변하게 만든다

```javascript
var o1 = { name: 'kim', score: [1, 2] };

Object.freeze(o1);
Object.freeze(o1.score);

o1.name = 'lee';
o1.city = 'seoul';
o1.score.push(3);

console.log(o1); // 변하지 않음
```

- `const`와 `Object.freeze`의 차이
  - `const`로 선언된 변수는 다른 객체를 참조할 수 없다

```javascript
const o1 = { name: 'kim' };
Object.freeze(o1);
const o2 = { name: 'lee' }; // 변화지 않는다

o1 = o2;
// error 발생
// const로 선언된 변수는 다른 객체를 참조하지 못하게 하는 것

o1.name = 'park'; // freeze 때문에 값이 변화지 않는다
console.log(o1);
```

---

## Reference

[생활코딩 - JavaScript Immutability](https://opentutorials.org/module/4075)
