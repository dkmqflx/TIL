```python
import sys

r, c, k = map(int, sys.stdin.readline().split())
#print(r,c,k) 

arr = []
for _ in range(3):
    arr.append(list(map(int, sys.stdin.readline().split())))
#print(arr)
```


```python
def operation(arr): # 연산을 위한 함수 
    temp = [] # 변경된 배열을 저장하기 위한 리스트 

    for i in range(len(arr)): # 모든 행에 대해서 
        #각 행 마다 
        temp_list = [] # 임시 리스트 만든다
        arr[i].sort() # 정렬해서 같은 수가 반복되도록 한다. ex)1, 1, 1, 2, 2
        for idx in list(set(arr[i])): # set을 사용해서 리스트에 있는 중복되지 않는 모든 수에 대해서 
            if idx != 0: # 0은 카운트 하지 않으므로 
                count = 0
                for j in range(len(arr[i])): # 같은 수가 있으면 count 
                    if idx == arr[i][j]:
                        count +=1
                temp_list.append([idx, count]) # 수와 등장 횟수를 리스트에 추가 
    
    #print(arr)
    #sorting function
    #after sorting and merging then append temp
    bubblesort(temp_list) # 등장 횟수에 대해서 정렬해준다 
    temp_list = concat(temp_list) # 각 행에 대해서 하나의 리스트로 합쳐준다 
    temp.append(temp_list) # temp에 추가해준다 

    #print(temp_list)
    #print(temp)
      fill(temp) # 0 빈 곳에 0을 채워준다 
    for i in range(len(temp)): # 길이가 100을 넘을 경우 처음 100개만 사용
        temp[i] = temp[i][0:100]
    return temp
```


```python
def bubblesort(lst): 
    for i in range(len(lst)-1):
        for j in range(len(lst)-i-1):
            if lst[j][1] > lst[j+1][1]: # 등장 횟수만 가지고 비교 
                temp = lst[j+1]
                lst[j+1] = lst[j]
                lst[j] = temp
```


```python
def concat(lst): # 하나의 리스트로 합쳐주기 위한 함수 
    result = []
    for i in range(len(lst)):
        result += lst[i]
        return result
```


```python
def fill(lst): # 빈 곳을 0으로 채워주기 위한 함수 
    max_len = 0
    for i in range(len(lst)): # 각 행에서 가장 길이가 긴 행의 길이를 기준으로 
        if len(lst[i]) > max_len:
            max_len = len(lst[i])
  
    for i in range(len(lst)): # 가장 길이가 긴 행 보다 작은 행의 경우 빈 곳을 0으로 채워준다 
        for j in range(max_len - len(lst[i])):
            lst[i] += [0]
```


```python
def rotate(lst): # C연산을 할때 rotate를 시켜 행으로 바꿔주기 위한 함수 
    temp = [[0] * len(lst) for _ in range(len(lst[0]))] # 행과 열의 위치가 다른 리스트 만들어준다 
    
    for i in range(len(lst)):
        for j in range(len(lst[i])):
            temp[j][i] = lst[i][j]
  
    return temp
```


```python
time = 0
while(time <= 100): # 100이 넘어가는 경우 -1이므로 100초까지는 count
    #print(f"loop time {time}")
    #print(arr)
    if r-1 <= len(arr)-1 and c-1 <= len(arr[0])-1: # 배열의 크기가 계속 바뀌므로 index 벗어나는 error 막기 위해서 
        if arr[r-1][c-1] == k:
            break

    if len(arr) >= len(arr[0]): # R연산 
        arr = operation(arr)
        
    elif len(arr) < len(arr[0]): # C연산
        arr = rotate(arr) # 우선 rotate 해준다음
        arr = operation(arr) # R연산을 해준다음
        arr = rotate(arr) # 결과를 다시 rotate해준다 
  
    time +=1
```


```python
if time >100: # 100초를 넘어가는 경우 -1
    #print(time)
    print(-1)
else: # 100초까지는 count
    print(time)
```

## Reference
- https://www.acmicpc.net/problem/17140
