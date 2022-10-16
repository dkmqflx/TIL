### FormaData

- FromData란 json처럼 데이터 전송을 가능하게 해주는 FormData 객체

- json 처럼 `key - value` 구조로 데이터를 전송한다

```javascript
const formData = new FormData(); // 객체 생성
```

```javascript
const formData = new FormData(); // 객체 생성

const FILE_SIZE = 4;
const fileName = 'newFile';

// 데이터 추가
formData.append('fileSize', FILE_SIZE);
formData.append('fileName', fileName);

// FormData의 key 확인
for (let key of formData.keys()) {
  console.log(key);
}

// FormData의 value 확인
for (let value of formData.values()) {
  console.log(value);
}
```

- 그리고 FormData를 서버로 보낼 때는 header에 `content-type`을 명시해 주어야 한다

```javascript
// axios
const axios = require('axios');
const fs = require('fs');
const data = new FormData();

const formData = new FormData(); // 객체 생성

const FILE_SIZE = 4;
const fileName = 'newFile';

// 데이터 추가
formData.append('fileSize', FILE_SIZE);
formData.append('fileName', fileName);

var config = {
  method: 'post',
  url: 'request_url',
  headers: {
    'content-type': 'multipart/form-data',
  },
  data: formData,
};

axios(config)
  .then(function (response) {
    console.log(JSON.stringify(response.data));
  })
  .catch(function (error) {
    console.log(error);
  });
```

--

## Reference

- [MDN Web Docs - FormData](https://developer.mozilla.org/ko/docs/Web/API/FormData/FormData)
