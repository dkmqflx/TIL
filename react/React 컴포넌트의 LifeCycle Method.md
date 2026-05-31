- 모든 리액트 컴포넌트에는 LifeCycle(생명주기)가 존재한다

- 컴포넌트의 수명은 페이지에 렌더링 되기 전인 준비과정에서 시작되어서 페이지에 사라질 때 끝이난다

- 컴포넌트를 처음 렌더링 할 때나 업데이트 하기 전 후, 또는 불필요한 업데이트를 방지해야할 경우가 있는데 이 때 사용하는 것이 LifeCycle methods이다

## Mount

- DOM이 생성되고 웹 브랑줘상에 나타나는 것을 마운트(Mount)라고 한다

- 이 때 다음과 같은 순서로 메서드가 호출된다

```bash
컴포넌트 만들기

-> constructor

-> getDerivedStateFromProps

-> render

-> componentDidMount
```

- 각 메서드는 다음과 같은 역할을 한다

- constructor

  - 컴포넌트의 생성자 메서드로 컴포넌트를 만들 때 처음으로 실행되는 생성자 메서드

  - 초기 state 값을 정할 수 있다

* getDerivedStateFromProps

  - props에 있는 값을 state에 넣을 때 사용하는 메서드

  ```jsx

  static getDerivedStateFromProps(nextProps, prevState){
    if(nextProps.value !== prevState.value){
      //조건에 따라 특정 값 동기화
      return {value:nextProps.value}
    }
    return null //state를 변경할 필요가 없다면 null 반환
  }

  ```

* render

  - 준비한 UI를 렌더링하는 메서드

  - 이 메서드 안에서 this.props와 this.state에 접근할 수 있으며, 태그나 컴포넌트와 같은 리액트 요소를 반환한다

  - 이 메서드 안에서 이벤트 설정이 아닌 곳에서 setState를 사용하면 안된다

  - 또한 브라우저의 DOM에 접근해서도 안된다

  - DOM 정보를 가져오거나 state에 변화를 줄 때는 componentDIdMount에서 해야한다

- componentDidMount

  - 컴포넌트가 웹 브라우저에 나타난 후 호출하는 메서드

  - 컴포넌트를 만들고 첫 렌더링을 마친 후 실행한다

  - 자바스크립트 라이브러리 또는 프레임 워크 함수를 호출하거나 이벤트 등록, setTimeout, setInterval , 네트워크 요청 같은 비동기 작업을 처리한다

## Update

- 컴포넌트는 다음과 같은 상황에서 업데이트 된다

1. props가 바뀌는 경우. 부모 컴포넌트에서 넘겨주는 props가 바뀌면 컴포넌트 렌더링이 이루어진다

2. state가 바뀌는 경우. 컴포넌트 자신의 state 값이 setState를 통해 업데이트 되는 경우 컴포넌트 렌더링이 이루어진다

3. 부모 컴포넌트가 리렌더링 되는 경우. 자신에게 할당된 props나 state가 바뀌지 않아도 부모 컴포넌트가 리렌더링되면 자식 컴포넌트 또한 리렌더링된다

4. this.forceUpdate로 강제로 렌더링을 트리거 할 때

- 그리고 컴포넌트가 업데이트 할 때 다음과 같은 순서로 메서드를 호출한다

```bash

컴포넌트 만들기

-> getDerivedStateFromProps

-> shouldComponentUpdate
  (true 반환시 render 호출, false 반환시 여기서 작업 취소)

-> render        <--forceUpdate

-> getSnapshotBeforeUpdate

-> componentDidUpdate
```

- 각 메서드는 다음과 같은 역할을 한다

* getDerivedStateFromProps

  - 업데이트가 시작되기 전에 호출된다. props의 변화에 따라 state 값에도 변화를 주고 싶을 때 사용한다

- shouldComponentUpdate

  - 컴포넌트가 리렌덜링을 해야할지 말아야 할지를 결정하는 메서드.

  - true를 반환하면 라이프 사이크 메서드를 게속 실행하고, false를 반환하면 작업을 중지한다.

  - 컴포넌트를 만들 때 이 메서드를 따로 생성하지 않으면 언제나 true를 반환한다

  - 이 메서드 안에서 현재 props와 state는 this.props와 this.state로 접근하고, 새로 설정된 props 또는 state는 nextProps와 nextState로 접근한다

  - 만약 특정 함수에서 this.forceUpdate() 함수를 호출하면 이 과정을 생략하고 바로 render 함수를 호출한다

- render

  - 컴포넌트를 리렌더링한디

- getSnapshotBeforeUpdate

  - 컴포넌트 변화를 DOM에 반영하기 직전에 호출하는 메서드

  ```jsx
  getSnapshotBeforeUpdate(prevProps, prevState){
    if(prevState.array !== this.state.array){
      const {scrollTop, scrollHeight} = this.list;
      return {scrollTop, scrollHeight};
    }
  }

  ```

  - 이 메서드에서 반환하는 값은 componentDidUpdate의 세번째 파라미터인 snapshot 값으로 전달 받을 수 있다

  - 주로 업데이트 하기 직전의 값을 참고할 일이 있을 때 활용된다(ex. 스클로바 위치 유지)

* componentDidUpdate

  - 컴포넌트 업데이트 작업이 끝난 후 호출하는 메서드

  ```jsx
  componentDidUpdate(prevProps, prevState, snapshot){ ... }

  ```

  - 업데이타 끝난 직후이므로 DOM 관련 처리를 해도 무방하다

  - prevProps 또는 prevState를 사용해서 컴포넌트가 이전에 가졌던 데이터에 접근할 수 있다

## Unmount

- 컴포넌트를 DOM에서 제거하는 것을 언마운트라고 한다

```bash
언마운트하기

-> componentWillUnmount

```

- componentWillUnmount

  - 컴포넌트가 웹 브라우저상에서 사라지기 전에 호출하는 메서드

  - 컴포넌트를 DOM에서 제거할 때 실행한다

  - componentDidMount에서 등록한 이벤트, 타이머, 직접 생성한 DOM이 있다면 이 메서드를 통해서 직접 제거해야 한다

<br/>

- 추가적으로 에러를 잡아낼 수 있는 componentDidCatch 메서드가 있다

- componentDidCatch 메서드를 사용하면 컴포넌트 렌더링 도중에 에러가 발생했을 때 오류 UI를 보여줄 수 있게 해준다

```jsx

componentDidCatch(error, info){
  this.setState({
    error:true
  });
  console.log({error, info})
}

```

- error는 파라미터에 어떤 에러가 발생했는지 알려주며, info 파라미터는 어디에 있는 코드에서 오류가 발생했는지에 대한 정보를 준다

- 하지만 이 메서드에서는 컴포넌트 자신에게 발생하는 에러를 잡아낼 수 없고, this.props.children으로 전달되는 컴포넌트에서 발생하는 에러만 잡아낼 수 있다

---

## Reference

- [리액트를 다루는 기술](https://m.yes24.com/Goods/Detail/78233628)

- [리액트를 다루는 기술 - github](https://github.com/velopert/learning-react/tree/master/07/hello-react/src)
