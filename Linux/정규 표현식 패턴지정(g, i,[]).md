
## 정규 표현식 패턴 지정을 좀 더 간단히 만들기

- 한 줄안에 여러번 나오는 문자열을 sed로 치환하려고 할 때 
- 하나의 문자열 밖에 치환되지 않는다
- 보통 sed나 vim은 한 줄에 한번 치환하면 바로 다음줄로 넘어가기 때문


- 따라서 g 플래그(global replacement)를 지정해서 전체 치환 모드로 만든다
- 전체 치환 모드에서는 한 줄안에서 해당하는 모든 부분을 치환한다 

- 치환하고 싶은 문자열에 대소문자가 섞여 있을 때 대소문자 차이를 무시하는 i플래그 옵션을 사용한다 

```
"s/(WINDOWS|Windows|windows) (XP|Xp|xp)/Windows"
# WINDOWS XP
# Windows XP
# windows XP
# 위 세가지 모두 windows로 치환된다 
```


```
"s/squeeze/wheezy/i"

# Squeeze, SQUEEZE 등 모두 wheeyze로 치환된다 

```


```

"s/(WINDOWS|Windows|windows) (XP|Xp|xp)/Windows"

"s/(Windows XP/windows/i
#아래와 같이 간단하게 바꿀 수 있다


# g플래그와 i플래그는 같이 쓸 수 있다
"s/Windows XP/Windows/gi"



```

<hr>


- A-010 --> A-0010
- B-005 --> B-0005
- C-103 --> C 0103


- 위처럼 바꾸고 싶은 경우 
- "s/(A|B|C|D|E|F)-/\1-0" 


- bracket을 쓰면 더 간단히 표현할 수 있다
- "s/(A-F)-/\1-0" 

<hr>

- "s/(G|H|I|K|M|O|P|Q|R)-/\1-1" 처럼 연속적이지 않은 경우


- "s/[G-IKMO-R])-/\1-1"


- 대소문자 모든 알파벳의 경우
- [a-zA-Z]

## Reference
- [만화로 배우는 리눅스 시스템 관리](http://www.yes24.com/Product/Goods/32402055?Acode=101)
