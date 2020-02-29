
## 3패턴 이상 사용

- hostname 명령어
    - 실행한 서버 호스트명을 출력하는 명령어
    - 이 실행 결과를 보고 조건 분기하면 서버마다 다른 처리를 하는 스크립트가 된다 
    
```
#!/bin/bash

if [ "$(hostname)" = "user1" ]
then
    rm -rf /ZZZ
fi

if [ "$(hostname)" = "user2" ]
then
    rm -rf /BBB
fi



```

- case 문
- 조건문이외에 case문을 사용해서 조건에 따른 처리를 할 수 있다 
- 조건문은 경우에 따라 몇번이고 분기해야 하지만
- case문을 통해서 미리 값을 지정해 놓으면 조건 판별 한번으로 분기 가능하다 

```
case "$variable" in # 여러 값을 취급하는 대상(변수나 명령어 치환 결과 등)
    값1) variable 값이 1과 같을 때 실행하는 명령어열 ;; # 각 패턴 사이는 세미콜론 두개로 구분
    값2) variable 값이 2과 같을 때 실행하는 명령어열 ;; # 값 뒤에는 ) 쓰기 
    값3) variable 값이 3과 같을 때 실행하는 명령어열 ;;

esac
```

```
#!/bin/bash

if [ "$(hostname)" = "user1 ]
then
    -rf /zzz
fi

case "$(hostname)" == in
    user1) 
        cp -r /aaa/bbb
        rm /aaa/*.bak
        ;; # 패턴마다 처리 끝에 ;; 넣어서 다음 패턴과 구분
    user2) 
        cp -r /ccc/ddd
        rm /aaa/*.bak
        ;;
esac

```

- 처리가 너무 긴 경우 함수를 사용할 수도 있다 

```
#!/bin/bash

func1() {
}

case "$(hostname)" == in
    user1) 
        func1() 
```

## Reference

  - [만화로 배우는 리눅스 시스템 관리](http://www.yes24.com/Product/Goods/32402055?Acode=101)
