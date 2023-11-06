# ESLint

- [ESLint](http://eslint.org/)는 코딩 컨벤션에 위배되는 코드나 안티 패턴을 자동 검출하는 도구다.

- ESLint는 처음부터 유용하게 사용할 수 있는 스타일 가이드(built-in rule)을 제공하지만 개발자가 자신의 스타일 가이드를 작성할 수도 있다.

## 플러그인 (plugin) / eslint-plugin-\*

- 플러그인에 정의된 프리셋 규칙을 즉시 적용하고 싶다면: `extends`

- 플러그인에 정의된 규칙을 개별적으로 적용하고 싶다면: `plugins`으로 불러오고 `rules`에 추가한다

- ESLint는 서드파티 플러그인 사용을 지원한다.

- **plugin**은 rule을 정의한 것으로, 예를 들면 `eslint-plugin-react`는 리액트와 관련된 룰을 정의한 패키지이다.

- **plugin** 패키지를 설치하고, 해당 플러그인을 `plugins`에 추가하여 사용할 수 있다.

```json
{
  "plugins": ["eslint-plugin-react"]
}
```

- 플러그인을 추가할 때, `eslint-plugin-` 접두사는 생략이 가능하다.

- 예를들어, `eslint-plugin-react`는 아래처럼 선언할 수 있다.

```json
{
  "plugins": ["react"]
}
```

- 이렇게 넣어도 **아무런 동작도 하지 않는데**

- 이제 `eslint-plugin-react`에 존재하는 룰을 사용할 수 있게 된 것이다.

- 만약 룰을 사용하고 싶다면 아래와 같이 **rules**에서 정의해야 한다.

## 규칙 (Rules)

- ESLint에는 프로젝트에서 사용하는 규칙을 수정할 수 있다.

- 규칙을 변경하는 경우, 다음과 같은 방법으로 설정해야 한다.

  - `"off"` 또는 `0`: 규칙을 사용하지 않음

  - `"warn"` 또는 `1`: 규칙을 경고로 사용

  - `"error"` 또는 `2`: 규칙을 오류로 사용

- **규칙에 추가 옵션이 있는 경우**에는 배열 리터럴 구문을 사용하여 지정할 수 있다.

  ```json
  {
    "rules": {
      "eqeqeq": "off",
      "curly": "error",
      "quotes": ["error", "double"],
      "comma-style": ["error", "last"]
    }
  }
  ```

```json
{
  "plugins": ["react"],
  "rules": {
    "react/jsx-uses-react": "error",
    "react/jsx-uses-vars": "error"
  }
}
```

- 하지만 이런식으로 매번 모든 룰에 대해 분석하고 파악해서 일일히 작성하기엔 너무 귀찮은 일이다.

- 때문에 대부분의 플러그인은 `recommended`나 `strict`, `all` 등의 자체 설정을 제공하는 것이다.

- `eslint-plugin-react`의 경우 `recommended`와 `all` 두가지의 config를 제공하는데 다음과 **extends**에서 같이 사용할 수 있다.

```json
{
  "extends": ["plugin:react/recommended"]
}
```

- 즉, **plugins**와 **rules** 대신 **extends**에 바로 필요한 설정들을 하는 것이다

## eslint-config-\*

- 이러한 `eslint-plugin-*` 패키지들이나 룰들을 모아서 설정으로 만든 것이 `eslint-config-*` 패키지다.

- 예를들면, `eslint-config-airbnb`는

  - `eslint`

  - `eslint-plugin-import`

  - `eslint-plugin-jsx-a11y`

  - `eslint-plugin-react`

  - `eslint-plugin-react-hooks`

- 의 룰들을 조합한 설정 패키지이고, 해당 패키지를 모두 받아야지 `eslint-config-airbnb` 패키지를 다운로드 받을 수 있다.

- 아래와 같이 정의해서 사용한다.

```json
{
  "extends": ["airbnb"]
}
```

- `eslint-plugin-*` 패키지의 설정은 `extends`에서 `plugin:패키지네임/설정네임`으로 사용할 수 있다.

- `eslint-config-*` 패키지의 설정은 바로 `*`에 해당하는 이름을 써주기만 하면 된다.

- 플러그인 패키지를 `plugins`에 단축어로 쓰던 것과 동일하다.

## parser

- 말 그대로 코드를 분석하기 위한 파싱툴인데, 기본값은 `espree`이다.

- `Babel`과 함께 사용되는 파서로는`babel-eslint`가 있고  js 워크스페이스에서는 `@babel/eslint-parser`, `Typescript` 구문 분석을 위해 사용되는`@typescript-eslint/parser`가 있다.

- `plugin:@typescript-eslint/recommended`를 포함시키면 `@typescript-eslint/parser`가 자동으로 포함된다.

```json
{
  "parser": "@typescript-eslint/parser"
}
```

## parserOptions

- `parserOptions`은 ESLint 사용을 위해 지원하려는 Javascript 언어 옵션을 지정할 수 있다.

> ESLint allows you to specify the JavaScript language options you want to support. By default, ESLint expects ECMAScript 5 syntax. You can override that setting to enable support for other ECMAScript versions and JSX using parser options.

- ecmaVersion: 사용할 ECMAScript 버전을 설정

- sourceType: parser의 export 형태를 설정

- ecmaFeatures: ECMAScript의 언어 확장 기능을 설정

  - globalReturn: 전역 스코프의 사용 여부 (node, commonjs 환경에서 최상위 스코프는 module)

  - impliedStric: strict mode 사용 여부

  - jsx: ECMScript 규격의 JSX 사용 여부

```json
{
  "parserOptions": {
    "ecmaVersion": 6,
    "sourceType": "module",
    "ecmaFeatures": {
      "jsx": true
    }
  }
}
```

## env

- linter가 파일을 분석하려 시도할 때 알아야 하는, 미리 정의된 전역 변수에 무엇이 있는지 명시하는 속성

- 사전 정의된 전역 변수를 제공한다.

- node 환경인 워크스페이스면 `node: true`를 추가해야 하고, 웹 환경이라면 `browser: true`, `es6: true` 등을 추가해야 한다.

  - browser : 브라우저에서 사용하는 document 같은 객체를 사용할 수 있게 한다.

  - node : node에서 console 같은 전역 변수를 사용할 수 있게 한다.

- `files`나 `overrides`를 사용해서 파일 패턴 단위로 적용할 전역 변수를 나눌 수도 있다. (물론 다른 설정도 마찬가지다)

  ```js
  module.exports = {
    overrides: [
      {
        files: "**/*.+(ts|tsx)",
        parser: "@typescript-eslint/parser",
        parserOptions: {
          project: "./tsconfig.json",
        },
        rules: {
          "no-undef": 0,
          "no-unused-vars": 0,
          "@typescript-eslint/no-unused-vars": 1,
        },
      },
    ],
  };
  ```

---

## Reference

- [ESLint 설정 뜯어보기 (feat. React, TypeScript)](https://datalater.github.io/posts/eslint/)

- [ESLint 알고 쓰기](https://velog.io/@yrnana/ESLint-%EC%95%8C%EA%B3%A0-%EC%93%B0%EC%9E%90)

- [ESLint 설정 살펴보기](https://velog.io/@kyusung/eslint-config-2)

- [Prettier & ESLint, Airbnb Style Guide로 코드 컨벤션 설정하기](https://overcome-the-limits.tistory.com/4)
