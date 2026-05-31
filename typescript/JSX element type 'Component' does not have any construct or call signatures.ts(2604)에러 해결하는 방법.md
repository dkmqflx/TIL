- 함수에 컴포넌트를 전달하는 과정에서 아래와 같은 에러가 발생했다.

```tsx
// App.tsx

<Routes>
  <Route path='/project' element={Auth(<ProjectsPage />)}></Route>
</Routes>
```

```jsx
// Auth.tsx
const Auth = (Component: JSX.Element) => {
  return <Component></Component>;
};

export default Auth;
```

- `JSX element type 'Component' does not have any construct or call signatures.ts(2604)View Problem`
- 해당 에러가 발생한 이유는 에러 메세지에서 확인할 수 있듯이 함수의 인자로 리액트 컴포넌트를 만들 수 있는 constructor를 전달한 것이 아니라 이미 만들어진 instance를 전달했기 때문이다

- 따라서 이미 만들어진 인스턴스가 아니라 아래처럼 컴포넌트를 함수의 인자 전달해준다

```tsx
// App.tsx

<Routes>
  <Route path='/project' element={Auth(ProjectsPage)}></Route>
</Routes>
```

- 그리고 나면 아래와 같은 에러가 또한 발생하게 된다
- `Argument of type '() => JSX.Element' is not assignable to parameter of type 'Element'. Type '() => Element' is missing the following properties from type 'ReactElement<any, any>': type, props, keyts(2345)`
- 즉, JSX.Element를 반환하는 함수 타입을 Element가 타입인 함수에 argument로 전달할 수 없다는 에러이다
- 함수의 parameter type을 수정해줌으로써 위 에러 또한 해결해줄 수 있다

```jsx
// Auth.tsx
const Auth = (Component: () => JSX.Element) => {
  console.log('component', Component);
  return <Component></Component>;
};

export default Auth;
```

## Reference

- [What does the error "JSX element type '...' does not have any construct or call signatures" mean?](https://stackoverflow.com/questions/31815633/what-does-the-error-jsx-element-type-does-not-have-any-construct-or-call)
- [JSX element type 'Component' does not have any construct or call signatures.ts(2604) 에러 해결](https://crong-dev.tistory.com/48)
