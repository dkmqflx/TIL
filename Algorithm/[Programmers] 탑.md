```python
def solution(heights):
    answer = [0] * len(heights)
    for i in range(len(heights)-1, -1, -1):
        send = heights[i]
        #print(f"send is {send}")
        
        for j in range(i-1 ,-1, -1):
            if heights[j] > send:
                #print(f"j is {j}")
                answer[i] = j+1
                break
            #print(f"answer is {answer}")
        
    return answer
```


```python
heights = [6,9,5,7,4]
```


```python
solution(heights)
```

    send is 4
    j is 3
    send is 7
    answer is [0, 0, 0, 0, 4]
    j is 1
    send is 5
    j is 1
    send is 9
    answer is [0, 0, 2, 2, 4]
    send is 6
    




    [0, 0, 2, 2, 4]




```python
heights = [3,9,9,3,5,7,2]
```


```python
solution(heights)
```

    send is 2
    j is 5
    send is 7
    answer is [0, 0, 0, 0, 0, 0, 6]
    answer is [0, 0, 0, 0, 0, 0, 6]
    j is 2
    send is 5
    answer is [0, 0, 0, 0, 0, 3, 6]
    j is 2
    send is 3
    j is 2
    send is 9
    answer is [0, 0, 0, 3, 3, 3, 6]
    answer is [0, 0, 0, 3, 3, 3, 6]
    send is 9
    answer is [0, 0, 0, 3, 3, 3, 6]
    send is 3
    




    [0, 0, 0, 3, 3, 3, 6]




```python
heights = [1,5,3,6,7,6,5]
```


```python
solution(heights)
```

    send is 5
    j is 5
    send is 6
    j is 4
    send is 7
    answer is [0, 0, 0, 0, 0, 5, 6]
    answer is [0, 0, 0, 0, 0, 5, 6]
    answer is [0, 0, 0, 0, 0, 5, 6]
    answer is [0, 0, 0, 0, 0, 5, 6]
    send is 6
    answer is [0, 0, 0, 0, 0, 5, 6]
    answer is [0, 0, 0, 0, 0, 5, 6]
    answer is [0, 0, 0, 0, 0, 5, 6]
    send is 3
    j is 1
    send is 5
    answer is [0, 0, 2, 0, 0, 5, 6]
    send is 1
    




    [0, 0, 2, 0, 0, 5, 6]



## Reference
- https://programmers.co.kr/learn/courses/30/lessons/42588
