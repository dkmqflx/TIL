- [숨바꼭질](https://www.acmicpc.net/problem/1697) 문제와 달리 가장 빠른 시간 뿐 아니라 방법의 수도 고려해야 한다 
- bfs로 문제를 풀다가, 해당 노드의 다음 노드(2배한 숫자, +1한 숫자, -1한 숫자)가 이미 큐에 들어있더라도 다음 노드까지의 거리가 이미 큐에 들어있는 노드와 같다면. 이미 중복되더라도 추가한다
- 예를 들어 이전 노드 18에서 (36, 17, 19)를 이미 추가했더라도 다음 노드 16의 (32, 17, 18)에서, 17의 거리가 노드 18에서 17의 거리와 같으면 16에서도 17을 추가해 준다 


```
import sys
from collections import deque
N, K = map(int, sys.stdin.readline().split())

#print(N, K)
```


```
q = deque()
visited = [0] * 100001


def bfs():
    q.append(N)
    visited[N] = 1
    count = 0
    while(q):
        #print(f"q is {q}")
        p = q.popleft()
        #print(f"p is {p}")
        
        if p == K:
            #print(f"p equal k is {visited[p]}")
            min_time = visited[p]-1
            count +=1
            #print(f"count is {count}")
            for q_idx in q:
                #print(f"q is {q_idx}, time is {visited[q_idx]}")
                if visited[q_idx]-1 == min_time and q_idx == K:
                    count+=1
            #print(f"count is {count}")
            return min_time, count
        
        if p*2 <= 100000:
            if visited[p*2] == 0:
                visited[p*2] = visited[p]+1
                q.append(p*2)
            elif visited[p*2] == visited[p]+1:
                q.append(p*2)
                
        if p-1 >= 0:
            if visited[p-1] == 0:
                visited[p-1] = visited[p]+1
                q.append(p-1)    
            elif visited[p-1] == visited[p]+1:
                q.append(p-1)
                
        if p+1 <= 100000:
            if visited[p+1] == 0:
                visited[p+1] = visited[p]+1
                q.append(p+1)
            elif visited[p+1] == visited[p]+1:
                q.append(p+1)
        
        #print(f"after q is {q}\n")
```


```
min_time, count= bfs()
print(min_time)
print(count)
```

## Reference
- https://www.acmicpc.net/problem/12851
