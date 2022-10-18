### async & await

- `async & await`는 프로미스에 좀 더 간편한 api를 제공하는 역할을 하는 syntatic sugar입니다.

- `async & await`를 사용하면 프로미스를 좀 더 간결하고 동기적으로 실행되는 것 처럼 코드를 작성할 수 있습니다.

- 프로미스 계속해서 체이닝 하면서 코드를 작성하면 코드가 난잡해 질 수 있습니다
- 이 때 `async, await`을 사용하면 동기식으로 코드가 순서대로 실행되는 것처럼 코드를 작성할 수 있습니다.

---

### async

- 프로미스를 사용하지 않고 코드를 더 간편하게 사용할 수 있는 방법은 함수 앞에 `async`라는 키워드를 붙여주는 것입니다.

- `async` 를 함수 앞에 붙여주면 프로미스를 쓰지 않아도 자동적으로 함수안에 있는 코드 블록이 프로미스로 변환이 됩니다.

- 아래 코드를 실행하고 콘솔 창을 확인해 보면 프로미스가 리턴 된 것을 확인할 수 있습니다

- 그리고 아래 코드에서 `user!`를 리턴하는 부분은 프로미스에서 `resolve` 함수에 `user!` 전달해서 실행하는 것과 같습니다.

- 따라서 `then`을 사용해서 값을 전달 받을 수 있습니다.

```javascript
async function fetchUser() {
  return 'user!';
}

const user = fetchUser();
user.then(console.log);
console.log(user);
```

- 즉, 위 코드는 아래처럼 Promise를 사용한 것과 같습니다

```javascript
function fetchUser() {
  return new Promise((resolve, reject) => {
    resolve('user');
  });
}
```

---

### await

- `await` 키워드는 `async` 함수 안에서만 동작하는데 프로미스를 기다리기 위해서 사용됩니다.

- 다음과 같은 코드를 실행하면, `await`가 있는 부분에서 실행이 잠시 중단되었다가, 프로미스가 처리되면 실행이 재개됩니다

- 그리고 프로미스에서 `resolve` 함수에 전달된 값을 `then`에서 받을 수 있는 것 처럼, 프로미스 객체의 결과 값이 `result`변수에 할당됩니다.

- 아래처럼 `resolve` 함수에 `success!`가 전달되는 경우에는 전달된 `success!`값이 `result`에 할당됩니다

```javascript
async function foo() {
  // 프로미스는 만들어지자 마자 실행된다
  const result = await new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve('success');
    }, 1000);
  });

  console.log(result);
}

foo();
```

- 에러가 발생하는 경우에는 에러 값이 `result`에 할당됩니다.

```javascript
async function foo() {
  const result = await new Promise((resolve, reject) => {
    setTimeout(() => {
      reject(new Error('error'));
    }, 1000);
  });

  console.log(result);
}

foo();
```

- 아래 코드처럼 `await`를 사용해서 firstFunc 함수가 1초 후 `first`를 반환하도록, SecondFunc 함수를 2초후에 `second`'를 반환하도록 할 수 있습니다

```javascript
function delay(ms) {
  return new Promise((resolve) => setTimeout(resolve(), ms));
}

async function firstFunc() {
  await delay(1000);
  // 1초가 지나면 resolve 호출하는 함수
  // await 키워드 때문에 1초가 끝날 때 까지 기다려야 한다
  return 'first';
  // delay 함수가 성공적으로 수행되고 resolve를 실행하게 되면,
  // firstFunc 함수에서도 first를 인자로 하는 resolve를 실행한다
}

async function secondFunc() {
  await delay(2000);
  return 'second';
}
```

- 만약 secondFunc 함수를 프로미스를 사용해서 구현한다면 다음과 같이 작성할 수 있습니다

```javascript
function secondFunc() {
  return delay(2000).then(() => {
    'second';
  });
}
```

- 동일 하게 프로미스로 구현한 코드와 `async & await`을 사용한 코드를 비교해 보면 프로미스를 체이닝 하는 것 보다 더 `async & await`을 사용한 코드가 더 직관적으로 이해할 수 있다는 것을 알 수 있습니다.

- 아래 코드는 위에서 작성한 firstFunc와 secondFunc 함수를 프로미스를 중첩해서 작성한 코드입니다

- 아래 코드는 `first to second` 까지만 출력 되지만 그 이상의 숫자를 출력하기 위해서 프로미스를 너무 많이 중첩적으로 사용하면 콜백 지옥을 작성할 때 처럼 코드의 가독성이 떨어진다는 단점이 있습니다

```javascript
function print() {
  return firstFunc().then((first) => {
    return secondFunc().then((second) => `${first} to ${second}`);
  });
}

print().then(console.log);
```

- 하지만 `async & await`를 사용하면 다음과 같이 `first to second` 이상의 숫더 간결하게 코드를 작성할 수 있습니다.

- 아래 코드는 `first`, `second` 이외에도 `third`, `fourth`를 반환하는 함수가 있는 경우입니다.

```javascript
async function print() {
  const first = await firstFunc(); // first를 리턴 받는다
  const second = await secondFunc(); // second를 리턴 받는다
  const third = await thirdFunc(); // third 리턴하는 함수
  const fourth = await fourthFunc(); // fourth 리턴하는 함수
  return `${first} + ${second} + ${third} + ${fourth}`;
}
print().then(console.log);
```

