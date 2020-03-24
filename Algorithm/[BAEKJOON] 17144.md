```python
import sys

R, C, T = list(map(int, sys.stdin.readline().split()))
mat = []
for _ in range(R):
    mat.append(list(map(int, sys.stdin.readline().split())))
```


```python
def diffusion(i, j): # 확산 구현 함수 
    
    #print(f"index is {i,j}")
    diff_val = mat[i][j] // 5
    
    #print(f"diff_val is {diff_val}")
    save = save_list[i][j] # 해당 좌표 값 저장 
    save_list[i][j] = mat[i][j]
    
    #left
    if j-1 >=0:
        if mat[i][j-1] != -1:
            save_list[i][j-1] += diff_val
            save_list[i][j] -= diff_val
    #up
    if i-1 >=0 :
        if mat[i-1][j] != -1:
            save_list[i-1][j] += diff_val
            save_list[i][j] -= diff_val
    #right
    if j+1 <C:
        if mat[i][j+1] != -1:
            save_list[i][j+1] += diff_val
            save_list[i][j] -= diff_val
    #down
    if mat[i+1][j] != -1:
        save_list[i+1][j] += diff_val
        save_list[i][j] -= diff_val

    save_list[i][j] += save 
    # 해당 값에 대한 확산이 끝난 다음, 다른 좌표에서 확산된 값을 더해준다 
    # 이전 확산 결과에 대한 영향을 받은 값이 확산이 일어나는 것이 아니니다
    # 예를들어 30, 7 이 있을 때 30이 확산된 후 7의 값이 13이 된 다음 확산이 일어나는 것이 아니라
    # 7이 확산이 일어나는 것
```


```python
def purify_air1(air_x, air_y): # 반시계 방향으로 이동하는 공기청정기 
    
    # 아래 방향 -> 왼쪽 방향 -> 위쪽 방향 -> 오른쪽 방향
    # 으로 이동하면 임시 값을 저장할 필요 없이 값을 한칸 씩 이동시킬 수 있다 
    
    # down
    for i in range(air_x-1, -1, -1): 
        if save_list[i+1][air_y] == -1:
            save_list[i][air_y] = 0
        else:
            save_list[i+1][air_y] = save_list[i][air_y]
            save_list[i][air_y] = 0

   #left
    for i in range(1, C):
        save_list[0][i-1] = save_list[0][i]
        save_list[0][i] = 0
        
   #up
    for i in range(1, air_x+1):
        save_list[i-1][C-1] = save_list[i][C-1]
        save_list[i][C-1] = 0
        
   #right
    for i in range(C-2, 0, -1):
        save_list[air_x][i+1] = save_list[air_x][i]
        save_list[air_x][i] = 0
```


```python
def purify_air2(air_x, air_y): # 시계방향으로  이동하는 공기청정기 
    
    # 위쪽 방향 -> 왼쪽 방향 -> 아래쪽 방향 -> 오른쪽 방향
    # 으로 이동하면 임시 값을 저장할 필요 없이 값을 한칸 씩 이동시킬 수 있다 
    
    #up
    for i in range(air_x+1, R):
        if save_list[i-1][0] == -1:
            save_list[i][0] = 0
        else:
            save_list[i-1][0] = save_list[i][0]
            save_list[i][0] = 0

    #left
    for i in range(1,C):
        save_list[R-1][i-1] = save_list[R-1][i]
        save_list[R-1][i] = 0

    #down 
    for i in range(R-2, air_x-1, -1):
        save_list[i+1][C-1] = save_list[i][C-1]
        save_list[i][C-1] = 0

    #right
    for i in range(C-2, air_y,-1):
        save_list[air_x][i+1] = save_list[air_x][i]
        save_list[air_x][i] = 0
```


```python
air_list = [] # 공기 청정기 위치 저장하기 위한 리스트 
for i in range(R):
    for j in range(C):
        if mat[i][j] == -1:
            air_list.append([i,j])
#print(air_list)
```


```python
for t in range(T):
    save_list = [[0] * C for _ in range(R)] # 확산 값들을 저장하기 위한 리스트 
    save_list[air_list[0][0]][air_list[0][1]] = -1 # 공기 청정기 위치 저장
    save_list[air_list[1][0]][air_list[1][1]] = -1
    
    for i in range(R):
        for j in range(C):
            if mat[i][j] != -1 and mat[i][j] != 0:
                diffusion(i,j) # 확산
                
    #print(save_list)
    purify_air1(air_list[0][0],air_list[0][1]) # 첫번째 공기 청정기 
    purify_air2(air_list[1][0], air_list[1][1]) # 두번째 공기 청정기 
    
    max_value = 0
    for i in range(R):
        for j in range(C):
            if save_list[i][j] != -1:
                max_value += save_list[i][j]
    mat = save_list # 1초가 지난후, 확산과 공기청정기 작동 이후 임시 리스트를 원래 리스트에 저장해준다 

```


```python
pritn(max_value)
```

## Reference
- https://www.acmicpc.net/problem/17144
