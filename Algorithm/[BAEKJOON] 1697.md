- BFS로 해결할 수 있는 문제 
- 파이썬의 경우 
    - if p*2 <= 100000 and visited[p*2] == 0:
    - 이 부분에서 오른쪽 리스트 index 범위 때문에 error가 난다.
    - 따라서if문 안에 if문을 넣는 방법으로 해결


```python
import sys


N, K = map(int, sys.stdin.readline().split())
q = []
visited =[0] * 100001 # 해당위치를 방문했을 때의 시간을 젖아하기 위한 리스트. N의 범위가 0 ~ 1000,00이므로 총 100001개

def bfs():
    q.append(N)
    visited[N] = 1
    
    while(q):
        #print(f"before q is {q}")
        
        p = q.pop(0)
        
        #print(f"p is {p}")
        if p == K:
            return visited[p]-1 # 시작위치를 1로 두었으므로 1빼서 return
        
        if p*2 <= 100000:
            if visited[p*2] ==0:
                visited[p*2] = visited[p]+1
                q.append(p*2)
        if p+1 <=100000:
            if visited[p+1] ==0:
                visited[p+1] = visited[p]+1
                q.append(p+1)
        if p-1 >=0 :
            if visited[p-1] == 0:
                visited[p-1] = visited[p]+1
                q.append(p-1)
result = bfs()
print(result)
        
```

## Reference
- https://www.acmicpc.net/problem/1697
