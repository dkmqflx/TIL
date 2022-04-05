### React Suspense

- 아래 코드는 Suspese의 자식 컴포넌트로 있는 `OtherComponent` 컴포넌트의 비동기 작업이 끝날 때 까지 기다려야하는 상황이다

- 그리고 비동기 작업이 자식 컴포넌트에서 진행되는 동안 `Spinner` 컴포넌트가 렌더링 된다

- 이 때, Suspense가 자식 컴포넌트가 비동기 작업을 처리하고 있다고 리액트에 알려주면 리액트는 자식 컴포넌트를 보고 있다가 비동기 작업이 끝나면 그 때 다시 렌더링이 일어나서 `OtherComponent`를 렌더링하게 된다

```jsx
const OtherComponent = React.lazy(() => import('./OtherComponent'));

function MyComponent() {
  return (
    // Displays <Spinner> until OtherComponent loads
    <React.Suspense fallback={<Spinner />}>
      <div>
        <OtherComponent />
      </div>
    </React.Suspense>
  );
}
```

- 정리를 하면 Suspese 컴포넌트는 비동기 작업을 진행하는 컴포넌트를 자식 컴포넌트로 가진다

- 자식 컴포넌트가 비동기 작업을 진행하는 동안에 fallback으로 할당을 받은 컴포넌트를 렌더링을 하고, 비동기 작업을 진행하고 있는 자식 컴포넌트를 리액트에게 알려주는 역할을 한다

- 그러면 리액트는 그 컴포넌트를 보고 있다가 비동기 작업이 끝나면 다시 랜더링(re-rendering)을 해주고 기존의 렌더링 되고 있던 fallback으로 전달 받은 컴포넌트 대신 우리가 원래 렌더링하고 싶었던 자식 컴포넌트를 다시 랜더링 해준다

---

- 다음 코드의 첫번째 Suspense 컴포넌트는 비동기 작업을 수행하는 `ProfileDetails` 컴포넌트를 자식 컴포넌트로 가진다

- 그리고 리액트에게 비동기 작업이 끝나면 `ProfileDetails` 컴포넌트를 렌더링 해달라고 리액트에게 알려준다

```jsx
const resource = fetchProfileData();

function ProfilePage() {
  return (
    <Suspense fallback={<h1>Loading profile...</h1>}>
      <ProfileDetails />
      <Suspense fallback={<h1>Loading posts...</h1>}>
        <ProfileTimeline />
      </Suspense>
    </Suspense>
  );
}

// 서버로 부터 비동기 작업을 통해 받아온 데이터를 렌더링 해주는 컴포넌트
function ProfileDetails() {
  // Try to read user info, although it might not have loaded yet
  const user = resource.user.read();
  return <h1>{user.name}</h1>;
}

function ProfileTimeline() {
  // Try to read posts, although they might not have loaded yet
  const posts = resource.posts.read();
  return (
    <ul>
      {posts.map((post) => (
        <li key={post.id}>{post.text}</li>
      ))}
    </ul>
  );
}
```

---

### Approach 1: Fetch-on-Render (not using Suspense)

- 기존에는 아래처럼 컴포넌트가 mount 된 다음에 useEffect를 호출해주는 방식으로 처리했다

```jsx
// In a function component:
useEffect(() => {
  fetchSomething();
}, []);

// Or, in a class component:
componentDidMount() {
  fetchSomething();
}
```

```jsx
function ProfilePage() {
  const [user, setUser] = useState(null);

  useEffect(() => {
    fetchUser().then((u) => setUser(u));
    // 2. state가 수정되면 리렌더링이 일어난다
  }, []);

  // 1.  처음에 아래 컴포넌트가 렌더링 된다
  if (user === null) {
    return <p>Loading profile...</p>;
  }

  // 3. 더이상 user가 null이 아닐 때 아래 컴포넌트가 렌더링 된다
  return (
    <>
      <h1>{user.name}</h1>
      <ProfileTimeline />
    </>
  );
}

function ProfileTimeline() {
  const [posts, setPosts] = useState(null);

  useEffect(() => {
    fetchPosts().then((p) => setPosts(p));
  }, []);

  if (posts === null) {
    return <h2>Loading posts...</h2>;
  }
  return (
    <ul>
      {posts.map((post) => (
        <li key={post.id}>{post.text}</li>
      ))}
    </ul>
  );
}
```

