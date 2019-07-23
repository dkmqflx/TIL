
## 풀이 1

- 아래 풀이는 https://has3ong.tistory.com/608를 참고해서 풀었습니다


```python
import sys

n = int(sys.stdin.readline()) 
line = list(map(int,sys.stdin.readline().split()))
```


```python
order = [] # 출력을 위한 리스트

for i in range(len(line)-1, -1, -1): # 따로 정렬을 해주는 것이 아니라 파이썬 range의 특성을 이용해서 
        order.insert(line[i], i+1) # 가장 키가 큰 사람 먼저 order 리스트에 추가 하였다 
    
for i in order:
    print(i, end =' ')
```

## 풀이 2


```python
import sys

n = int(sys.stdin.readline()) 
line = list(map(int,sys.stdin.readline().split()))
```


```python
line.sort() # 키가 큰 사람이 먼저 서도록 정렬한다. [0, 1, 1, 2]
order = [] # 출력을 위한 list
```


```python
for i in range(n):
    order.insert(line[i], n-i)
    
for i in order:
    print(i, end =' ')
```

- 파이썬 문법 range에서 숫자를 큰 수에서 작은수로 차감되는 방법을 배울 수 있었다.

- list의 append이외의 insert의 사용방법에 대해서 익힐 수 있었다.

- 왜 그런지는 모르겠는데 두번째 풀이는 채점해보면 계속해서 틀렸다고 한다.. 첫번째 풀이와 다를게 없는데 왜 틀린건지 이해가 안된다..

## Reference 

- https://www.acmicpc.net/problem/1138
