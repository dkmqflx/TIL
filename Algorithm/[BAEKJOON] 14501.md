- 해당 문제는 다이나믹 프로그래밍으로 해결할 수 있다 
- 문제를 풀기 위해 다음과 같은 점화식을 사용한다 


- DP[day] = max(DP[day+1], DP[day + T[day]] + P[day])
- day에서 시작해서 퇴사일까지 최대 값을 DP[day]에 저장한다 
- DP[day]는 두가지 중 최대 값을 저장한다
- 오늘 스케줄을 하는 경우 : DP[day+T[day]] + P[day]
- 오늘의 스케줄을 안하는 경우 : DP[day+1]



```python
import sys

N = int(sys.stdin.readline())

lst = []
t = []
p = []
cache = [0] * N # memorization을 위한 리스트 
```


```python
for _ in range(N):
    lst = list(map(int, sys.stdin.readline().split()))
    t.append(lst[0])
    p.append(lst[1]) 
```


```python
def solve(day):
    if day == N: # 마지막 날이 넘어가는 경우, 일을하지 않기 때문에 0을 리턴한다 
        return 0
    if day > N: # 이외에 더 큰 경우는 - 무한대와 같은 매우큰 음수 값을 임의의 값으로 리턴 
        return -100000
    if cache[day] != 0:
        return cache[day]
    
    cache[day] = max(solve(day+1), solve(day+t[day]) + p[day])
    return cache[day]
```


```python
print(solve(0))
```

## Reference
- https://www.acmicpc.net/problem/14501
- https://www.youtube.com/watch?v=VEbh7lCu7Ic&t=260s
