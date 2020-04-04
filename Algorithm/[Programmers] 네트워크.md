- dfs로 해결하는 문제


```python
def dfs(computers, current_node, visited):
    if current_node not in visited: # 아직 방문하지 않은 노드라면 추가
        visited.append(current_node) # current노드는 행을 나타낸다 
        
    for i in range(len(computers)): # i는 열을 나타낸다 
        if computers[current_node][i] == 1 and i not in visited: # 해당 행의 각 열이 1이고 아직 방문하지 않은 상태라면
                dfs(computers, i, visited) # 해당 위치로 dfs 
```


```python
def solution(n, computers):

    result_lst = [] # 모든 노드에 대한 dfs 정보 저장하는 리스트
    for i in range(n): # 모든 노드에 대해서 실행
        visited = [] # 각각의 노드의 dfs 정보 포함하기 위해서 초기화 시켜준다
        dfs(computers, i, visited)
        result_lst.append(visited)
    
    for i in range(len(result_lst)):
        result_lst[i].sort() # set 사용하기 위해서 모든 리스트 원소 순서 정렬
        
    result = list(set([tuple(item) for item in result_lst])) # tuple로 만든 후 set 사용하면 중복된 원소 제거 가능
    answer = len(result)
    return answer
```


```python
n = 3
computers = [[1, 1, 0], [1, 1, 0], [0, 0, 1]] 
```


```python
solution(n, computers)
```




    2




```python
n = 3
computers = [[1, 1, 0], [1, 1, 1], [0, 1, 1]]
```


```python
solution(n, computers)
```




    1




```python
n = 3
computers = [[1, 0, 0], [0, 1, 0], [0, 0, 1]]


```


```python
solution(n, computers)
```




    3




```python
n = 1
computers = [[1]]
```


```python
solution(n, computers)
```




    1




```python
n = 4
computers = [[1,1,1,1], [1,1,1,0], [1,1,1,0], [1,0,0,1]]
```


```python
solution(n, computers)
```




    1



## Reference
- https://programmers.co.kr/learn/courses/30/lessons/43162