- 또한 error가 발생하는 경우에도 `try, catch`를 사용해서 해결할 수 있습니다

- 아래 코드는 `firstFunc` 함수에서 `error`가 발생하는 경우입니다.

- `firstFunc`에서 `error`가 발생하게 되고, 이를 `catch`문에서 처리해주게 됩니다

```javascript
async function firstFunc() {
  await delay(2000);
  throw 'error';
  return 'second';
}

async function secondFunc() {
  await delay(2000);
  return 'second';
}

async function print() {
  try {
    const first = await firstFunc();
    const second = await secondFunc();
  } catch {
    return 'error';
  }
}

print().then(console.log); // error 출력
```

---

- 아래 코드는 위에서 작성한 first + second를 출력하는 코드입니다.

- 이 코드에서는 `await`을 만나는 순간 각 프로미스가 처리되어야 하므로 firstFunc 함수가 실행되고 1초 뒤에 `first`를 반환 받은 다음, secondFunc를 실행해서 2초 기다려서 `second`를 반환 받습니다

- 하지만 두 함수는 서로 연관되어 있지 않기 때문에 서로 기다릴 필요가 없습니다

```javascript
function delay(ms) {
  return new Promise((resolve) => setTimeout(resolve(), ms));
}

async function firstFunc() {
  await delay(1000);
  return 'first';
}

async function secondFunc() {
  await delay(2000);
  return 'second';
}

async function print() {
  const first = await firstFunc();
  const second = await secondFunc();
  return `${first} + ${second}`;
}
print().then(console.log);
```

- 따라서 두 함수가 각각 병렬적으로 실행되도록 하기 위해서 아래 코드처럼 각각의 프로미스를 만들어 줍니다

- 프로미스는 만들어지는 순간 바로 실행되기 때문에 코드를 다음과 같이 수정하면 두 함수가 각각 병럴적으로 실행됩니다

```javascript
async function print() {
  // 프로미스를 만들자 마자 코드 블록 안의 함수가 실행된다, 병렬적으로 두 함수가 실행된다
  const firstPromise = firstFunc();
  const secondPromise = secondFunc();
  // await 키워드를 통해 두 함수의 실행이 끝날 때 까지 기다린다
  const first = await firstPromise;
  const second = await secondPromise;

  return `${first} + ${second}`;
}
```

- 이러한 `async`, `await` 키워드는 리액트에서도 유용하게 사용될 수 있다.

- 리액트에서 axios와 같은 데이터를 서버 통신을 위한 라이브러리를 사용해서 request를 보내 데이터를 받아와서 rendering 해야하는 경우, 이러한 함수는 비동기적으로 작동하기 때문에 데이터를 받아오기 전에 화면을 rendering 하는 경우 있다.

- 이 때 `async`, `await` 를 사용해서 데이터를 모두 받아온 다음에 해당 데이터가 반영된 결과를 rendering 할 수 있다

---

- 이렇게 병렬적으로 프로미스를 실행하는 경우 프로미스에서 제공하는 api를 사용해서 더 간결한 코드로 나타낼 수 있습니다.

- `Promise.all` 은 여러 개의 프라미스를 동시에 실행시키고 모든 프라미스가 준비될 때까지 기다리는 상황에서 유용하게 사용할 수 있다

- `Promise.all`메서드에 프로미스를 담은 배열을 전달하게 되면, 배열에 있는 모든 프로미스들이 완료된 후 새로운 프로미스가 fulfilled 됩니다.

- 이 때 배열에 있는 각각의 프로미스의 결과값을 담은 배열이 새로운 새로운 프로미스의 결과값이 됩니다.

```javascript
function print() {
  //firstFunc, secondFunc 두 함수에서 반환하는 first, second를 then의 인자로 전달한다
  return Promise.all([firstFunc(), secondFunc()]).then((number) =>
    number.join(' + ')
  );
}

print().then(console.log);
```

- 병렬적으로 프로미스들이 실행될 때 가장 먼저 완료되는 프로미스를 사용하기 위해서는 `Promise.race`를 사용합니다.

- 아래 코드를 실행하면 완료까지 firstFunc 함수는 1초, secondFunc는 2초가 걸리기 때문에 firstFunc 함수의 결과값인 `first`가 출력됩니다

```javascript
function print() {
  return Promise.race([firstFunc(), secondFunc()]);
}

print().then(console.log);
```

---

## Reference

- [MDN web docs - async](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Statements/async_function)
- [MDN web docs - await](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Operators/await)
- [MDN web docs - Promise.all](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Promise/all)
- [자바스크립트 13. 비동기의 꽃 JavaScript async 와 await 그리고 유용한 Promise APIs | 프론트엔드 개발자 입문편 (JavaScript ES6)](https://www.youtube.com/watch?v=aoQSOZfz3vQ)
- [for loop vs .map for making multiple API calls](https://dev.to/askrishnapravin/for-loop-vs-map-for-making-multiple-api-calls-3lhd)
- [프라미스 API](https://ko.javascript.info/promise-api)
