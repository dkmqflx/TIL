## Tilde(~)와 Carrot(^)

- 틸트와 캐럿은 버전의 범위를 지정하기 위해 사용한다

  > In NPM versioning, both the tilde (~) and caret (^) symbols are used to specify acceptable version ranges for dependencies, but they differ in the level of updates they allow.

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

<br/>

## 캐럿(Carrot)

- 캐럿은 가장 왼쪽에서 0이 아닌 숫자를 변경시키지 않고 나머지만 번경시키는 방법이다

- 즉, 캐럿을 사용하면 마이너와 패치 버전을 변경하게 된다

- 예를 들면 다음과 같다

  - `^1.2.3` : `1.2.3 <= ^1.2.3 < 2.0`

  - `^0.2.3`: `0.2.3 <= 0.2.3 < 0.3`

  - `^0.0.3`: 0.0.3 버전만 가능하다

<br/>

## 틸트(Tilde)

- 틸드의 경우 마이너 버전까지 명시되어 있는 경우, 그리고 패치버전까지 명시되어 있는 경우로 나눌 수 있다

### 마이너 버전까지만 명시되어 있는 경우

- 마이너 버전이 명시되어 마이너 버전만 변경할 수 있다.

- 예를들어 다음과 같다

  - `~1.2` : `1.2.0 <= ~1.2 < 1.3.0`

### 패치 버전까지 명시되어 있는 경우

- 패치 버전만 번경할 수 있도록 한다

- 예를들어 다음과 같다

  - `~1.2.3` : `1.2.3 <= ~1.2.3 < 1.3.0`

  - `~0.2.3` : `0.2.3 <= ~0.2.3 < 0.3.0`

<br/>

## 틸드 vs 캐럿

- 요악하자면 틸드가 캐럿보다 더 보수적인 방법이라고 할 수 있다

- 캐럿의 경우에는 x.y.z로 버전이 명시되어 있는 경우, 패치와 마이너 버전 까지 모두 업그레이드 될 수 있지만 틸드의 경우에는 패치 버전만 업그레이드가 가능하기 때문이다

- x,y,z로 버전이 되어 있을 때 틸트와 캐럿은 명시적인 차이를 보이는데 x.y 까지만 명시되어 있는 경우에는 version range가 동일하기 때문이다

- 그릐고 npm 으로 패키지를 설치하면 package.json에 설치한 버전을 기록하는데 캐럿 방식을 이용한다.

<br/>

- ~0과 ^0인 경우에도 차이가 있는데 다음과 같은 차이가 있다.

  - ~0인 경우에는 번위가 0.0.0 이상, 1.0.0 미만이 된다

  - ^0인 경우에는 범위가 0.0.0 이상 0.1.0 미만이 된다
