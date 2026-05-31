## package.json-lock

<blockquote>

package-lock.json is automatically generated for any operations where npm modifies either the node_modules tree, or package.json.

It describes the exact tree that was generated, such that subsequent installs are able to generate identical trees, regardless of intermediate dependency updates.

</blockquote>

- package.json-lock 파일이 필요한 이유는 package.json에서 버전 정보를 저장할 때 틸드(~) 또는 캐럿(^) 방식으로 버전의 범위를 지정해서 저장하는데 각각의 방식에 따라 다른 버전의 패키지가 설치될 수 있기 때문이다.

- ~1.2.3과 ^1.2.3를 예로들면 다음과 같다

  - ~1.2.3의 범위는 1.2.3 <= ~1.2.3 < 1.2.9

  - ^1.2.3의 범위는 1.2.3 <= ^1.2.3 <1.3

- package.json-lock 파일은 생성된 시점의 의존성 정보를 모두 갖고 있기 때문에 package.json-lock 파일이 원격 저장소를 통해 공유되어야지 정확히 같은 의존성 정보를 공유할 수 있게 된다.

## Reference

- [npm - package-lock.json](https://docs.npmjs.com/cli/v10/configuring-npm/package-lock-json)

- [package-lock.json은 왜 필요할까?](https://hyunjun19.github.io/2018/03/23/package-lock-why-need/)
