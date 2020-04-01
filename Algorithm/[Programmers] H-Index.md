```python
citations = [3, 0, 6, 1, 5]
```


```python
citations = [4, 3, 3, 3, 3]
```


```python
citations = [0,0,0,0,0]
```


```python
def solution(citations):
    
    answer_lst = []
    for h in range(10000):
        max_h = 0
        min_h = 0
        
        for j in range(len(citations)):
            if citations[j] >= h:
                max_h +=1 # h번 이상 인용된 논문
            if citations[j] <= h:
                min_h +=1 # h번 이하 인용된 논문 
        
        if max_h >= h and h >= min_h: # h번 이상 인용된 논문이 h편 이상이고, 나머지 논문이 h번 이하 인용된 경우 
            print(f"max_h is {max_h}, h is {h}, min_h is {min_h}")
            answer_lst.append(h)
    
    if not answer_lst:
        answer = 0
        return answer
    else:
        answer = max(answer_lst)
    return answer
```


```python
citations = [3, 0, 6, 1, 5]
```


```python
solution(citations)
```




    3




```python
citations = [4, 3, 3, 3, 3]
```


```python
solution(citations)
```

    max_h is 5, h is 0, min_h is 0
    max_h is 5, h is 1, min_h is 0
    max_h is 5, h is 2, min_h is 0
    




    2




```python
citations = [0,0,0,0,0]
```


```python
solution(citations)
```




    0



## Reference

- https://programmers.co.kr/learn/courses/30/lessons/42747
