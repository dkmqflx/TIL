```python
import sys
from collections import deque
```


```python
N, M = map(int, sys.stdin.readline().split())
```


```python
adj = [list(input()) for _ in range(N)]
```


```python
N = 7
M = 7
```


```python
adj = [['#','#','#','#','#','#','#'],
       ['#','.','.','.','R','B','#'],
       ['#','.','#','#','#','#','#'],
       ['#','.','.','.','.','.','#'],
       ['#','#','#','#','#','.','#'],
       ['#','O','.','.','.','.','#'],
       ['#','#','#','#','#','#','#']]
```


```python
visited  = [[[[False] * M for _ in range(N)] for _ in range(M)] for _ in range(N)] 
# 빨간색 구슬 상하좌우, 파란색 구슬 상하좌우 정보 필요하므로 4차원 배열 만든다 
```


```python
dx, dy = (-1, 0, 1, 0), (0,1,0,-1) #  (왼쪽, 오른쪽), (위쪽, 아래쪽)
queue = deque()
```


```python
def init():
    rx, ry, bx, by = [0]*4 # 빨간, 파란 구슬 위치 저장 위한 리스트
    for i in range(N):
        for j in range(M):
            if adj[i][j] == 'R':
                rx, ry  = i, j # 빨간색 구슬 위치
            elif adj[i][j] == 'B':
                bx, by = i, j # 파란색 구슬 위치 
    print("빨간색 구슬 위치: ", rx, ry)
    print("파란색 구슬 위치: ",bx, by)
    print("\n")
    queue.append((rx,ry,bx,by,1)) # 위치 정보와 depth 저장
    visited[rx][ry][bx][by] = True
                
```


```python
def move(x, y, dx, dy): # 한칸 움직인 후 다음 위치 정보를 return하는 함수 
    count = 0 # 몇 칸 이동했는지 
    
    # 반복문 돌 때마다 왼쪽, 아래쪽, 오른쪽, 위쪽 순서대로 확인한다 
    while adj[x+dy][y+dx] != '#' and adj[x][y] != '0': # 현재 위치에서 네 방향이 벽이 아니거나, 현재 위치가 0가 아닐 때 
        x += dy # 상하로 이동시킨다
        y += dx # 좌우로 이동시킨다 
        count += 1
    return x, y, count
```


```python
def bfs():
    init()
    
    while queue:
        rx, ry, bx, by, depth = queue.popleft()
        print("red queue: ", rx, ry)
        print("blue queue: ", bx, by)
        print("\n")
        if depth >10:
            break
        
        for i in range(len(dx)): # 0: 좌, 1: 우, 2:상, 3:하, 한번 루프 돌 때 마다 모든 방향 체크한다 

            next_rx, next_ry, r_count = move(rx, ry, dx[i], dy[i])
            next_bx, next_by, b_count = move(bx, by, dx[i], dy[i])
            
            print("빨간 구슬 이동한 위치: ", next_rx, next_ry)
            print("파란 구슬 이동한 위치: ", next_bx, next_by)
            print("depth: ", depth)
            #print("좌우 이동방향: ", dx[i])
            #print("상하 이동방향: ", dy[i])
            print("\n")
            print("adj :", adj[next_rx][next_ry])
            if adj[next_bx][next_by] == 'O': # 한칸 움직인 다음 위치에서 파란 구슬이 0이 되는 경우, continue를 사용해서 다른 방향으로 진행
                continue
            
            if adj[next_rx][next_ry] == 'O': # 한칸 움직인 다음 위치에서 빨간 구슬이 0이 되는 경우 1 출력하고 return
                print(1)
                return 
            
            if next_rx == next_bx and next_ry == next_by : # 빨간 구슬과 파란 구슬이 같은 칸에 있을 수 없다 
                if r_count > b_count : # 이동거리가 더 많은 구슬을 한칸 뒤로 움직인다
                    next_rx -= dy[i]
                    next_ry -= dx[i]
                else :
                    next_bx -= dy[i]
                    next_by -= dx[i]
            
            #dfs 탐색 끝난 후 확인
            print("조정 후 빨간 구슬 이동한 위치: ", next_rx, next_ry)
            print("조정 후 파란 구슬 이동한 위치: ", next_bx, next_by)
            print("\n")
            
            if not visited[next_rx][next_ry][next_bx][next_by]: # 빨간 구슬과 파란구슬을 각각 움직인 곳이 아직 방문 하지 않은 곳이라면
                visited[next_rx][next_ry][next_bx][next_by] = True
                queue.append((next_rx,next_ry,next_bx,next_by, depth+1))
                print("red queue append is: ", next_rx, next_ry)
                print("blue queue append is: ", next_bx, next_by)
                print("\n")
                
    
    print(0)
            
```


```python
bfs()
```

- test case



```python
N = 7
M = 7
```


```python
adj = [['#','#','#','#','#','#','#'],
       ['#','.','.','.','R','B','#'],
       ['#','.','#','#','#','#','#'],
       ['#','.','.','.','.','.','#'],
       ['#','#','#','#','#','.','#'],
       ['#','O','.','.','.','.','#'],
       ['#','#','#','#','#','#','#']]
```


```python
bfs()
```

## Reference
- https://www.acmicpc.net/problem/13459
- https://jeongchul.tistory.com/665
