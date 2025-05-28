## Documents

- [Set-Cookie header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Set-Cookie)

- `Set-Cookie: refreshToken=<new refreshToken>; Path=/; HttpOnly; Secure; SameSite=Strict`

  - [Path](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Set-Cookie#pathpath-value)

  - [HttpOnly](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Set-Cookie#httponly)

  - [Secure](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Set-Cookie#secure)

    - Insecure sites (http:) cannot set cookies with the Secure attribute. The https: requirements are ignored when the Secure attribute is set by localhost.

    - With the `Secure` attribute and `SameSite="None"` option set by the server, `http://localhost:3000` can still send cookies due to a browser exception for localhost.

- [SameSite](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Set-Cookie#samesitesamesite-value)
