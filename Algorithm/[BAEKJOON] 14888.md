- 해당 문제는 모든 경우의 수를 따진 후 결과를 출력하는 완전탐색 문제이다
- 또한 dfs를 사용해서 재귀적으로 문제를 해결할 수 있다 


```python
import sys

N = int(sys.stdin.readline())

lst = list(map(int, sys.stdin.readline().split()))

op = list(map(int, sys.stdin.readline().split()))

val_lst = []
```


```python
def dfs(result, count):
    if count == N-1: # 모든 연산이 끝나고 난 후, 결과값을 리스트에 추가한 후 return한다 
        val_lst.append(result)
        return 
    
    for i in range(len(op)):
        if op[i] != 0: # 연산자 위치 값이 0이 아닌 경우 
            op[i] -=1 # 해당 연산자를 이용해서 계산하므로 -1 해준다
            if i == 0: # +인 경우
                dfs(result + lst[count+1], count+1)
            elif i == 1: # -인 경우
                dfs(result - lst[count+1], count+1)
            elif i == 2: # * 인 경우
                dfs(result * lst[count+1], count+1)
            elif i == 3: # 나누기인 경우
                if result < 0 and lst[count+1]>0: # 음수를 양수로 나눌 경우
                    result *= -1 # 양수로 바꾼 후 
                    next_val =  result // lst[count+1] # 몫을 취한 다음
                    next_val *= -1 # 그 몫을 음 수로 바꾼 뒤 계산해 준다 
                    dfs(next_val, count+1)
                else:
                    dfs(result // lst[count+1], count+1)
            op[i] +=1
```


```python
dfs(lst[0], 0)
print(max(val_lst))
print(min(val_lst))
```

## Reference
- https://www.acmicpc.net/problem/14888
- https://www.youtube.com/watch?v=I5G2uU8GGZg
