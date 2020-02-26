## Ch1.

### 버전관리 

    - 내가 원하는 시점(버전)으로 이동할 수 있게 해주는 것. 이를 도와주는 툴이 버전 관리 시스템이다.
    - 내가 원하는 시점마다 깃발을 꽂고, 깃발이 꽂힌 시점으로 자유롭게 이동할 수 있다면 편안하게 새로운 코드를 추가하거나 삭제할 수 있다.
    - 이를 가능하게 해주는 소스코드 버전 관리 시스템이 Git
    - Github는 Git으로 관리하는 프로젝트를 올려둘 수 있는 호스팅 사이트 중 하나.

```
$ git # git 설치 확인

$ git init 
# 로컬 저장소 만들기. [.git]라는 폴더가 자동을로 생성된다. 
# git으로 생성한 버전들의 정보와 원격 저장소 주소등이 들어있다 

```

<hr>

- Git에서는 생성된 각 버전을 커밋(commit)이라고 한다

```

# 버전 관리를 위한 내 정보 등록 
$ git config --global user.email "hello.git.Github@gmail.com"

$ git config --global user.name "Cat-Hanbit"

$ git add README.txt

$ git commit -m "사이트 설명 추가" # 버전 생성

$ git log # 지금까지 만든 커밋 확인

$ git checkout 5813bb5 # 앞자리 7자리 커밋 아이디로 이동할 수 있다

$ git checkout - # 최신 커밋으로 돌아간다 


```

<hr>

- GitHub에서는 원격저장소를 레포지토리(Repository)라고 한다 

```
$ git remote add origin "원격 저장소 주소" # 로컬 저장소에 원격 저장소 주소를 알려준다

$ git push origin master # 로컬저장소에 있는 커밋들을 push 명령어로 원격 저장소에 올린다
```

<hr>

- 원격 저장소의 코드와 버전을 내 컴퓨터로 내려받는 것을 클론(Clone)이라고 한다
- pull은 원격 저장소에 새로운 커밋이 있다면 그걸 내 로컬 저장소에 받아 오는 명령어

```

$ git clone "원격 저장소 주소" . # 한칸 뛰우고 마침표 


# 로컬저장소와 원격 저장소와 차이가 있을 때 pull을 사용하면 원격저장소의 커밋을 로컬저장소에 내려받을 수 있다 
$ git pull origin master 

```

- Add .gitignore
    - 작업할 때 굳이 Github에 올릴 필요가 없는 파일들이 있다
    - 이 옵션에서 선택한 항목에 따라 Github에 올리지 않기를 바라는 파일이 자동으로 목록에 추가 된다
