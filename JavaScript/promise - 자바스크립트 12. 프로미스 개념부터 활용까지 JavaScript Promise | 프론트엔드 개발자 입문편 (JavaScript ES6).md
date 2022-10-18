### 프로미스(Promise)

- 프로미스는 비동기를 간편하게 처리할 수 있도록 자바스크립트에서 제공하는 객체입니다.

- 프로미스를 사용하면 요청한 작업이 끝난 이후, 정상적으로 요청한 작업을 수행한 경우에는 성공의 메시지와 처리된 결과 값을 전달 받을 수 있고 만약 수행중 예상치 못한 문제가 발생한 경우에는 에러 메시지를 전달 받을 수 있습니다

- 프로미스는 콜백 함수(Callback Function) 대신 유용하게 사용할 수 있다는 장점이 있습니다.

- 프로미스 이해할 때 state, 그리고 우리가 원하는 데이터를 제공하는 producer와 제공한 데이터를 소비하는 consumer애 대한 개념을 이해하는 것이 중요합니다

---

### States

- 프로미스는 다음 중 하나의 state를 가집니다

  - Pending : 작업 수행 중

  - Fulfilled : 작업이 성공적으로 끝남

  - Rejected : 요청하는 파일 찾을 수 없거나 네트워크에 문제가 발생한 경우

---

- 프로미스 생성자 함수는 비동기 작업을 수행할 콜백 함수를 인자로 전달 받고 콜백 함수는 `resolve`와 `reject` 함수를 인자로 전달받습니다

- `resolve` 는 기능을 정상적으로 수행해서 마지막으로 정상적인 데이터를 전달하는 함수이고 `reject` 는 기능을 수행하다가 중간에 문제가 생기면 호출하는 함수입니다

- 프로미스는 만들어 지는 순간 프로미스에 전달된 executor 콜백함수가 바로 실행됩니다

- 따라서 만약 사용자가 요구하는 경우에만 네트워크 연결을 하는 기능을 구현하고 싶은 경우 프로미스의 콜백 함수에 해당 기능을 구현한다면 불필요한 네트워크 요청이 일어날 수 있습니다

- 아래 코드는 프로미스를 만들고 반환하는 함수를 구현한 것입니다

- 해당 함수를 실행하고 콘솔창에서 확인하게 되면 프로미스의 `state`가 `pending`인 것을 확인할 수 있습니다.

```javascript
function User() {
  return new Promise((resolve, reject) => {});
}
const user = User();
console.log(user);
```

- 프로미스를 만들고 `resolve`나 `reject` 호출하지 않으면 프로미스가 `pending` 상태가 되기 때문에 `resolve`나 `reject`를 통해서 작업을 완료해주어야 합니다

```javascript
function User() {
  return new Promise((resolve, reject) => {
    resolve(); // fulfilled
  });
}
const user = User();
console.log(user);
```

- 아래는 2초 후 작업이 성공하면 success, 실패하면 error 메시지를 보여주는 코드 입니다.

```javascript
// Producer
const promise = new Promise((resolve, reject) => {
  console.log('doing someting');

  setTimeout(() => {
    resolve('success !');
    // 성공적으로 받아온 데이터를 resolve라는 콜백함수에 전달한다
    // resolve를 실행하면 Fulfilled 상태가 된다

    reject(new Error('error !'));
    // 에러 발생 오브젝트 생성
  }, 2000);
});
```

---

### then, catch, finally

- 프로미스 작업을 수행한 다음, 프로미스 상태의 결과값을 `then, catch, finally`을 통해 받을 수 있습니다

- `then`은 프로미스가 성공적으로 수행한 다음 `resolve`의 함수에 인자로 전달된 값을 인자로 전달받습니다

- 따라서 아래 코드의 `value`로 `'success !'`가 전달되고 `doing somthing`이 출력되고 2초후 `success !`가 출력됩니다

