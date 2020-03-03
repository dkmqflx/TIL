# Ch6

- Git을 온전히 이해하고 더 잘 사용하기 위해서는 CLI 환경을 익혀야 한다
- GUI 프로그램은 CLI 기능 중 자주 쓰는 기능만 모아서 만들었기 때문에 모든 기능(옵션)을 100% 사용할 수 없다
- CLI 환경을 사용할 때 작업속도가 더 빠르고 몇가지 고급 명령은 CLI 환경에서만 작동한다

- $ 기호와 표시된 경로 드을 합쳐서 프롬프트(Prompt)라고 한다
- 프롬프트는 CLI에서 가장 기본적인 정보를 보여준다
- '~'는 현재 폴더 위치이다


- pwd
    - 현재 폴더의 위치를 확인한다
- ls -a
    - 현재 폴더의 파일 목록을 확인한다
    - -a 옵션을 이용해 숨김 파일도 볼 수 있따
- cd
    - 홈 폴더로 이동한다
    - 홈 폴더는 사용자 이름과 폴더명이 같고 내 문서 폴더의 상위 폴더이다
- cd <폴더이름>
    - 특정 위치의 디렉토리로 이동한다
- cd ..
    - 현재 폴더의 상위 폴더로 이동한다
- mkdir <새폴더이름>
    - 현재 폴더의 아래에 새로운 폴더를 만든다
- echo "문자열"
    - 화면에 ""안의 문자열을 표시한다

<hr>

```
# Git 저장소의 상태를 알려주는 명령어
# git status는 Git 저장소(정확하게는 워킹트리)에서만 정상적으로 수행된다
$ git status


# git status 명령 보다 짧게 요약해서 상태를 보여주는 명령어로, 
# 변경된 파일이 많을 때 유용하다
$ git status -s

```

- git status 명령어가 에러 없이 동작되는 경우도 있다
- 이 경우는 새로 만든 폴더가 git 프로젝트의 하위 폴더라는 의미
- 즉, 현재 폴더의 상위 폴더 중 어떤 폴더가 Git 저장소로 이미 초기화 되어 있다는 뜻
- 예를들어 윈도우 환경에서, 내문서 - Documents 폴더가 git 저장소 인 경우
- 실수로 git push 명령어를 사용하면 내 문서 내의 자료가 통채로 github로 공개 될 수 있다
- 따라서 이러한 경우에는 이미 생성된 [.git] 폴더를 삭제한다

```

# 현재 폴더에 Git 저장소를 생성한다. 현재 폴더에는 [.git]이라는 폴더가 생성된다
# 이 폴더가 로컬저장소이다
$ git init

$ ls -a # [.git] 폴더 확인 가능

$ git status # 워킹 트리 상태 확인

```

- 워킹트리(working tree)
    - 일반적으로 사용자가 파일과 하위 폴더를 만들고 작업 결과물을 저장하는 곳
    - 작업 폴더에서 [.git]폴더 (로컬저장소)를 뺀 나머지 부분을 말한다
- 로컬 저장소(local repository)
    - git init 명령어로 생성되는 [.git]폴더
    - 커밋, 커밋을 구성하는 객체, 스테이지가 모두 이 폴더에 저장된다
- 원격 저장소(remote repository)
    - 로컬 저장소를 업로드하는 곳
- Git 저장소
    - git 명령어로 관리할 수 있는 폴더 전체를 일반적으로 git 프로젝트 혹은 git 저장소라고 한다
    - 공식문서에서는 로컬저장소와 git 저장소를 같은 뜻으로 사용하고 있다
- 작업폴더
    - 워킹트리 + 로컬저장소


<hr>

