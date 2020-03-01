
## 같은 처리를 1시간마다 반복 실행하기 

- while
    - 단순히 같은 처리를 반복해서 실행하고 싶으면 while 반복 사용
    - while 반복은 조건을 만족하는 동안 처리를 반복해서 실행한다 
    - for 반복문은 파일 목록을 처리할 때 처럼 목록 내용을 하나씩 처리하기 위한 구문
    - 목록 처리에는 잘 어울리지만 그저 같은 걸 단순히 반복하고 싶은 경웅는 while문이 더 잘 어울린다 

```
#!/bin/bash

count = 0

while[ $count != 10]
do
    echo $count
    count = $(($count + 1 ))
done

```

- 웹페이지에 접속할 때는 curl 명령어를 사용한다 
- curl 
    - 인수로 지정한 URL에 접속해서 받은 결과를 출력하는 명령어
    
- sleep
    - 지정한 초 만큼 처리를 멈추는 명령어 
    - 처리를 일부러 천천히 진행하고 싶을 때 사용한다 

```
#!/bin/bash

count = 0

while[ $count != 3600] # 3600회 반복
do
    curl "http://..." # 웹 페이지 접속
    sleep 1           # 1초 대기 
    count = $(($count + 1 ))
done

# 1초 간격으로 3600회 반복한다면 전체는 3600초 (1시간) 정도 걸린다 
# 도중에 강제로 스크립트 실행을 중지하고 싶을 때 Ctrl+c
```

### Reference

  - [만화로 배우는 리눅스 시스템 관리](http://www.yes24.com/Product/Goods/32402055?Acode=101)
