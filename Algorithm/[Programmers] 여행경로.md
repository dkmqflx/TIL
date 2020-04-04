- 해당 문제는 DFS + 백트래킹 문제이다
- 즉, 결과를 구하기 위해서 DFS를 해주고, 알파벳 순서대로 비교하기 위해 모든 경우의 경로를 구하기 위해서 한번의 DFS 사이클이 끝나면 가장 끝에 있던 원소를 빼주는 백트래킹을 해준 다음 다시 DFS를 진행해야 한다
- 즉, 백트래킹 문제는 DFS와 queue를 이용해서 해결할 수 있다


- 그리고 이번 문제를 풀 때 pop이 영향을 끼치는 범위에 대해서도 고려를 해야 한다 
- 아래 코드처럼, x_lst에 x를 추가했더라도, x에서 pop()을 해주면 x_lst에도 영향을 끼친다
- 따라서 이를 해결하기 위해 temp 역할을 하는 리스트에 deepcopy를 해준다음에, temp 리스트를 추가하는 방법으로 문제를 해결한다

```
x = [1,2,3,4]
x_lst = []
x_lst.append(x)

x.pop()
print(x) # [1, 2, 3]
print(x_lst) # [[1, 2, 3]]

```


```python
import copy

def solution(tickets):

    
    route_lst = [] # 모든 경로를 저장하기 위한 리스트
    
    for i in range(len(tickets)):
        route = [] # 각 시작점마다 경로 저장
        visited = [False] * len(tickets) # ticktes 순서대로, 방문 여부 저장하기 위한 리스트
        if tickets[i][0] == "ICN":
            route.extend(tickets[i])
            dfs(tickets, i, visited, route, route_lst)
    #print(f"route_lst is {route_lst}")
    #print(f"min is {min(route_lst)}")
    answer = min(route_lst)

    return answer
```


```python
def dfs(tickets,idx,visited, route, route_lst):
    
    visited[idx] = True

    if len(route) == len(tickets)+1 :
        if route: # 경로가 존재하는 경우 
            route_copy = copy.deepcopy(route) # pop문제 해결하기 위해 copy
            route_lst.append(route_copy) # 경로 추가 
        return 

    
    for i in range(len(tickets)):
        if route[len(route)-1] == tickets[i][0] and visited[i] == False : # 가장 경로의 끝과 같고, 아직 방문안한 경우 
            route.extend([tickets[i][1]]) # 해당 원소 추가
            
            dfs(tickets, i, visited, route, route_lst) 
            route.pop() # 백트래킹 문제이므로, pop()으로 가장 끝에 있는 원소 빼준다
            visited[i] = False # 해당 원소에 방문 다시 취소 
```


```python
tickets = [["ICN", 'JFK'], ['HND', 'IAD'], ['JFK','HND']]
```


```python
solution(tickets)
```




    ['ICN', 'JFK', 'HND', 'IAD']




```python
tickets = [["ICN", "SFO"], ["ICN", "ATL"], ["SFO", "ATL"], ["ATL", "ICN"], ["ATL","SFO"]]
```


```python
solution(tickets)
```




    ['ICN', 'ATL', 'ICN', 'SFO', 'ATL', 'SFO']




```python
tickets = [["ICN","COO"], ["ICN", "BOO"], ["COO", "ICN"], ["BOO", "DOO"]]
```


```python
solution(tickets)
```




    ['ICN', 'COO', 'ICN', 'BOO', 'DOO']




```python
tickets = [["ICN","SFO"], ["SFO", "ICN"], ["ICN", "SFO"],["SFO","QRE"]]
```


```python
solution(tickets)
```




    ['ICN', 'SFO', 'ICN', 'SFO', 'QRE']




```python
tickets = [['ICN','BOO' ], [ 'ICN', 'COO' ], [ 'COO', 'DOO' ], ['DOO', 'COO'], [ 'BOO', 'DOO'] ,['DOO', 'BOO'], ['BOO', 'ICN' ], ['COO', 'BOO']]
```


```python
solution(tickets)
```




    ['ICN', 'BOO', 'DOO', 'BOO', 'ICN', 'COO', 'DOO', 'COO', 'BOO']



## Reference
- https://programmers.co.kr/learn/courses/30/lessons/43164?language=python3
- https://wikidocs.net/16038
