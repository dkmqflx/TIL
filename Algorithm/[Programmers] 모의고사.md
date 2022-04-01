
- 완전탐색 문제

### 첫번째 풀이 

```python
def solution(answers):
    lst = [[1,2,3,4,5]*10000, 
           [2, 1, 2, 3, 2, 4, 2, 5]*10000, 
           [3, 3, 1, 1, 2, 2, 4, 4, 5, 5]*10000]
    
    count = 0
    comp = []
    for i in range(len(lst)):
        for j in range(len(answers)):
            #print("i, j", i,j)
            if lst[i][j] == answers[j]:
                count+=1
        #print("count is ", count)
        comp.append(count)
        count = 0
    
    answer = []
    
    max_index = comp.index(max(comp)) # 가장 큰 인덱스 위치를 찾는다 
     
    for i in range(len(comp)): # 루프를 통해서 가장 큰 인덱스와 같은 값을 가지는 인덱스를 추가한다 
        if comp[max_index] == comp[i]:
            answer.append(i+1)
    return answer
```

- Test Case


```python
solution([1,3,2,4,2])
```




    [1, 2, 3]




```python
solution([1,2,3,4,5])
```




    [1]
    
### 두번째 풀이 

```
def solution(answers):
    result = [0, 0, 0]
    first = [1,2,3,4,5]
    second = [2, 1, 2, 3, 2, 4, 2, 5]
    third = [3, 3, 1, 1, 2, 2, 4, 4, 5, 5]
    while (len(first) <=10000):
        first.extend(first)
        second.extend(second)
        third.extend(third)
    
    for i in range(len(answers)):
        if answers[i] == first[i]:
            result[0]+=1
        if answers[i] == second[i]:
            result[1]+=1
        if answers[i] == third[i]:
            result[2]+=1
    
    answer = [idx+1 for idx, x in enumerate(result) if x == max(result)]
    return answer

```


## Reference
    - https://programmers.co.kr/learn/courses/30/lessons/42840
