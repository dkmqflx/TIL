### Switch 대신 Routes 사용

- Routes는 기존 Switch 처럼 경로를 순서를 기준으로 선택하는 것이 아닌, 가장 일치하는 라우트를 기반으로 선택하게 된다.

```jsx
// v5
<Switch>
  <Route path="/" element={<LoginPage />} />
</Switch>
```

```jsx
// v6
<Routes>
  <Route path="/" element={<LoginPage />} />
</Routes>
```

### useHistory 대신 useNavigate 사용

- useNavigate로 useHistory의 기능을 사용할 수 있다
- useHistory의 history는 객체였지만 useNavigate의 navigate는 함수라는 차이가 있다.

```jsx
// v5
const history = useHistory();

history.push('/');
history.goback();
history.go(-2);
history.push(`/user/${user.id}`);
```

```jsx
// v6
const navigate = useNavigate();

navigate('/');
navigate(-1);
navigate(-2);
navigate(`/user/${user.id}`);
```

### exact 옵션이 더 이상 필요하지 않다.

- 기존에는 `Route`의 `path`의 url이 부분적으로 일치하는 모든 `Route`가 매칭되었기 때문에 `exact` 옵션을 사용해서 정확히 url이 같은 `Route`만 매칭 되도록 했다
- v6부터는 기본적으로 `exact` 옵션이 적용되어있기 때문에 더 이상 `exact` 옵션을 사용할 필요가 없다

```jsx
// v5

// 주소가 / 인 경우, exact를 쓰지 않으면  두 컴포넌트가 모두 렌더링 되기 때문에
// path가 / 일 때 UserPage만 렌더링 되도록 exact 옵션을 사용해주었다

<Route path="/login" exact component={LoginPage} />
<Route path="/" exact component={UsersPage} />

```

```jsx
// v6

// exact 없어도 각각의 컴포넌트가 렌더링 된다
<Route path="/login" element={<LoginPage />} />
<Route path="/" element={<UsersPage />} />

```

### 서브 경로가 필요한 경우 `*`을 사용한다

- v6에는 기본적으로 `exact` 옵션이 적용되어 있기 때문에 만약 하위경로에 여러 라우팅을 매칭시키고 싶다면 다음과 같이 URL 뒤에 아무 텍스트나 매칭하는 `*` 와일드 카드를 사용하여 일치시킬 수 있다.

```jsx
// v5
<Route path="/users/:username" component={User}></Route>
```

```jsx
// v6

// url이 /users/1/id, /users/2/info 인 경우 모두 라우트에 매칭된다.
<Route path="/users/:username/*" element={<User />}></Route>
```

- 따라서 v6에서는 PageNotFound 페이지를 다음과 같이 구현할 수 있다

- 상단에 위치하는 라우트들의 규칙을 모두 확인하고, 일치하는 라우트가 없다면 가장 아래 위치한 NotFound 라우트가 매칭된다.

```jsx
<Routes>
  <Route path="/" element={<Layout />}>
    <Route index element={<Home />} />
    <Route path="/about" element={<About />} />
    <Route path="/profiles/:username" element={<Profile />} />
  </Route>
  <Route path="/articles" element={<Articles />}>
    <Route path=":id" element={<Article />} />
  </Route>
  <Route path="*" element={<NotFound />} />
</Routes>
```

### `Outlet`을 사용해서 중첩된 라우트를 구현할 수 있다.

```jsx
// v5

// App.js
<Route path="/users/:username" component={UsersPage} />

// UserPage.js

// UsersPage 파일 안에 중첩된 라우트를 구현해준다
<Route path="/users/:username" component={UserMain} />
<Route path="/users/:username/about" component={About} />
```

```jsx
// v6

// App.js

// 아래처럼 Route의 children으로 중첩된 라우트를 구현할 수 있다.
<Route path="/users/:username/*" element={<UsersPage />}>
  <Route path="" element={<UserMain />} />
  <Route path="about" element={<About />} />
</Route>

// UserPage.js

// Outlet 부분에
// /users/:username 인 경우에는, userMain 컴포넌트 화면
// /users/about 인 경우에는, About 컴포넌트 화면이 보여진다.

<Outlet />
```

### Route에서 컴포넌트 렌더링 하는 방식의 변화

- 기존에는 children이나 component 또는 render 함수를 사용했지만 v6 부터는 대신에 element 사용해서 Route의 컴포넌트를 렌더링한다.

```jsx
// v5

//children
<Route path="/login" exact>
    <HomePage />
</Route>

// component
<Route path="/" exact component={HomePage} />

// render function
<Route
  path='user'
  render={(info) => (
    <HomePage info={info}  />
  )}
/>

```

```jsx
// v6
<Route path="/" element={<HomePage />} />
```

### Route는 Routes의 바로 아래 있는 자식이어야 한다

- 가존에는 Route가 꼭 Switch 안에 없어도 되었지만, v6 부터는 Routs 바로 아래 위치해야 한다

```jsx
// v5
  <Route path="/" element={<HomePage />} />
  <Route path="/login" element={<LoginPage />} />

```

```jsx
// v6
<Routes>
  <Route path="/" element={<HomePage />} />
  <Route path="/login" element={<LoginPage />} />
</Routes>
```

### Optional url 파라미터대신 필요한 Route를 만들어주어야 한다.

```jsx
// v5
<Route path="/optional/:value?" component={Optional} />
```

```jsx
// v6
<Route path="/optional/:value" element={<Optional />} />
<Route path="/optional" element={<Optional />} />
```

---

## Reference

- [React Router v5 → v6 빠르게 훑어보기](https://www.youtube.com/watch?v=CHHXeHVK-8U&list=PLGk6-UFPJT2UyzY8ATFO7UWSzPVHwR8Bb&index=6)
- [react-router v6에서는 어떤것들이 변했을까??](https://blog.woolta.com/categories/1/posts/211)
- [React Router v6 튜토리얼](https://velog.io/@velopert/react-router-v6-tutorial)
- [React Router 공식 문서](https://reactrouter.com/docs/en/v6/getting-started/overview)
