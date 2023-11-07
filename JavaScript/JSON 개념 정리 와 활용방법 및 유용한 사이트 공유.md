### [HTTP (Hypertext Transfer Protocol)](https://developer.mozilla.org/en-US/docs/Web/HTTP)

- HTTP는 클라이언트가 어떻게 서버와 통신할 수 있는지를 정의한 통신규약입니다

- 이 HTTP를 기반으로 브라우저 상에서 작동하는 웹 사이트나 웹 어플리케이션 같은 클라이언트는 서버에게 원하는 정보를 request 할 수 있고 서버는 클라이언트가 요청한 것에 따라 그에 맞는 response 를 보내주는 방식으로 서로 통신을 할 수 있습니다.

- 이 때 Hypertext는 웹사이트에서 이용되는 하이퍼링크들 뿐 아니라 전반적으로 사용되는 리소스인 문서나 이미지를 모두 포함합니다.

---

### [AJAX (Asynchronous JavaScript And XML)]([https://developer.mozilla.org/en-US/docs/Web/Guide/AJAX])

- 브라우저에서 서버에 웹 페이지를 요청하게 되면 서버는 요청받은 웹 페이지(HTML)을 반환하는데 이 때 HTML에서 로드하는 CSS나 JavaScript 파일도 같이 반환됩니다.

- 서버로부터 웹페이지가 반환되면 클라이언트(브라우저)는 이를 렌더링하여 화면에 표시하는데 이 과정을 다음과 같은 그림으로 나타낼 수 있습니다.

<img src="./images/2020-06-18-javascript-json1.png" >

- HTTP를 이용해서 서버에게 데이터를 요청하고 받아 올 수 있는 방법으로는 AJAX가 있습니다

- AJAX는 동적으로 서버에게 데이터를 주고 받을 수 있는 기술로 클라이언트와 서버는 비동기적(Asynchronouse)인 방법으로 데이터를 주고 받습니다.

- 서버로부터 웹페이지가 반환되면 화면 전체를 갱신해야 하는데 페이지 일부만을 갱신하고도 동일한 효과를 볼 수 있도록 하는 것이 AJAX입니다.

- 즉, 페이지 전체를 로드하여 렌더링할 필요가 없고 갱신이 필요한 일부만 로드하여 갱신하면 되므로 빠른 퍼포먼스와 부드러운 화면 표시 효과를 기대할 수 있습니다.

<img src="./images/2020-06-18-javascript-json2.png" >

- AJAX의 대표적인 예로는 XMLHttpRequest(XHR) 오브젝트가 있습니다

- XHR은 브라우저 api에서 제공하는 오브젝트 중 하나로 이 오브젝트를 이용하면 간단하게 서버에게 데이터를 요청하고 받을 수 있습니다

- 최근 브라우저 api 추가된 fetch API 사용해도 간편하게 데이터를 주고 받을 수 있지만 IE에서 지원이 되지 않기 때문에 유의해서 사용해야 합니다.

- AJAX와 XHR에서 반복적으로 등장하는 XML이란 HTML과 같은 마크업 언어 중 하나로써 태그들을 이용해서 데이터를 나타냅니다.

- 클라이언트와 서버가 데이터 주고 받을 때 XML 형식 이외에도 다양한 파일 포맷을 주고 받을 수 있습니다

- 하지만 XML을 사용하면 불필요한 태그 많아져서 file size가 커질 뿐 만아니라 가독성도 좋지 않아서 요즘 많이 쓰이지 않고 대신 JSON(JavasScript Object Notaion)이 많이 사용됩니다

---

### [JSON (JavasScript Object Notation )](https://developer.mozilla.org/en-us/docs/learn/javascript/objects/json)

- JSON은 객체 문법으로 구조화된 데이터를 표현하기 위한 포맷으로 다음과 같이 key와 value로 이루어져 있으며 key는 큰 따옴표로 둘러쌓여져 있습니다

- JSON은 브라우저 뿐만 아니라 모바일에서 서버와 데이터를 주고 받을 때 또는 서버와 통신을 하지 않아도 파일 시스템에 저장할 때도 JSON 타입을 많이 사용한다

  ```javascript
  {
    "gender": "male",
    "age": 20,
  }
  ```

- JSON은 다음과 같은 특징을 가집니다

- JSON

  - simplest data interchange format

    - 데이터터를 주고 받을 때 사용할 수 있는 가장 간단한 포맷이다

  - lightweight text-based structure

    - 텍스트를 기반으로해서 가볍다

  - easy to read

    - 사람 눈으로 읽기 쉽다

  - key-value pairs

  - used for serialization and transmission of data between the network the network connection

  - **independent programming language and platform**

- 위 특징 중, serializaton 은 데이터를 전달하기 위한 적절한 형태로 변환하는 것을 말합니다

- JSON은 프로그래밍 언어와 상관없이 쓰일 수 있다는 특징을 가지기 때문에, 파이썬 php, java등 언어에 상관없이 jSON을 사용할 수 있습니다

- 그리고 key-value pairs의 특징을 가지기 때문에 서버에 데이터 전송할 때와 받을 때 모두 {key: value} 로 데이터를 주고 받습니다

