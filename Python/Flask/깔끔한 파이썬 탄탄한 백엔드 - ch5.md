
## 미니 트위터 구현

### 핵심기능
- 회원가입
- 로그인
- 트윗(tweet)
- 다른 회원 팔로우(follow)
- 다른 회원 언팔로우(unfollow)
- 타임라인
- 많은 수의 동시접속, HTTP 요청 속도를 고려한 구현은 하지 않는다.


#### 회원가입
- id
- name
- email
- password
- profile


#### 회원가입 구현


```python
from flask import Flask, jsonify, request
#필요한 Flask module import
#request : HTTP 요청을 통해 전송한 JSON 데이터를 읽어 들일 수 있다
#jsonify : dictionary 객체를 JSON으로 변환하여 HTTP 응답으로 보낸다.

app = Flask(__name__) 
# Flask 클래스를 객체화(instantiate)시켜서 app변수에 저장. 
#이 app 변수가 API 애플리케이션. 여기에 API 설정과 엔드포인트들을 추가하면 API가 완성된다

app.users = {} # 새로 가입한 사용자를 저장하는 dictionary
app.id_count = 1 # 회원가입하는 사용자의 id 값을 저장하는 변수, 가입자 늘면 1씩 증가한다.

@app.route("/sign-up", methods=['POST']) #엔드포인트의 고유주소를 "/sign-up"으로 지정, http 메소드는 POST
def sign_up():
    new_user = request.json
    #HTTP요청을 통해 전송된 회원 정보를 읽어들임
    #request에는 엔드포인트에 전송된 HTTP요청정보 (header, body등)을 저장하고 있다.
    #requst.json을 통해서 전송된 JSON 데이터를 python dictionary로 변환해준다
    new_user["id"] = app.id_count # HTTP 요청으로 전송된 회원가입 정보에 id값을 더해준다.
    app.users[app.id_count] = new_user
    app.id_count = app.id_count + 1
    
    return jsonify(new_user)#
```

#### 실행


```python
FLASK_ENV=development FKAS-APP=app.py flask run
#FLASK_ENV : Flask가 실행되는 개발 스테이지
#development로 지정하면 debug mode가 실행된다.
#debug mode실행시 코드가 수정될 때마다 Flask가 자동으로 재실행되어 수정된 코드가 반영되도록 해준다.
```

#### 회원가입 요청


```python
http -v POST localhost:5000/sign-up name=kim email=kim@gmail.com
```

#### 300자 제한 트윗 글 올리기

- 사용자가 300자 이내의 글을 전송하면 엔드포인트는 사용자의 글을 저장한다
- 사용자는 타임라인 엔드포인트로 저장된 글을 읽을 수 있다

- Tweet 엔드포인트를 호출할 때 전송하는 JSON 데이터


```python
{
    "id" : 1, # tweet 보내는 사용자의 아이디
    "tweet" : "My First Tweet"
}
```


```python
app.tweets = [] # 트윗을 저장할 디렉터리, key = 사용자 아이디, value = 트윗을 담고 있는 리스트

@app.route('/tweet', methods=["POST"]) # 엔드포인트의 주소는 "/tweet", http메소드 : POST
def tweet():
    payload = request.json
    user_id = int(payload['id']) # 전송된 JSON데이터에서 사용자를 읽어들임
    tweet = payload['tweet']
    
    if user_id not in app.users:
        return '사용자가 존재하지 않습니다', 400
    
    if len(tweet) > 300:
        return '300자를 초과했습니다', 400
    
    user_id = int(payload['id'])
    
    #해당 사용자 아이디와 트윗을 딕셔너리로 생성해서 app.tweets 리스트에 저장시킨다.
    app.tweets.append({ 
        'user_id' : user_id,
        'tweet' : tweet
    })
    
    return '', 200
```

#### 실제 트윗 보내기


```python
http -v POST localhost:500/tweet id:=1 tweet"My First Tweet"
```

#### 팔로우와 언팔로우 엔드포인트

- 팔로우 엔드포인트에 전송할 JSON 데이터


```python
{
    "id" : 1,
    "follow" : 2
}
```

- 언팔로우 엔드포인트에 전송할 JSON 데이터


```python
{
    "id" : 1,
    "unfollow" : 2
}
```

#### 팔로우 엔드포인트 구현