```javascript
// Producer
const promise = new Promise((resolve, reject) => {
  console.log('doing someting');

  setTimeout(() => {
    resolve('success !');
    // 성공적으로 받아온 데이터를 resolve라는 콜백함수에 전달한다

    reject(new Error('error !'));
    // 에러 발생 오브젝트 생성
  }, 2000);
});

// Consumer
promise
  .then((value) => {
    console.log(value);
    // Producer 코드에서 resolve의 인자로 전달된 값이 value가 된다
  })
  .catch((error) => {
    console.log(error);
  });
```

- 하지만 아래 코드처럼 에러가 발생한 경우, reject 함수에 전달된 에러 오브젝트가 catch의 인자로 전달되기 때문에 `Uncaught (in promise) Error: error !`가 콘솔 창에 출력됩니다.

```javascript
// Producer
const promise = new Promise((resolve, reject) => {
  console.log('doing someting');

  setTimeout(() => {
    // 에러 발생 오브젝트 생성, 에러 발생한 경우
    reject(new Error('error !'));
  }, 2000);
});

// Consumer
promise.then((value) => {
  console.log(value);
});
```

- `catch` 부분을 작성하게 되면 해당 에러가 발생하지 않게 되고, 아래 코드 처럼 `'error !'` 값이 전달되어 콘솔창에 출력됩니다

```javascript
// Producer
const promise = new Promise((resolve, reject) => {
  console.log('doing someting');

  setTimeout(() => {
    // 에러 발생 오브젝트 생성, 에러 발생한 경우
    reject(new Error('error !'));
  }, 2000);
});

// Consumer
promise
  .then((value) => {
    console.log(value);
  })
  .catch((error) => {
    console.log(error);
  });
```

- 마지막 `finally`는 프로미스의 성공, 실패 여부에 상관 없이 실행됩니다

```javascript
// Producer
const promise = new Promise((resolve, reject) => {
  console.log('doing someting');

  setTimeout(() => {
    reject(new Error('error !'));
    // 에러 발생 오브젝트 생성
  }, 2000);
});

// Consumer
promise
  .then((value) => {
    console.log(value);
    // Producer 코드에서 resolve의 인자로 전달된 값이 value가 된다
  })
  .catch((error) => {
    console.log(error);
  })
  .finally(() => {
    // 성공 실패 상관없이 호출된다
    console.log('finally');
  });
```

- 이 때, `then`이 실행되는 부분에서 프로미스를 리턴할 수도 있는데 만약 `then`에서 리턴환 프로미스가 에러가 발생하게 되면 `catch` 를 써서 에러를 잡을 수 있습니다

```javascript
// Producer
const promise = new Promise((resolve, reject) => {
  console.log('doing someting');

  setTimeout(() => {
    resolve('success!');
    // reject(new Error('error !'));
    // 에러 발생 오브젝트 생성
  }, 2000);
});

// Consumer
promise
  .then((value) => {
    console.log(value); // success ! 출력
    return new Promise((resolve, reject) => {
      reject(new Error('new error !'));
    });
  })
  .catch((error) => {
    console.log(error); // new error! 출력
  });
```

---

### Promise Chaining

- 아래 코드 처럼 `then`을 여러개 묶어서 비동기 요소들을 처리할 수 있습니다.

- 첫번째 `then`의 결과 값 `4`가 두번째 `then`으로 전달되고, 두번째 `then`의 결과 값 `6`이 세번째 `then`으로 전달됩니다

- 그리고 세번째 `then`에서는 새로운 프로미스가 만들어지고, 성공적으로 작업이 끝나고 나면 `num - 1` 의 결과 값 5를 마지막 `then`으로 전달하므로 최종적으로 `5`가 출력됩니다

- 세번째 then에서처럼, then은 값을 바로 전달하는 것 뿐 아니라 프로미스를 전달할 수도 있다

```javascript
const fetchNumber = new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve(1);
  }, 1000);
});

fetchNumber
  .then((num) => num * 2)
  .then((num) => num * 3)
  .then((num) => {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        resolve(num - 1);
      }, 1000);
    });
  })
  .then((num) => console.log(num)); //num -1의 결과가 num으로 전달된다
```

