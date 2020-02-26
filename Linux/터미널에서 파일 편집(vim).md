
## 4. 터미널에서도 대화형으로 파일 편집하기(vim)

- 데스크톱 환경 : 윈도우가 있고 마우스로 조작가능한 환경
- 서버를 구축할 때는 서버 처리 능력을 최대한 활용하기 위해서 데스크톱 같은 건 빼고 최소 구성으로 설치하는 경우 많다. 
- vim은 vi의 강화판

- 설치방법
    - sudo apt-get install vim
    - yum install vim

- vim 명령어 뒤에 편집하고 싶은 파일 경로를 적는다
- 단, 시스템 설정 파일을 변경하려면 sudo명령어를 붙여준다
- i : Insert mode.
    - 화살표키로 커서 움직이기 가능
    - 키 입력으로 문자입력

```
sudo vim "편집하고 싶은 파일 경로"
sudo vim /etc
```

---------------

- 어떤 모드에 있던지 esc누르면 normal mode로 돌아가게 된다
- 수정 후에는 esc 눌러서 normal mode로 돌아간 후에 :wq 입력 후 Enter

```
:wq
```

- Insert : 끼워넣기 모드
- Write : 디스크에 쓰기
- Quit : Vim 종료

- 기본적인 흐름은, 파일을 normal mode로 열어서 편집모드에 들어가서 편집하고, normal mode로 돌아가서 저장하고 종료.

- / (검색모드)
- / 눌러서 검색하고 싶은 문자열을 입력하고 Enter
- text라는 문자열 찾고 싶은 경우
    - /text 
- 내가 찾고 싶은 곳까지 스크롤 된다.


- N (Next)
    - next의 단축키로, /로 검색한 다음에는 normal mode에서 N을 누르면 검색된 곳을 순서대로 갈 수 있다. 
    - 반대방향으로 돌아가러면 SHIFT키를 누른채로 N키
    - 검색에는 정규표현식도 가능하다 이 경우에는 / 뒤에 \v(백슬래쉬, 소문자v)를 써준다
    - ex) /\v(Cp949|EUC - KR)

vim 치트시트
https://vim.rtorr.com/lang/ko

  ------
  
  ### Reference
  
  - [만화로 배우는 리눅스 시스템 관리](http://www.yes24.com/Product/Goods/32402055?Acode=101)