```python
from flask.json import JSONEncoder 
#flask.json 모듈에서 JSONEncoder 클래스 임포트한 후 
#JSONEncoder 클래스를 확장해서 Custome Encoder를 구현

#list는 JSON으로 변경될 수 있지만 set을 파이썬의 json 모듈이 JSON으로 변경하지 못한다
#Custom JSON encoder를 직접 구현해서 default JSON encoder에 더어 씌운다

class CustomJSONEncoder(JSONEncoder): # JSONEncoder 클래스를 부모클래스로 상속받는 CustomJSONEncoder 구현
    def default(self, obj):           # JSONEncoder 클래스의 default 메소드를 over-write
        if isinstance(obj, set):      # JSON으로 변경하고자 하는 객체(obj)가 set인 경우 list로 변경
            return list(obj)          
        
        return JSONEncoder.default(self, obj) #객체가 set이 아닌 경우는 본래 JSONEncoder의 default메소드 호출
    
app.json_encoder = CustomJSONEncoder 
# CustomJSONEncoder 클래스를 Flask의 default JSONEncoder로 지정
# jsonify 함수가 호출될 때 마다 JSONEncoder가 아닌 CustomeJSONEncoder 클래스가 사용된다.

app.route('/follow', methods=['POST'])
def follow():
    payload = requset.json
    user_id = int(payload['id'])
    user_id_to_follow = int(payload['follow'])
    
    if user_id not in app.users or user_id_follow not in app.users: # 사용자나 팔로우할 사용자가 존재하지 않는 경우
        return '사용자가 존재하지 않습니다', 400
    
    user = app.users[user_id] # app.users 딕셔너리에서 해당 사용자의 데이터를 읽어들인다
    user.setdefault('follow', set()).add(user_id_to_follow)
    #사용자의 정보를 담고 있는 딕셔너리가 이미 "follow" 필드를 가지고 있을 때 
    #즉, 이미 사용자가 다른 사용자를 팔로우한 적이 있는 경우
    #사용자의 "follow" 키와 연결되어 있는 set에 팔로우 하고자 하는 사용자 아이디를 추가한다
    #처음 팔로우를 하는 경우
    #딕셔너리에 "follow"라는 키를 empty set과 연결하여 추가한다.
    
    #setdefault를 사용해서 키가 존재하지 않으면 default 값을 저장하고 키가 존재하면 해당 값을 읽어들인다
    #이미 팔로우하고 있는 사용자를 팔로우하는 요청이 들어왔을 대도 동일한 사용자가 여러번 저장되지 않게 list대신 set을 이용한다
    
    
    return jsonify(user)
```

#### 팔로우 엔드포인트에 HTTP 요청


```python
http -v POST localhost:5000/follow id:=1 follow:=2
```

#### 언팔로우 엔드포인트 구현


```python
@app.route('/unfollow', methods=['POST'])
def unfollow():
    payload = request.json
    user_id = int(payload['id'])
    user_id_to_follow = int(payload['unfollow']) #언팔로우할 사용자 아이디를 읽어들임
    
    if user_id not in app.users or user_id_to_follow not in app.users:
        return '사용자가 존재하지 않습니다', 400
    
    user = app.users[user_id]
    user.setdefault('follow',set()).discard(user_id_to_follow)
    
    #언팔로우할 사용자 아이디를 set에서 삭제
    #remove 메소드 대신 discard 메소드를 사용하는 이유는
    #remove 메소드는 없는 값을 삭제하려고 하면 오류를 일으키지만
    #discard 메소드는 삭제하고자 하는 값이 있으면 삭제하고 없으면 무시한다
    #따라서 삭제하고자 하는 사용자 아이디가 set에 존재하는지 확인하는 로직을 구현하지 않아도 된다
```

#### 타임라인 엔드포인트

- 타임라인 엔드포인트가 리턴하는 JSON 데이터


```python
{
    "user_id" : 1,
    "timeline" ; [
        {
            "user_id" : 2,
            "tweet" : "Hello world"
        },
        {
            "user_id" : 1,
            "tweet" : "My first tweet!"
        }
    ]
}
```

#### 타임라인 엔드포인트


```python
@app.route('/timeline/<int:user_id>', methods=['GET']) #엔드 포인트의 주소에 해당 사용자의 아이디를 지정할 수 있다

def timeline(user_id): # 타임라인 엔드포인트를 구현하는 함수, user_id를 인자로 전달받는다.
    if user_id not in app.users:
        return '사용자가 존재하지 않습니다', 400
    
    follow_list = app.users[user_id].get('follow', set()) 
    # 해당 사용자가 팔로우하는 사용자들 리스트를 읽어들인다.
    # 사용자가 다른 팔로우한 적이 없는 경우 follow 필드가 존재하지 않을 수 있다. 그런경우 empty set 리턴
    
    follow_list.add(user_id) # 해당 사용자도 추가해서 해당 사용자의 트윗도 볼 수 있도록 한다
    
    timeline = [tweet for tweet in app.tweets if tweet['user_id'] in follow_list]
    #전체 트윗 중에 해당 사용자와 해당 사용자가 팔로우하는 사용자들의 트윗들만 읽어들인다.
    
    return jsonify({
        'user_id' : user_id,
        'timeline' : timeline
    }) 
    #사용자 아이디와 함께 타임라인을 JSON 형태로 리턴한다.
```


      File "<ipython-input-1-273690e85bf7>", line 2
        def timeline(user_id):
                              ^
    SyntaxError: unexpected EOF while parsing



- Reference [깔끔한 파이썬 탄탄한 백엔드](http://www.yes24.com/Product/goods/68713424)
- 모든 코드는 [저자의 깃허브에](https://github.com/rampart81/python-backend-book) 공개되어 있습니다