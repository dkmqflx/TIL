- 연결요소(Connected component)의 개수를 묻는 문제
- BFS를 사용하면 모두 연결된 노드를 확인할 수 있으므로 BFS를 사용해서 문제를 해결한다 


```python
import sys
from collections import deque

N, M = map(int, sys.stdin.readline().split())

visited = [False] * (N+1)

adj = [[] for _ in range(N+1)]
```


```python
for _ in range(M):
    a, b = map(int, sys.stdin.readline().split())
    adj[a].append(b)
    adj[b].append(a)

# print(adj)
```


```python
def bfs(adj, start_node):
    # print("start node: ", start_node) , 시작노드 출력
    queue = deque()
    queue.append(start_node)

    visited[start_node] = True
    while(queue):
        current_node = queue.popleft()
        # print("current_node ", current_node), 현재 노드 출력

    for v in adj[current_node]:
        if visited[v] == False:
           # print("append node: ", v)
            queue.append(v)
            visited[v] = True # 큐에 넣는 노드는 방문하게 되므로 True


count = 0

for start_node in range(N):
    if visited[start_node+1] == False:
        print("start node is ", start_node+1) # 시작노드
        bfs(adj, start_node+1)
    count +=1 # 한번 루프를 돌때마다 하나의 연결요소를 찾게 되므로 1씩 카운트해준다 

print(count)
```

## Reference
    - https://www.acmicpc.net/problem/11724
