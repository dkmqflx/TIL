---
layout: post
title: 'Javascript의 콜백(Callback) 함수 '
subtitle: 'javascript callback'
categories: frontend
tags: javascript
comments: true
---

- Javascript의 콜백 함수(Callback Function)에 대해서 정리한 글입니다

---

- 자바스크립트는 싱글 스레드(Single Thread) 프로그래밍 언어이기 때문에 하나의 콜 스택(Call Stack)을 가집니다. 하나의 콜 스택을 가진다는 말은 한번에 하나의 작업만 수행할 수 있으므로 동기적(Synchronous)으로 코드가 실행된다는 뜻입니다.

- 동기적으로 코드가 실행될 때는 다음과 같은 단점이 있습니다.

- 예를 들어 다음과 같이 데이터를 받아오는데 10초가 걸리는 코드가 있다고 가정해 보겠습니다.

- 자바스크립트 동기적으로 작동하므로 10초가 걸리는 작업이 끝날 때 까지 다음 코드로 넘어가지 않고 기다리게 됩니다

- 만약 해당 코드의 뒷 부분에 웹페이지의 ui을 표시하는 코드가 있다면, 데이터를 받아오는 동안 웹 페이지는 표시되지 않고 데이터를 받아올 동안 사용자는 비어있는 웹페이지를 보게 됩니다.

- 요청 받는 데이터의 용량이 클수록 더 많은 많은 시간을 기다려야하는 단점이 있기 때문에 이렇게 오래 걸리는 작업들은 비동기적으로 처리해줄 필요가 있습니다

```javascript
function fetchUser() {
  // do network requst is 10 secs

  return 'user!';
}

const user = fetchUser();
console.log(user);
```

---

- 이러한 단점을 극복하기 위한 방법이 비동기적(Asynchronous) 방법입니다.

- 요약하자면 자바스크립트의 코드는 기본적으로 동기적(Synchronous)으로 실행되지만 Web API에서 제공하는 여러 함수들을 사용해서 비동기적(Asynchronous)으로 실행 할 수 있습니다.

- 우선 아래의 코드는 한줄씩 동기적으로 실행되는 코드 입니다

```javascript
console.log('1');
console.log('2');
console.log('3');
// 1, 2, 3 출력
```

- 하지만 `setTimeout()`함수를 쓰면 비 동기적으로 코드를 실행할 수 있습니다.

- 아래 코드를 보면 `setTimeOut()` 함수의 첫번째 인자로 전달되는 함수가 있는데 이 함수가 바로 콜백 함수 입니다.

