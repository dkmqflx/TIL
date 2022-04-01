
## Ch21. 조건에 따라 처리 흐름 바꾸기(조건 분기)

- &#36;#는 스크립트에 지정한 인수개수를 의미하는 변수
- &#36;script.sh foo bar
    - 인수 2개 이므로 $# = 2

```
if [$# = 2]
then
    echo "Hello!"
fi # if를 거꾸로 한 것. 처리가 끝난 걸 의미
```

```
if [조건]
then
    조건을 만족하면 실행하는 내용
else
    조건을 만족하지 않으면 실행하는 내용
fi
공통처리 부분
```

```
!#/bin/bash

while getopts r: OPT  
do   
case $OPT in  
    r) reportname = "$OPTARG";; # -r"~"로 지정한 값을 reportname으로도 참조하게 하기
        
    esac
done

if [$reportname !=""] # -r옵션이 지정된 경우 
```

### Reference
  - [만화로 배우는 리눅스 시스템 관리](http://www.yes24.com/Product/Goods/32402055?Acode=101)
