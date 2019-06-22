### Endpoint

- API 서버가 제공하는 통신 채널 또는 접점
- 각 엔드포인트는 고유의 URL 주소를 가지게 되며, 고유의 URL 주소를 통해 해당 엔드포인트에 접속할 수 있다.
- 일반적으로 각 엔드포인트는 고유의 기능을 담당하고 있다. 그리고 이러한 엔드포인트들이 모여서 하나의 API를 구성하는 것이다.




```python
from flask import Flask

app = Flask(__name__)
# import한 Flask 클래스를 객체화 시켜서 app이라는 변수에 저장.
# app 변수에 API의 설정과 엔드포인트들을 추가하면 API가 완성된다.

@app.route("/ping", methods=['GET']) 
# flask의 route 데코레이터를 사용해서 엔드포인트 등록, HTTP 메소드는 GET으로 설정
# flask에서는 일반적으로 route 데코레이터를 이용해서 함수들을 엔드포인트로 등록하는 방식을 사용한다.

def ping():
    return "pong"
```
  



```python
FLASK_APP = app.py FLASK_DEBUG=1 flask run 
#api 실행하기
#FLASK_DEBUG를 1로 설정하면 debug모드가 활성화되어 코드가 수정되었을 때 새로 수정된 코드가 자동으로 반영되도록 한다
```




- Reference [깔끔한 파이썬 탄탄한 백엔드](http://www.yes24.com/Product/goods/68713424)
- 모든 코드는 [저자의 깃허브에](https://github.com/rampart81/python-backend-book) 공개되어 있습니다


