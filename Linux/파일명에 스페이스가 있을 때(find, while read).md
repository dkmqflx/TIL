## 스페이스가 들어 있는 파일명도 반복 처리에 사용하고 싶을 때

- for 반복은 in 뒤에 공백 문자(스페이스, 탭, 줄바꿈)를 구분자로 써서 나열한 항목을 순서대로 처리한다 
- 따라서 아래 예시처럼 파일명에 공백이 있으면 중간에 끊기게 된다

```
for file in /data/back/project members.csv
do
    rm "$file"
done

```

- 이러한 문제를 해결하기 위해 while과 read를 사용한다 
- find 파일을 검색해서 그 결과를 파이프라인을 통해서 다음 명령어로 넘긴다 
- 다음 명령어 부분은 while 부터 done 까지
- 실제로 파이프 라인을 사용할 때 암묵적으로 서브셰을 사용하는 것이다
- 따라서 while 반복문을 상요할 때도 서브셸로 실행된다 
- read 입력은 반드시 한 줄 단위로 읽으니까 for 문과 달리 스페이스나 탭 같은 공백 문자 있어도 중간에 끊기지 않는다 

```
find /data/backup -ctime +30 | while read file
do
    rm "$file" # 인용 부호로 감싸면 하나로 이어진 문자열로 취급
done


```

### Reference
  - [만화로 배우는 리눅스 시스템 관리](http://www.yes24.com/Product/Goods/32402055?Acode=101)
