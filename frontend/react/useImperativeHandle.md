## useImperativeHandle

- 부모 컴포넌트에서 자식 컴포넌트로 forwardRef를 통해 ref를 전달했을 때, useImperativeHandle hook을 사용하면 전달받은 ref를 자식 컴포넌트에서 customize 할 수 있다.

- 아래 코드를 보면 MyInput 컴포넌트는 forwardRef를 통해 부모 컴포넌트 Form 으로 부터 ref를 전달 받는다

- 그리고 전달받은 ref를 useImperativeHandle hook의 첫번째 인자로 전달하고, 두번째 인자로 focus 라는 함수를 return 하고 있다

- 그 결과 부모 컴포넌트의 button을 클릭 할 때 마다 focus가 되는 것을 확인할 수 잇다.

```js


import { forwardRef, useRef, useImperativeHandle } from 'react';

export default function Form() {
  const ref = useRef(null);

  function handleClick() {
    ref.current.focus();
    // This won't work because the DOM node isn't exposed:
    // ref.current.style.opacity = 0.5;
  }
  console.log("render App");

  return (
    <form>
      <MyInput placeholder="Enter your name" ref={ref} />
      <button type="button" onClick={handleClick}>
        Edit
      </button>
    </form>
  );
}

const MyInput = forwardRef(function MyInput(props, ref) {
  const inputRef = useRef(null);

  useImperativeHandle(ref, () => {
    return {
      focus() {
        inputRef.current.focus();
      },
    };
  }, []);

  console.log('render MyInput')
  return <input {...props} ref={inputRef} />;
});

export default MyInput;


// render App
// render MyInput
```

- 그리고 useRef의 current에 함수를 등록해주었기 때문에, button을 클릭해서 함수를 실행시키더라도 다시 렌더링 되지 않는 장점이 있다.

- 만약 useState 또는 Context API를 사용해서 state로 관리를 했다면 state 변경으로 인한 렌더링일 발생하게 되었을 것이다

<br/>

- 다만 리액트 공식문서에서는 refs를 과도하게 사용하지 말고 props로 표현할 수 없는 경우에만 사용라고 말하고 있다.

<blockquote>

Do not overuse refs. You should only use refs for imperative behaviors that you can’t express as props: for example, scrolling to a node, focusing a node, triggering an animation, selecting text, and so on.

If you can express something as a prop, you should not use a ref. For example, instead of exposing an imperative handle like { open, close } from a Modal component, it is better to take isOpen as a prop like `<Modal isOpen={isOpen} />`. Effects can help you expose imperative behaviors via props.

</blockquote>

---

## Reference

- [useImperativeHandle](https://react.dev/reference/react/useImperativeHandle)