- 아래 코드는 `then`을 사용해서 함수를 차례대로 실행시키는 코드입니다

- 우선, `First` 함수를 실행하면 첫번째 프로미스가 생성됩니다

- `First`함수의 프로미스가 성공적으로 처리되면 두번째 함수 `Second`가 실행 되고, 이때 두번째 함수의 인자로 `'first'`가 전달 됩니다

- 두번째 함수가 실행되면 새로운 프로미스가 생성되는데, 성공적으로 처리가 되면 `'first to second'` 가 세번째 함수의 인자로 전달됩니다

- 만약 두번째 프로미스에서 에러가 발생하더라도 `catch`에서 return 값으로 `'substitue'`를 반환함으로써 에러가 발생했을 때 바로 처리할 수 있습니다

- 세번째 함수가 실행되면 새로운 프로미스가 생성되고, 성공적으로 처리되면 `'first to second to third'`가 마지막 `then`로 전달되고, 최종적으로 `'first to second to third'`가 출력됩니다

```javascript
const first = () =>
  new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve('first');
    }, 1000);
  });

const second = (firstNum) =>
  new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve(`${firstNum} to second`);
      reject(new Error(`error ! ${firstNum} to second`));
    }, 1000);
  });

const third = (secondNum) =>
  new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve(`${secondNum} to third`);
    }, 1000);
  });

First()
  .then((firstNum) => Second(firstNum))
  .catch((error) => {
    return 'substitue';
  })
  .then((secondNum) => Third(secondNum))
  .then((fourthNum) => console.log(fourthNum)) // 최종적으로 만들어진 문자열이 출력된다
  .catch(console.log);
```

- 코드의 then 의 인자로 함수 이름만 적어도 then에서 받아오는 인자를 바로 함수로 전달할 수 있습니다

```javascript
First()
  .then(Second)
  .catch((error) => {
    return 'substitue';
  })
  .then(Third)
  .then(console.log);
  .catch(console.log);
```

- 이전 [콜백 함수를 정리한 글](https://ibtg.github.io/frontend/2020/06/15/javascript-callback/)의 콜백 지옥 예제를 프로미스를 사용하면 훨씬 더 간단하게 구현할 수 있습니다

```javascript
class UserStorage {
  //더 이상 콜백을 전달받지 않아도 된다
  loginUser(id, password) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        if (
          (id === 'correctUser' && password === 'correctPW') ||
          (id === 'correctUser2' && password === 'correctPW2')
        ) {
          resolve(id); // 로그인 성공
        } else {
          reject(new Error('not found'));
        }
      }, 2000);
    });
  }

  getRoles(user) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        if (user === 'correctUser') {
          resolve({ name: 'correctUser', role: 'admin' });
        } else {
          reject(new Error('no access'));
        }
      }, 1000);
    });
  }
}

const userStorage = new UserStorage();
const id = prompt('enter your id'); // correctUser 입력
const password = prompt('enter your password'); //correctPW 입력

userStorage
  .loginUser(id, password)
  .then((user) => userStorage.getRoles(user)) //로그인 성공하면 유저의 역할 호출
  .then((user) => alert(`Hello ${user.name}, you have a ${user.role} role`)) // 성공적으로 유저 받아오면 alert창 나타난다
  .catch(console.log);

//이렇게 콜백 지옥 코드가 간단해진다
```

---

## Reference

- [MDN web docs - promise](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Promise)
- [https://joshua1988.github.io/web-development/javascript/promise-for-beginners/](https://joshua1988.github.io/web-development/javascript/promise-for-beginners/)
- [자바스크립트 12. 프로미스 개념부터 활용까지 JavaScript Promise | 프론트엔드 개발자 입문편 (JavaScript ES6)](https://www.youtube.com/watch?v=JB_yU6Oe2eE&t=1227s)
