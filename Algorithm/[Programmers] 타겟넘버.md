- DFS를 사용해서 해결할 수 있는 문제
- 매번 재귀를 사용할 때 마다 원소를 하나씩 추가해 나간다 
- 계속 원소를 추가하다가 모든 수를 다 사용한 경우 pop을 사용해서 하나 원소를 꺼내고, 부호가 반대인 원소를 추가 
- 예를 들어 [1]부터 시작하는 경우 [1,1,1,1,1]까지 끝내고 pop을 사용해서 맨 마지막 위치에 있는 1을 꺼낸 다음에  , [1,1,1,1,-1] 이런 식으로 -1을 다시 추가 


```python
numbers = [1,1,1,1,1]
target = 3
```


```python

def solution(numbers, target):
    global answer # 전역 변수 사용
    answer = 0 # 초기화 
    lst = []
    dfs(lst,numbers,target, 0)
    return answer

```


```python
def dfs(lst, numbers, target, idx):
    global answer # 전역 변수 사용 

    if len(lst) == len(numbers):
        if sum(lst) == target:
            answer +=1
        return
    
    lst.append(numbers[idx])
    dfs(lst,numbers,target,idx+1)
    lst.pop()
    
    lst.append(-numbers[idx])
    dfs(lst,numbers,target,idx+1)
    lst.pop()
    
    return 
    
```


```python
solution(numbers, target)
```




    5



### 두번째 풀이 방법

- result라는 리스트를 추가해서, 조건을 만족하는 수들을 리스트에 추가해준다
- 이 방법을 통해서 조건을 만족하는 원소들의 조합을 알 수 있다 
- 마지막으로는 리스트의 길이를 반환


```python
def solution(numbers, target):
    lst = []
    result = []
    answer = dfs(lst,numbers,result, target, 0)
    return answer

def dfs(lst, numbers,result, target, idx):

    if len(lst) == len(numbers):
        if sum(lst) == target:

            result.append([lst])
        return 
    
    lst.append(numbers[idx])
    dfs(lst,numbers,result, target,idx+1)
    lst.pop()
    
    lst.append(-numbers[idx])
    dfs(lst,numbers,result, target,idx+1)
    lst.pop()
    
    return len(result)
    
```


```python
solution(numbers, target)
```




    5



## Reference
- https://programmers.co.kr/learn/courses/30/lessons/43165
