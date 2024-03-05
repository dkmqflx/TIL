## Deep Linking

- Deep linking refers to the practice of using a hyperlink that links to a specific, generally searchable or indexed, piece of web content—this can be a website (HTTP), a mobile application, or a page within a mobile app.

- Unlike traditional links that direct to a homepage or an app's landing page, deep links take you directly to a specific location within the web or app space, saving time and improving user experience by eliminating the need for navigation through homepages or menus.

### URI Scheme

- deep linking을 구현하는데 있어 가장 간단한 방법으로 uri 앞에 scheme을 등록하는 방법이다.

```js
const handleDeepLinking = (deepLink: string) => {
  window.location.href = deepLink;
  // youtube://https://www.youtube.com/c/test,
};
```

### scheme

- youtube : `youtube://`

- instagram: `instagram://`

- facebook : `fb://`

- naverblog : `naverblog://`

- kakao : `kakaolink://`
