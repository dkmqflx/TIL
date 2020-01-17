

```python
import sys
```


```python
n = int(sys.stdin.readline())
count = 0
change = 1000 - n
lst = [500, 100, 50, 10, 5, 1]
```


```python
for i in lst:
    if(change>=i):
        temp = change // i
        change -= temp*i
        count+=temp
```


```python
print(count)
```

## Reference

- https://www.acmicpc.net/problem/5585
