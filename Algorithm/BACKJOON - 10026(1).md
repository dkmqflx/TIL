
- 해당 문제는 BFS 알고리즘을 통해서 해결할 수 있는 문제이다
- BFS에서는 한 노드에 대해 연결된 모든 노드를 Queue에 넣은 다음, 넣은 노드를 Queue에서 하나씩 꺼낸 다음 해당 노드에 인접한 노드를 또 다시 Queue에 넣어준다
- 이 방법이 동일하게 적용된다.
- [i,j] 위치에서 좌, 우, 위, 아래 요소 중 같은 값을 가지는 인덱스를 Queue에 넣은 다음, 넣은 인덱스 값을 Queue에서 하나씩 꺼낸 다음 주변에 있는 인덱스 중 같은 값들을 차례대로 방문한다


```python
import sys

N = int(sys.stdin.readline())

graph = [[0]* N for _ in range(N)]

for i in range(N):
    s = sys.stdin.readline()
    for j in range(N):
        graph[i][j] = s[j]
```


```python
def bfs(graph, i, j, visited):
    if [i,j] in visited:
        return visited
    queue = []
    queue.append([i,j])
    
    while(queue):
        i,j = queue.pop(0)
        if [i,j] not in visited:
            visited.append([i,j])
        
        if j >0 and [i,j-1] not in visited and graph[i][j] == graph[i][j-1]: # left
            queue.append([i,j-1])
            
        if j <N-1 and [i,j+1] not in visited and graph[i][j] == graph[i][j+1]: # right
            queue.append([i,j+1])

        if i >0 and [i-1,j] not in visited and graph[i][j] == graph[i-1][j]: # up
            queue.append([i-1,j])
            
        if i < N-1 and [i+1,j] not in visited and graph[i][j] == graph[i+1][j]: # down
            queue.append([i+1,j])
            
    return visited
        
```


```python
count_rgb = 0
visited = []

for i in range(N):
    for j in range(N):
        if [i,j] not in visited:
            visited.append(bfs(graph, i, j, visited))
            count_rgb +=1
```


```python
for i in range(N):
    for j in range(N):
        if(graph[i][j] == 'G'):
            graph[i][j] = 'R'
```


```python
count_rb = 0
visited = []

for i in range(N):
    for j in range(N):
        if [i,j] not in visited:
            visited.append(bfs(graph, i, j, visited))
            count_rb +=1
```


```python
print(count_rgb, count_rb)
    
    
```

##  Reference
-  https://www.acmicpc.net/problem/10026
