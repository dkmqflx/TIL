## 브랜치 전략 (git branch management strategy)

- 여러 개발자가 협업하는 환경에서 git 저장소를 효과적으로 활용하기 위한 work flow

- 브랜치의 생성, 삭제, 병합이 자유로운 git의 유연한 구조를 활용하여 다양한 방식으로 소스관리를 할 수 있다.

## 자주 쓰이는 브랜치 전략

1. git-flow

   - 5가지의 브랜치를 이용해 운영하는 브랜치 전략

2. github-flow

   - master 브랜치 하나만 두되, Pull Request를 활용한 단순한 브랜치 전략

## git-flow

- 항상 유지되는 2개의 메인 브랜치와 역할을 완료하면 사라지는 3개의 보조 브랜치로 구성되어 있다.

- 메인 브랜치 : 항상 유지된다

  - master : 제품으로 출시될 수 있는 브랜치

  - develop: 다음 출시 버전을 개발하는 브랜치

- 보조 브랜치 : merge 되면 사라진다

  - feature : 기능을 개발하는 브랜치

    - develop 브린치에서 새로 추가할 기능들을 위해, 기능을 개발하는 브랜치

  - release : 이번 출시 버전을 준비하는 브랜치

    - develop 브랜치가 완료되면 테스트 또는 QA하기 위한 요오돌 사용하는 브랜치

  - hotfix : 출시 버전에서 발생한 버그를 수정하는 브랜치

    - master 브랜치에서 뭔가 문제가 생겼을 때 버그 픽스를 위해 사용하는 브랜치

### git-flow 개발 프로세스

1. 개발자는 develop 브랜치로부터 본인이 개발할 기능을 위한 feature 브랜치를 만든다

2. feature 브랜치에서 기능을 만들다가, 기능이 완성되면 develop 브랜치에 merge 한다

3. 이번 배포 버전의 기능들이 develop 브랜치에 모두 merge 됐다면 QA를 위해 release 브랜치를 생성한다

4. release 브랜치에서 오류가 발생한다면 release 브랜치 내에서 수정한다.

   - 마침내 QA가 끝났다면, 해당 버전을 배포하기 위해 master 브랜치로 merge 한다.

   - bugfix가 있었다면 해당 내용을 반영하기 위해 develop 브랜치에도 merge 한다

5. 만약 제품(master)에서 버그가 발생한다면 hotfix 브랜치를 만든다

6. hotfix 브랜치에서 버그 픽스가 끝나면 develop과 master 브랜치에 각각 merge 한다

### git-flow의 특징

1. 주기적으로 배포를 하는 서비스에 적합하다

2. 가장 유명한 전략인 만큼 많은 IDE가 지원한다

---

- [웨지의 Git 브랜치 전략](https://www.youtube.com/watch?v=jeaf8OXYO1g&list=PLGk6-UFPJT2UZ9uKrqq4ZvxFaSWUqdDgj&index=12)
