## 팀 개발을 위한 Git, GitHub 시작하기 (Ch7) - (1)

- Branch 생성하기
- 일반적으로 새로운 기능을 개발하기 위해서 브랜치를 생성하고 개발한 다음, 개발이 완료되면 [master] 브랜치로 병합한다
- 브랜치에 * 기호가 있는 경우 현재 작업중인 브랜치, 즉 HEAD를 나타낸다
- 최신 커밋은 부모 커밋을 가르킨다
- 따라서 커밋은 부모 커밋에 대한 정보를 담고 있는 반면 부보 커밋은 자식 커밋에 대한 정보를 담고 있지 않다
- 어느 커밋에서 정보를 가져오면 부모 커밋을 알 수 있지만 자식 커밋을 알 수 없다
- 병합을 통해 생성된 병합 커밋에는 부모 커밋이 두개 존재한다
- 커밋하면 커밋 객체가 생긴다. 커밋 객체에는 부모 커밋에 대한 참조와 실제 커밋을 구성하는 파일 객체가 들어있다
- 브랜치는 논리적으로는 어떤 커밋과 그 조상들을 묶어서 뜻하지만, 사실은 단순히 커밋 객체 하나를 가르키는 것이다

<hr>

- 브랜치를 사용하는 경우
    - 새로운 기능추가
        - 대표적으로 브랜치를 사용하는 경우
        - [master]브랜치에는 정상적으로 동작하는 안정적인 버전의 프로젝트가 저장되어 있기 때문에 기능을 추가할 때는 [master] 브랜치의 최신커밋으로 브랜치를 생성해서 개발한다
        - 이후 완료한 다음 이상이 없으면 [master]브랜치로 병합한다
    - 버그 수정
        - 버그가 발생하면 [master]브랜치로부터 새로운 브랜치를 생성해서 작업한다
        - 이 때 브랜치 이름은 hotFix, bugFix 같은 이름을 사용한다
        - 버그 수정이 끝나면 [master] 브랜치로 병합한다
    - 병합과 리베이스 테스트
        - 병합이나 리베이스는 입문자에게 까다로운 일 중하나이다
        - 임시 브랜치를 만들어서 병합과 리베이스 테스트를 해본다
        - 잘못되었을 경우 그냥 브랜치를 삭제하면 된다
    - 이전 코드 개선
        - 새로 브랜치를 만들어 이전 코드를 과감하게 삭제하고 새 코드를 작성한다
        - 다른 브랜치의 이전 커밋에는 잘 돌아가는 코드가 남아 있기 때문에 새롭게 코드를 작성하는 것에 대해서 걱정할 필요가 없다
    - 특정 커밋으로 돌아가고 싶을 때
        - 이미 저장 되어 있는 특정 커밋으로 돌아가고 싶을 때 일반적으로 hard reset이나 revert를 사용한다. 하지만 hard reset의 경우 커밋이 없어질 수 있기 때문에 추천하지 않고 revert는 사용이 조금 까다롭다
        - 이 경우 브랜치를 새로 만들어서 작업을 하고 이후 리베이스나 병합을 사용하는 것이 좋다

```
git branch [-v]
# 로컬 저장소의 브랜치 목록을 보는 명령어
# -v 옵션을 사용하면 마지막 커밋도 함께 표현된다
# 표시된 브랜치 중에서 일므 왼쪽에 *가 붙어 있으면 HEAD 브랜치이다

git branch [-f] <브랜치이름> [커밋체크섬]
# 새로운 브랜치를 생성한다
# 커밋체크섬 값을 주지 않으면 HEAD로 부터 브랜치를 생성한다
# 이미 있는 브랜치를 옮기고 싶을 때는 -f 옵션을 사용한다 

git branh -r[v]
# 원격 저장소에 있는 브랜치를 보고 싶을 때
# -v 옵션을 추가하면 커밋 요약을 볼 수 있다

git checkout <브랜치이름>
# 특정 브랜치로 체크아웃 할 때 

git checkout -b <브랜치이름> <커밋 체크섬>
# 특정 커밋에서 브랜치를 새로 생성하고 동시에 체크아웃 까지 한다 

git merge <대상 브랜치>
# 현재 브랜치와 대상 브랜치를 병합할 때 사용
# 병합 커밋이 새로 생기는 경우가 많다 

git rebase <대상 브랜치>
# 내 브랜치의 커밋을 대상브랜치에 재배치 시킨다
# 히스토리가 깔끔해져서 자수 사용하지만 조심해서 사용해야 한다 

git branch -d <브랜치이름>
# 특정 브랜치를 삭제한다
# HEAD 브랜치나 병합이 되지 않은 브랜치는 삭제할 수 없다

git branch -D <브랜치이름>
# 브랜치를 강제로 삭제 
# -d로 삭제할 수 없는 브랜치를 지우고 싶을 때 사용한다
# 조심해서 사용해야 한다 



```

<Hr>

