

```python
import sys

#첫 줄에 동전개수 N과 k원이 주어진다
a = list(map(int,sys.stdin.readline().split())) 
n= a[0]
cost = a[1]
```


```python

money = [] # 입력받는 동전의 가치를 저장하기 위한 리스트
change_num = 0 #필요한 동전의 개수
total = 0 # K원을 만드는데 필요한 동전 개수의 최소값
```


```python
#두번째줄 부터 N번째줄 까지 동전의 가치를 한 줄 씩 입력받는다.
for i in range(n):
    x = int(sys.stdin.readline())
    money.append(x)
```


```python
money_reversed = sorted(money, reverse=True) # Greey 알고리즘으로 풀기 위해서 내림차순으로 동전의 가치를 정렬한다.
```


```python
for j in range(n):
    for i in range(n):
        if(cost == 0):
            break
        if(cost%money_reversed[i] != cost): # K값을 동전의 가치로 나눴을 때의 나머지가 K값과 같지 않다면 그 동전의 가치로 K값을 나눌 수 있다.
            change_num = int(cost/money_reversed[i])
            total += change_num 
        cost %= money_reversed[i]
```


```python
print(total)
```

## Reference

- https://www.acmicpc.net/problem/11047
