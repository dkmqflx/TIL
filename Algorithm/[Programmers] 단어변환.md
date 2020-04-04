- BFS를 사용해서 해결한다
- begin을 기준으로 words에 있는 문자열 중 서로 1개의 문자만 다른 문자열을 queue에 추가한다
- 해당 queue에 있는 원소를 pop 해서 꺼냈을 때, target과 일치하는 경우 해당하는 높이를 return한다


```python
from collections import deque

def solution(begin, target, words):
    # dictionary에 각 문자열까지 가는 높이를 저장한다
    dict = {}
    dict[begin] = 0
    visited = []
    for i in words:
        dict[i] = 0
        
    answer =  bfs(begin, target, words, visited, dict)
    
    if not answer:
        return 0
    else:
        return answer
    
```


```python
def similar_check(str1, str2): # 두 문자열을 비교했을 때 서로 다른 문자가 1개 뿐인지
    count = 0
    for i in range(len(str1)):
        if str1[i] == str2[i]:
            count+=1
    return count     
```


```python
def bfs(begin, target, words, visited, dict):
    
    queue =  deque()
    
    queue.append(begin)
    
    while(queue):
        start = queue.popleft()
        if start == target:
            return dict[start] # target찾으면, target까지 가는 높이 출력 
       
        visited.append(start)
      
        for word in words:
            if similar_check(start, word) == len(start)-1 and word not in visited:
                queue.append(word)
                visited.append(word)

                dict[word] +=1
                dict[word] += dict[start]
                 
```


```python
begin = "hit"
target = "cog"
words = ["hot", "dot", "dog", "lot", "log", "cog"]
```


```python
solution(begin, target, words)
```




    4




```python
begin = "hit"
target = "cog"
words = ["hot", "dot", "dog", "lot", "log"]
```


```python
solution(begin, target, words)
```




    0




```python
begin = "hot"
target = "lot"
words = ["hot", "dot", "dog", "lot", "log"]
```


```python
solution(begin, target, words)
```




    1




```python
begin = "hit"
target ="hhh"
words = ["hhh","hht"]
```


```python
solution(begin, target, words)
```




    2



## Referene
- https://programmers.co.kr/learn/courses/30/lessons/43163
