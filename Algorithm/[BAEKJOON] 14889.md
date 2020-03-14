- 해당 문제는 주어진 조건에 대해 가능한 경우를 일일이 다 탐색해서 문제를 해결하는 완전탐색 문제이다
- 문제를 해결하기 위해서는 다음과 같은 두 단계가 필요하다
    1. star team, link team이 있으므로, N명을 2개팀으로 나눈다
    2. 각 팀에 대해서 팀원들이 같은 팀이 되었을 때 능력치를 구해주어야 한다. 
        예를 들어 1,2,3이 같은 팀이라면 1과 2가 같은  팀이 되었을 때의 능력치(s12+s21), 1과 3이 같은 팀이 되었을 때의 능력치(s13+s31, s23+32), 2과 3이 같은 팀이 되었을 때의 능력치(s23+s32)를 모두 구해야 하므로 팀원이 2명씩 짝지을 수 있는경우를 구해준다


```python
import sys
import itertools # 조합을 구하기 위해서 사용

N = int(sys.stdin.readline())
min_val = 101 # sij 값은 1보다 크거나 같고 100보다 작거나 같은 정수이므로 
```


```python
# s입력 받음
s = []
for i in range(N):
    s.append(list(map(int,sys.stdin.readline().split())))

    
```


```python
# star team을 조합으로 뽑기 위한 리스트 만든다 
lst = []
for i in range(N):
    lst.append(i)

# star team은 주어진 N/2개씩 한 팀이 된다(ex. N=4 -> 2개씩 2팀, N=6-> 3개씩 2팀)

lst_comb = [] # star team이 만들어 질 수 있는 모든 경우의 수를 담는 리스트

for c in itertools.combinations(lst, N//2): # N/2개가 한 팀이 되는 경우의 수 (조합), // 연산자를 쓰면 정수로 나누어 떨어진다 
    lst_comb.append(list(c)) # tuple로 반환되므로 list로 형변환
```


```python
for i in range(len(lst_comb)): # star team이 될 수 있는 모든 경우의 수에 대해서 
    lst = []
    for j in range(N):
        lst.append(j) # link team을 만들기 위한 리스트. N 크기 만큼의 리스트를 만든다
        for k in range(len(lst_comb[i])): # 총 N개의 원소에 대해서 star team에 이미 있는 원소를 제거해 준다 
            lst.remove(lst_comb[i][k]) 
    
    # 각 팀당 팀원 수 는 N/2명이다
    # 따라서 N/2명에 대해서 각 팀원 두명이 한 팀이 되었을 때의 능력치를 계산하기 위해서
    # N/2개 중에서 2명씩 짝지어 주는 경우의 수를 구한다 (조합)
    
    # star team combination
    star_lst = []
    for c in itertools.combinations(lst_comb[i], 2):
        star_lst.append(list(c))
    
    # link team combination
    link_lst = []
    for c in itertools.combinations(lst,2):
        link_lst.append(list(c))

    star_val = 0
    link_val = 0
    
    # star team의 능력치 계산
    for _ in range(len(star_lst)):
        i, j = star_lst.pop(0) 
        star_val += s[i][j]
        star_val += s[j][i]
    
    # link team의 능력치 계산
    for _ in range(len(link_lst)):
        i, j = link_lst.pop(0)
        link_val += s[i][j]
        link_val += s[j][i]

    diff = abs(star_val - link_val)
    
    if diff < min_val:
        min_val = diff

print(min_val)


 
```

## Reference
- https://www.acmicpc.net/problem/14889
