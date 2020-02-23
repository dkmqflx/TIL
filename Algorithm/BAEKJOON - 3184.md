
- BFS를 사용해서 각 영역을 찾은 다음에 양과 늑대의 개수를 비교해준다


```python
import sys

N = list(map(int, sys.stdin.readline().split()))

R = N[0]
C = N[1]

graph =  [list(input()) for _ in range(R)]
visited = [[False] * C for _ in range(R)]
sheep = 0
wolf = 0
```


```python
def bfs(graph, i,j):
    queue = []
    queue.append([i,j])
    o_count = 0
    v_count = 0
    
    while(queue):
        
        i, j = queue.pop(0)
        visited[i][j] = True
        
        if graph[i][j] == 'o':
            o_count +=1
        elif graph[i][j] == 'v':
            v_count +=1
        
             
        if j > 0 and visited[i][j-1] == False and graph[i][j-1] != '#' and [i, j-1] not in queue: # left
            queue.append([i, j-1])
        
        if j < C-1 and visited[i][j+1] == False and graph[i][j+1] != '#' and [i, j+1] not in queue: # right
            queue.append([i, j+1])
    
            
        if i > 0 and visited[i-1][j] == False and graph[i-1][j] != '#' and [i-1, j] not in queue: # up
            queue.append([i-1,j])
            
        if i < R-1 and visited[i+1][j] == False and graph[i+1][j] != '#' and [i+1, j] not in queue: # down
            queue.append([i+1,j])

           
    return o_count, v_count
```


```python
o_life = 0
w_life = 0

# Loop를 한번 돌때마다 하나의 영역을 찾게 된다 
for i in range(R):
    for j in range(C):
        if visited[i][j] == False and graph[i][j] != '#':
            sheep, wolf = bfs(graph, i, j)
            if (sheep > wolf):
                o_life += sheep
            else:
                w_life += wolf

print(o_life, w_life)
    
```

## Reference
- https://www.acmicpc.net/problem/3184
