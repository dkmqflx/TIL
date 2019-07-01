

```python
import sys
```


```python
n = sys.stdin.readline()
time = list(map(int,sys.stdin.readline().split()))

#입력 받는 부분, 굉장히 많은 시간을 썼다.
#입력 받을 때 input()으로 숫자를 입력받으니 런타임 에러가 계속해서 발생함
#파이썬으로 입력 받을 때 가장 빠른 방법은 sys.stdin.readLine()을 사용하는 방법

time.sort()# 1, 2, 3, 3, 4
#가장 인출하는데 걸리는 시간이 적은 순서대로 정렬시킨다.

costSum = [] # 1, 3, 6, 9, 13
add = 0

for i in range(int(n)): #sys.stdin.readline()로 입력받았기 때문에 n의 type은 str이다.
    for j in range(i+1):
        add += time[j]
    costSum.insert(i, add)
    add = 0
```


```python
print(sum(costSum))
```

## Reference
- https://www.acmicpc.net/problem/11399
