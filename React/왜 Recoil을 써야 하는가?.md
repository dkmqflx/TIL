## 동기와 철학

### ‘상태 관리'에 대한 정의

- 상태? 애플리케이션의 동작 방식을 설명하는 모든 데이터
- XState 라이브 러리의 제작자 David Khourshid
  - 상태 관리는 시간이 지남에 따라 상태가 변경되는 방식이다
- 상태 ‘관리'가 되려면 아래 기능들을 할 수 있어야 한다
  - 최초 값 (initial value)를 저장
  - 현재 값 (current value)를 읽기
  - 값을 업데이트

### Recoil은 왜 필요한 걸까 ?

- React의 내장 상태 관리 ‘기능'의 한계점 극복
- 그 중에 최대한 React스러운 API 유지
- 사용하기 위한 부속 라이브러리 최소화

### React 상태 관리 로직의 한계점

- 컴포넌트의 상태는 공통되는 부모 컴포넌트까지 올라가야 하는데, 심할 경우 에플리케이션 상단까지 올라가야하는 문제가 발생할 수 있음
- Context API는 확정되지 않은 수의 갑을 저장하는데 적합하지 않으며, 최적화 관점에서의 한계점이 명확함

  - 심지어 Context API는 State관리라기 보다는 개념상 의존성 주입(depencency injection에 가깝다고 볼 수 있다
  - (Provider란 파이프 시작점에서 Consumer란 파이프 끝으로 이어지는)

- Context API 는 상태 관리라고 할 수 없다
  - 위의 상태 ‘관리'가 되기 위한 세가지 기능을 다 할 수 없기 때문이다
  - 상태가 관리가 되려면 최초 값을 저장하고, 현재 값을 읽고 그냥 값을 업데이트할 수 있어야 되는데 기본적으로 Context API 그 세 가지를 다 할 수가 없는 라이브러리
  - 컨텍스트 API는 별도의 useState나 useReducer 같은 리액트에서 제공한 로컬 상태 관리를 가져다가 어떤 컴퍼넌트 굉장히 높은 곳에 위치시켜 높고
  - 그것을 하단 부위에 있는 컴퍼넌트의 주입을 시키는 일종의 Dependency Injection의 개념으로 사용되는 것 뿐이지 적합한 상태 관리 툴이 라고 볼 수 없다 라고 하는게 주류의견
- 그리고 기존의 이제 리액트 에서 별도의 상태관리 로직을 사용하지 않고 내부에서 사용되는 것만 사용할 때는 공통 공통되는 부모 컴포넌트 까지 전부 다 상태를 올려 놓은 다음에 그걸 이제 props 형태로 내어주어야 한다
- 이러한 props drilling이 발생하는 경우 어플리케이션이 굉장히 코드 지저분해질 수도 있고 또 트래킹이 어려워질 수도 있다는 한계 점이 있다

### Recoil의 접근 방법

- Recoil은 React Tree에 직교되는 형태로 존재하는 방향 그래프(Directed Graph)로 구성되어 있다
- 상태의 변경은 이 그래프를 따라 리액트 컴포넌트로 흘러들어간다
- 다양한 장점들이 있지만 가장 큰 장점으로 컴포넌트 쪽의 로직을 건드리지 않고 상태 데이터를 단독으로 변경할 수 있다는 큰 장점이 있다
- 기존의 이제 그 그 리덕스로 따지면 외부 스토어가 있고 리액트가 있고 그 중간에 이제 연결을 해주는 리액트 리덕스 라는 별도의 라이브러리 깔았고 있었는데,
- 리코일 같은 경우는 그런 어떤 중간에 이제 그걸 다리를 놔주는 라이브러리가 없어도 리코일 자체적으로 자체 상태 관리도 되고
- 그냥 리액트에 컴퍼넌트 데이터를 전달해 줄 수도 있다

### Recoil의 철학

- 보일러 플레이트가 적은 API면서 React의 로컬 상태(useState, useReducer) 유사한 간단한 인터페이스
- Concurrent Mode와 호환
- 코드 상호간의 낮은 결합도를 통해 Code splitting 용이성 확보
- 파생데이터를 사용함으로써 데이터를 사용하는 컴포넌트에서 임 의로 데이터를 바꾸는 로직을 가져가지 않아도 된다
  - 가져와서 useEffect로 바꿔주기를 하지 않고, 로직 자체를 Recoil atom에 귀속시킬 수 있다

---

## Core Concept

- Flexible shared state: 유연하게 상태 관리 가능
- Derived data and quries: 파생 데이터 생성이 용이
- App-wide stat observation : 애플리케이션 단의 상태 Observing 가능
  - 애플리케이션단의 상태 Observing 이란 전반적인 상태 관리 툴에서 요구되는 어떠한 상태의 시계열에 따른 상태의 변화 라든지 그런 기록들을
  - 리코일 자체에서 Observing을 하고 있다가 바뀌는 걸 갖다가 다른 곳, 예를들어 디버거 틀에 다가 전달해 준다던가 하는 기능들이 굉장히 용이하게 제공이 된다.

### Flexbile shared state

- 공통적으로 필요한 데이터를 어떻게 저장할 것인가 ?
- 컨텍스트 API를 사용하면 Dynamic하게 구성할 수 없다 + Coupling 발생
  - Provider가 추가될 때 마다 Tree는 다시 reconciling을 해줘야 하는 이슈 등
    - 어떤 데이터가 동적으로 만약에 생성되었을 때 이것을 변화를 주기 어렵다
    - 변화를 줄 수 있지만 변화를 주기도 어렵고 변화를 주게 되면 전체 트리가 다시 또 이제 reconcilation이 발생하면서 렌더링 효율이 굉장히 떨어질 수 있다는 문제 도 있고
    - 또 Provider와 Consumer가 상단과 하단에, 즉 루트 랑 리프에 존재하기 때문에 커플링 현상이 발생해서 렌더링 최적화에 굉장히 크리티컬 하게 문제를 가져올 수도 있다
    - 그렇기 때문에 보통 이제 컨텍스트 api 를 사용할 때는 추천되는 경우는 테마나 locale 같은 이렇게 같은 한번 바꾸면 오랫동안 바뀌지 않은 항목들에 대해서 보통 추천 하는 편
- React의 로컬 컴포넌트 상태와 동일하게 batching과 같은 작업들이 모두 라이브러리 내부에서 처리된다

### Derived data

- 상태와 관련 있거나, 상태로부터 만들어진 것들 (Things that are computed from state, or related to state)
- 상호 의존적인 state를 만들 필요가 없다 (두개 이상의 atom을 참고한 또 하나의 atom이라던지)
- Pure function으로 atom 데이터를 사용할 수 있게 해준다
  - 정말 데이터에 변화가 있을 때만 recompute 하도록 해준다

### Core Concept

- Atom
  - 데이터를 보관하는 기본 단위
  - 리덕스로 따지자면 리듀서와 같이 전체 스토어의 일부분을 차지하지만 훨씬 적은 보일러 플리에티를 차지하고 작은 단위로 관리될 수 있다
- Selector
  - atom, 다른 selector들을 조합할 수 있음
  - 파생되는 상태(derived state)를 생성한다
  - dependency에 해당 하는 atom이 업데이트 되면 같이 업데이트 되기 때문에 관리의 부담이 없음

---

## 활용

### Atom

- 데이터를 가지고 있는 가장 작은 단위
- 리덕스의 리듀서와 유사하지만, 의미 단위로 최대한 쪼개서 사용하는 것이 용이하다

### Selector

- 상태에 많은 데이터를 ‘저장'하고 있을 수록 에러가 발생할 확률이 더욱 더 높아짐
- selector는 atom과 달리 별도의 데이터를 저장하는 것이 아니라, 파생된 데이터

### React에서 사용하는 API

- useRecoilValue: 기존에 사용하던 리액트의 로컬 상태 API와 동일한 형태로 사용 가능
- atom, selector모두 동일한 API를 사용하기에 변경이 필요할 때 언제든 컴포넌트 수정을 최소화하고 리코일 state를 변경할 수 있따

### useRecoilCallback

- 리액트의 useCallback과 유사하며, 다만 Recoil State를 사용할 수 있는 API를 제공
- atom이나 selector가 업데이트 될 때, 리액트 컴포넌트를 리렌더링하고, 비 동기적으로 recoil state를 읽는다
- render-time에 하고 싶지 않은 시간이 오래 걸리는 비동기 액션 수행
- Recoil state를 read 하거나 write하는 side-effect 수행
- Render-time에는 어떤 어떤 atom 혹은 selector가 업데이트하고 싶은지 알 수 없을 때
  - 이 경우에는 useSetRecoilState를 사용할 수 없기 때문

### Snapshot을 이용하여 re-rendering 없이 atom 읽기

- useRecoilCallback은 atom, selector state에 대한 snapshot을 가지고 있기 대문에 아래의 예제처럼 특정 상태 값을 사용하고 싶지만, deps에는 반영하고 싶지 않을 때 유용하게 사용할 수 있다
- 대표적으로 Logger와 같은 케이스에서 유용하게 사용할 수 있다.

```jsx
import { atom, useRecoilCallback } from 'recoil';

const itemsInCart = atom({
  key: 'itemsInCart',
  default: 0,
});

function CartInfoDebug() {
  const logCartItems = useRecoilCallback(({ snapshot }) => async () => {
    const numItemsInCart = await snapshot.getPromise(itemsInCart);
    console.log('Items in cart: ', numItemsInCart);
  });

  return (
    <div>
      <button onClick={logCartItems}>Log Cart Items</button>
    </div>
  );
}
```

---

## 왜 Recoil이 괜찮은 선택일까 ?

### 낮은 진입장벽, 간단한 API

- 리덕스를 시작할 때 처럼, Action, Store, Reducer와 같은 개념들을 모두 익힐 필요가 없다
- React API와 굉장히 유사하며 대체하기도 굉장히 용이하다
- 비동기 데이터처리가 용이하다
- atomFamily, selectorFamily를 이용하여 국소적으로 사용하느 상태를 생설할 수 있다
- atomEffetcts를 이용하여 변화나는 값을 atom 자체적으로 tracking할 수 있다

### 비동기 데이터 쿼리 다루기

- Recoil은 data-flow graph 형태로 React Component에 state와 파생 state를 모두 전달한다
- 여기서 전달되는 이 Function 형태의 graph들은 모두 비동기도 된다
  - 가장 큰 강점은, async, sync 함수끼리 섞을 수 있다는 점이다
- 변경 가능한 데이터에는 Query Refresh 등과 같은 방법이 있다
- 아래와 같은 예제를 살펴보면, currentUserNameQuery는 currentuserIdState가 업데이트 될 때 다시 revalidate 된다
  ```jsx
  const currentUserNameQuery = selector({
    key: 'CurrentUserName',
    get: async ({ get }) => {
      const response = await myDBQuery({
        userID: get(currentUserIDState),
      });
      return response.name;
    },
  });

  function CurrentUserInfo() {
    const userName = useRecoilValue(currentUserNameQuery);
    return <div>{userName}</div>;
  }
  ```

### Query Refresh 전략 예제

- RequestId를 dependent하는 atom 혹은 atomFamily에 추가해주어 해당 atom 값의 변화에 대응하도록 한다
- 아래 예제는 이제 userInfoQueryRequestIdState atom이 업데이트 되면 자연스럽게 해당 selector도 업데이트 된다
  ```jsx
  const userInfoQuery = selectorFamily({
    key: 'UserInfoQuery',
    get:
      (userID) =>
      async ({ get }) => {
        get(userInfoQueryRequestIDState(userID)); // Add request ID as a dependency
        const response = await myDBQuery({ userID });
        if (response.error) {
          throw response.error;
        }
        return response;
      },
  });
  ```

### atomFamily

- writable한 RecoilState atom을 반환하는 함수를 반환한다
- atom들의 모음집(Collection of atoms)로 저장한다
- 기본적으로 Recoil 내부적으로 caching과 같은 최적화를 진행해준다
- 일반적으로 atom은 RecoilRoot 단위로 등록이 되지만, 여기서 atomFaily는 사용처가 약간 다르다
  - 예를들어 UI Prototyping 툴을 만들 때, 각각의 UI element에 대해 position이나 width, height와 같은 값들을 가지고 있다고 가정할 때, 이런걸 리스트로 보관하면서 memoizing해도 되지만, atomFamily를 사용하면 Recoil에서 이런 부분들을 처리해준다

---

## Reference

- **[왜 Recoil을 써야 하는가?](https://www.youtube.com/watch?v=H10KNVxF6_s&list=PLGk6-UFPJT2XnhxgIuaC3423-loarOaZa&index=21&t=2440s)**
