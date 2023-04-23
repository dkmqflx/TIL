## Tilt(~)와 Carrot(^)

- 틸트와 캐럿은 버전을 지정하기 위해 사용한다

### 틸트

- 틸드는 간단히 말하면 현재 지정한 버전의 마지막 자리 내의 범위에서만 자동으로 업데이트한다.

  - `~0.0.1`?:?`>=0.0.1 <0.1.0`
  - `~0.1.1`?:?`>=0.1.1 <0.2.0`
  - `~0.1`?:?`>=0.1.0 <0.2.0`
  - `~0`?:?`>=0.0 <1.0`

### 캐럿

- 캐럿을 이해하기 전에 우선 [Semantic Versioning](http://semver.org/)에 대해서 이해하고 있어야 한다

- Node.js도 그렇고 npm의 모듈은 모두 SemVer를 따르고 있는데 Semantic Versioning이란 `MAJOR.MINOR.PATCH`
  의 버저닝을 따르는데 각 의미는 다음과 같다. 1. MAJOR version when you make incompatible API changes, 2. MINOR version when you add functionality in a backwards-compatible manner, and 3. PATCH version when you make backwards-compatible bug fixes.

- 즉, MAJOR 버전은 API의 호환성이 깨질만한 변경사항을 의미하고

- MINOR 버전은 하위호환성을 지키면서 기능이 추가된 것을 의미하고

- PATCH 버전은 하위호환성을 지키는 범위내에서 버그가 수정된 것을 의미한다.

- 즉, 캐럿 방식은 `[major, minor, patch]` 에서 가장 왼쪽에 있는 0이 아닌 요소를 수정하지 않는 변경 허용

- 1.0.0 버전이라면 minor와 patch 버전을 업데이트를 허용

- 0.X 버전이라면 patch 업데이트 허용

- 0.X.X 버전이라면 업데이트를 허용하지 않는다.

- **`^1.2.3`:** `>=1.2.3 < 2.0.0`

  - 왼쪽에서 맨 처음 0이 아닌 요소는 major 이기 때문에 minor, patch 업데이트를 허용

- **`^0.2.3`:** `>=0.2.3 <0.3.0`

  - 왼쪽에서 맨 처음 0이 아닌 요소가 minor 이기 때문에 patch 업데이트를 허용

- **`^0.0.3`**

  - 왼쪽에서 맨 처음 0이 아닌 요소가 patch이기 때문에 업데이트를 허용하지 않음

---

### Reference

- [npm package.json에서 틸드(~) 대신 캐럿(^) 사용하기](https://blog.outsider.ne.kr/1041)
- [npm semver - 틸트 범위(~)와 캐럿 범위(^)](https://velog.io/@slaslaya/npm-semver-%ED%8B%B8%ED%8A%B8-%EB%B2%94%EC%9C%84%EC%99%80-%EC%BA%90%EB%9F%BF-%EB%B2%94%EC%9C%84)
