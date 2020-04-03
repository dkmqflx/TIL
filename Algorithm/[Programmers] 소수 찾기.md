```python
from itertools import permutations
```


```python
numbers = "011"
```


```python
def solution(numbers):
    decimal_lst = []
    
    for i in range(1,len(numbers)+1):
        permu_lst = list(set(permutations(numbers, i)))   # 중복되는 수 제거하기 위해 set 사용
        permu_lst_int = []
        for j in range(len(permu_lst)):
            permu_lst_int.append("".join(permu_lst[j])) 
        
        permu_lst_int = list(map(int, permu_lst_int)) # str형 int형으로 변환
        
        decimal_lst.extend(permu_lst_int) # 소수 검사하기 위한 리스트에 추가 
    decimal_lst = set(decimal_lst) # 중복되는 수 제거하기 위해 set사용
    
    primes = []
    max_len = max(decimal_lst)
    check = [False, False] + [True] * (max_len-1)
    
    for i in range(2, max_len+1):
        if check[i]:
            primes.append(i)
            for j in range(i*2, max_len+1, i): # i를 제외한 모든 i의 배수에 대해서 
                if check[j]:
                    check[j] = False
    answer = len([i for i in decimal_lst if i in primes])

    return answer
    
        
```


```python
numbers = "17"
```


```python
solution(numbers)
```




    3




```python
numbers = "011"
```


```python
solution(numbers)
```




    2



- 소수를 구하는 부분에서 처음에는 아래 풀이로 문제를 풀어보았지만 시간 초과 문제가 발생하였다 
- 따라서, 해당 문제를 풀기 위해서는 [에라토스테네스의 체](https://wikidocs.net/21638)를 이해 해야 한다


```python
def decimal_check(number):
    decimal_count = 0
    if number == 2:
        return False
    
    for i in range(1, number+1):
        if number % i == 0:
            decimal_count+=1
    
    if decimal_count == 2:
        return True
    else:
        return False
            
```

- 간단히 말해서 에라토스테네스의 체의 방법을 사용하는 것은 소수인지 알고 싶은 수들이 모여있는 리스트에 대해서 소수인 수를 미리 체크한 리스트를 구한다음, 리스트와 비교해서 소수인 수들만 찾아내는 것이다


```python
decimal_lst = [1, 7, 17, 71]
```


```python
primes = [] # 소수인 수들을 담기 위한 리스트 

max_len = max(decimal_lst) # decimal_lst는 내가 소수인지 알고 싶은 수 들이 모여 있는 리스트, 리스트에 있는 가장 큰 수  
check = [False, False] + [True] * (max_len-1) # 0과1은 버리고 2 부터 소수인지 검사, 인덱스가 2면 소수 2를 나타내므로 max_len -1

for i in range(2, max_len+1): # 2부터 리스트에 있는 가장 큰 수 까지 
    if check[i]: # 소수인 경우, 4인 경우에는 아래 코드에 의해 미리 False처리가 된다 
        primes.append(i)
        for j in range(i*2, max_len+1, i): # i를 제외한 모든 i의 배수에 대해서 
            if check[j]: # 아직 소수가 아니라고 체크 하지 않은 경우
                check[j] = False # 소수가 아니라고 체크 
                
answer = len([i for i in decimal_lst if i in primes])

return answer


```

## Reference
- https://programmers.co.kr/learn/courses/30/lessons/42839
- https://wikidocs.net/21638
- https://sinawi.tistory.com/69


```python

```
