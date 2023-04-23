## Tagged Template Literal

- Tagged Template Literals는 Template Literals를 이용하여 함수의 인자를 파싱하여 넘겨주는 것
- 아래 코드를 실행해보면 다음과 같은 결과가 나온다
  - string?*['before ', ' before ', '', raw: Array(3)]*
    - **0**: "before "
    - **1**: " before "
    - **2**: ""
    - **length**: 3
    - **raw**: (3)?['before ',?' before ',?'']
  - first first
  - second second

```jsx
const first = 'first';
const second = 'second';

const taggedFunc = (string, first, second) => {
  console.log('string', string);
  console.log('first', first);
  console.log('second', second);

  console.log(`${string}, ${first} ${second}}`);
};

console.log(taggedFunc`before ${first} before ${second}`);
```

- 즉, tagged template은 인수를 배열 매개변수로 받는 것
- function f(strings, …args) 에서 문자열은 strings배열로 들어가고, 변수들은 args배열로 간다
- 이 때 strings는 마지막 부분에 빈문자(empty character)가 들어간다

- 아래처럼 string 이외의 파라미터 부분을 rest 파라미터로 처리할 수 도 있다

```jsx
const taggedFunc = (string, ...str) => {
  console.log('string', string);
  console.log('str', str); // ['first', 'second']

  console.log(`${string}, ${str[0]} ${str[1]}}`);
};

console.log(taggedFunc`before ${first} before ${second}`);
```

### 활용방법

- tagged literal을 사용하면 복잡한 문자열을 쉽게 처리할 수 있다

- 다음은 console.log와 같은 기능을 하는 함수이다.
- 아래처럼 함수를 정의해서 호출하면 console.log와 동일한 결과를 출력해주며
- console.log 부분에서 추가적인 로직을 통해서 문자열을 변형시킬 수 있다

```jsx
const first = 'first';
const second = 'second';

const consoleLog = (strs, ...vars) => {
  const string = strs.reduce(
    (prev, cur, i) => prev + strs[i] + (vars[i] || ''),
    ''
  );
  console.log('string', string); // 여기에 문자열을 추가하거나 변형시키는 등의 또 다른 로직을 처리할 수 있다
  return string;
};

consoleLog`before f ${first} before s ${second}`;
래;
```

- 문자열을 변형하는 것을 아래 예시를 통해서 확인할 수 있다.
- 점수를 입력하고, 점수에 따른 등급을 출력하는 함수로, 이렇게 tagged literal을 사용하면

```jsx
const score = 100;
const name = 'Kim';

const tagScore = (strings, ...params) => {
  const score = params[0];
  console.log(strings);
  console.log(params);
  let grade;

  if (score > 90) {
    grade = 'A';
  } else if (score > 80) {
    grade = 'B';
  } else if (score > 70) {
    grade = 'C';
  } else if (score > 60) {
    grade = 'D';
  } else {
    grade = 'F';
  }
  return strings[0] + grade + strings[1] + params[1];
};

console.log(tagScore`your grade: ${score} your name: ${name}`);
```

- ㅇ이렇게 tagged literal을 사용하지 않고 score를 grade로 변환해주는 함수를 사용했다면, 필요할 때 마다 문자열을 입력하고 함수를 import 해와야 하지만
- 이렇게 문자열 전체를 처리하는 함수를 정의한 다음 tagged literal을 사용하면 한 문장을 통해서 모두 처리할 수 있다.

---

## Reference

- [(JavaScript) Tagged Template Literals란?](https://medium.com/@su_bak/javascript-tagged-template-literals%EB%9E%80-d7dca9461a45)
- [태그드 템플릿 리터럴(Tagged Template Literals) ? 자바스크립트 가이드 4](https://smoothiecoding.kr/%ED%83%9C%EA%B7%B8%EB%93%9C-%ED%85%9C%ED%94%8C%EB%A6%BF-%EB%A6%AC%ED%84%B0%EB%9F%B4-%EC%9E%90%EB%B0%94%EC%8A%A4%ED%81%AC%EB%A6%BD%ED%8A%B8/)
- [ES2015 Tagged Template Literal](https://www.zerocho.com/category/ECMAScript/post/5aa7ecc772adcb001b2ed6f3)