```

$ cd ~/Documents/hello-git-cli

(master) $ git log -- oneline # 커밋 로그 보기

(master) $ git branch # 현재 브랜치 확인
# * master
# HEAD->master와 동일한 의미

(master) $ git branch mybranch1 # 새로운 브랜치 생성

(master) $ git branch # 현재 브랜치 확인

(master) $ git log --oneline --all # 변경된 브랜치 확인 




```

- HEAD
    - HEAD는 현재 작업 중인 브랜치를 가리킨다
    - 브랜치는 커밋을 가리키므로 HEAD도 커밋을 가리킨다
    - 결국 HEAD는 현재 작업 중인 브랜치의 최근 커밋을 가리킨다

<hr>

- revert를 사용해서 커밋을 되돌려야 하는 경우


```
C1 <--- F1 <--- C2 <--- F2 <--- C3(master)
# F1과 F2를 취소하고 싶은 경우 revert를 사용해서 이를 해결 할 수 있다



$ git revert F2
$ git revert F1

C1 <--- F1 <--- C2 <--- F2 <--- C3 <--- RF2 <--- RF1(master)
# git revert를 실행할 때는 최신 커밋 부터 취소를 하는 것이 좋다 
# 이렇게 하면 F2와 F!을 취소하는 커밋(RF2, RF!)을 각각 만들어 낸다
# 이전의 히스토리를 변경하지 않고도 깔끔하게 히스토리 중간의 여러 커밋 내용을
# 작업 이전 상태로 되돌릴 수 있으므로 현업에서도 유용하게 사용한다 


```

<hr>

- CLI로 checkout 하기
- checkcout 명령은 브랜치의 내용을 워킹트리에 반영할 때 사용한다
- 정확하게는 브랜치가 가르키고 있는 커밋의 내용을 워킹트리에 반영한다

```
(master)$ git checkout mybranch1 # 브랜치 체크아웃

(mybranch1)$ git branch # 현재 브랜치 확인
# * mybranch1

(mybranch1)$ git log --oneline --all 

(mybranch1)$ cat file1.txt 

(mybranch1)$ echo "third -my branch" >> file1.txt

(mybranch1)$ cat file1.txt

(mybranch1)$ git status

(mybranch1)$ git add file1.txt

(mybranch1)$ git commit

(mybranch1)$ git log --oneline all # 변경된 브랜치 확인


```

- git checkout <커멧체크섬>을 사용하는 경우 HEAD와 브랜치가 분리되는 Detached HEAD 상황이 된다
- 이 상황에서도 커밋을 생성할 수 있지만 다른 브랜치로 체크아웃하는 순간 Detached HEAD의 커밋은 다 사라져서 안보이게 된다
- 커밋은 로컬저장소에 남아 있기 때문에 git reflog 명령으로 복구할 수 있지만 권장하지 않는 작업 방법이다
- 공식 홈페이지도 브랜치를 사용해서 체크아웃을 하고 있다

<hr>

```
# 커밋 전
mybranch1(HEAD)------>   [df1f4d1]
				 --->       ↓
			     |
master------------       [cd6e80a]    




# 커밋 후

mybranch1(HEAD)------>   [905dda3]
                            ↓
master         ------>   [df1f4d1]
							↓
									
						 [cd6e80a]      


```

- 새로운 커밋을 생성하면 그 커밋의 부모는 언제나 이전 HEAD 커밋이다
- 커밋이 생성되면 HEAD는 새로운 커밋으로 갱신된다
- HEAD가 가리키는 브랜치도 HEAD와 함께 새로운 커밋을 가리킨다

<hr>

- CLI를 이용한 빨리 감기 병합

```
# 커밋 전

mybranch1(HEAD)------>   [905dda3]
	                        ↓
master         ------>   [df1f4d1]
							↓
					    [cd6e80a]



# 커밋 및 병합 후

mybranch1(HEAD)------> [2dbc561]
                  -->
	             |        ↓													
master       ------   [905dda3]
	                      ↓
master       ------>  [df1f4d1]
						 ↓
					  [cd6e80a]

```

<HR>

- 빨리 감기(fast-forward) 병합으로 완료 된다 

```
(mybranch1)$ echo "fourth - my branch" >> file1.txt

(mybranch1)$ cat file1.txt

(mybranch1)$ git status

(mybranch1)$ git add file1.txt

(mybranch1)$ git commit

(mybranch1)$ git log --oneline --all --graph # 커밋 로그 보기 

(mybranch1)$ git checkout master

(master)$ cat file1.txt

(master)$ git merge mybranch1

(master)$ git log --oneline --all --graph

(master)$ cat file1.txt


```

<HR>

- reset —hard로 브랜치 되돌리기
    - rest은 현재 브랜치를 특정 커밋으로 되돌릴 때 사용한다
    - git reset —hard <이동할 커밋 체크섬>
        - 현재 브랜치를 짖어한 커밋으로 옮긴다. 작업 폴더의 내용도 함께 변경된다
        - —hard 옵션을 사용하려면 커밋 체크섬을 알아야 한다
        - git log를 통해 확인할 수 있지만 복잡한 커밋 체크섬을 하는 것은 번거롭기 때문에 HEAD~ 또는 HEAD^로 시작하는 약칭을 사용한다
        
