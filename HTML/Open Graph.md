# og 태그

## Open Graph(og) 태그

- 오픈그래프는 어떤 `HTML` 문서의 메타정보를 쉽게 표시하기 위해서 메타정보에 해당하는 제목, 설명, 문서의 타입, 대표 URL 등 다양한 요소들에 대해서 사람들이 통일해서 쓸 수 있도록 정의해놓은 프로토콜이며 페이스북에 의하여 기존의 다양한 메타 데이터 표기 방법을 참조하여 만들어졌다

- 사용자가 클릭하기 전에 크롤러가 해당 웹사이트를 방문하여 `HTML`의 `head`의 메타데이터를 크롤링하여 미리 보기 화면을 생성해 준다

- 특정 페이지의 링크를 통해서 공유할 때, 이미지와 타이틀, 그리고 description과 같은 정보가 표시된다

```html
<!-- 필수 og 태그 -->
<meta property="og:type" content="website">
<meta property="og:url" content="https://example.com/page.html">
<meta property="og:title" content="Content Title">
<meta property="og:image" content="https://example.com/image.jpg">
<meta property="og:description" content="Description Here">
<meta property="og:site_name" content="Site Name">
<meta property="og:locale" content="en_US">

<!-- 필수는 아니지만, 추천하는 og 태그 -->
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
```

- 모바일 앱이 존재하는 경우 아래와 같은 태그를 추가해주어야 한다

```html
<meta name="twitter:card" content="트위터 카드 타입(요약정보, 사진, 비디오)" /> 
<meta name="twitter:title" content="콘텐츠 제목" /> 
<meta name="twitter:description" content="웹페이지 설명" /> 
<meta name="twitter:image" content="표시되는 이미지 " />
```

- 트위터의 경우에는 아래와 같이 name에 twitter

```html
<--iOS-->
<meta property="al:ios:url" content=" ios 앱 URL" />
<meta property="al:ios:app_store_id" content="ios 앱스토어 ID" /> 
<meta property="al:ios:app_name" content="ios 앱 이름" /> 

<--Android-->
<meta property="al:android:url" content="안드로이드 앱 URL" />
<meta property="al:android:app_name" content="안드로이드 앱 이름" />
<meta property="al:android:package" content="안드로이드 패키지 이름" /> 
<meta property="al:web:url" content="안드로이드 앱 URL" />
```

---

### Reference

- [Meta 태그, OG(오픈그래프) 사용 방법](https://seons-dev.tistory.com/entry/html-Meta-OG)