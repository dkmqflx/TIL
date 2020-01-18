

```python
import sys
from collections import Counter
```


```python
a = list(map(int, sys.stdin.readline().split()))
```


```python
N = a[0] 
M = a[1] 
```


```python
mat = []
lst = []
lst_hd = []
```


```python
for i in range(N):
    mat.append(sys.stdin.readline().strip())
  # mat.append(sys.stdin.readline().splitlines())
```


```python
for i in range(M):
    for j in range(N):
        lst.append(mat[j][i])
        lst.sort()
        ch = Counter(lst).most_common()[0]
    lst_hd.append(ch[0])
    lst = []
```


```python
count = 0
for i in range(N): 
    for j in range(M):
        if(mat[i][j]!= lst_hd[j]):
            count+=1
```


```python
print(''.join(lst_hd))
print(count)
```

## Reference

- https://www.acmicpc.net/problem/1969
