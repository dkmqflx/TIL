- 기본적인 스택 문제
- 마지막 출력은 asterisk를 써서 unpacking을 주어서 출력한다


```python
import sys

N = int(sys.stdin.readline())

lst = list(map(int, sys.stdin.readline().split()))
result = [0] * N

for i in range(N-1,-1,-1):
    send = lst[i]
    for j in range(i-1,-1,-1):
        if send <= lst[j]:
            result[i] = j+1
            break

print(*result)



```

## Reference
- https://www.acmicpc.net/problem/2493