- 위 코드에서는 다음고 같은 문제점이 있다.

- 유저 정보를 받아오는 동안 비동기 처리가 되고 있기 때문에 벙렬적으로 포스트에 대한 정보를 서버로 부터 받아올 수 있음에도 불구하고 코드의 구조적인 한계 때문에 `fetchUser()`로 유저정보를 다 받아온 다음에야 `fetchPosts()`가 실행되어서 포스트 정보를 받아올 수 있다

- 즉, Waterfall 방식, 계단식으로 앞의 데이터를 다 받은 다음에서야 비로소 그 다음 데이터를 받아오고, 또 그 자식의 데이터를 받아 오고 이러한 과정을 계속 진행하는 방식으로 앞의 과정이 끝나야 새로운 데이터를 받을 수 있게 되는 것이다.

- 위 코드는 비동기적인 코드를 가지고 있기 때문에 유저 정보와 포스트 정보를 동시에 받아올 수 있음에도 불구하고 순서대로 데이터를 받아오게 된다.

- 그렇기 때문에 유저는 유저 정보를 받아 올 때까지는 `<h1>Loading profile...</h1>` 코드를 보고 프로필을 계속 보고 있다가 그 다음에 포스트 정보를 받아올 때는 `<h2>Loading posts...</h2>`에 해당하는 코드를 계속 보게 된다.

- 두 정보를 동시에 받았으면 더 빨리 이 정보들을 볼 수 있을 것인데 이를 해결하기 위해서 다음과 같은 방법이 제시되었다 .

---

### Approach 2: Fetch-Then-Render (not using Suspense)

```jsx
function fetchProfileData() {
  return Promise.all([fetchUser(), fetchPosts()]).then(([user, posts]) => {
    return { user, posts };
  });
}
```

- `Promise.all`을 사용해서 서버로 부터 유저 정보와 포스트 정보를 동시에 요청한 다음, 두 데이터를 모두 받은 다음에 `then`이 실행된다

- 첫번째 방법이 각각 데이터를 불러오는 방법이었다면 `Promise.all`을 사용해서 데이터를 한꺼번에 불러오도록 수정하였다

```jsx
// Kick off fetching as early as possible
const promise = fetchProfileData();

function ProfilePage() {
  const [user, setUser] = useState(null);
  const [posts, setPosts] = useState(null);

  useEffect(() => {
    promise.then((data) => {
      // user와 posts에 사용할 수 있는 데이터를 동시에 받아왔다.
      setUser(data.user);
      setPosts(data.posts);
    });
  }, []);

  if (user === null) {
    return <p>Loading profile...</p>;
  }
  return (
    <>
      <h1>{user.name}</h1>
      <ProfileTimeline posts={posts} />
    </>
  );
}

// The child doesn't trigger fetching anymore
function ProfileTimeline({ posts }) {
  if (posts === null) {
    return <h2>Loading posts...</h2>;
  }
  return (
    <ul>
      {posts.map((post) => (
        <li key={post.id}>{post.text}</li>
      ))}
    </ul>
  );
}
```

- 하지만 `Promise.all`을 사용하게 되면 다음과 같은 문제점이 있다

- 만약 포스트 정보를 받아오는데 많은 시간이 걸린다면, 유저 정보를 다 받아오고 나서도 사용자는 유저 정보를 보지 못하는 문제가 있다.

- 그리고 리액트 18 이전에서는 Promsie 안에서의 `setState` 사용으로 인해 batch 업데이트가 되지 않는 문제가 생긴다

- setUser을 호출하면 렌더링이 일어나고, setPosts를 호출하고 또 다시 렌더링이 일어나서 총 세번의 렌더링이 일어나는 즉, setState 호출 때 마다 렌더링이 일어나는 문제가 생긴다

- 이러한 한계점을 극복하기 위한 방법이 바로 `Suspense` 이다

---

### Approach 3: Render-as-You-Fetch (using Suspense)

- 앞의 두 예시는 fetching 시작 후, fetching이 다 끝난 다음에 setState를 통해서 렌더링을 해주었다

- 하지만 Suspense를 사용하면 fetching을 하면서 rendering을 할 수 있다.

