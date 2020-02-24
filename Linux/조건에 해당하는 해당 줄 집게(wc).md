
## Ch5. 조건에 해당하는 로그 줄 수 집계 (wc)

- wc 명령어
    - Word Count의 약자
    - 지정한 파일이나파이프라인으로 넘어온 내용의 문자수와 줄 수를 세서 그 결과를 돌려주는 명령어 

```
$ cat /tmp/sample.txt | wc --lines # 줄수(wc -l)

$ cat /tmp/sample.txt | wc --words # 단어수(wc -w)

$ cat /tmp/sample.txt | wc --chars # 문자수 (wc -m)

$ cat /tmp/sample.txt | wc # 옵션 사항이 없으면 줄수, 단어수, 바이트수가 전부 출력됨
```

- 10 페이지 정도 있는 캠페인용 페이지 접속수 합계를 알고 싶다
- 캠페인 기간인 1월 중 로그 전부를 집계

```
!#/bin.bash

total_count = 0

for log in /lodlog/2014/access.*gz # 와일드 카드에 해당하는 파일이 모두 처리 대상이 됨
do
    pattern = ([23][0-9]/Jan | (0[0-9]|10)/Feb)/2014"
            # 2또는3, 0에서 9까지, 0과 0에서 9까지 또는 10 
            # 20에서 39까지 해당 , 00에서 10까지 
            # -> 2014년 1월 20일에서 2월 10일까지라고 지정 가능 
            # 달을 남기는 날짜범위는 정규 표현식을 사용
            
    count  = $(zcat $log | grep "/campaign" | grep -E #pattern | wc -l) # 이 파일 안에 해당하는 줄 수를 구하기 
    
    total_count = $((total_count + $count)) # $(( ))는 합을 구하는데 쓴다 
    

```
