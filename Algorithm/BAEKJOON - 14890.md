- 모든 칸의 높이가 같은 경우 길을 지나갈 수 있다
- 칸의 높이가 2이상 되는 경우는 경사로를 놓을 수 없다
- 다음 칸이 현재 칸 보다 높이가 낮은 경우
    - 해당 칸 다음 L 개의 칸이 서로 높이가 같은지 비교한다
    - 그리고 L+1칸부터 다시 경사로를 놓을 수 있다 
- 다음 칸이 현재 칸 보다 높이가 높은 경우
    - 다음 칸 이외의, 현재 칸을 포함해서 L개의 칸이 서로 높이가 같은지 비교한다
    


```python
import sys

N, L = map(int, sys.stdin.readline().split())
adj = []
adj_t = [[] for _ in range(N)]
```


```python
for i in range(N):
    adj.append(list(map(int, sys.stdin.readline().split())))

for i in range(N):
    for j in range(N):
        adj_t[i].append(adj[j][i])
```


```python
def move(row):
    current = row[0] 
    visited = [[False] * N for _ in range(N)]

    for i, pos in enumerate(row): # i는 다음 위치의 index
        if current == pos:
            continue
    
    elif current + 1 == pos: # 다음칸이 한칸 더 높은 경우
        for j in range(i-1, i-1-L, -1): # i-1-L은 포함 안함
            if j < 0 or current != row[j] or visited[j] == True:
                return False
            visited[j] = True
        current = pos # 해당 위치까지 현재 위치를 옮긴다
    
    elif current - 1 == pos:
        for j in range(i, i+L): # 다음칸이 한칸 더 낮은 경우 
            if j >=N or current-1 != row[j] or  visited[j] == True:
                return False
            visited[j] = True
        current = pos # 해당 위치까지 현재 위치를 옮긴다 

    else: # 높이 차이가 2이상 인경우
        return False

    return True

count = 0
for i in range(N):
    if move(adj[i]) == True:
        count +=1

for i in range(N):
    if move(adj_t[i]) == True:
        count +=1
print(count)
```

## Reference
- https://www.acmicpc.net/problem/14890
- https://bcp0109.tistory.com/31
