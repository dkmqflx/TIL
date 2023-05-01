## 커링

- 함수를 반환하는 함수

  - 함수형 프로그래밍 특징 언어 함수를 인자로 전달할 수 있다

  - 커링을 이용하면 기능이 추가된 함수를 반환할 수 있다

- 객체지향 프로그래밍에서 상속을 통해서 이미 구현된 중복 코드를 줄일 수 있는데

- 함수형 프로그래밍에서는 커링을 사용해서 해당 기능을 구현할 수 있다.

- 아래 처럼 두 수를 곱한 결과를 리턴하는 함수가 있다고 하자

```js
// 두 수를 곱한 결과를 리턴하는 함수
const multiply = (a, b) => {
  return a * b;
};
```

- 이 함수를 재활용해서 2배수 함수를 정의한다면 아래처럼 코드를 작성할 수 있다

```js
// 재활용해서 2배수 해주는 함수를 아래처럼 정의할 수 있다
const multiplyTwo = (a) => {
  return multiply(a, 2);
};
```

- 하지만 이렇게 코드를 작성하면 3배수, 4배수 하는 코드를 하려면 2대신 3, 4가 있는 함수를 추가적으로 정의해주어야 한다

- 이 때 커링을 사용하면 이렇게 반복적으로 정의할 필요 없이 배수가 되는 값을 인자로 받는 함수를 정의할 수 있다

- 코드는 다음과 같다

```js
// 아래처럼 함수를 정의할 수 있다
const multiplyX = (x) => {
  return (a) => {
    return multiply(a, x);
  };
};
```

- 작성한 코드를 아래와 같이 사용할 수 있다

```js
const x2 = multiplyX(2); // 배수 함수 정의
console.log(x2(10)); // 20

// 아래처럼 인자를 나눠서 전달할 수 있다
multiplyX(2)(3); // 6
multiplyX(3)(3); // 9
```

- 추가적으로 코드를 작성해서 아래처럼 덧셈함수도 정의해주자

```js
const add = (a, b) => {
  return a + b;
};

const addX = (x) => {
  return (a) => add(x, a);
};
```

- 그리고 다음과 같은 수학 공식이 있다고 하자

  - 2x \* 3 + 4

- 커링을 사용하면 위 공식을 수학 연산자 없이 사용할 수 있다

```js
const addFour = addX(4); // (a) => add(4, a);
const multiplyThree = multiplyX(3); // (a) =>  multiply(a, 3);
const multiplyTwo = multiplyX(2); // (a) =>  multiply(a, 2);

const forumula = (x) => {
  return addFour(multiplyThree(multiplyTwo(x)));
};

formula(10); // 64
```

- `multiplyTwo(x)` === `2x`

- `multiplyThree(multiplyTwo(x))` === `multiplyThree(2x)`

- `addFour(2x*3)` === `2x + 3`

- 하지만 이렇게 작성한 연산 함수는 단점이 있는데

- 괄호도 많아서 혼동하기 쉽고 함수가 싷애되는 순서가

- 우리가 인지하는 순서의 방향(-->)이 아닌, 반대 방향 (<--) 이라는 점이다

- 그리고 순서를 잘못 배치하면 결과값에 오류가 발생하는 경우가 생기기도 한다

- 조합 함수들을 순서대로 배치할 수 있다면 가독성 문제를 해결할 수 있다

  - `multiplyTwo`, `multiplyTwo`, `addFour` 순으로 배치

- 이러한 함수를 순서대로 조합하도록 도와주는 함수를 reduce를 사용해서 만들 수 있다

```jsx
const formula = [multiplyTwo, multiplyThree, addFour].reduce(
  (prevFunc, nextFunc) => {
    return (x) => {
      return nextFunc(prevFunc(x));
    };
  }
  (k) => k // 초기 값, 생략 가능
);

console.log(formula(10)); // 64
```

- 첫번째 순서는 다음과 같다

  - prevFunc: `(k) => k` (initValue)

  - nextFunc: multiplyTwo

  - 반환값(1):

  ```js
  (x) => {
    return multipyTwo((x) => x);
  };
  ```

- 두번째 순서는 다음과 같다

  - prevFunc: 반환값(1)

  - nextFunc: multiplyThree

  - 반환값(2):

  ```js
  (x) => {
    return multiplyThree(반환값(1));
  };
  ```

- 마지막 순서는 다음과 같다

  - prevFunc: 반환값(2)

  - nextFunc: addFour

  - 반환값(3):

    ```js
    (x) => {
      return addFour(반환값(2));
    };
    ```

- 이렇게 코드를 작성하면 배열에 넣은 배치 순서대로 함수가 실행되는 것을 확인할 수 있다

- 이렇게 작성할 수 도 있다

```js

const formula = [multiply(2), multiply(3), add(4)].reduce(
  (prevFunc, nextFunc) => {
    return (x) => {
      return nextFunc(prevFunc(x));
    };
  }
  (k) => k // 초기 값, 생략 가능
);

console.log(formula(10)); // 64


```

- 그리고 이렇게 작성한 함수를 아래처럼 좀 더 응용해서 작성할 수 있다

- 이 함수를 Compose라고 한ㄷ ㅏ

```js
const compose = (...args) => {
  return args.reduce(
    (prevFunc, nextFunc) => {
      return (...values) => {
        return nextFunc(prevFunc(...values));
      };
    },
    (k) => k
  );
};

const formula = compose(multiplyX(2), multiplyX(3), addX(4));

formula(10); // 64
// compose가 return하는 것은 (...values) => {] 함수
```

- 요약하자면

1. 커링 패턴으로 함수 인자를 분리하여 함수를 재활용할 수 있다

2. 증강 함수(Higher Order Function)는 함수를 인자로 받아 증강된 새 함수를 반환한다

3. 컴포즈(Compose) 함수를 사용하면 여러 증강 함수를 조합할 수 있다

---

### Referenece

- [커링과 함수 조합 파헤치기-currying & compose: Do it! 리액트 프로그래밍 정석](https://www.youtube.com/watch?v=VEAUpHod4cg&t=335)
