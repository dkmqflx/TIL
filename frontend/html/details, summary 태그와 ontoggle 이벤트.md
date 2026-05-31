### details, summary

- `details` 태그는 `open` 상태일 때만 정보를 보여주는 위젯을 만들 때 사용된다

- 이 때 사용자에게 보여지는 요약 정보를 `summary` 태그 안에 넣어준다

- 아래는 `details` 태그와 `summary` 태그를 사용하는 예시로, `detail 1 `옆에 나타나는 label을 클릭해서 `open` 상태가 되면 `p` 태그 안에 내용이 사용자에게 보여진다

- 그리고 `detail 1 `옆에 나타나는 label을 다시 클릭해서 해당 내용을 숨길 수도 있다

```html
<details>
  <summary>detail 1 summary</summary>
  <p>detail1 - paragraph</p>
</details>
```

- `summary` 태그 안에는 `p` 태그 이외에도 다양한 태그를 사용할 수 있는데, 아래처럼 `li` 태그처럼 목록을 나타나는 태그와도 함께 사용할 수 있다

```html
<details ontoggle="onToggle()">
  <summary>list</summary>
  <ol>
    <li>li 1</li>
    <li>li 2</li>
    <li>li 3</li>
    <li>li 4</li>
    <li>li 5</li>
  </ol>
</details>
```

- 공식 문서에는 `details` 태그를 다음과 같이 설명하고 있는데, 즉 `open` 상태가 된다는 것은 `detail`태그로 만들어진 위젯이 `toggle` 된다는 것이다.

      <blockquote>
          The HTML Details Element (<details>) creates a disclosure widget in which information is visible only when the widget is toggled into an "open" state. A summary or label must be provided using the <summary> element.
      </blockquote>

- 따라서 `toggle` 이벤트와 함께 `details` 태그를 사용할 수 있다

- 아래는 `detail` 태그에 `ontoggle` 이벤트 핸들러를 등록한 것으로, `detail 1 `옆에 나타나는 label을 클릭할 때마다 `ontoggle` 이벤트가 발생하는 것을 콘솔창에서 확인할 수 있다

```html
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Document</title>
  <link rel="stylesheet" href="./index.css" />
  <script>
    const onToggle = () => {
      console.log('toggle!');
    };
  </script>
</head>
<body>
  <div>
    <details ontoggle="onToggle()">
      <summary>detail 1</summary>
      <span>detail1 - span</span>
    </details>
  </div>
</body>
```

---

## Reference

- [MDN web docs - details](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/details)
- [MDN web docs - summary](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/summary)
- [HTML details 태그](http://www.tcpschool.com/html-tags/details)
- [ontoggle Event](https://www.w3schools.com/jsref/event_ontoggle.asp)
