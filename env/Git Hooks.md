## Git hook

- Git Hooks 는 Git 과 관련한 어떤 이벤트가 발생했을 때 특정 스크립트를 실행할 수 있도록 하는 기능이다

- 아래와 같은 경로를 통해서 git hook을 위한 쉘 스크립트 파일을 확인할 수 있다

- 실행하고자 하는 git hook 스크립트 파일을 작성한 다음에 `.sample` 확장자를 제거하면 git hook을 실행할 수 있다.

```shell

$ cd .git/hooks

$ ls -a

# pre-commit.sample

```

- 커밋 워크플로 훅 은 git commit 명령으로 커밋을 할 때 실행하는 훅이고,

- 기타 훅 은 Rebase, Merge, Push 와 같은 이벤트를 실행할 때 실행하는 훅을 포함한다.

- 커밋 워크플로 훅

  - pre-commit : commit 을 실행하기 전에 실행

  - prepare-commit-msg : commit 메시지를 생성하고 편집기를 실행하기 전에 실행

  - commit-msg : commit 메시지를 완성한 후 commit 을 최종 완료하기 전에 실행

  - post-commit : commit 을 완료한 후 실행

- 여기서 단점은 `.git` 디렉토리는 Git에 기록되지 않는다는 것이다.

- git에 기록되지 않으면 원격 레포에 올리지 못하기 때문에, 원격 레포에 못올라가면 팀원들과 플젝을 할때 각각의 팀원이 알아서 git hook을 적용해야 한다.

- 이러한 문제를 husky와 같은 도구를 사용해서 git hook을 관리하는 방식으로 해결할 수 있다.

## Husky

- husky 는 Git Hooks 를 보다 쉽게 적용할 수 있는 npm 모듈이다. 심지어 Git Hooks 에 대해 자세히 알지 못하더라도 commit, push 정책을 관리하고 공유할 수 있다.

## commitlint

- commitlint는 커밋 메시지 관리를 할 수 있는 도구

- root 위치에 `commitlint.config.cjs` 파일을 만들고 아래와 같이 필요한 설정을 추가한다

```cjs
module.exports = {
  extends: ["@commitlint/config-conventional"],
  rules: {
    "subject-case": [0, "never"],
    "header-min-length": [2, "always", 10],
    "scope-empty": [2, "always", true],
    "subject-full-stop": [2, "never", "."],
    "type-enum": [
      2,
      "always",
      ["feat", "fix", "style", "chore", "refactor", "test"],
    ],
  },
};
```

- 그리고 husky에서 commit-msg를 통해서 커밋 메시지 작성 후에 위에서 작성한 commitlint의 규칙에 맞게 커밋 메시지가 작성되었는지 확인할 수 있다

- 만약 규칙을 제대로 지키지 않았다면 커밋이 메세지가 추가되지 않는다

```shell

#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "🚦 commit 양식이 유효한지 체크합니다..."
npx commitlint --edit $1


```

## lint-staged

- lint-staged란 내가 add한 파일들에 대해서 git 파일에 대해 lint와 우리가 설정해둔 명령어를 실행해주는 라이브러리다.

- husky만 사용하면 프로젝트의 모든 코드를 검사히기 때문에 비효율적이지만, lint-staged는 Git의 staged한 코드만 검사해서, 보다 효율적인 lint가 가능하다

- husky와 함께 사용할 수 있다

```sh
# husky/pre-commit.sh

#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

echo "🚦 commit 이전에 코드를 체크합니다..."
npx lint-staged

```

```json
// package.json
{
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": ["eslint --fix --cache"]
  }
}
```

---

### Reference

- Git Hooks

  - [Git hook 을 사용해 보자!](https://dsc-sookmyung.tistory.com/486)
  - [8.3 Git맞춤 - Git Hooks](https://git-scm.com/book/ko/v2/Git%EB%A7%9E%EC%B6%A4-Git-Hooks)
  - [gabia - husky 로 git hook 하자](https://library.gabia.com/contents/8492/)
  - [deer - git branch 이름과 hook으로 commit message 컨벤션 강제하기](https://blog.deering.co/commit-convention/)
  - [Commit 메세지에 자동으로 issue number 추가하기](https://myeongjae.kim/blog/2019/02/02/prepare-commit-msg-hook-issue-number)

- commitlint

  - [commitlint](https://commitlint.js.org/#/)

- lint-staged

  - [husky, lint-staged란 무엇인가?!](https://velog.io/@jma1020/husky-lint-staged%EB%9E%80-%EB%AC%B4%EC%97%87%EC%9D%B8%EA%B0%80)
  - [husky, lint-staged를 사용하자( sub : ESLint 자동화하기 )]
