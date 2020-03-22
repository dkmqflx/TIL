- 해당 문제는 모든 경우의 수에 대한 값을 비교해서 최종 결과 값을 구하는 완전탐색 문제이다 


```python
import sys

N = int(sys.stdin.readline())

d_input = []
for _ in range(N):
    d_input.append(list(map(int, sys.stdin.readline().split())))
    
```


```python
def fill(x, y, value):
    if x <0 or x>=N or y<0 or y>=N: # 범위를 벗어나게 되면 리턴
        return
    if district[x][y] != 0: # 0이 아닌 부분을 만나면 리턴 
        return 
    district[x][y] = value
    
    fill(x-1,y,value) # left
    fill(x+1,y,value) # right
    fill(x,y-1,value) # up
    fill(x,y+1,value) # down

# d1, d2 value 
d_list = []
for i in range(1,N):
    for j in range(1,N):
        d_list.append([i, j])

result = 1000

for i in range(len(d_list)):
    d1,  d2 = d_list[i]
    
    for x in range(N):
        for y in range(N):
            if x < x+d1+d2 and x+d1+d2 < N:
                if 0 <= y-d1 and y > y-d1 and y < y+d2 and y+d2 < N:
                    district = [[0] * N for _ in range(N)]
                    
                    for i in range(d1+1):
                        district[x+i][y-i] = 5 # 1번 경계선
                        district[x+d2+i][y+d2-i] = 5 # 4번 경계선

                    for i in range(d2+1):
                        district[x+i][y+i] = 5 # 2번 경계선
                        district[x+d1+i][y-d1+i] = 5 # 3번 경계선 

                    for r in range(x-1, -1,-1):
                        district[r][y] = 1 # 1번 선거구 경계선
                    for c in range(y+d2+1, N):
                        district[x+d2][c] = 2 # 2번 선거구 경계선
                    for c in range(y-d1-1, -1, -1):
                        district[x+d1][c] = 3 # 3번 선거구 경계선
                    for r in range(x+d1+d2+1, N):
                        district[r][y+d2-d1] = 4 # 4번 선거구 경계선 


                    fill(0,0,1) # 1번 선거구 시작점
                    fill(0,N-1,2) # 2번 선거구 시작점
                    fill(N-1,0,3) # 3번 선거구 시작점
                    fill(N-1,N-1,4) # 4번 선거구 시작점


                    count = [0,0,0,0,0]
                    for i in range(N):
                        for j in range(N):
                            if district[i][j] == 1:
                                count[0] += d_input[i][j]
                            elif district[i][j] == 2:
                                count[1] += d_input[i][j]
                            elif district[i][j] == 3:
                                count[2] += d_input[i][j]
                            elif district[i][j] == 4:
                                count[3] += d_input[i][j]
                            else:
                                count[4] += d_input[i][j]

                    value = max(count) - min(count)
                    if value < result:
                        result = value
```


```python
print(result)
```

## Reference
- https://www.acmicpc.net/problem/17779
- https://www.youtube.com/watch?v=sfIseJYH7NE
