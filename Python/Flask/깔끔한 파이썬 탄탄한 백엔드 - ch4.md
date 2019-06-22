## HTTP (HyperText Transfer Protocol)

- 웹상에서 서로 다른 서버간에 HTML을 서로 주고 받을 수 있도록 만들어진 프로토콜 (통신규약)
- HTTP는 기본적으로 request와 response구조로 되어 있다.
- HTTP는 stateless한 구조이다
  - HTTP 프로토콜에서는 동일한 클라이언트와 서버가 주고 받은 HTTP 통신들이라도 서로 연결되어 있지 않고 각각의 통신은 독립적이다. 
  - 즉, 이러한 stateless한 구조를 가진다
  - 이러한 구조 때문에 HTTP 통신들의 상태를 서버에서 저장할 필요가 없어 서버 디자인이 간단해지지만 stateless하기 때문에 HTTP 요청을 보낼 때는 해당 요청을 처리하기 위해 필요한 모든 데이터를 포함시켜 요청해야 한다.
  - 이러한 점들을 해결하기 위해서 쿠키(cookie)나 세션(session)등을 사용해서 HTTP 요청을 처리할 때 필요한 진행 과정이나 데이터를 저장한다.
- 쿠키(cookei)
  - 웹 브라우저가 웹사이트에서 보내온 정보를 저장할 수 있도록 하는 파일
- 세션(session)
  - HTTP 통신삳에서 필요한 데이터를 저장할 수 있게 하는 매커니즘
  - 쿠키가 웹 브라우저, 클라이언트 측에서 데이터를 저장하는 반면에 세션은 웹 서버에서 데이터를 저장한다.

---------

##  HTTP 요청구조

- Start Line
- Headers
- Body



### Start Line

- HTTP 요청의 시작줄

```
GET /search HTTP/1.1
```

- HTTP 메소드
  - 해당 HTTP 요청이 의도하는 액션을 정의하는 부분
  - GET, POST, PUT, DELETE, OPTIONS
- Request target
  - 해당 HTTP 요청이 전성되는 목표 주소
- HTTP version
  - "1.0", "1.1", "2.0"이 있다
  - 버전 마다 HTTP 요청 메세지의 구조나 데이터가 다를 수 있다





### Header

- HTTP 요청 그 자체에 대한 정보를 담고 있다
- 파이썬의 dictionary처럼 key : value로 표현된다.
- google.com에 보내는 HTTP 요청의 Host 헤더의 경우

```
HOST : google.com
```

- Host
  - 요청이 전송되는 target 호스트의 URL 주소를 알려주는 헤더.
- User-Agent
  - 요청을 보내는 클라이언트에 대한 정보.
  - 예를 들어 웹 브라우저에 대한 정보
- Accept
  - 해당 요청이 받을 수 있는 응답(response) body 데이터 타입을 알려주는 헤더
  - MIME(Multipurpose Internet Mail Extensions) type이 value로 지정된다.
  - JSON 데이터 타입을 요쳥하는 경우는 application/json MIME type을 value로 지정
  - 모든 데이터 타입을 다 허용해주는 경우는 * / *
- Connection
  - 해당 요청이 끝난 후에 서버가 계속해서 네트워크 연결을 유지할 것인지 말 것인지를 알려주는 헤더
  - keep-alive
    - 앞으로도 계속해서 네트워크 연결 유지
  - close
    - 더 이상 HTTP 요청을 하지 않을 것이므로 네트워크 연결을 닫아도 된다는 뜻
- Connection-Type
  - HTTP 요청이 보내는 메시지 body의 타입
  - MIME type이 사용된다
  - JSON 데이터를 전송하면 Content-Type:application/json
- Connection-Length
  - HTTP 요청이 보내는 메세지 body의 총 사이즈

### Body

- HTTP 요청이 전송하는 데이터를 담고 있는 부분

-------

## HTTP 응답구조

- Status LIne
- Headers
- Body



### Status Line

- HTTP응답 메세지의 상태를 간략하게 요약하여 알려주는 부분

- ```
  HTTP/1.1 404 Not Found
  ```

- HTTP/1.1 : HTTP Version

- 404 : Status Code. 응답 상태를 숫자로된 코드로 나타낸다

- Not Found : 응답상태를 글로 설명해주는 부분

### Header

- HTTP 요청 헤더 부분과 동일하나 HTTP 응답에는 User-Agent 대신 Server 헤더가 사용된다

###Body

- HTTP 요청 메시지의 body와 동일하다.
- 전송하는 데이터가 없으면 body 부분은 비어있게 된다.

------

## 자주 사용되는 HTTP 메소드

### GET

- 어떠한 데이터를 서버로 부터 요청할 때 사용하는 메소드

### Post

- 데이터를 생성하고나 수정 및 삭제 요청을 할 때 주로 사용되는 메소드

### Option

- 주로 엔드포인트에서 허용하는 메소드들이 무엇이 있는지 알고자 할 때 사용되는 HTTP 메소드.

------

## API 엔드포인트 아키텍처 패턴

- RESTful vs GraphQL



### RESTful HTTP API

- REST(Representation State Transfer)ful HTTP API

- API에서 전송하는 리소스(resource)를 URI로 표현하고 해당 리소스에 행하고자 하는 의도를 HTTP 메소드로 정의하는 방식.

- 각 엔드포인트는 처리하는 리소스를 표현하는 고유의 URI 주소를 가지고 있다

- 사용자 정보를 리턴하는 "/users"라는 엔드포인트에서 사용자 정보를 받아오는 HTTP 요청

- ```
  HTTP GET /users
  GET /users
  ```

- 새로운 사용자를 생성하는 경우

  ```
  POST /user
  {
  	"name" : "newName",
  	"email" : "newMail@gmail.com"
  }
  ```

- RESTful API의 가장 큰 장점은 Self-descriptiveness
- 엔드포인트 구조를 통해서 해당 엔드포인트가 제공하는 리소스와 기능을 파악할 수 있다.



### GraphQL

- REST 방식의 API와는 다르게 엔드포인트가 하나다.

- 엔드포인트에 클라이언트가 필요한 것을 정의해서 요청하는 식

- 기존의 REST API 방식과 반대

- 서버가 정의한 틀에서 클라이언트가 요청하는 것이 아니라 **클라이언트가 필요한 것을 서버에 요청하는 방식**

- 아이디가 1인 사용자의 정보가 그의 친구들의 이름정보를 API로 받아와야 하는 경우

- ```
  GET /users/1
  GET /users/1/friends
  ```

- REST 방식에서는 다음과 같이 두번 요청을 해야한다. 

  

- 하지만 GraphQL방식에서 

- 사용자 정보들 중 이름, 나이, 친구들의 이름이 필요한 경우

- ```
  POST /graphql
  {
  	user(id: 1){
  		name
  		age
  		friends {
  			name
  		}
  	}
  }
  ```

- 만일 사용자 정보는 이름만 필요하고 친구들의 이름과 이메일이 필요한 경우

```
POST /graphql
{
	user(id: 1){
		name
		friends {
			name
			email
		}
	}
}
```

-------

- Reference [깔끔한 파이썬 탄탄한 백엔드](http://www.yes24.com/Product/goods/68713424)
- 모든 코드는 [저자의 깃허브에](https://github.com/rampart81/python-backend-book) 공개되어 있습니다

