

```python
import sys

s = sys.stdin.readline().split();

#readlines()함수는 파일의 모든 줄을 읽어서 각각의 줄을 요소로 갖는 리스트를 반환한다 

A = s[0]
B = s[1]

MIN = 50


for i in range(len(B)-len(A)+1):
    count = 0
    for j in range(len(A)):
        if(A[j]!=B[j+i]):
            count+=1
    MIN = min(count, MIN)


print(MIN)



```

## Reference

- https://www.acmicpc.net/problem/1120
