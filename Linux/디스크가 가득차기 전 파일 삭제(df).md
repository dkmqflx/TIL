## 디스크가 가득 차기 전에 파일 삭제(df)

- 1개월 이상 오래된 파일을 지워서 빈 공간 확보 

```
files = $(find /data/backup -ctime +30)

for file in $files
do
    rm "$files"
done
```

- 디스크 빈 공간 조사하는 방법

```
$ df

# 1K-blocks : 디스크 총 용량
# Used : 사용량(단위 K바이트)
# Available : 빈 용량(단위: K바이트)
# Use% : 사용률
# Mounted on : 디렉터리 트리의 마운트 위치

```

- df 출력은 특정 한 글자로 나눌 수 없으므로 cut은 사용할 수 없다

```
#!/bin/bash

free_size = $(df /data/backup | \ # 경로를 지정하면 그 디렉터리가 포함된 디스크 정보만 출력됨
    sed -r -e "s/[^ ]+ +[^ ]+ +[^ ]+ +([^ ]+).+/\1/" | \ # Available 출력
    tail -n -1) # 마지막 줄만 추출

required_size = $((10 * 1000 * 1000)) 
# 10G 바이트
= 10 * 1,000M 바이트
= 10,000 * 1,000K 바이트
= 10,000,000K 바이트

if [$free_size -lt $required_size] # 실제 빈 영역이 최저 필요한 빈 용량보다 작으면
then
    files = $(find /data/backup -ctime +30)
    for file in files # 오래된 파일 삭제
    do
        rm "$file"
    done
fi
```

- bash에서 <, >도 특별한 의미를 가진다 

```
# 따라서 아래와 같은 방법으로 사용한다 

if [ $free_size "<" $required_size] # " 또는 '로 감싸서 문자열로 작성

if [ $free_size \< $required_size] # 백 슬래시로 이스케이프 

```


- 숫자를 비교할 때 <, >를 사용할 수 없다 
- 문자열용 비교연산자이기 때문이다 

```
X = Y # X와 Y가 같다
X != Y # X와 Y가 다르다
X < Y # X가 Y보다 앞
X > Y # X가 Y보다 뒤 
```


- 숫자를 비교할 때는 -lt(less than) 또는 -gt(greater than)을 쓴다 

```
10 -lt 100



```

- df -h 옵션으로 검색하면 df출력 결과를 사람이 보기 편하게 만들어준다 

  ### Reference
  
  - [만화로 배우는 리눅스 시스템 관리](http://www.yes24.com/Product/Goods/32402055?Acode=101)
