- 완전탐색 문제
- 치킨집 중에서 최대 M개를 골라야 하므로, 우선 총 치킨집에서 M개를 고를 수 있는 모든 수의 조합을 구해준다
- 반복문을 통해 조합 중에 하나를 고르다음, 모든 집에 대해서 해당 조합 중에서 가장 거리가 작은 치킨 집에 대한 거리를 구해준다
- 계속 반복을 하면서 도시의 치킨 거리가 작게 되는 값을 구해준다 


```python
import sys
from itertools import combinations

N, M = map(int, sys.stdin.readline().split())

mat = []
for _ in range(N):
    mat.append(list(map(int, sys.stdin.readline().split())))

chicken_list = []
for i in range(N):
    for j in range(N):
        if mat[i][j] == 2:
            chicken_list.append([i,j])

comb_list = list(combinations(chicken_list, M)) # 가능한 모든 조합의 수를 구한다 
```


```python
# 집과 모든 치킨집 과의 거리 중 가장 작은 값을 구한다음 반환한다 
def dist(r, c, comb):
    min_dist = 2*N
    for i in range(len(comb)):
        chicken = comb[i]
        #print(f"chicken is {chicken}")
        dist = abs(r-chicken[0]) + abs(c - chicken[1])
        if dist <min_dist:
            min_dist = dist
    return min_dist
 
```


```python
result = N*N*N*N*N

#모든 조합 중에 하나씩 선택해서 도시의 치킨 거리를 구해주고, 가장 작은 도시의 치킨거리를 구한다  

for c in range(len(comb_list)):
    comb = comb_list[c]
    chicken_result = 0
    #print(f"comb is {comb}")
    for r in range(N):
        for c in range(N):
            if mat[r][c] == 1:
                chicken_result += dist(r, c, comb)
    if chicken_result < result:
        result = chicken_result


print(result)
```

## Reference
- https://www.acmicpc.net/problem/15686
