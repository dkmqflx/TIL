
## 9. 오래전에 실행한 명령어 호출(명령어 이력 검색)

- 명령어 이력에는 오랫동안 쓰지 않은 명령어는 남아 있지 않는다
- bash는 실행되었을 때 명령어 이력 내용을 .bash_history라는 파일에서 읽어온 다음 메모리에 복사해 둔다
- bash에서 실행한 명령어 이력은 그 복사본에 저장되고 이력 검색 대상이 된다
- bash를 종료할 때 .bash_history에 이력을 저장한다

```
$ vim ~/.bashrc

#SHIFT + G로 파일 맨 아래로 이동

$ export HISTSIZE 10000 # 메모리에 저장할 이력의 최대 건수 
$ export HISTFILESIZE=10000 # .bash_history에 저장할 이력의 최대 건수

# :wq로 파일 저장 후 재 실행
```

<hr>

- GNOME 단에서 탭을 새롭게 열면 다른 bash가 실행된다
- 그리고 각각의 bash는 각자의 이력 복사본을 가지게 된다
- 따라서 어떤 화면에서 실행한 명령어는 다른 화면 bash 명령어 이력에서 검색할 수 없다
- 아래 설정을 추가하면 .bash_history와 메모리 복사본을 자주 동기화 한다
- 이 방법을 사용하면 다른 화면 bash 에서 실행한 명령어도 명령어 이력 검색에서 찾을 수 있다

```
# vim ~/.bash_history 파일을 열어서 끝에 아래 내용 추가  

function share_history{
				history -a
				history -c
				history -r
}
PROMPT_COMMAND='share_history'
shopt -u histappend
```