- git 옵션에는 지역옵션, 전역옵션, 시스템 환경 옵션이 있다
    - git config 명령을 사용해서 옵션을 보거나 값을 바꿀 수 있다
    - 우선 순위 : 지역 옵션 > 전역 옵션 > 시스템 환경 옵션
    - 일반적으로 개인 PC에서는 전역 옵션을 많이 하용하지만 공용 PC처럼 여러 사람이 사용하거나 git을 잠깐만 써야할 경우 지역 옵션을 사용한다
    - 시스템 환경 옵션
        - PC 전체의 사용자를 위한 옵션
        - git이나 소스트리 설치시에 몇가지 값들이 지정되는 곳
    - 전역 옵션
        - 현재 사용자를 위한 옵션
        - 현재 git 저장소에서만 유효한 옵션
    - 지역 옵션
        - 현재 Git 저장소에서만 유효한 옵션

```
git config --global <옵션명>
#지정한 전역 옵션의 내용을 살펴본다

git config --global <옵션명> <새로운 값>
#지정한 전역 옵션의 값을 새로 설정한다

git config --global unset <옵션명>
#지정한 전역 옵션을 삭제한다 

git config --local <옵션명>
#지정한 지역 옵션의 내용을 살펴본다

git config --local <옵션명> <새로운 값>
#지정한 지역 옵션의 값을 새로 설정한다

git config --local unset <옵션명>
#지정한 지역 옵션을 삭제한다 

git config --system <옵션명>
#지정한 시스템 옵션의 내용을 살펴본다

git config --system <옵션명> <값>
#지정한 시스템 옵션의 값을 새로 설정한다

git config --system unset <옵션명> <값>
#지정한 시스템 옵션의 값 삭제한다 

git config --list
#현재 프로젝트의 모든 옵션을 살펴본다


$ git config --global user.name
#현재 user 확인

$ git config --global user.name "new"
#현재 이름을 new로 지정

# 현재 작업 PC가 공용이거나 프로젝트마다 값을 따로 설정하고 싶은 경우
# --global 대신 지역 옵션을 설정한다 

#git 기본 에디터 확인
$ git config core.edigot

$ git config --global core.editor

$ git config --system core.editor


```

<hr>

- 스테이징과 커밋을 수행하는 add, commit



```

git add 파일1 파일2
#파일들을 스테이지에 추가
#새로 생성한 파일을 스테이지에 추가할 때 add명령어를 사용한다 

git commit
#스테이지에 있는 파일들을 커밋한다

git commit -a
# add 명령을 생략하고 바로 커밋할 때 사용한다
# 변경된 파일과 삭제된 파일은 자동으로 스테이징되고 커밋된다
# untracked 파일을 커밋되지 않는다
# 기존 커밋 이력이 있는 파일. 즉 modified 상태의 파일의 스테이징 과정을 생략할 수 있다 

git push [-u] [원격저장소별명] [브랜치이름]
# 현재 브랜치에서 새로 생성한 커밋을 원격저장소에 업로드 한다
# -u 옵션으로 브랜치의 업스트림을 등록할 수 있다
# 한번 등록한 후에는 git push만 입력해도 된다

git pull
# 원격 저장소의 변경사항을 워킹트리에 반영한다
# git fetch + merge와 같다 

git fetch [원격저장소별명] [브랜치이름]
# 원격 저장소의 브랜치와 커밋들을 로컬저장소와 동기화 한다.
# 옵션을 생략하면 모든 원격저장소에서 모든 브랜치를 가져온다

git merge 브랜치이름
# 지정한 브랜치의 커밋들을 현재 브랜치 및 워킹트리에 반영한다

git reset [파일명] 
# 스테이지 영역에 있는 파일들을 스테이지에 내린다[언스테이징]
# 워킹트리의 내용은 변경되지 않는다. 즉, 워킹트리의 내용은 그대로 두고 해당파일을 스테이지에서만 내린다
# soft, mixed, hard 옵션을 사용가능하다. 옵션 없이 사용하면 mixed reset으로 동작


```

<hr>

