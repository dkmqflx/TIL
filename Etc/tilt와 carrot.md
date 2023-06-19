## Tilt(~)와 Carrot(^)

- 틸트와 캐럿은 버전을 지정하기 위해 사용한다

- Node.js도 그렇고 npm의 모듈은 모두 [Semantic Versioning](http://semver.org/)를 따르고 있는데 Semantic Versioning이란 `MAJOR.MINOR.PATCH` 의 버저닝을 따르는데 각 의미는 다음과 같다. 

  - 1. MAJOR version when you make incompatible API changes, 
  
  - 2. MINOR version when you add functionality in a backwards-compatible manner
  
  - 3. PATCH version when you make backwards-compatible bug fixes.
  
- 즉, MAJOR 버전은 API의 호환성이 깨질만한 변경사항을 의미하고

- MINOR 버전은 하위호환성을 지키면서 기능이 추가된 것을 의미하고

- PATCH 버전은 하위호환성을 지키는 범위내에서 버그가 수정된 것을 의미한다.

- 정리하자면 다음과 같다

  - 주 버전(Major Version): 기존 버전과 호환되지 않게 변경한 경우
  
  - 부 버전(Minor version): 기존 버전과 호환되면서 기능이 추가된 경우
  
  - 수 버전(Patch version): 기존 버전과 호환되면서 버그를 수정한 경우

## 틸트

- 틸트(~) 는 마이너 버전이 명시되어 있으면 패치버전만 변경한다. 

- 예를 들어 `~1.2.3` 표기는 `1.2.3` 부터 `1.3.0` 미만 까지를 포함한다. 

  - 즉, ^1.2.3은 1.x.x 까지 지원한다는 뜻이다

- 마이너 버전이 없으면 마이너 버전을 갱신한다. 

- `~0` 표기는 `0.0.0` 부터 `1.0.0` 미만 까지를 포함한다.

- 즉, 틸드는 간단히 말하면 현재 지정한 버전의 마지막 자리 내의 범위에서만 자동으로 업데이트한다.

  - `~0.0.1` : `>=0.0.1 <0.1.0`
  - `~0.1.1` : `>=0.1.1 <0.2.0`
  - `~0.1` : `>=0.1.0 <0.2.0`
  - `~0` : `>=0.0 <1.0`

- 아래와 같은 package.json 파일에서 react 버전이 틸트로 ` "react": "~0"`처럼 명시되어 있는 경우

```js
// package.json

{
  "name": "frontend-env",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC",
  "dependencies": {
    "react": "~0"
  }
}

```

- `npm install` 명령어를 통해 설치 후 `node_modules/react/pacakge.json` 파일을 보면

- 버전이 `"version": "0.14.10"` 으로, 마이너 버전이 없기 때문에 마이너 버전이 갱신된 것을 확인할 수 

- 하지만 `^0.0`인 경우 0.0.3으로 패치 버전만 변경된 것을 확인할 수 있다.


## 캐럿
  
- 캐럿(^) 은 정식버전에서 마이너와 패치 버전을 변경한다.
 
- 예를 들어 ^1.2.3 표기는 1.2.3부터 2.0.0 미만 까지를 포함한다. 

- 정식버전 미만인 0.x 버전은 패치만 갱신한다. 

- ^0 표기는 0.0.0부터 0.1.0 미만 까지를 포함한다.

- 보통 라이브러리 정식 릴리즈 전에는 패키지 버전이 수시로 변한다. 

- 0.1에서 0.2로 부버전이 변하더라도 하위 호환성을 지키지 않고 배포하는 경우가 빈번하다. 

- ~0로 버전 범위를 표기한다면 0.0.0부터 1.0.0미만까지 사용하기 때문에 하위 호완성을 지키지 못하는 0.2로도 업데이트 되어버리는 문제가 생길수 있다.

- 반면 캐럿을 사용해 ^0.0으로 표기한다면 0.0.0부터 0.1.0 미만 내에서만 버전을 사용하도록 제한한다. 따라서 하위 호완성을 유지할 수 있다. 

- NPM으로 패키지를 설치하면 package.json에 설치한 버전을 기록하는데 캐럿 방식을 이용한다. 

- 초기에는 버전 범위에 틸트를 사용하다가 캐럿을 도입해서 기본 동작으로 사용했다. 

- 그래서 우리가 설치한 react는 ^16.12.0 표기로 버전 범위를 기록한 것이다.

- 즉, 캐럿 방식은 `[major, minor, patch]` 에서 가장 왼쪽에 있는 0이 아닌 요소를 수정하지 않는 변경을 허용한다

- 1.0.0 버전이라면 minor와 patch 버전을 업데이트를 허용하고

- 0.X 버전이라면 patch 업데이트 허용

- 0.X.X 버전이라면 업데이트를 허용하지 않는다.

- **`^1.2.3`:** `>=1.2.3 < 2.0.0`

  - 왼쪽에서 맨 처음 0이 아닌 요소는 major 이기 때문에 minor, patch 업데이트를 허용

- **`^0.2.3`:** `>=0.2.3 <0.3.0`

  - 왼쪽에서 맨 처음 0이 아닌 요소가 minor 이기 때문에 patch 업데이트를 허용

- **`^0.0.3`**

  - 왼쪽에서 맨 처음 0이 아닌 요소가 patch이기 때문에 업데이트를 허용하지 않음

- 아래와 같은 package.json 파일에서 react 버전이 캐럿으로 ` "react": "^0"`처럼 명시되어 있는 경우

```js
// package.json

{
  "name": "frontend-env",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC",
  "dependencies": {
    "react": "^0"
  }
}

```

- `npm install` 명령어를 통해 설치 후 `node_modules/react/pacakge.json` 파일을 보면 버전이 `"version": "0.14.10"` 인 것을 확인할 수 있다.

- 하지만 `^0.0`인 경우 0.0.3으로 패치 버전만 변경된 것을 확인할 수 있다.


---

### Reference

- [npm package.json에서 틸드(~) 대신 캐럿(^) 사용하기](https://blog.outsider.ne.kr/1041)
- [npm semver - 틸트 범위(~)와 캐럿 범위(^)](https://velog.io/@slaslaya/npm-semver-%ED%8B%B8%ED%8A%B8-%EB%B2%94%EC%9C%84%EC%99%80-%EC%BA%90%EB%9F%BF-%EB%B2%94%EC%9C%84)
- [프론트엔드 개발환경의 이해: NPM](https://jeonghwan-kim.github.io/series/2019/12/09/frontend-dev-env-npm.html)
