- 리액트에서 타이머를 구현할 때 setInterval을 사용하면 아래와 같은 문제점이 발생한다.

- setCount를 통해서 1초마다 count를 1씩 증가하도록 했기 때문에, 1초 후 Counter 컴포넌트가 렌더링된다.

- 따라서 이 때 1초마다 count 1을 증가 시키는 새로운 setInterval 카운터가 만들어지게 된다

- 즉, 렌더링되고 새로운 setInterval 카운터가 만들어지는 상황이 반복되는 문제가 생긴다.

```jsx
import { useState } from 'react';

function Counter() {
  const [count, setCount] = useState(0);

  setInterval(() => {
    setCount(count + 1);
  }, 1000);

  return <h1>{count}</h1>;
}
```

- 아래 코드를 실행시켜 보면 숫자가 오르락 내리락 하는 방식으로 출력이 된다.

- 이는 각각의 렌더링 때 마다 다른 setInterval 카운터가 있기 때문이다.

- 첫번째 렌더링에서 카운터의 count는 0에서 1로 증가한다

- 두번째 렌더링에서 카운터의 setCount에서 증가시키는 count값은 1에서 2로 증가한다

- 즉, 세번째, 네번째 렌더링할 때 마다 각각의 카운터는 클로저로 인해 다른 count 값을 갖기 때문에 숫자가 오르락 내리락 하는 것이다.

<br/>

- 이러한 문제는 아래와 같이 useEffect를 사용해서 해결할 수 있다

```jsx
function Counter() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    const id = setInterval(() => {
      setCount(count + 1);
    }, 1000);

    return () => clearInterval(id);
  });

  return <h1>{count}</h1>;
}
```

- useEffect에서 count 값이 증가하기 때문에 값이 증가할 때 마다 렌더링이 일어난다

- 이 때 생성한 카운터를 clearInterval을 사용해서 clear 해주기 때문에 이전의 카운터는 없어지게 되고

- 새로운 렌더링으로 인해 만들어진 새로운 카운터에서 count 값을 증가시켜주기 때문에 정상적으로 카운터가 작동하는 것이다

- 다만 위 코드는 계속해서 렌더링 될 때 마다 카운터를 만들고 없애준다는 단점있는데 아래처럼 useEffect의 dependency와 useState의 함수형 업데이트를 통해서 해결할 수 있다.

```jsx
import { useState, useEffect } from 'react';

function Counter() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    const id = setInterval(() => {
      setCount((count) => count + 1);
    }, 1000);

    return () => clearInterval(id);
  }, []);

  return <h1>{count}</h1>;
}
```

<br/>

- 위 코드에서는 state를 사용해서 카운터를 만들었지만 외부에서 Prop으로 전달되는 값을 사옹해서 카운터를 만들어야할 경우도 있다

- 즉 useEffect에 있는 setInterval에 전달되는 콜백함수가 매번 경신되어아 하는 문제가 있다.

- 이 때는 아래처럼 dan Dan Abramov의 useInterval 훅을 사용해서 해결할 수 있다.

```jsx
import { useState, useEffect, useRef } from 'react';

function Counter() {
  const [count, setCount] = useState(0);

  useInterval(() => {
    setCount(count + 1);
  }, 1000);

  return <h1>{count}</h1>;
}

export function useInterval(callback, delay) {
  const savedCallback = useRef();

  // Remember the latest callback.
  useEffect(() => {
    savedCallback.current = callback;
  }, [callback]);

  // Set up the interval.
  useEffect(() => {
    function tick() {
      savedCallback.current();
    }
    if (delay !== null) {
      let id = setInterval(tick, delay);
      return () => clearInterval(id);
    }
  }, [delay]);
}
```

- 위의 코드처럼 useInterval을 사용하는 경우에는 클로저를 신경쓸 필요가 없다.

- 실행되 때 마다 받은 콜백을 별도로 저장해 놓고, tick이라는 함수에서 클로저로 받은 콜백을 사용하기 때문이다.

- 즉 useRef로 저장한 콜백함수를 setInterval, clearInterval로 처리하기 때문에 렌더링 할 때 마다 카운터가 새롭게 만들어지지 않기 때문에 Counter 컴포넌트에서는 렌더링 할 때의 시점에 관련된 코드만 작성하면 된다

- 이렇게 코드를 작성하는 것이 선언적 프로그래밍 방법이다.

## Reference

- [코좀봐코 - React에서의 타이머 part 1 : setInterval 말고 이것!](https://www.youtube.com/watch?v=2tUdyY5uBSw&t=28)
- [코좀봐코 - React에서의 타이머 part 2 : useIntervalValue Hook 만들어서 카운트다운 쉽게 구현하기](https://www.youtube.com/watch?v=zBmTqF0GpN4)
- [React에서 카운트 다운 타이머 구현](https://class.codejong.kr/t/react/371)
- [Making setInterval Declarative with React Hooks](https://overreacted.io/making-setinterval-declarative-with-react-hooks/)
- [React 에서 useEffect의 return 호출 조건이 이해가 안됩니다!](https://jsdev.kr/t/react-useeffect-return/5676)
