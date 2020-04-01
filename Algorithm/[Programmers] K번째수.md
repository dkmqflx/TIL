```python
def solution(array, commands):
    answer = []
    for idx in range(len(commands)):
        i = commands[idx][0]-1
        j = commands[idx][1]-1
        k = commands[idx][2]-1
        lst = []
        for n in range(i,j+1):
            lst.append(array[n])
            lst.sort()
        answer.append(lst[k])    
    
    return answer
```

## Reference
- https://programmers.co.kr/learn/courses/30/lessons/42748