```
$ echo "hello git"

$ echo "hello git" > file1.txt

$ ls

$ git status # file1.txt가 untracked 상태임을 확인할 수 있다

$ git add file1.txt

$ git status


```

- git reset [파일명]
    - 스테이지 영역에 있는파일을 스테이지에서 내린다(언스테이징)
    - 이 명령어는 워킹트리의 내용은 그대로 두고 해당 파일을 스테이지에서만 내린다
    - reset에는 세가지 옵션(soft, mixed, hard)를 사용할 수 있다
    - 옵션을 따로 지정하지 않고 상요하면 mixed reset으로 동작한다

```
$ git status

$ git reset file1.txt # file1.txt 파일 언스텡징

$ git status # 언스테이징 되어 스테이지에서 내려간 상태 확인 

$ ls

$ cat file1.txt # 언스테이징 후에 파일 내용이 변경 되었는지 확인 

$ git add file1.txt

$ git status

$ git commit 
# 커밋 실행, 비주얼 스튜디오로를 기본 에디터로 설정한 경우 비주얼 스튜디오가 뜬다
# git commit 명령어를 작성할 때, 첫 줄에는 작업 내용의 요약, 
# 두번째 줄에는 자세하게 작엄 내용을 기록한다
# 즉,  첫 줄은 제목, 그 다음줄은 본문

$ git status

$ git log --oneline --graph -- all --decorate
# e0044ee (HEAD -> master) 첫 번째  커밋



```

- 커밋 히스토리에서 보이는 16진수 7자리는 커밋 체크섬 혹은 커밋 아이디이다
- SHA1 해시 체크섬 값을 사용하는데 잉는 전 세계에서 유일한 값을 가진다
- git 커밋은 일반적으로 커밋 아이디라고 하는 영문 소문자와 숫자 조합의 40자리 SHA1 해시 체크섬 값을 가진다
- 해시는 무언가를 잘게 쪼개서 섞어놓은 것을 말한다
- 체크섬은 데이터의 정확성을 확인하기 위해서 계산한 어떤 값을 말한다
- 따라서 SHA1 해시 체크섬은 SHA1이라는 알고리즘을 사용해서 만들어낸 체크섬 값을 말한다

<HR>

```
$ git log
# 현재 브랜치의 커밋 이력을 보는 명령어
# HEAD와 관련된 커밋들이 자세하게 나온다 

$ git log -n<숫자>
# 전체 커밋 중에서 최신 n개의 커밋을 살펴본다

$ git log --oneline --graph --decorate --all
# 모든 브랜치들을 보고 싶을 때 

# --oneline : 현재 커밋을 한 줄로 요약해서 보여준다
# --graph : 커밋 옆에 브랜치의 흐름을 그래프로 보여준다
# --decorate : 브랜치와 태그 등의 참조를 간결히 표시한다
# --all : all 옵션이 없을 경우 HEAD와 관계 없는 옵션은 보여주지 않는다 



$ git log --oneline
# 간단히 커멧 해시와 제목만 보고 싶을 때 

$ git log --oneline --graph --decorate
#HEAD와 관련도니 커밋들을 조금 더 자세히 보고 싶을 때 

$ git log --oneline -n5
# 내 브랜치의 최신 커밋을 5개만 보고 싶을 때 

$ git help <명령어>
# 해당 명령어의 도움말을 표시한다


# 도움말 기능 사용하기 
# git help <명령어> , 해당 명령어의 도움말을 표시한다 
$ git help status
$ git help commit


```

- 좋은 커밋메세지의 7가지 규칙
    1. 제목과 본문을 빈 줄로 분리한다
    2. 제목은 50자 이내로 쓴다
    3. 제목을 영어로 쓸 경우 첫 글자는 대문자로 쓴다
    4. 제목에는 마침표를 넣지 않는다
    5. 제목을 영어로 쓸 경우 동사원형(현재형)으로 시작한다
    6. 본문을 72자 단위로 줄바꿈한다
    7. 어떻게 보다 무엇과 왜를 설명한다

