## 명령어 출력을 파이프라인으로 받기 

- 셸 스크립트도 파이프라인으로 다른 명령어 다음에 사용할 수 있다
- 표준 입력을 사용하면 셸 스크립트에서도 다른 명령어 출력 결과를 직접 받을 수 있다 

- 스크립트를 실행할때 외부에서 정보를 넘기려면 명령줄인수 ($1)를 사용하는 방법도 있지만
- 표준 입력도 그처럼 스크립트 외부에서 정보를 넘기는 입구 중 하나이다 
- grep이나 cut 같은 명령어도 파이프라인을 통해 이전 명령여 출력을 받아들일 때 표준입력을 사용하고 있다 

- read-sample.sh

```
#!/bin/bash

read input
echo "입력은 <$input> 입니다 
```

```
$ echo "안녕하세요" | ./read-smaple.sh
# 입력은 안녕하세요 입니다

```

- 파이프라인으로 넘긴 내용은 표준 입력으로 들어오는데 내버려 두면 사용하지 않는다
- 따라서 표준 입력에서 들어온 내용을 사용하려면 read 명령어로 능동적으로 읽어 들일 필요가 있다 

- read 명령어는 실행 한 번에 표준 입력에서 한 줄의 내용을 읽어 들이기 때문에 전부 읽어 들이러면 그 만큼 반복해서 실행해야 한다 
- 예를들어 while문을 사용할 경우, read도 명령어 이므로 표준 입력을 읽어 들이면 성공, 읽지 못하면 실패라는 결과가 된다 

```
#!/bin/bash

while read line
do
    echo "입력은 <$input> 입니다"
done

```

- mktemp 명령어를 실행하면 임시 저장용으로 기존 파일과 겹치지 않는 새로운 빈 파일을 만든다
- 거기에 read로 읽은 내용을 저장해두면 로그 파일 대신에 사용할 수 있는 임시 파일이 된다 

```
tempfile = $(mktemp) # 작성한 임시 파일 경로를 명령어 치환을 사용해서 tempfile이라는 변수로 참조 
while read line # 표준 입력을 한줄 씩 읽기 
do
    echo "$line" >> $tempfile # 읽은 내용을 임시 파일에 기록 
done
log = $tempfile

cat $ log | ... # 임시 파일은 그 뒤의 처리에서 그대로 로그 파일 대신에 사용

```

```
#!/bin/bash

log = $1 # 기본적으로 명령줄 인수로 지정한 파일을 사용

if [ "$1" == ""] # 인수로 파일이 지정되지 ㅇ낳으면 표준 입력을 저장한 임시 파일을 사용
then
    tempfile = $(mktemp)
    while read line
    do
        echo "$line" >> $tempfile
    done
    log = $tempfile
fi

cat $log |cut -d " " -f 7 | sort | uniq -c | sort -r | head -n 10 > ./top.txt


if [ "$tempfile" != ""] # 사용이 끝난 임시 파일은 삭제 
then
    rm $tempfile
fi


```

- [ 명령어는 test 명령어
- 판정 결과를 종료 스테이터스로 돌려주는 명령어

```
$ test 10 -gt 5
$ echo $? 
# 종료 스테이터스가 0
# = 성공
# = 지정한 조건이 참

$ [10 -gt 5]
$ echo $?

```

### Reference
  - [만화로 배우는 리눅스 시스템 관리](http://www.yes24.com/Product/Goods/32402055?Acode=101)
