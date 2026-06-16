// 같은 동작을 Express로. 라우팅 분기를 프레임워크가 대신 해 준다.
// 설치:  npm i express
// 실행:  node express-server.js
// 확인:  curl http://localhost:3000/posts
//        curl -i http://localhost:3000/unknown   (→ 404)

const express = require("express");
const app = express();

// 메서드 + 경로를 한 줄로 선언. status/json도 헬퍼로 간결해진다.
app.get("/posts", (req, res) => {
  res.json({ message: "hello" });
});

// 어떤 라우트에도 안 걸리면 여기로. (404 처리도 한 줄)
app.use((req, res) => {
  res.status(404).json({ message: "Not Found" });
});

app.listen(3000, () => {
  console.log("express server → http://localhost:3000");
});
