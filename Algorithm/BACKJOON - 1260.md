

```python
import sys

input = list(map(int, sys.stdin.readline().split()))

N = input[0]
M = input[1]
V = input[2]

graph = [[0]*(N+1) for _ in range(N+1)]

```


```python
for i in range(M):
    link = list(map(int, sys.stdin.readline().split()))
    graph[link[0]][link[1]] = 1
    graph[link[1]][link[0]] = 1
```


```python
def dfs(graph, current_node, visited):
    if current_node not in visited:
        visited.append(current_node)
    for i in range(N+1): # 0,1,2,3,4
        if graph[current_node][i] == 1 and i not in visited:
            dfs(graph, i, visited)
```


```python
def bfs(graph, current_node):
    visited = []
    queue = []
    
    queue.append(current_node)
    visited.append(current_node)
    while(queue):
        current = queue.pop(0)
        for i in range(N+1):
            if graph[current][i] == 1 and i not in visited:
                queue.append(i)
                visited.append(i)
    return visited
```


```python
visited = []
dfs(graph, V, visited)
print(*visited)

```


```python
print(*bfs(graph, V))
```

## Reference
- https://www.acmicpc.net/problem/1260
