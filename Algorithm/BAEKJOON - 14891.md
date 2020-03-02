```python
from collections import deque
```


```python
import sys
adj = [list(input()) for _ in range(4)]
```


```python
rotate_count = int(input())
```


```python
def move(lst, check):
    lst_new = []
    if check == 1: #clockwise
        for i in range(len(lst)):
            if i+1 == len(lst):
                lst_new.insert(0, lst[i])
            else:
                lst_new.append(lst[i])

    else : # counterclockwise
        for i in range(len(lst)):
            if i+1 != len(lst):
                lst_new.append(lst[i+1])
            else:
                lst_new.append(lst[0])
    return lst_new
```


```python
for _ in range(rotate_count):
    position, direction = map(int ,sys.stdin.readline().split())
    position -= 1 

  
    if position == 0: # 1번 톱니바퀴
        lst_check = []
        lst_check.append([position, direction])
        if adj[position][2] != adj[position+1][6] :
            lst_check.append([position+1, -direction])
            if adj[position+1][2] != adj[position+2][6]:
                lst_check.append([position+2, direction])
                if adj[position+2][2] != adj[position+3][6]:
                    lst_check.append([position+3, direction])

        for i in range(len(lst_check)):
            adj[lst_check[i][0]] = move(adj[lst_check[i][0]], lst_check[i][1])

    elif position == 1: 
        lst_check = []
        lst_check.append([position, direction])
        if adj[position][6] != adj[position-1][2]: 
            lst_check.append([position-1, -direction])
            
        if adj[position][2] != adj[position+1][6]:
            lst_check.append([position+2, -direction]) 
            if adj[position+1][2] != adj[position+2][6]:
                lst_check.append([position+2, direction])

        for i in range(len(lst_check)):
            adj[lst_check[i][0]] = move(adj[lst_check[i][0]], lst_check[i][1])


    elif position == 2: 
        lst_check = []
        lst_check.append([position, direction])
        
        if adj[position][6] != adj[position-1][2]: 
            lst_check.append([position-1, -direction])
            if adj[position-2][2] != adj[position-1][6]: # 2번과 비교 
                lst_check.append([position-2, direction])
    
        if adj[position][2] != adj[position+1][6]:
            lst_check.append([position+1, -direction]) # 4번과 비교 

        for i in range(len(lst_check)):
            adj[lst_check[i][0]] = move(adj[lst_check[i][0]], lst_check[i][1])    
  
    else :
        lst_check = []
        lst_check.append([position, direction])
        
        if adj[position][6] != adj[position-1][2]: #3 번과 비교 
            lst_check.append([position-1, -direction])
        
        if adj[position-1][6] != adj[position-2][2]:
            lst_check.append([position-2, direction])
            if adj[position-2][2] != adj[position-3][2]:
                lst_check.append([position-3, -direction])
            
        for i in range(len(lst_check)):
            adj[lst_check[i][0]] = move(adj[lst_check[i][0]], lst_check[i][1])        
```


```python
count = 0

if adj[0][0] == '1':
    count +=1
if adj[1][0] == '1':
    count +=2
if adj[2][0] == '1':
    count +=4
if adj[3][0] =='1':
    count +=8


print(count)
```

## Reference
 - https://www.acmicpc.net/problem/14891
