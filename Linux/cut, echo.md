
## Ch17. 로그 파일에서 필요한 줄만 뽑기(cut)

- 아파치 로그에서 접속수가 많은 페이지와 적은 페이지 목록 출력하는 방법  
    - 적절하지 않은 줄을 제외하고 필요한 줄만 집계 대상으로 삼음
    - 로그 각 줄에서 접속한 페이지 경로를 추출
    - 경로 등장 횟수를 카운트
    - 등장 횟수로 경로를 재정렬
    - 상위와 하위 항목을 추출

- cut 명령어
    - 파이프로 넘어온 내용의 각 줄마다 필요한 부분만 잘라서 돌려준다
    - 구분자(delimiter)와 함께 쓴다
    - 보통 아래 두 옵션과 함께 사용
        - --delimiter "구분자" 또는 -d "구분자"
        - --fields 추출할위치 또는 -f 추출할 위치

- 1. 적절하지 않은 줄을 제외하고 필요한 줄만 집계 대상으로 삼음

```
$ cat /var/log/apache2/access.log | grep -v "/live"
```

- 2. 로그 각 줄에서 접속한 페이지 경로를 추출

- 다음과 같은 로그 있을 때 아래 옵션 쓰면 /path.to.page 부분만 추출할 수 있다 
- 192.168.113 - - [7/Feb/2013:15:02:57 +0900] "GET /path/to/page HTTP1.1" 200 13472 "-" Mozilla/5.0 (Windows NT 6.0; rv:17.0)

```

$ cat /var/log/apache2/access.log | grep -v "/live" | cut -d " " -f 7 | less
# /path.to.page 부분만 추출
```

```
$ cat /var/log/apache2/access.log | grep -v "/live" | cut -d "[" -f 2| cut -d "]" -f 1
# 7/Feb/2013:15:02:57 +0900 시간만 출력


```

- echo 명령어
    - 인수로 넘어온 문자열을 출력하기만 하는 명령어
    - $PWD 값이 /var/log/apache2라면
    - echo "&#36;PWD" | cut -d "/" -f 2
        - 변수 값 var을 다른 명령어에 넘길 수 있다 
    

### Reference

  - [만화로 배우는 리눅스 시스템 관리](http://www.yes24.com/Product/Goods/32402055?Acode=101)
