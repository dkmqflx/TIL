
## BFS (Breadth-First Search)

- 너비를 우선으로 탐색하는 알고리즘 
- 시작 노드에서 가까운 노드들 부터 탐색이 이루어 진다.
- '최단 경로'를 찾아준다는 점에서 최단 길이를 보장해야 할 때 많이 사용한다 
- Queue을 사용한다 

### 1. 재귀를 이용한 방법


```python
def bfs(graph, current, visited):
    if current not in visited:
        visited.append(current)
    #print("current: ", current)
    #print("visited: ", visited)
    for v in graph[current]:
        #print("v: ", v)
        if v not in visited:
            temp = list(set(graph[current]) - set(visited))
            #print("temp: ", temp)
            visited.extend(temp)
            #print("\n")
            bfs(graph, v, visited)
            
```

- 예제입력 1


```python
graph = {
    1:[2,3,4],
    2:[1,4],
    3:[1,4],
    4:[1,2,3]
}
```


```python
visited = []
```


```python
bfs(graph, 1, visited)
```


```python
visited
```




    [1, 2, 3, 4]



- 예제입력 2


```python
graph = {
    1:[2,3],
    2:[1,5],
    3:[1,4],
    4:[3,5],
    5:[2,4]
}
```


```python
visited = []
```


```python
bfs(graph, 3, visited)
```


```python
visited
```




    [3, 1, 4, 2, 5]



### Queue를 이용한 방법


```python
def bfs(graph, start_node):
    visited = []
    queue = []
    
    queue.append(start_node)
    
    while (queue):
        current = queue.pop(0)
        if current not in visited:
            visited.append(current)
            temp  = list(set(graph[current]) - set(visited))
            queue.extend(temp)
    return visited
        
```

- 예제입력 1


```python
graph = {
    1:[2,3,4],
    2:[1,4],
    3:[1,4],
    4:[1,2,3]
}
```


```python
bfs(graph, 1)
```




    [1, 2, 3, 4]



- 예제입력 2


```python
graph = {
    1:[2,3],
    2:[1,5],
    3:[1,4],
    4:[3,5],
    5:[2,4]
}
```


```python
bfs(graph, 3)
```




    [3, 1, 4, 2, 5]



## Reference

- https://blog.naver.com/ndb796/221230944971
- https://www.acmicpc.net/problem/1260

