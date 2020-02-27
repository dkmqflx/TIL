## 복잡한 조건으로 파일 찾기

- 실행한 날로부터 일주일에서 2주일 전 사이의 로그파일 검색하기

```
# -and 사용
$ find /logs/ ctime +7 and -ctime -15

```

- find 명령어는 파일명으로도 검색할 수 있다 

```
# -name 사용
# 문자열로 인식되도록 이름 지정은 반드시 큰따옴표를 사용한다 

$ find /logs/ -ctime +180 -and -name "*access*"
# 이름 지정은 와일드카드를 사용한다 
# 이름에 access가 포함된 파일 검색
```

- 1개월 보다 오래되고 파일명에 access 또는 error를 포함한 파일

```
$ find /logs/ -ctime +30 and \( -name "*access*" or -name "*error*" \)
# 괄호는 bash등의 셸에서는 특수한 의미가 있으므로 문자열로 인식되도록 \(백슬래시)로 이스케이프 한다 
# 괄호 뒤에는 스페이스를 넣는다 
```

```
$time /logs/ -ctime -8 and -name "*.log"

# 직전 일주일전에 변경된 이름이 *.log로 끝나는 파일

$time /logs/ -ctime +30 -and -ctime -60 -and \( -name "*report*" -or -name "*error*" \)

# 지난달 1개월 사이에 변경된, 이름에 report 또는 error를 포함한 파일

```

  ### Reference
  
  - [만화로 배우는 리눅스 시스템 관리](http://www.yes24.com/Product/Goods/32402055?Acode=101)



```python

```
