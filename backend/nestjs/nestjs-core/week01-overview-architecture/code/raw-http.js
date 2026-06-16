// 순수 Node.js 내장 http 모듈만으로 만든 최소 서버.
// 의존성 없음. 실행:  node raw-http.js
// 확인:    curl http://localhost:3000/posts
//          curl -i http://localhost:3000/unknown   (→ 404)

const http = require("node:http");

const server = http.createServer((req, res) => {
  // 라우팅을 직접 분기해야 한다 — 메서드와 URL을 손으로 검사.
  if (req.method === "GET" && req.url === "/posts") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ message: "hello" }));
    return;
  }

  // 위에서 처리되지 않은 모든 요청 = 404. 이것도 손으로 챙겨야 한다.
  res.writeHead(404, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ message: "Not Found" }));
});

server.listen(3000, () => {
  console.log("raw http server → http://localhost:3000");
});
