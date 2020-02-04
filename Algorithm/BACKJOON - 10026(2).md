

```python
import sys

N = int(sys.stdin.readline())

graph = [[0]* N for _ in range(N)]

for i in range(N):
    s = sys.stdin.readline()
    for j in range(N):
        graph[i][j] = s[j]

visited = [[False]*N for _ in range(N)]
```


```python
def bfs(graph, i, j):
    queue = []
    queue.append([i,j])
  
    while(queue):
        i,j = queue.pop(0) 
        visited[i][j]= True
        
        if j >0 and visited[i][j-1] == False and graph[i][j] == graph[i][j-1]: # left
            queue.append([i,j-1])

            
        if j <N-1 and visited[i][j+1] == False and graph[i][j] == graph[i][j+1]: # right
            queue.append([i,j+1])

        
        if i >0 and visited[i-1][j] == False and graph[i][j] == graph[i-1][j]: # up
            queue.append([i-1,j])

        if i < N-1 and visited[i+1][j] ==False and graph[i][j] == graph[i+1][j]: # down
            queue.append([i+1,j])

            
    return  
 
```


```python
count_rgb = 0

for i in range(N):
    for j in range(N):
        if visited[i][j] is False:
            bfs(graph, i, j)
            count_rgb+=1
```


```python
for i in range(N):
    for j in range(N):
        if (graph[i][j] == 'G'):
            graph[i][j] = 'R'
```


```python
    
count_rb = 0
visited = [[False]*N for _ in range(N)]


for i in range(N):
    for j in range(N):
        if visited[i][j] is False:
            bfs(graph, i, j)
            count_rb+=1
 
```


```python
print(count_rgb, count_rb)
    
    
```

## Reference
- https://www.acmicpc.net/problem/10026
