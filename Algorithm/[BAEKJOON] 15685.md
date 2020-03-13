- 해당 문제는 주어진 조건에 맞는 결과를 출력하는 시뮬레이션 문제이다
- 주어진 조건에서 규칙을 찾아서 문제를 해결할 수 있다


- 0: x좌표가 증가하는 방향 (→)
- 1: y좌표가 감소하는 방향 (↑)
- 2: x좌표가 감소하는 방향 (←)
- 3: y좌표가 증가하는 방향 (↓)

- 규칙은 다음과 같다
- 입력으로 4 2 1 3 이 주어진 경우


- 0세대:↑
- 1세대:↑ | ←
- 2세대:↑← | ↓←
- 3세대:↑←↓← | ↓→↑←

- 위와 같이 새로운 세대로 진행할 경우 이전 세대의 화살표 방향 중 가장 끝에 있는 화살표 부터 왼쪽으로 90도를 꺾어 추가하는 방식으로 진행된다


```python
import sys

N = int(sys.stdin.readline())

size = [[0]*101 for _ in range(101)] # (100,100) 좌표를 나타내기 위해 101x101 행렬을 만들어 준다 (index: 0~100)
dx = [1,0,-1,0] # d값 (0,1,2,3)에 따라 이동
dy = [0,-1,0,1]
```


```python
for i in range(N):
    x, y, d, g = map(int, sys.stdin.readline().split())
    lst = []
    lst.append(d)
    
    for j in range(g):
        for k in range(len(lst)-1,-1, -1):
            nd = (lst[k] + 1) % 4 # 0,1,2,3으로 반복되도록 하기 위해서 4로 나눈 값의 나머지를 다음 값으로 추가한다 
            lst.append(nd)

    size[x][y] = 1
    
    for i in range(len(lst)):
        x = x+dx[lst[i]]
        y = y+dy[lst[i]]
        size[x][y] = 1

count = 0
```


```python
for i in range(len(size)-1): #len(size)는 101이므로 -1 빼서 100으로 맞추어준다 
    for j in range(len(size)-1): # 최대 좌표가 (100,100) 이므로 마지막 i,j가 99,99가 되도록 한다 
        if size[i][j] == 1 and size[i+1][j] == 1 and size[i][j+1]and size[i+1][j+1] == 1:
            count+=1
```


```python
print(count)
```

## Reference
- https://www.acmicpc.net/problem/15685
- https://www.youtube.com/watch?v=89HyOfwiAgo&t=350s
