- 퀵 정렬은 병합 정렬과 마찬가지로 분할 정복(divide and conquer)에 근거해서 만들어진 정렬 방법이다
- 퀵 정렬에서는 pivot, left, right, low, high의 개념을 이해해야 한다


- pivot : 기준이 되는 원소
- left : 정렬 대상의 가장 왼쪽 지점을 가리키는 이름
- right : 정렬 대상의 가장 오른쪽을 가리키는 이름
- low : pivot을 제외한 가장 왼쪽에 위치한 지점
- high : pivot을 제외한 가장 오른쪽에 위치한 지점


```
pivot : 5
left : 5
right : 8
low : 1
high : 8

[5,1,3,7,9,2,4,6,8]

- low는 pivot보다 큰 값을 만날 때 까지 오른쪽으로 이동한다
- high는 pivot보다 작은 값을 만날 때 까지 왼쪽으로 이동한다
-> 그 다음 low와 high의 값을 교환한다
-> 이와 같은 과정을 low와 high가 역전될 때 까지 반복한다



```

- pivot이 중간에 해당하는 값일 경우 정렬 대상은 균등하게 나뉜다. 
- 예를 들어 [1,2,3,4,5,6,7,8,9]로 정렬되어 있고 pivot은 가장 왼쪽에 위치한 데이터로 결정한다고 가정할 때 
- 위의 배열은 결코 둘로 나뉘지 않는다. 
- 즉, 1부터 시작해서 9의 앞에 있는 8까지 순서대로 피벗이 되어 정렬의 과정을 거치게 된다 


- 정렬의 과정에서 선택되는 pivot의 수는 앞서 정의한 Partiton함수의 호출 횟수를 의미한다 
- 그렇기 때문에 Partition 함수의 호출횟수가 많다는 것은 그만큼 데이터의 비교 및 이동의 횟수가 증가함을 뜻한다
- 즉, 좋은 성능을 보이려면 최대한 중간 값에 가까운 pivot이 지속적으로 선택되어야 한다 
- 이를 위해서 정렬대상에서 세 개의 데이터를 추출하고 그 중에서 중간 값에 해당하는 것을 pivot으로 선택한다 
- 이 세가지 데이터를 추출하는 방법에는 여러가지가 있다
- 단순히 맨 앞에 위치한 3가지 데이터를 추출하는 방법, 또는 가장 왼쪽, 가장 오른쪽, 그리고 중간에 위치한 데이터를 추출하는 방법등
<hr>

- 정렬이 진행될 때 pivot이 결정되면 low는 오른쪽으로, high는 왼쪽으로 이동을 시작한다.
- 이동은 low와 high가 역전될 때 까지 진행되는데 이동과정에서 pivot과의 비교를 수행한다
- 따라서, 하나의 pivot이 제 자리를 찾아가는 과정에서 발생하는 비교 연산의 횟수는 데이터 수에 해당하는 n이라고 할 수 있다
- pivot으로 인해서 n보다 하나 적은 수의 비교 연산이 이루어지지만 이는 무시할 수 있다 


- 비교 연산 이외에도 분할이 몇 단계에 걸쳐서 이루어지는지도 이해를 해야 한다 
- 31개의 데이터가 있고 pivot이 항상 중간 값으로 결정되는 이상적인 경우를 가정하게 되면
- 31개의 데이터는 15개씩 둘로 나뉘어 총 2조각이 된다 
- 이어서 각각 7개씩 둘로 나뉘어 총 4조각이 된다
- 이어서 각각 3개씩 둘로 나뉘어 총 8조각이 된다
- 이어서 각각 1개씩 둘로 나뉘어 총 16조각이 된다 


- 둘로 나뉘는 횟수를 k라 할 때, 데이터 수 n과의 관계는 
- k = logn이 된다 
- 따라서 퀵 정렬에서 비교연산 횟수는 $\ nlog_{2} n$이고 
- 빅오는 O($\ nlog_{2} n$)

- 위의 빅오는 최선의 결과에 대한 빅오이다. 퀵 정렬의 경우에는 늘 최선의 경우를 보이는 것은 아니지만 최선의 경우에 가까운 성능을 평균적으로 보이기 때문이다 
- 최악의 경우에 대한 빅오는 이미 데이터들의 정렬되어 있는 상태에서 pivot이 가장 작은 값으로 결정되는 상황이다
- 이때 둘로 나뉘는 횟수 k와 데이터수 n의 관계는 다음과 같다 
- k = n
- 따라서 최악의 경우의 비교 연산 횟수에 대한 빅오는 $\ O(n^2)$


```python
def Swap(lst, idx1, idx2):
    temp = lst[idx1]
    lst[idx1] = lst[idx2]
    lst[idx2] = temp
```


```python
def Partition(lst, left, right):
    pivot = lst[left]  # pivot의 위치는 가장 왼쪽
    low = left + 1
    high = right

    while(low <= high):
        # low와 high사이에 =를 넣는 이유는 [3, 3, 3] 처럼 같은 수가 반복되는 리스트가 있을 때
        # 무한 루프에 빠질 수 있기 때문이다 
        while low <= right and pivot >= lst[low] : # pivot보다 큰 값 찾을 때 까지 이동, low위치 값이 pivot과 같아도 이동한다 
            low += 1        
        while high >= (left+1) and pivot <= lst[high] : # pivot 보다 작은 값 찾을 때 까지 이동, pivot 위치 때문에 +1
            high -= 1
        

        if (low <= high):
            Swap(lst, low, high) # 교차 되지 않은 상태라면 swap 실행, low와 high 위치에 있는 값 교환

    Swap(lst, left, high) # 피벗과 high가 가리키는 대상 교환
    
    return high # 옮겨진 피벗의 위치 정보 반환 
            
```


```python
def QuickSort(lst, left, right):
    if (left <= right):
        pivot = Partition(lst, left, right) # 둘로 나눈다 
        QuickSort(lst, left, pivot-1)
        QuickSort(lst, pivot+1, right)
```


```python

lst = [5,1,3,7,9,2,4,6,8]
```


```python
QuickSort(lst,0, len(lst)-1)
```


```python
lst
```




    [1, 2, 3, 4, 5, 6, 7, 8, 9]


