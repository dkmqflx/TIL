
## Stack

- 한 쪽 끝에서 자료를 넣고 뺄 수 있는 LIFO(Last In First Out) 형식의 자료구조

- pop(): Stack에서 가장 위에 있는 데이터를 가져온다
- push(): 새로운 자료를 Stack에 추가한다 
- isEmpty(): 스택이 비어있는지 확인한다 


```python
class Stack:
    def __init__(self):
        self.lst = []
    def push(self, item):
        self.lst.append(item)
    def pop(self):
        return self.lst.pop()
    def isEmpty(self):
        return not self.lst
```
