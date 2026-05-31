## dependencies

- 앱에 종속된 가장 일반적인 종속성

- 런타임과 빌드타임, 개발중 모두에서 이 종속성 패키지들이 필요하기 때문에, 앱이 빌드 될 때 이 종속성 패키지들이 번들에 포함되어 배포된다.

## devDependencies

- devDependencies는 개발 모드일 때만 의존하고 있다는 것을 알려주는 것

- devDependencies는 실제로 배포할 때는 필요없는 테스트 도구나 웹팩, 바벨같은 것들을 넣어두면 된다.

- 런타임에서는 필요하지 않고 빌드타임 & 개발중에만 필요한 패키지

- 빌드타임에서 이 종속성들은 빌드에 도움을 주거나 참조가 되지만, 번들에는 포함되지 않는 종속성 패키지들이다.

## peerDependencies

- 직접 require은 하지 않지만 호환되는 패키지의 목록

- 실제로 패키지에서 직접 require(import) 하지는 않더라도 호환성이 필요한 경우 명시한다.

- 주로 어떤 패키지의 플러그인 같은 개발할 때 사용한다.

<br/>

- 예를들어 `my-app` 에서 사용하기 위한 React 기반의 컴포넌트 라이브러리인 `my-ui-library`를 개발하는 경우, 이 때, UI Library 에서는 `react 17.0.0` 버전을 peer dependancy로 두고 있다고 하자

- `my-ui-library`는 `react`컴포넌트의 라이브러리이기 때문에, 이 라이브러리를 사용하게 될 프로젝트에서는 `react`를 의존할 수 밖에 없다. 이러한 경우 peer dependencies를 사용한다.

- `my-app`은 아래와 같은 모듈 구조가 생성이 된다.

  ```
  node_modules
  ㄴreact ^16.0.0 (dependancy)
  ㄴmy-ui-library ^0.0.1 (dependancy)
    ㄴnode_modules
      ㄴreact ^17.0.0 (peer dependancy)
  ```

<br/>

- peerDependencies가 필요한 이유는 다음과 같다.

  - 본질적으로, 플러그인은 host 패지키와 함께 사용하도록 설계되어 있다. 하지만 더 중요한 것은 특정 버전의 호스트 패키지와 함께 사용하도록 설계되어있다.

  - 예를 들어, chai-as-promised version1.x 와 2.x 플러그인은 chai version 0.5와 동작한다. 반면에 version 3.x 는 chai 1.x 와 동작한다.

  - 하지만 대부분의 플러그인은 실제로 host package에 의존하지 않는다.

  - 즉 grunt 플러그인은 절대로 require('grunt')하지 않으므 플러그인이 호스트 패키지를 dependency로 설정하더라도 다운로드한 카피본은 사용되지 않는다.

  - 따라서 사용하는 쪽에서 호환되지 않는 호스트 패키지에 플러그인을 꽂을 가능성이 있다.

- 이러한 문제를 해결하기 위해 peerDependencies

  - 패키지 매니저에게, '나는 내 호스트 패키지 버전 1.2.x에 연결될 때만 작동하므로 나를 설치하는 경우 호환되는 호스트가 설치되어있는지 확인해주세요' 라고 말해야 하는데, 이 관계를 peer dependency라고 한다.

  - 즉, peer dependency는 반대로 내가 만든 모듈이 다른 모듈과 함께 동작할 수 있다는 호환성을 표시하는 것이다.

  - 내가 만든 모듈이 호스트의 모든 버전이 아니라 1.3 버전과만 동작한다면, 그런 정보를 표시해줘야 하는데 이럴 때 사용하는 것이 peerDependencies라는 것이다.

  - 플러그인을 작성할 때 의존하는 호스트 패키지의 버전을 파악하고 package.json에 추가한다.

  ```json
  {
    "name": "tea-latte",
    "version": "1.3.5",
    "peerDependencies": {
      "tea": "2.x"
    }
  }
  ```

---

## Reference

- [package.json](https://www.zerocho.com/category/NodeJS/post/5825a3caaff5c70018279975)

- [Peer Dependencies 에 대하여](https://velog.io/@johnyworld/Peer-Dependencies-%EC%97%90-%EB%8C%80%ED%95%98%EC%97%AC)

- [npm Docs - peerDependencies](https://docs.npmjs.com/cli/v10/configuring-npm/package-json#peerdependencies)

- [Peer Dependencies는 왜 쓸까?](https://bohyeon-n.github.io/deploy/etc/peerdependencies.html)
