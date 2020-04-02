```python
def solution(progresses, speeds):
    lst = []
    for i in range(len(progresses)):
        pro = progresses[i]
        time = 0
        while(pro<100):
            pro+=speeds[i]
            time+=1
        lst.append(time)
    
    #print(lst)
    answer = []
    while(lst):
        comp = lst.pop(0)
        count = 0
        #print(f"comp is {comp}")
        for i in range(len(lst)):
            if lst[i] > comp:
                break
            
            else:
                count+=1
        
        answer.append(count+1)
        for i in range(count):
            lst.pop(0)
              
    #print(answer)
    return answer
```


```python
progresses = [93, 30, 55]
speeds = [1, 30, 5]
```


```python
solution(progresses, speeds)
```




    [2, 1]




```python
progresses = [ 93 , 30 , 55 , 60 ];
speeds = [ 1, 30 , 5 , 40 ];
```


```python
solution(progresses, speeds)
```




    [2, 2]



## Reference
- https://programmers.co.kr/learn/courses/30/lessons/42586