- HEAD~<숫자>
    - HEAD&#126; 는 헤드의 부모 커밋, HEAD~2는 헤드의 할아버지 커밋을 의미한다
    - HEAD~n은 n번째 위쪽 조상이라는 뜻
    
- HEAD^<숫자>
    - HEAD^는 똑같이 부모 커밋
    - 반면 HEAD^2는 두번째 부모를 가르킨다
    - 병합 커밋처럼 부모가 둘 이상인 커밋에서만 의미 있다    
    

```

# reset은 현재 브랜치를 특정 커밋으로 되돌릴 때 사용한다 
# 현재 브랜치를 지정한 커밋으로 옮기다. 작업 폴더의 내용도 함께 변경된다 
# --hard 명령을 사용하려면 커밋 체크섬을 알아야 한다 
git reset --hard <이동할 커밋 체크섬>



$ git reset hard HEAD~2
# HEAD를 2단계 이전으로 되돌리기 

$ git log --oneline --all # 로그 확인

#e79f81e (mybranch1) my branch1의 두번째 커밋
#9081938 mybranch1의 첫번째 커밋
#e5a7ece (HEAD -> master, origin/master) 두 번째 커밋
#e0044ee 첫 번째  커밋

```

- 방금 reset hard 명령어 결과는 아래와 같다


```

# hard reset 이전

mybranch1(HEAD)------>
						  [2dbc561]
master         ------> 	     ↓
						  [905dda3]
	                         ↓
						  [df1f4d1]
							 ↓
						  [cd6e80a]



# hard reset 이후


mybranch1(HEAD)------>	 [2dbc561]
							↓
master         ------>	 [905dda3]
	                        ↓
						 [df1f4d1]
							↓
						 [cd6e80a]


```

- reset —hard 명령어는 checkout 명령과 비슷하다

```
# reset --hard 명령어는 아래 세 명령어를 한번에 수행하는 명령어이다 
$ git checkdout HEAD~2 # master 브랜치는 그 자리에 있고 HEAD만 옮겨진다(detached HEAD 상황)
$ git branch -f master # 다시 master 브랜치와 HEAD를 연결
$ git checkdout master


```

<hr>

- git rebase <대상브랜치> 명령은 현재 브랜치에만 있는 새로운 커밋을 대상 브랜치 위로 재배치 시킨다
- 그런데 현재 브랜치에 재배치할 커밋이 없는 경우 rebase는 아무런 동작을 하지 않는다
- 또한 빨리 감기 병합이 가능한 경우 rebase 명령을 수행하면 빨리 감기 병합을 한다

```
# rebase 이전


mybranch1(HEAD)------>	 [2dbc561]
							↓
						 [905dda3]
	                        ↓
master         ------>	 [df1f4d1]
							↓
						 [cd6e80a]



# rebase 이후


mybranch1(HEAD)------>
						  [2dbc561]
master         ------> 	     ↓
						  [905dda3]
	                         ↓
						  [df1f4d1]
							 ↓
						  [cd6e80a]
 

```

- merge 명령 대신 rebase를 이용해서 빨리 감기 병합을 하고 mybranch를 제거


```
$ git checkout mybranch1

$ git rebase master
# mybranch1 브랜치는 이미 master 브랜치 위에 있기 때문에 재배치할 커밋이 없다
# 그래서 rebase master를 수행해도 아무 일도 일어나지 ㅇ낳는다 

$ git log --oneline --all

$ git checkout master

$ git rebase mybranch1
# rebase 명령어로 master 브랜치를 mybranch1 브랜치로 재배치를 시도한다
# 빨리 감기가 가능한 상황이기 때문에 rebase는 merge 명령과 마찬가지로 빨리 감기를 하고 작업을 종료한다 

$ git log --oneline --all

$ git push

$ git branch -d mybranch # 브랜치 삭제

$ gt log --oneline --all -n2 # 로그 확인

```

<hr>

- 배포 버전에 태익하기
- 태그에는 주석이 있는 태그와 간단한 태그 두 종류가 있다
- 태그는 차후에 커밋을 식별할 수 있는 유용한 정보
- 태그를 사용하면 GitHub의 [Tags] 탭에서 확인할 수 있고, [Release] 탭에서 다운 받을 수 있다

```
git tag -a -m <간단한 메시지> <태그 이름> [브랜치 또는 체크섬]
# -a로 주석있는(annotated) 태그를 생성한다
# 메시지와 태그 이름은 필수이며 브랜치 이름을 생략하면 HEAD에 태그를 생성한다 

git push <원격 저장소 별명> <태그 이름>
# 원격 저장소에 태그르 업로드 한다 


```


```
$ git log --oneline # 로그 확인

$ git log -a -m "첫 번째 태그 생성" v0.1

$ git log --oneline # 태그  생성 확인

$ git push origin v0.1 # 태그 푸시

```

## Refernece
- [팀 개발을 위한 Git, GitHub 시작하기](http://www.hanbit.co.kr/store/books/look.php?p_code=B5159933380)
