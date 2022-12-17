## Window size

### window.screen.width , window.screen.height

- 사용자의 모니터의 사이즈를 구할 수 있다

```javascript
window.screen.width;
window.screen.height;
```

### window outer

- 브라우저의 URL와 Tab을 포함한 전체적인 브라우저의 사이즈를 나타낸다

```javascript
window.outerwidth;
window.outerHeight;
```

### window inner

- 브라우저의 URL와 Tab을 제외한 브라우저의 사이즈를 나타낸다. 그리고 스크롤이 있는 경우 스크롤에 해당하는 부분도 포함한다

```javascript
window.innerwidth;
window.innerHeight;
```

### documentElement.clientWidth, documentElement.clientheight

- 브라우저의 URL와 Tab을 제외한 화면상에 나타내는 브라우저의 사이즈를 나타낸다. 이 때 스크롤이 있는 경우에도 스크롤 아래 화면에 보이지 않는 부분은 사이즈에 포함시키지 않는다

```javascript
document.documentElement.clientWidth;
document.documentElement.clientheight;
```

---

### getBoundingClientRect()

- 요소의 width, height, left, top 정보를 알 수 있다

- left는 x축, top은 y축과 같이, 왼쪽에서 얼마나 떨어져 있는지, 위쪽에서 얼마나 떨어져 있는지를 구할 수 있다

- right와 bottom은 css에서 right와 bottom을 구하는 방법과 다르다

- css에서는 right와 bottom이, 오른쪽에서 그리고 아래쪽에서 얼마나 떨여져있는지를 나타내지만 `getBoundingClientRect`에서는 아래 그림과 같이 right는 제일 왼쪽에서 얼마나 떨어져 있는지, bottom은 위에서 얼마나 떨어져 있는지를 나타낸다.

<img src = "https://github.com/ibtg/ibtg.github.io/blob/master/assets/img/post_img/2020-08-01-html-windowbrowser.png?raw=true">

```html
<body>
  <div></div>
  <div></div>
  <div class="rect"></div>
  <div></div>
</body>
```

```javascript
const rect = document.querySelector('.rect');
const clienRect = rect.getBoundingClientRect();
```

### clientX, Y vs page X, Y

```javascript
const coordinates = (e) => {
  console.log(`client: ${e.clientX}, ${e.clientY} `);
  console.log(`page: ${e.pageX}, ${e.pageY} `);
};
```

- click과 같은 event 발생하면 eventlistner로 event가 전달되는데, 이 때 해당 event를 통해서 브라우저의 좌표를 구할 수 있다

- clientX, Y

  - clientX, Y는 브라우저에서(네모난 창) x와 y가 얼마나 떨어져 있는지를 나타낸다

- pageX, Y

  - pageX, Y는 화면상에 보이는 브라우저를 기준으로 한 좌표가 아니라 페이지 자체에서 떨어져 있는 x와 y를 의미한다 , 이 때 페이지는 우리 눈에 보이지 않는 제일 위의 지점일 수도 있다.

  - 예를 들어, 스크롤 아래의 부분에서 click 이벤트를 발생한 다음 pageY 구하게 되면, 화면에서 보이는 창에서 y만큼 떨어진 좌표를 구하는 것이 아니라 페이지 시작 부분에서 y 값을 구한다

---

## Reference

- [MDN web docs - getBoundingClientRect ](https://developer.mozilla.org/en-US/docs/Web/API/Element/getBoundingClientRect)
