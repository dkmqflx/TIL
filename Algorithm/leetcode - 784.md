
### Backtracking

- 조건에 맞는 모든 경우를 찾는다. 
- 조건에 맞는 값을 찾을 때 까지 전진하고
- 더 이상 나갈 길이 없으면 한칸 후퇴한다.
- 이 과정을 계속 반복

- 이 문제에서는 입력에 문자가 있을 때 대문자, 소문자가 되는 모든 경우의 수를 반환해야 한다


```python
import sys

s = list(sys.stdin.readline().strip());

lst = []


def backtrack(lst,ret,idx):
    if(idx == len(lst)):
        ret.append(''.join(lst))
    else:
        ch = lst[idx]
        if(ch.isalpha()):
            lst[idx] = ch.upper()
            backtrack(lst,ret,idx+1)
            lst[idx] = ch.lower()
            backtrack(lst,ret,idx+1)
        else:
            backtrack(lst, ret, idx+1)

backtrack(s, lst, 0)

print(lst)






```

## Reference

- https://leetcode.com/problems/letter-case-permutation/description/
- https://www.youtube.com/watch?v=tc0CKG0faZU
