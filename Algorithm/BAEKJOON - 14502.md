- 해당 문제는 bfs와 완전 탐색을 같이 사용해서 해결할 수 있다
1. 임의의 위치에 벽 3개를 세운다
2. 그 다음 bfs를 실행하는데 값이 2인 영역을 스택에 넣어준다
3. 하나씩 스택에서 원소를 꺼낸 다음 상하좌우 모든 방향에 대해서 값이 0인 영역을 다시 스택에 넣어준다 
4. 해당 과정을 반복한 다음 영역의 값이 0인 안전 영역의 크기를 구해준다 
5. 모든 영역에 대해 벽 3개를 세웠을 때의 안전 영역의 크기 중 가장 큰  값을 구해준다 


```python
import sys
from collections import deque 
N, M = map(int, sys.stdin.readline().split())


adj = []

for _ in range(N):
    adj.append(list(map(int, sys.stdin.readline().split())))

dr = [0,0,-1,1] # row 방향, 위아래
dc = [-1,1,0,0] # column 방향, 좌우
result = []
```


```python
def bfs():
    count = 0
    copy = [[0] * M for _ in range(N)]
    
    for i in range(N):
        for j in range(M):
            copy[i][j] = adj[i][j]
    
    stack = deque()
  # 값이 2인 모든 위치를 stack에 넣어준다 
    
    for i in range(N):
        for j in range(M):
            if copy[i][j] == 2:
                stack.append([i,j])

    while(stack):
        r, c = stack.popleft()
        
        # 위치가 2인 영역의 모든 방향에 대해서 값이 0을 가지는 영역을 2로 바꾼다음 다시 스택에 넣는다 
        # 바이러스가 퍼지는 과정
        for i in range(4):
            nr = r+dr[i]
            nc = c+dc[i]
            
            if nr >= 0 and nr < N and nc >= 0 and nc <M:
                if copy[nr][nc] == 0:
                    copy[nr][nc] = 2
                    stack.append([nr,nc]) 

    # 안전 영역의 영역을 계산해준다 

    for i in range(N):
        for j in range(M):
            if copy[i][j] == 0:
                count+=1
  
    result.append(count)
```


```python
def wall(wall_count):
    if wall_count == 3:
        bfs()
        return
    # for문을 써서 모든 행과 열에 대해서 3개의 벽을 세우고 재귀
    # 재귀가 끝나면 벽을 세운 위치를 다시 0으로 바꾸어 준다 
    for i in range(N):
        for j in range(M):
            if adj[i][j] == 0:
                adj[i][j] = 1
                wall(wall_count+1)
                adj[i][j] = 0

                
```

## Reference

- https://www.acmicpc.net/problem/14502
- https://pacific-ocean.tistory.com/262