```jsx
// This is not a Promise. It's a special object from our Suspense integration.
const resource = fetchProfileData();

function ProfilePage() {
  return (
    <Suspense fallback={<h1>Loading profile...</h1>}>
      <ProfileDetails />
      <Suspense fallback={<h1>Loading posts...</h1>}>
        <ProfileTimeline />
      </Suspense>
    </Suspense>
  );
}

function ProfileDetails() {
  // Try to read user info, although it might not have loaded yet

  // 1. 유저 정보를 가지고 오고 있을 때 Suspense가 자식 컴포넌트인 ProfileDetails가 데이터를 가지고 오고 있다고, 즉 suspend 상태라는 것을 리액트에게 알려주고 suspend 상태인 컴포넌트를 모아놓는 곳에 등록해준다
  // 2. 그리고 다음 Suspense로 넘어간다
  const user = resource.user.read();
  return <h1>{user.name}</h1>;
}

function ProfileTimeline() {
  // Try to read posts, although they might not have loaded yet

  // 3. 두번째 Suspense는 ProfileTimeline를 자식 컴포넌트로 가지는데 이 컴포넌트도 비동기적으로 데이터를 가져오고 있다
  // 4. ProfileTimeline도 suspend 상태라는 것을 리액트에게 알려주고 suspend 상태인 컴포넌트를 모아놓는 곳에 등록해준다
  const posts = resource.posts.read();
  return (
    <ul>
      {posts.map((post) => (
        <li key={post.id}>{post.text}</li>
      ))}
    </ul>
  );
}

// 5. 리액트가 더 이상 렌더링할 것이 없으면, suspend 상태인 컴포넌트를 등록한 곳에서 가장 먼저 추가한 ProfileDetails의 부모인 컴포넌트인 Suspense 컴포넌트를 찾고,
// 거기에 등록된 fallback 함수를 호출해서 등록된 컴포넌트를 렌더링한다.
// 6. 그리고 비동기 작업이 작업이 끝나면 리액트는 ProfileDetails 컴포넌트를 리렌더링 해준다.
// 7. 리 렌더링 해주기 때문에 fallback에 등록된 컴포넌트 대신 ProfileDetails 컴포넌트가 렌더링 된다
// 8. 이 때 리액트는 suspend 상태로 등록된 컴포넌트를 보고 있다가 먼저 비동기 작업이 끝나는 컴포넌트를 렌더링해준다.
```

- 정리하자면 위 코드를 통해서 알 수 있는 것은 Suspense 컴포넌트의 사용으로 인해 `ProfileDetails` 컴포넌트와 `ProfileTimeline` 중 자식 컴포넌트의 비동기 작업이 먼저 끝나는 컴포넌트의 자식 컴포넌트를 해주는 방식으로 기존의 한계점을 극복할 수 있다.

- 추가적으로, 만약 아래처럼 하나의 Suspense 안에 두 컴포넌트가 있다면, 두 컴포넌트 모두 비동기 작업일 끝날 때 까지 fallback 함수에 등록된 코드가 렌더링 되고, 두 컴포넌트의 비동기 작업이 끝난 이후에 Suspense 안에 있는 두 컴포넌트가 렌더링 된다

```jsx
function ProfilePage() {
  return (
    <Suspense fallback={<h1>Loading profile...</h1>}>
      <ProfileDetails />
      <ProfileTimeline />
    </Suspense>
  );
}
```

- 그렇기 때문에 각각의 컴포넌트가 렌더링 되는 동안 다른 화면을 보여주고 싶다면 중간에 Suspense를 사용하면 되는 것이다.

---

## Reference

- [초간단 비동기 렌더링 React Suspense](https://www.youtube.com/watch?v=8q7OQSPLF4k&list=PLGk6-UFPJT2UyzY8ATFO7UWSzPVHwR8Bb&index=33)
- [Suspense for Data Fetching (Experimental)](https://17.reactjs.org/docs/concurrent-mode-suspense.html)
- [React 18을 준비하세요.](https://medium.com/naver-place-dev/react-18%EC%9D%84-%EC%A4%80%EB%B9%84%ED%95%98%EC%84%B8%EC%9A%94-8603c36ddb25)
- [React의 setState를 async 함수 안에서 사용하면 일어나는 일](https://dkmqflx.github.io/frontend/2021/04/28/react-async-setState/)
- [사용자 경험 개선 1편 - react suspense](https://tecoble.techcourse.co.kr/post/2021-07-11-suspense/)
- [React Suspense 이해하기](https://developer-alle.tistory.com/428)