<hr>

- 원격저장소 관련 CLI 명령어 (remote, push, pull)
    - 로컬 저장소를 원격 저장소에 Push하기 위해서는 원격 저장소를 깃허브에서 만들어 등록한다
    
```
$ git remote add <원격저장소 이름> <원격 저장소 주소>
# 원격 저장소를 등록한다
# 원격 저장소는 여러 개 등록할 수 있지만 같으 별명의 원격저장소는 하나만 가질 수 있다
# 통상 첫번째 원격저장소를 origin으로 지정한다

$ git remote -v
# 원격 저장소 목록을 살펴본다 


$ git push -u origin master
# push와 동시에 업스트림 지정



```

<hr>

```
$ git remote add origin "원격 저장소 주소"

$ git remote -v

$ git push
# 에러 발생, [master] 브랜치와 연결된 원격 저장소의 브랜치가 없어서 발생한 오류
# 이전에는 git push origin master 와 같이 사용

$ git push -u origin master # push와 동시에 업스트림 지정

$ git log --oneline -n1 
# e0044ee (HEAD -> master, origin/master)
# 지금 HEAD가 가르키는 [master]는 로컬의 [master] 브랜치이고, [origin/maser]는
# 원격 저장소인 GitHub의 마스터 브랜치이다 
# 현재 상태는 HEAD, master, origin/master 모두 e0044ee 커밋을 가리키고 있다 

$ git push # Everything up-to-date




```

- 업스트림(upstream)브랜치는 로컬저장소와 연결된 원격 저장소를 일컫는 단어
- 업스트림 브랜치 설정을 위해서 —set-upstream 또는 -u 옵션을 사용한다
- 그러면 origin 저장소의 [master] 브랜치가 로컬 저장소의 [master] 브랜치의 업스트림으로 지정되어 git push 명령어만으로도 에러 없이 push가 가능해 진다
- 대개 git bash에서 긴 명령은 대시 두 개(—) 짧은 명령은 대시 한 개로 시작하는 경우가 많다

<hr>

- Clone
    - git clone <저장소주소> [새로운 폴더명]
        - 저장소 주소에서 프로젝트를 복제해 온다
        - 새로운 폴더명은 생략가능하다. 생략할 경우 프로젝트 이름과 같은 이름의 폴더가 새로 생성된다
        - git clone 명령어를 사용할 때 저장소 주소가 꼭 원격일 필요는 없으며 로컬 저장소도 git clone 명령어로 복제할 수 있다
        


```
$ pwd

$ cd ..

$ git clone "원격 저장소 주소"
# 에러 발생 할 수 있다 
# [새로운 폴더명] 옵션을 지정하지 않으면 복제한 프로젝트 이름과 같은 폴더를 만들게 된다
# 예를들어 hello-git-cli라는 로컬 저장소와 원격 저장소가 모두 있을 때 

$ git clone "원격 저장소 주소" hello-git-cli2

$ ls

$ cd hello-git-cli2

$ git log -- oneline 

$ git remote -v # 원격 저장소 목록 확인


```

```
$ echo "second" >> file1.txt # 파일에 내용 한 줄 추가 

$ cat file1.txt

$ git commit -a
# 스테이징 없이 바로 커밋
# -a 옵션을 사용하면 기존에 커밋 이력이 있는 파일 즉 modified 상태의 파일의
# 스테이징 과정을 생략할 수 있다 


```

```
$ cd ~/Documents/hello-git-cli # 처음 저장소로 이동

$ git log --oneline # 결과를 보면 커밋 하나만 있는 것 확인 

$ git pull # pull = fetch + merge

$ git log --oneline ## 커밋 두개 확인 

$ cat file1.txt


```

## Refernece
- [팀 개발을 위한 Git, GitHub 시작하기](http://www.hanbit.co.kr/store/books/look.php?p_code=B5159933380)
