## 팀 개발을 위한 Git, GitHub 시작하기 (Ch7) - (2)

- CLI로 3-way 병합하기

- 긴급한 병합 시나리오
    - 버그를 발견한 상황에서 버그 수정은 다음과 같은 단계로 이루어 진다
        1. (옵션) 오류가 없는 버전(주로 Tag가 있는 커밋)으로 롤백
        2. [master] 브랜치로부터 [hotfix]브랜치 생성
        3. 빠르게 소스 코드 수정 / 테스트 완료
        4. [master] 브랜치로 병합 (Fast-forward) 및 배포
        5. 개발 중인 브랜치에도 병합 (충돌 발생 가능성이 높음)
- 버그가 발생한 상황에서는 원래 작업 중이던 브랜치도 [master[ 브랜치로 부터 시작했기 때문에 같은 버그를 가지고 있을 것이다
- 때문에 [hotfix] 브랜치의 내용은 [master] 브랜치와 개발 브랜치 모두에 병합 되어야 한다
- 보통 [master] 브랜치의 병합은 빨리 감기이기 때문에 쉽게 되는 반면 개발 중인 브랜치의 병합은 병합 커밋이 생성되고 충돌이 일어날 가능성이 높다

```
$ git checkout master

$ git checkout -b feature1 # 브랜치 생성 및 체크아웃

$ echo "기능 1 추가" >> file1.txt

$ git add file1.txt

$ git commit

$ git log --oneline --all --graph -n2


```

- 위 상황에서 커밋한 이후 장애가 발견되었을 때
- [master] 브랜치에서 [hotfix] 브랜치를 만들고 버그를 고친 후에 커밋을 한다
- 그리고 [hotfix]브랜치를 [master]브랜치에 병합한다
- [master]브랜치의 최신 커밋을 기반으로 [hotfix] 브랜치 작업을 했기 때문에 빨리 감기 병합이 가능하다

```
$ git checkout -b hotfix master # master로 부터 hotfix브랜치 생성, 체크아웃

$ git log --oneine --all -ne # 2개의 커밋 로그만 보기 

$ echo "some hot fix" >> file1.txt

$ git add file1.txt

$ git commit

$ git log --oneline -n1

$ git checkout master

$ git merge hotfix

$ git push


```

- hotfix 커밋은 버그 수정이었기 때문에 이 내용을 현재 개발 중인 [feature1] 브랜치에도 반영해야 한다
- [feature1] 브랜치와 [master] 브랜치은 서로 다른 분기로 진행되고 있다.
- 이 경우에는 빨리 감기 병합이 불가능 하므로 3-way 병합을 해야한다
- 따라서 병합 커밋이 생성된다
- 모든 3-way 병합이 충돌을 일으키는 것은 아니지만 두 브랜치 모두 file1.txt를 수정했기 때문에 충돌이 발생한다


- master 브랜치의 file1.txt
    - hello git
    - second
    - third - my branch
    - fourth
    - some hot fix
- feature1 브랜치의 file1.txt
    - hello git
    - second
    - third -my branch
    - fourth
    - 신규기능1

```
$ git checkout feature1 

$ git log --oneline --all

$ git merge master # master 브랜치와 병합
# 충돌 발생

$ git status # 실패 원인 파악

# visual studio (editor)를 열어서 충돌이 일어난 부분을 수정한 후

$ cat file1.txt

$ git add file1.txt

$ git status

$ git commit

$ git log --oneline --all --graph -n4


```

- CLI로 rebase하기
    - 3-way로 병합을 하면 병합 커밋이 생성되기 때문에 트리가 다소 지저분해진다는 단점이 있다
    - 이럴 때 트리를 깔끔하게 하고 싶다면 rebase를 사용할 수 있다
    
```

# rebase의 원리 
1. HEAD와 대상 브랜치의 공통 조상을 찾는다(아래 그림의 C2)
2. 공통 조상 이후에 생성한 커밋들 (C4, C5 커밋)을 대상 브랜치의 뒤로 재배치한다 

C1 <-- C2 <--  C3 (master)
                ↑
                -----C4 <-- C5(*feature1)


C1 <-- C2 <-- C3(master) <-- C4' <-- C5'(*feature1)
```

- feature 브랜치는 HEAD이므로 *이 붙어 있다
- git rebase master 명령을 수행하면 공통 조상인 C2 이후 커밋인 C4와 C5를 master 브랜치의 최신 커밋인 C3 뒤쪽으로 재배치를 수행한다
- 재배치된 C4, C5 커밋은 C4', C5' 커밋이 되는데 이 커밋은 원래의 커밋과 다른 커밋이라는 뜻이다
- rebase 전과 후에 커밋 체크섬을 확인해보면 값이 달라진 것을 확인할 수 있다
- rebae 명령어는 주로 로컬 브랜치를 깔끔하게 정리하고 싶을 때 사용한다
- 여러 git 가이드에서 원격 저장소에 존재하는 브랜치에 대해서는 rebase를 하지 말 것을 권장한다

```
$ git checkout feature1 

$ git reset --hard HEAD~ # 현재 블내치를 한 단계 되돌린다 

$ git log --oneline --graph --all -n3

$ git rebase amster 
# HEAD 브랜치의 커밋을 master로 재배치

$ git push # 원격에 푸시

# 충돌로 인해 rebase는 실패한다. 충돌을 수정한다

$ git status

$ git add file1.txt

$ git status

$ git rebase --continue
# 리베이스 계속 진행
# merge는 마지막 단계에서 git commit 명령을 사용하지만 
# rebaes는 git rebase --continue 명령을 사용한다

$ git log --oneline --all --graph -n2

$ git checkout master

$ git merge feature1 # 빨리감기 병합 
        
```

- 3-way병합은 기존 커밋의 변경 없이 새로운 병합 커밋을 하나 생성한다
- 따라서 충돌도 한 번만 발생한다
- 충돌 수정 완료 후 git commit 명령을 수행하면 merge 작업이 완료된다
- 그러나 rebase는 재배치 대상 커밋이 여러 개일 경우 여러 번 충돌이 발생할 수 있다
- 또한 기존의 커밋을 하나씩 단계별로 수정하기 때문에 git rebase —continue 명령으로 충돌로 인해 중단된 rebase를 재개하게 된다
- 여러 커밋에 충돌이 발생했다면 충돌을 해결할 때 마다 git rebase —continue 명령을 매번 입력해야 한다
- 3-way 병합
    - 특징 : 머지 커밋 생성
    - 장점 : 한번만 충돌 발생
    - 단점 : 트리가 약간 지저분 해짐
- rebase
    - 특징 : 현재 커밋들을 수정하면서 대상 브랜치 위로 재배치함
    - 장점 : 깔끔한 히스토리
    - 단점 : 여러번 충돌이 발생할 수 있음

<HR>
 
 
![rebase](https://user-images.githubusercontent.com/42763164/75947543-0bb22480-5ee4-11ea-83d3-7d2eafc8e324.JPG)


- 위 사진처럼 master 브랜치만 사용했는데도 뻗어나오는 가지가 생기는 경우가 있다
- 보통 이런 상황은 두 대의 PC에서 한 브랜치에 작업을 하는 경우 생긴다
- 한 PC에서 커밋을 생성하고 push를 했는데 다른 PC에서 pull을 하지 않고 커밋을 하게 되면 이전 커밋을 부모로한 커밋이 생긴다.
- 그 상황에서 뒤늦게 pull을 하면 자동으로 3-way 병합이 되기 때문에 위 그림처럼 모양이 생기게 된다
- 이를 해결하는 방법으로는 reset —hard로 병합 커밋을 되돌리고 rebase를 사용하는 것이다

- 우선 상황을 만들어 준다

```
# 보통 커밋 만들기 

$ echo "master1" > master1.txt

$ git add master1.txt

$ git commit -m "master 커밋 1"

$ git push origin master

$ git log --oneline -n1

$ ls # 작업 디렉토리 상태 호가인 
```

```
# 가지 커밋 만들기

$ git reset --hard HEAD~ # HEAD를 한 단계 되돌리기

$ echo "master2" > master2.txt 

$ git add . 
# 스테이지에 추가 
# . 은 모든 것(all), 즉 working directory 전체를 의미하는데 all은 권장하지 않는다
# 중요한 설정 파일까지 add할 필요가 없기 때문이다 

$ git commit -m "master 2 커밋"

$ git log --oneline --graph --all -n3

$ git pull # 충돌 생긴다 

$ git log --oneline --graph --all -n4 # 병합 커밋 생성 확인


# 병합커밋이 생기는 빈도는 그리 놓지 않다 
# 따라서 pull을 사용하고 그 때 병합커밋이 생성되면 
# hard reset을 이용해 되돌리고 rebase를 하면 된다 

```

```
# rebase로 가지 없애기

$ git reset --hard -HEAD~
# 마지막 커밋은 병합 커밋이므로 병합되기 전 커밋으로 돌아간다 
# 이 커밋은 튀어나온 가지 커밋이므로 재배치 해야 한다 

$ git rebase origin/aster 
# 이 명령어를 수행하면 로컬 amster 브랜치의 가지 커밋이 
# origin/master 브랜치 위로 재배치 된다 

$ git log --oneline --all --graph -n3

$ git push

```

- rebase를 사용할 때, 원격 저장소에 푸시한 브랜치는 rebase하지 않는 것이 원칙이다
- 예를 들어 C1 커밋을 원격에 푸시하고 rebase를 하게 되면 원격에서 C1이 존재하고 로컬에는 다른 커밋인 C1'이 생성된다
- 이 때 내가 아닌 다른 사용자는 원격에 있던 C1을 병합할 수 있다
- 그런데 변경된 C1'도 언젠가는 ㅍ ㅜ시되고 그럼 원격에는 같은 커밋이었던 C1과 C1'이 동시에 존재하게 된다
- 이 상황에서 또 누군가는 충돌을 해결하기 위해 merge와 rebase를 사용하게 되는데 이 경우 동일한 커밋의 사본도 여러개 존재하고, 충돌도 발생하고, 히스토리가 꼬이는 상황이 생긴다
- 따라서 rebase와 git의 동작 원리를 이해하기 전까지는 가급적 rebase는 아직 원격에 존재하지 않는 로컬 브랜치들에만 적용한다

<HR>

- 임시 브랜치 사용하기
- 입문자들이 merge나 rebase할 때 소스가 깨지거나 작업의 내용이 사라지는 걱정이 있는데 이럴 때 임시브랜치를 활용한다
- 원래 작업하려고 했던 브랜치의 커밋으로 임시 브랜치를 만들고 나면 해당 브랜치에서는 아무작업이나 해도 상관이 없다
- 나중에 그 블내치를 삭제하기만 하면 모든 내용이 원상 복구 된다
- 임시 브랜치가 필요 없어지는 git branch -D <브랜치 이름> 명령으로 삭제할 수 있다

```
$ git branch test feature1 # featue1 브랜치에서 임시 브랜치 생성

$ git checkout test

$ echo "abc" > test1.txt

$ git add .

$ git commit -m "임시 커밋"

$ git log --oneline --graph --all -n4


$ git checkout master

$ git branch -D test

$ git log --oneline --graph --all -n3
```

## Refernece
- [팀 개발을 위한 Git, GitHub 시작하기](http://www.hanbit.co.kr/store/books/look.php?p_code=B5159933380)
