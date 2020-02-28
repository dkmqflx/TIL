
## 10. 네트워크 건너서 파일 복사(scp)

- scp는 Secure CoPy의 약어로 네트워크를 통해서 파일을 복사하는 명령어


- 원격 서버 —> 로컬 서버로 파일 전송할
- scp [옵션][계정명]@[원격지IP주소]:[원본 경로 및 파일][전송 받을 위치]

```
# ex. IP 123.456,789 서버의 aaa 계정으로 /home/aaa/ex.txt 파일을 로컬 서버 /home/me/디렉토리에 전송 받을 때
scp aaa@123.456.789:/home/aaa/ex.txt /home/me

#파일명이 txt인 모든 파일을 복사
scp aaa@123.456.789:/home/aaa/*.txt /home/me

# r 옵션으로 디렉터리를 재귀적으로 복사
# home/aaa로 복사 원본 경로로 디렉터리 저장
scp -r aaa@123.456.789:/home/aaa/ /home/me

```

<hr>

- 로컬서버 —> 원격 서버로 파일 전송
- scp [옵션][원본 경로 및 파일] [계졍명]@[원격지IP주소]:[전송할 경로]

```
# ex. 로컬 서버 /home/me/ex1.txt파일을 IP 123.456,789 서버aaa 계정의 /home/aaa/로 전송할 때

scp /home/me/ex1.txt aaa@123.456.789:/home/aaa/
```

<hr>

- 서버에서 서버로 파일 복사

```
$ scp one@server1:/data/file two@server2:/data2/file2
# 복사 원본 서버명과 서버 경로       복사 대상 서버명과 서버 경로
```

- scp는 복사 원본이나 복사 대상에 다른 컴퓨터 파일을 지정하는 것 이외에는 cp와 다르지 않다
```
$ cp ./file.txt /tmp/

```
### Reference
  - [만화로 배우는 리눅스 시스템 관리](http://www.yes24.com/Product/Goods/32402055?Acode=101)
