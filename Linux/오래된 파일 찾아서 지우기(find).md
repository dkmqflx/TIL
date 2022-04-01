
## 오래된 파일 찾아서 지우기(find)

- find
    - 다양한 조건으로 파일을 검색하는 명령어
    
    
```
$ find "파일 검색하는 디렉터리 경로" ctime +날짜

$ find /backup/daily ctime +30

# ctime : 최종 갱신 시각(changed time)으로 파일을 찾으라고 지정
# + : 날짜 범위 지정

# 30일 이전 날짜 지정 : -30
# ctime 30처럼 기호가 없는 경우 최종 갱신일이 딱 30일 전인 파일


```

- 1개월 보다 오래된 백업 파일을 자동으로 삭제하는 스크립트 


```
#!/bin/bash

#find 실행 결과 파일 목록을 명령어 치환으로 변수에 대입
remove_files = "$(find /backup/daily -ctime +30)" 

for file in remove_files
do
    rm"$file"
done

```

- 목적일 기준으로 더 오래된 파일을 찾는 경우 +
- 목적일 기준으로 새로운 파일을 찾는 경우 -

```

find ./ -ctime +365
# 최종 갱신일이 1년이상 된(1년이상 변경되지 않은) 오래된 파일

find ./ -ctime -8
# 최종갱신일이 1주일 이내(1주일 사이에 변경된) 새로운 파일

find ./ -ctime 7
# 최종 갱신일이 딱 7주일 된 파일



#find 명령어는 미리 단독으로 실행해서 관계없는 팡리이 포함되어 있지 않은지 확인해본 다음 처리한다 

$ find /home/user -ctime +365 | less


```

## Reference

  - [만화로 배우는 리눅스 시스템 관리](http://www.yes24.com/Product/Goods/32402055?Acode=101)
