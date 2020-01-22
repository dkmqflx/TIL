
## DFS (Depth-First Search)

- 깊이를 기준으로 탐색하는 알고리즘 
- 루트 노드 부터 시작해서 인접한 노드가 없을 때 까지 계속해서 깊이를 기준으로 삼고 계속해서 노드를 찾아나간다 
- Stack을 사용한다 

### 1. 재귀를 이용한 방법


```python
def dfs(graph, current_node, visited):
    # print("node: ",current_node, "visited: ",visited)
    visited.append(current_node) 
   #  print("appended_visited: ",visited)
    for v in graph[current_node]:
        if not v in visited:
            dfs(graph,v,visited)
```

- 예제 입력 1


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
dfs(graph, 1, visited)
```


```python
visited
```




    [1, 2, 4, 3]



- 예제 입력 2


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
dfs(graph, 3, visited)
```


```python
visited
```




    [3, 1, 2, 5, 4]



### 2. 스택을 이용한 방법


```python
def dfs(graph,current_node):
    stack = [] # 주변 노드를 찾기 위한 stack
    visited = [] # 순서를 확인하기 위한 list 
    stack.append(current_node)
    
    while(stack):
        current = stack.pop() # stack에서 꺼내서 visited에 추가한 다음에 노드를 방문한 것을 check한다 
        #print("pop node: ",current)
        if not current in visited:
            visited.append(current)
            temp = list(set(graph[current]) - set(visited)) # 선택한 노드 주변에 있는 노드 중 이미 방문한 노드는 제외한다 
            # print("temp: ",temp)
            temp.reverse()
            # print("reversed temp: ",temp)
            
            stack.extend(temp) # 스택에서 가장 위에 있는 노드부터 주변을 찾아 나간다.
            # print("visited: ",visited)
            # print("stack: ",stack)
        #print("\n")
    return visited
```

- 예제 입력 1


```python
graph = {
    1:[2,3,4],
    2:[1,4],
    3:[1,4],
    4:[1,2,3]
}
```


```python
dfs(graph,1)
```




    [1, 2, 4, 3]



- 예제 입력 2


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
dfs(graph,3)
```




    [3, 1, 2, 5, 4]



## Reference

- https://blog.naver.com/ndb796/221230945092
- https://www.acmicpc.net/problem/1260
