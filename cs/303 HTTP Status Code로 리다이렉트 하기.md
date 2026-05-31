## 303 See Other

<blockquote>

The HyperText Transfer Protocol (HTTP) 303 See Other redirect status response code indicates that the redirects don't link to the requested resource itself, but to another page (such as a confirmation page, a representation of a real-world object — see HTTP range-14 — or an upload-progress page).

This response code is often sent back as a result of PUT or POST. The method used to display this redirected page is always GET.

</blockquote>

- 즉, 클라이언트가 요청한 리소스를 다른 URI에서 GET 요청을 통해 얻어야 할 때, 서버가 클라이언트로 직접 보내는 응답이다.

<br/>

- PG사와 결제 연동을 한 상황에서 다음과 같은 문제가 있었다.

  - 결제 과정을 진행 후에 결과 페이지로 이동해야 한다.

  - 하지만 PG 사에서는 POST 방식으로 어플리케이션에 문서를 요청을 하고 있었기 때문에 **405** 응답 코드를 전달받고 있는 상황이었다.

- 이러한 문제를 해결하기 위해 POST 가 아닌 GET으로 요청 방식을 바꿔야 했다.

- Next.js의 API Route를 사용해서 POST 요청을 하는 경우에 GET 요청으로 Redirect 하는 방법으로 문제를 해결해주었다.

- 그리고 이 때 redirect는 기본적으로 307 를 상태 코드로 있는데 공식문서에 따라 GET 요청으로 바꾸기 위해 303으로 상태 코드를 전달해주었다.

> If you want to cause a `GET` response to a `POST` request, use `303`.

```tsx
export default function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method === "POST") {
    const redirectPath = `/result`;
    return res.redirect(303, redirectPath);
  }
}
```

- 303 코드는 다음과 같이 GET 요청으로 redirect하는 역할을 한다

> The HyperText Transfer Protocol (HTTP) **`303 See Other`** redirect status response code indicates that the redirects don't link to the requested resource itself, but to another page (such as a confirmation page, a representation of a real-world object — see [HTTP range-14](https://en.wikipedia.org/wiki/HTTPRange-14) — or an upload-progress page).

This response code is often sent back as a result of `[PUT](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/PUT)` or `[POST](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/POST)`. The method used to display this redirected page is always `[GET](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/GET)`.

---

## Reference

- [Next.js - Why does `redirect` use 307 and 308?](https://nextjs.org/docs/pages/api-reference/functions/next-server#why-does-redirect-use-307-and-308)

- [MDN - 303 See Other](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/303)
