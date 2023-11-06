# Prettier

- Prettier와 ESLint의 설명을 요약해보자면 다음과 같다.

  - Prettier를 활용해 자신이 작성한 코드를 정해진 코딩 스타일에 맞게 변환할 수 있다.

  - ESLint를 활용해 자신이 작성한 코드 품질이 괜찮은지 검사할 수 있다.

- **Prettier**는 '한 줄의 최대 길이', 'tab'을 쓸 것인지 'space'를 쓸 것인지, 문자열을 '(홑 따옴표)로 할 것인지 "(큰따옴표)로 할 것인지 같이 정해진 코딩 스타일에 맞게 코드를 변환하기 위해 사용한다.

- **ESLint**는 문법 에러를 잡아내고, 코드 품질을 검사하기 위해 사용한다.

- 따라서 **Prettier**와 **ESLint**를 같이 쓰면 코드 품질을 바로 잡은 뒤 코드를 정해진 코딩 스타일에 맞게 바꿀 수 있다.

## 설치하기

- 아래 명령어를 사용해서 prettier를 설치한다

```shell

$ npm install prettier --save-dev --save-exact

```

- 한 가지 주목할 점은 ESLint 모듈을 설치할 때와는 다르게 `--save-exact` 옵션이 추가되었다.

- **버전이 달라지면서 생길 스타일 변화를 막을 수 있기 때문**에 Prettier에서는 이 옵션을 붙이는 것을 추천한다

## 필요한 추가 모듈

- 이 둘을 함께 쓰려면 추가로 여러 모듈을 설치해야 한다.

  - eslint-config-prettier

  - eslint-plugin-prettier

- eslint-config-prettier

  - eslint-config-prettier는 Prettier와 충돌할 수 있는 ESLint 규칙들을 꺼준다.

- eslint-plugin-prettier

  - eslint-plugin-prettier는 Prettier가 ESLint의 규칙으로써 동작하도록 만들어준다.

- 코드 품질과 관련된 검사는 ESLint의 몫이기 때문에 Prettier과 같이 사용하는 것이 최선

- 이를 위해 Prettier는 이러한 ESLint와 통합 방법을 제공하지만 **Prettier와 ESLint는 서로 충돌할 수 있기 때문에 eslint-config-prettier를 활용한다.**

- 이는 프리티어와 충돌하는 ESLint 규칙을 끄는 역할을 한다.

```shell

$ npm install eslint-plugin-prettier eslint-config-prettier --save-dev

```

- 그리고 프로젝트의 최상위 위치에 `.eslintrc.json`을 만들고 안에 다음의 내용을 추가한다

```json
// .eslintrc.json
{
  "plugins": ["prettier"],
  "extends": ["eslint:recommended", "plugin:prettier/recommended"],
  "rules": {
    "prettier/prettier": "error"
  }
}
```

## Prettier 설정 파일

- Prettier 규칙은 `.prettierrc.json` 파일을  `.eslintrc.json`과 같은 위치에 만들고 [Prettier의 옵션 문서](https://prettier.io/docs/en/options.html)에서 필요한 설정을 골라 안에 채워 넣으면 된다

```json
{
  "trailingComma": "es5",
  "tabWidth": 2,
  "semi": true,
  "singleQuote": true
}
```

---

## Reference

- [Prettier & ESLint, Airbnb Style Guide로 코드 컨벤션 설정하기](https://overcome-the-limits.tistory.com/4)
