
## 이전 명령어가 실패하면 다음 명령어 실행

- OR 리스트

```
download-data --server=primary.datastore || download-data --server=secondary.datastore || exit 1

```

- AND 리스트는 모두 성공해야 실행된다 
- OR 리스트는 명령어 중 하나만 성공하도 다음 명령어 실행된다
- 즉, 이전 명령어가 실패했을 때만 다음 명령어를 실행한다 

```
# 이전 명령어 종료 status가 0(성공)이면

prepare-data && process-data && report-result

prepare-data
if [$? ==0 ]
then
    process-data
    if[$? ==0 ]
        then
            report-result
    fi
fi

```

```
# 이전 명령어 종료 status가 0이 아니라면 (실패)

prepare-data || process-data || report-result

prepare-data
if [$? != 0]
then
    process-data
    if[$? !=0 ]
        then
            report-result
    fi
fi



```

- ||로 명령어를 나열한 OR 리스트는 명령어 실행에 실패하면 다음 명령어를 실행한다 
- OR 리스트는 성공할 때까지 나열한 명령어를 순서대로 실행하는(실패하면 다음 안을 시험하는)사용법이 대다수
- 이런 처리에 실패하면 차선책으로 단계적으로 전환하는 것을 폴백이라고 한다 

  
### Reference
  - [만화로 배우는 리눅스 시스템 관리](http://www.yes24.com/Product/Goods/32402055?Acode=101)