---

### Object to JSON

- Object를 serialize 해서 JSON 파일로 만들기 위해서는 `JSON.stringify`함수를 사용할 수 있습니다

```javascript
// Object를 JSON으로 변환하는 방법
let json = JSON.stringify(['apple', 'banna']);
console.log(json);
// single quote가 아니라 double quote로 출력 된다
// ["apple","banna"]

console.log(Object.entries(json));
// JSON의 key-value를 확인할 수 있다
// 아래처럼 숫자와 각 문자열이 매칭된다
// "0"-"["
// "1"-"""
// "2"-"a"
```

```javascript
const obj = {
  name: 'obj_name',
  color: 'white',
  size: null,
  date: new Date(),
  symbole: Symbol('id'),
  jump: () => {
    console.log(`${this.name} can jump!`);
  },
};

json = JSON.stringify(obj);
console.log(json);
```

- `new Date()`로 생성된 `date` 오브젝트는 스트링으로 변환됩니다

- `jump` 함수는 출력되지않는 것을 확인할 수 있습니다.

- 함수는 오브젝트에 있는 데이터가 아니므로 JSON 에 포함이 되지 않있기 때문입니다

- 그리고 `symbole` 같이 자바스크립트에만 있는 특별한 키워드도 JSON에 포함되지 않습니다.

- 아래 코드처럼 내가 원하는 프로퍼티만 JSON으로 변환할 수도 있습니다

```javascript
json = JSON.stringify(obj, ['name', 'color']);
console.log(json);
```

- 또한 콜백함수를 이용해서 값을 조정할 수 있습니다

```javascript
json = JSON.stringify(obj, (key, value) => {
  console.log(`key: ${key}, value: ${value}`);
  return key === 'name' ? 'new_obj_name' : value;
});
console.log(json);
```

---

### JSON to Object

- JSON 파일을 Object로 deserialize하기 위해서는 `JSON.parse`함수를 사용할 수 있습니다

```javascript
const obj = {
  name: 'obj_name',
  color: 'white',
  size: null,
  date: new Date(),
  jump: () => {
    console.log(`${this.name} can jump!`);
  },
};
// JSON to Object
const json = JSON.stringify(obj);
const parseObj = JSON.parse(json);
console.log(parseObj);
```

- 앞서 serialize 할 때, 함수는 JSON 포맷으로 변환되지 않았기 때문에 JSON으로 변환된 오브젝트를 다시 deserialize 하더라도 해당 원본 오브젝트에 있었던 `jump` 함수를 호출 할 수 없습니다

```javascript
obj.jump();
parseObj.jump(); // error
```

- obj에서 `Date` 오브젝트를 사용했기 때문에 `date` 프로퍼티는 `getDate` 메소드를 사용해서 현재 날짜를 출력할 수 있었습니다.

- 하지만 아래처럼 다시 JSON 파일을 Object로 바꾼 다음에는 `date`에서 `getDate` 메소드를 사용하면 에러가 발생합니다

- 그 이유는 obj에서 `date`는 오브젝트였지만 JSON으로 serialize 한 후에 다시 오브젝트로 decerialize 한 parseObj에서 `date`는 `string`이기 때문입니다.

```javascript
const json = JSON.stringify(obj);
const parseObj = JSON.parse(json);

console.log(obj.date.getDate());

console.log(parseObj.date.getDate()); // error, date는 string이기 때문이다
```

- 이 때 콜백함수를 사용하면 다시 객체로 사용할 수 있습니다

```javascript
const json = JSON.stringify(obj);
const parseObj = JSON.parse(json, (key, value) => {
  console.log(`key: ${key}, value: ${value}`);
  return key === 'date' ? new Date(value) : value;
});

console.log(parseObj.date.getDate());
```

---

### JSON을 다루는데 유용한 사이트

- [JSON Diff](http://www.jsondiff.com/)

  - 서버에게 요청했을 때 첫번째로 받아온 데이터와 두번째로 받아온 데이터가 어떻게 다른지 잘 모를 때 비교할 수 있는 사이트

- [JSON Beautifier](https://jsonbeautifier.org/)

  - 서버에서 받아온 JSON을 복사해서 붙여넣기 하면 포맷이 망가지는 경우가 있는데 이 때 간단하게 포맷을 다시 보기 좋게 만들어주는 사이트

- [JSON Parser](https://jsonparser.org/)
  - JSON 타입을 오브젝트 형태로 확인하고 싶을 때 사용하는 사이트
- [JSON Validator](https://tools.learningcontainer.com/json-validator/)
  - JSON이 유효한 JSON 데이터인지 확인할 수 있다

---

## Reference

- [MDN web docs - HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP)
- [MDN web docs - AJAX](https://developer.mozilla.org/en-US/docs/Web/Guide/AJAX)
- [MDN web docs - JSON](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Objects/JSON)
- [JSON 개념 정리 와 활용방법 및 유용한 사이트 공유 JavaScript JSON ](https://www.youtube.com/watch?v=FN_D4Ihs3LE&t=219s)
- [poiemaweb - AJAX](https://poiemaweb.com/js-ajax)
