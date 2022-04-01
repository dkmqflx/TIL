

```python
def solution(arr1, arr2):
    answer = []
    add = []
    
    for i in range(len(arr1)):
        for j in range(len(arr1[i])):
            add.append(arr1[i][j] + arr2[i][j])
        
        print("add: ", add)
        answer.append(add)
        add = []
    return answer
```

- Test case


```python
solution([[1,2],[2,3]],[[3,4],[5,6]])
```

    add:  [4, 6]
    add:  [7, 9]





    [[4, 6], [7, 9]]



## Reference
-  https://programmers.co.kr/learn/courses/30/lessons/12950
