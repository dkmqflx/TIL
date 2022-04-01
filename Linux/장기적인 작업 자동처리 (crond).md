
## Ch1. 장기적인 작업 자동처리 

- crond
    - 지정한 시각에 명령어를 자동 실행하는 리눅스 서비스
- crondtab
    - crond로 실행하고 싶은 명령어와 실행시각(crondjob)
    

```
$ sudo crontab -l
#-l은 list 의미, cronjob 목록을 표시하는 옵션
```

- 0 3 * * * /scripts/do_backup.sh
    - 분, 시, 일, 월, 요일 순으로 표시 된다 
    - 일(0) 월(1) 화(2) 수 (3) 목(4) 금(5) 토(6) 일(7)
    - 일요일 0, 1 둘다 사용가능 
    
    
- 30 2, 14 * * * /scripts/do_backup.sh
    - 2시 30분과 14시 40분 모두 실행ㅊ


```

# * : 문자열 와일드카드
$ ls *a* # 중간에 a가 있는 모든 파일 출력

$ ls f* # 맨 처음 문자가 f인 모든 파일 출력 



```

<hr>

- usr 사용자로 
- 매주 월요일 11시 45분(오전)
- /home/usr/scripts/analyze_log.sh를 실행

```
$ crontab -e 

# cronjob 설정을 편집할 수 있다
# cronjob은 사용자마다 저장되므로 crontab은 명령어를 실행한 사용자의 cronjob만 처리한다 
# 특별한 권한이 필요한 처리가 아니라면 안전하게 root 권한이 없는 일반 사용자 cronjob을 쓰는게 원칙이다 

$ 45 11 * * 1 /home/usr/scripts/analyze.sh > /tmp/result_$(date +%y-%m-%d).txt # 실행 결과 파일로 출력 
# 셸 스크립트를 실행할 때는 홈 디렉터리에서의 상대 경로나 절대경로를 사용해야 한다 


$ 22 12 * * 1 /home/usr/scripts/analyze.sh > /tmp/result_$(date +%y-%m-%d).txt 
# 보통 현재 시각(12시 20분)보다 2분 이후 시간을 지정해서 cronjob을 설정해서 테스트 한다 


```

```
# 실행 결과를 자신의 메일 주소로 받는 방법
# cronjob의 실행결과를 자신의 메일 주소로 보낼 수 있다 
# 이 경우 MTA를 설정해 두어야 한다 

MAILTO = usr@gmail.com
$ 45 11 * * 1 /home/usr/scripts/analyze.sh > /tmp/result_$(date +%y-%m-%d).txt # 실행 결과 파일로 출력 


```

### Reference
  - [만화로 배우는 리눅스 시스템 관리](http://www.yes24.com/Product/Goods/32402055?Acode=101)