- [MDN Web Docs](https://developer.mozilla.org/en-US/docs/Glossary/Callback_function)는 콜백 함수를 다음과 같이 정의하고 있습니다.

- A callback function is a function passed into another function as an argument, which is then invoked inside the outer function to complete some kind of routine or action.

- 즉, 콜백 함수는 다른 함수의 인자로 전달되어 특정한 시점에 실행되는 함수라고 할 수 있습니다.

- 아래 코드에서의 화살표 함수는 2초 이후에 Web API에 의해 태스크 큐로 이동하게 된 다음 실행되는 콜백함수 입니다.

```javascript
console.log('1');
setTimeout(() => {
  console.log('2');
}, 2000);
console.log('3');

// 1, 3, 2 출력
```

- 위 코드에서 `setTimeout()` 함수의 두번째 인자로는 timeout 값인 2초를 전달해주었고 2초후에 첫번째 인자로 전달된 함수가 실행되면서 `2`가 출력됩니다.

- 따라서 코드를 실행시키면 `1, 3, 2`가 순서대로 출력됩니다

- 하지만 `setTimeout()` 함수의 timeout 인자를 0으로 설정해도 결과값은 `1, 2, 3`이 아닌 `1, 3, 2`가 출력됩니다

- 그 이유를 알기 위해서는 `setTimeout()` 함수가 콜 스택(Call Stack)에서 어떻게 작동하는지 알아야 합니다

---

<img src = "./images/2020-06-16-javascript-callback.png">

- 위 그림을 통해서 `setTimeout()` 함수가 어떻게 실행되는지 알 수 있습니다.

- 브라우저에서 제공되는 Web API의 `setTimeout()` 함수를 실행하면 Web API를 호출하게 되고, 인자로 전달된 콜백 함수는 바로 실행되지 않고 timeout 만큼 기다린 후에 Event Queue로 이동합니다.

- 그리고 콜백 함수는 Call Stack이 비어졌을 때, Call stack 으로 이동해서 실행됩니다.

- 그렇기 때문에 timeout 값을 0으로 설정하더라도, 모든 call stack의 함수가 실행된 후에 call stack이 비어진 다음에 콜백 함수가 실행되는 것입니다

---

- 이렇게 비동기 처리 방식에서 발생할 수 있는 문제를 콜백 함수(Callback Function)를 통해서 해결할 수 있습니다.

- 아래 코드는 `1, 2, 3` 을 순서대로 출력하기 위해 콜백 함수를 사용하고 있습니다.

- 아래 예제에서는 첫번째 예제의 비동기 처리 방식에서 발생한 문제를 또 다른 콜백 함수로 해결하고 있습니다

- `2`를 출력하는 `printTwo()` 함수의 인자로 전달되는 `3`을 출력하는 함수가 콜백 함수(Callback function)입니다.

- 코드를 실행하면 `1`이 출력된 다음 2초의 시간이 지난 후 `2`가 출력된 되고 그 다음 callback 함수가 출력되므로 `1, 2, 3`이 순서대로 출력됩니다

```javascript
function printTwo(callback) {
  setTimeout(() => {
    console.log('2');
    callback();
  }, 2000);
}

function printThree() {
  console.log('3');
}

console.log('1');
printTwo(printThree);

// 1, 2, 3
```

---

- 콜백함수는 주로 비동기적(Asynchronous)으로 사용되지만 동기적(Synchronous)으로 사용될 수 있습니다.

- 아래 코드의 첫번째 예제처럼 동기적으로 실행되는 콜백 함수 입니다

```javascript
//Synchornous Callback
function printImmediately(print) {
  print();
}

printImmediately(() => console.log('hello'));
//PrintImmediately 함수를 실행 한 다음에 인자로 전달된 Print함수가 실행된다.

//Asynchornous Callback
function printWithDelay(print, timeout) {
  setTimeout(print, timeout);
}

printWithDelay(() => {
  console.log('async callback');
}, 2000);
// 인자로 전달된 콜백 함수가 2초후에 실행된다
```

---

- 콜백 함수를 이용해서 자바스크립트의 싱글 스레드(Single Thread) 단점을 극복할 수 있다는 장점이 있지만, 콜백 함수를 너무 중복되서 사용한다면, 예를 들어 콜백 함수안에서 다른 콜백 함수를 부르고 또 그 함수 안에서 또 다른 콜백 함수를 부르는 방식으로 사용한다면 **콜백 지옥**에 빠질 수 있습니다

- 만약 콜백 함수를 통해 `1`부터 `3`까지 아니라, `1`부터 `5`까지 순서대로 출력되도록 비 동기적인 방법으로 콟백 함수를 사용한다고 할 때, 다음과 같이 코드를 작성할 수 있습니다

```javascript
function printTwo(callback) {
  setTimeout(() => {
    console.log('2');
    callback(
      setTimeout(() => {
        printFour(
          setTimeout(() => {
            printFive();
          }, 3000)
        );
      }, 2000)
    );
  }, 1000);
}

function printThree(callback) {
  console.log('3');
}

function printFour(callback) {
  console.log('4');
}
function printFive() {
  console.log('5');
}

console.log('1');
printTwo(printThree);
```

- printThree함수의 콜백함수로는 printFour를 호출하는 setTimeout함수를 사용하고, printFour의 콜백함수로는 printFive를 호출하는 setTimeout 함수를 콜백 함수로 사용합니다

- 1초 후 printThree함수를 호출하고 2초 후에는 PrintFoure함수를, 3초후에는 printFive 함수를 호출합니다.

- 한눈에 봐도 코드가 매우 복잡하고 한눈에 파악하기가 힘듭니다

- 다음은 조금 더 복잡한 코드입니다.

- 아래 코드는 사용자로 부터 id와 password를 입력받은 다음, 해당 id와 password가 있는 경우 일치하는 사용자의 역할을 찾아서 출력해주는 코드입니다

```javascript
class UserStorage {
  loginUser(id, password, onSuccess, onError) {
    // 해당 id, pw 있으면 Onsuccess 함수, 없으면 onError 함수 호출, 2초 뒤에 실행된다
    setTimeout(() => {
      if (
        (id === 'correctUser' && password === 'correctPW') ||
        (id === 'correctUser2' && password === 'correctPW2')
      ) {
        onSuccess(id); // id값이 전달된다
      } else {
        onError(new Error('not found'));
      }
    }, 2000);
  }
  //사용자의 역할을 받아오는 함수, 1초뒤에 실행된다
  getRoles(user, onSuccess, onError) {
    setTimeout(() => {
      if (user === 'correctUser') {
        onSuccess({ name: 'correctUser', role: 'admin' });
      } else {
        onError(new Error('no access'));
      }
    }, 1000);
  }
}

const userStorage = new UserStorage();
const id = prompt('enter your id'); // correctUser 입력
const password = prompt('enter your password'); //correctPW 입력

//로그인으로  id, password 입력 받음
//id 조건에 해당하면 (user)=> 함수 실행

userStorage.loginUser(
  id,
  password,
  (user) => {
    //user 값이 correctUser로 if문  조건에 만족하면 onSuccess함수 실행

    //onSuccess함수는 일치하는 id 있으면 해당하는 role을 가져오는 함수
    userStorage.getRoles(
      user, // user값으로 correctUser 전달
      (userWithRole) => {
        // 위 getRoles 함수의 onSuccess 함수의 인자가 아래 출력된다
        alert(
          `Hello ${userWithRole.name}, you have a ${userWithRole.role} role`
        );
      },
      (error) => {
        console.log(error);
      }
    );
  },
  (error) => {
    console.log(error);
  }
);
```

- 코드를 보면 콜백 함수 안에 또 다른 콜백 함수가 호출되면서 코드 내용을 파악하기가 힘듭니다

- 두 예시를 코드를 통해서 콜백 함수를 중첩해서 사용하는 콜백 체인의 문제점을 확인할 수 있습니다

- 첫번째는 가독성입니다. 로그인 한 다음에 사용자의 데이터를 받아온다는 것을 한눈에 파악하기 어렵습니다.

- 두번째는 에러가 발생했을 때 알아차리기가 힘들다는 것입니다. 어디서 체인이 길어질수록 어디서 에러가 발생했는지 찾아 문제를 해결하는 것이 힘들고 이러한 코드는 유지보수를 하기도 힘듭니다

- 이러한 콜백 지옥의 해결할 수 있는 방법으로는 [프로미스(Promise)](https://ibtg.github.io/frontend/2020/06/27/javascript-promise/)와 [async & await](https://ibtg.github.io/frontend/2020/06/27/javascript-asyncawait/)가 있습니다.

---

## Reference

- [MDN Web Docs](https://developer.mozilla.org/en-US/docs/Glossary/Callback_function)
- [자바스크립트 13. 비동기의 꽃 JavaScript async 와 await 그리고 유용한 Promise APIs | 프론트엔드 개발자 입문편 (JavaScript ES6)
  ](https://www.youtube.com/watch?v=s1vpVCrT8f4&t=1076s)
- [자바스크립트 호출 스택(Call Stack) 이해하기](https://new93helloworld.tistory.com/358)
