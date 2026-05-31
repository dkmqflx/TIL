### Event

- 브라우저 위에서는 다양한 이벤트(Event)가 발생할 수 있다

  - mouse click
  - keyboard
  - resizing window
  - close window
  - page loading
  - form submission
  - video is being played
  - error

- 이외에도 [mdn 문서](https://developer.mozilla.org/ko/docs/Web/Events)를 보면 다양한 이벤트가 발생하는 것을 확인할 수 있다

- 특정한 요소에 이벤트 핸들러(Event Hanlder)를 등록해서 우리가 핸들링하고 싶은 부분만 이벤트 처리를 할 수 있다

- 예를 들어 특정 요소에 클릭 이벤트가 발생하는 경우에 대한 이벤트 핸들러를 등록해 놓으면 나중에 사용자가 요소를 클릭을 했을 때 브라우저에서 이벤트 라는 오브젝트를 만들게 된다

- 이벤트 오브젝트에는 어떠한 요소가 클릭 되었는지, 어떠한 부분이 클릭 되었는지에 대한 다양한 정보들이 들어있고 이 오브젝트를 등록한 이벤트 핸들러에 전달해준다

- 이벤트 핸들러를 등록할 수 있는 모든 요소는 Node 오브젝트를 상속하고, Node 오브젝트는 EventTarget이라는 요소를 상속하기 때문에 모든 요소에는 이벤트 핸들러를 등록할 수 있다

- EventTarget에는 총 3가지의 API가 있다

  - EventTarget.addEventListener()

    - 이벤트 등록

  - EventTarget.removeEventListener()

    - 이벤트 삭제

  - EventTarget.dispatchEvent()
    - EventTarget에 이벤트를 디스패치 할 수 있다 (인위적으로 이벤트를 발생시킬 수 있다)

```javascript
// 브라우저에서 임의의 요소 선택 ($0)

// click event 등록했기 때문에 요소를 클릭하면 click 문자열이 출력된다
$0.addEventListener('click', () => {
  console.log('click!');
});

// click 이라는 이벤트를 인위적으롱 발생시켰기 때문에 click이라는 문자열이 출력된다
$0.dispatchEvent(new Event('click'));

// 함수를 선언하고 등록할 수도 있다
const lintenser = () => {
  console.log('click!');
};

$0.addEventListener('click', lintenser);

// 이렇게 등록한 경우 등록한 이벤트를 삭제할 있다
$0.removeEventListener('click', lintenser);
```

---

### Event Capturing & Bubbling

- 아래 코드를 실행시키면 가장 안쪽에 있는 button을 클릭하여도 outer와 middle 부분이 출력되는 것을 확인할 수 있다

```css
/* css */
.outer {
  width: 300px;
  height: 300px;
  background-color: burlywood;
  display: flex;
  justify-content: center;
  align-items: center;
}

.middle {
  width: 200px;
  height: 200px;
  background-color: yellowgreen;
  display: flex;
  justify-content: center;
  align-items: center;
}
```

```html
<!-- html -->
<body>
  <div class="outer">
    <div class="middle">
      <button>Click</button>
    </div>
  </div>
  <script>
    const outer = document.querySelector('.outer');
    const middle = document.querySelector('.middle');
    const button = document.querySelector('button');

    outer.addEventListener('click', () => {
      console.log(`outer: ${event.currentTarget},${event.target}`);
    });

    middle.addEventListener('click', () => {
      console.log(`middle: ${event.currentTarget},${event.target}`);
    });

    button.addEventListener('click', () => {
      console.log(`button: ${event.currentTarget},${event.target}`);
    });
  </script>
</body>
```

- click 버튼을 눌렀을 때 `middle: ` , `outer: ` 문자열 까지 호출되는 이유는 이벤트 캡처링(Event Capturing)과 이벤트 버블링(Event bubbling) 때문이다

- 위 코드를 보면 button과 middle outer에 모두 클릭 이벤트 핸들러가 등록되어 있다

- 캡처링(Capturing)

  - 자식 요소에서 발생한 이벤트가 부모 요소부터 시작하여 이벤트를 발생시킨 자식 요소까지 도달하는 것을 캡처링이라 한다

  - click 버튼을 클릭 하게 되면 자식 요소인 button 태그에서 발생한 클릭 이벤트가 부모 요소인 outer부터 시작해서 자식 요소인 button 까지 해당 태그를 찾아서 내려오게 되고 그 다음에 이벤트 핸들러가 호출된다

- 버블링(Bubbling)

  - 캡처링이 끝난 후 자식 요소부터 발생한 이벤트가 부모 요소까지 전파되는 것을 버블링이라고 한다

  - button 태그에서 발생한 클릭 이벤트가 부모 요소에 전파되면서 부모 요소의 클릭 이벤트에 대한 이벤트 핸들러를 호출한다

  - 이러한 버블링이 일어나기 때문에 이유로 부모 요소는 자식 요소에서 발생하는 모든 이벤트를 전달받을 수 있다

  - 버블링은 부모 - 자식 구조에서만 발생하고 형제 요소 사이에는 발생하지 않는다

- 대부분은 캡처링이 단계에서 무엇인가를 처리하는 것은 흔하지 않고 버블링 단계에서 이벤트를 처리 한다

```html
<!-- html -->
<body>
  <div class="outer">
    <div class="middle">
      <button>Click</button>
    </div>
  </div>
  <script>
    const outer = document.querySelector('.outer');
    const middle = document.querySelector('.middle');
    const button = document.querySelector('button');

    outer.addEventListener('click', () => {
      console.log(`outer: ${event.currentTarget},${event.target}`);
    });

    middle.addEventListener('click', () => {
      console.log(`middle: ${event.currentTarget},${event.target}`);
    });

    button.addEventListener('click', () => {
      console.log(`button1: ${event.currentTarget},${event.target}`);
    });

    button.addEventListener('click', () => {
      console.log(`button2: ${event.currentTarget},${event.target}`);
    });
  </script>
</body>
```

- 다음과 같은 코드에서 button을 클릭하면 `button1 button2 middle outer` 순서대로 총 4가지가 출력된다

- `button1`과 `button2`에서는 event.currentTarget과 event.target이 `HTMLButtonElement`로 동일 하지만 `middle`과 `outer`에서는 currentTarget은 `HTMLDivElement`, event.target이 `HTMLButtonElement`로 서로 다른 것을 확인할 수 있다

- 이렇게 다르게 출력되는 이유는 target은 이벤트가 발생한 요소를 가르키고, currentTarget은 이벤트 핸들러를 등록한 요소를 가르키기 때문이다

- target과 currentTarget이 다르면 이 요소에서 이벤트가 일어나지 않은 것을 알 수 있다

- 해당 요소에서 발생한 이벤트를 상위 요소로 전달하지 않기 위해서는 `evet.stopPropagation()` 를 추가하면 된다

```html
<!-- html -->
<script>
  button.addEventListener('click', () => {
    console.log(`button1: ${event.currentTarget},${event.target}`);
    event.stopPropagation();
    // bubbling이 일어나지 않는다
  });

  button.addEventListener('click', () => {
    console.log(`button2: ${event.currentTarget},${event.target}`);
  });
</script>
```

- 그리고 상위 요소로 이벤트를 전달하는 것을 막는 것에 더해서 한 요소에 등록된 또 다른 다른 이벤트 리스너도 방지하고 싶다면 아래처럼 `event.stopImmediatePropagation()`을 추가한다

```html
<!-- html -->
<script>
  button.addEventListener('click', () => {
    console.log(`button1: ${event.currentTarget},${event.target}`);
    event.stopImmediatePropagation();
  });

  button.addEventListener('click', () => {
    console.log(`button2: ${event.currentTarget},${event.target}`);
  });
  // 이 부분에서 등록된 이벤트는 무시되기 때문에 button2는 출력되지 않는다
</script>
```

- 하지만 다음과 같이 등록하면 `button1`과 `button2`가 모두 출력된다

- 그 이유는 `button1`을 출력하는 이벤트가 먼저 등록되었기 때문에 `button2`를 등록한 이벤트 이후에 등록된 이벤트만 무시하게 된다

```html
<!-- html -->
<script>
  button.addEventListener('click', () => {
    console.log(`button1: ${event.currentTarget},${event.target}`);
    // 이 부분에서 출력된다
  });

  button.addEventListener('click', () => {
    console.log(`button2: ${event.currentTarget},${event.target}`);
    event.stopImmediatePropagation();
  });
</script>
```

- 따라서 다음과 같이 코드를 작성하게 되면 `button1`과 `button2`만 출력되는 것을 확인할 수 있다

```html
<!-- html -->
<script>
  button.addEventListener('click', () => {
    console.log(`button1: ${event.currentTarget},${event.target}`);
  });

  button.addEventListener('click', () => {
    console.log(`button2: ${event.currentTarget},${event.target}`);
    event.stopImmediatePropagation();
  });

  button.addEventListener('click', () => {
    console.log(`button3: ${event.currentTarget},${event.target}`);
  });
</script>
```

- 하지만 `event.stopPropagation()`, `event.stopImmediatePropagation()` 이 두개는 가능한 사용하지 않는 것이 좋다

- 그 이유는 위의 코드에서 button이 클릭되었을 때 다른 부분에서 관련되어있는 일을 처리해야 할 수도 있고 부모 컨테이너에서 특별한 기능을 수행하는 코드가 있을 수 있기 때문이다.

- 따라서 내가 관심이 있을 때만 처리를 하도록 currentTarget과 target에 따른 조건을 설정해준다

- 아래처럼, outer와 middle의 코드를 수정하면, outer와 middle에 대한 부분이 출력되지 않는 것을 확인할 수 있다

```html
<!-- html -->
<script>
  outer.addEventListener('click', () => {
    // outer 부분만 눌렀을 때 출력된다
    if (event.target !== event.currentTarget) {
      return;
    }
    console.log(`outer: ${event.currentTarget},${event.target}`);
  });

  middle.addEventListener('click', () => {
    // middle 부분만 눌렀을 때 출력된다
    if (event.target !== event.currentTarget) {
      return;
    }
    console.log(`middle: ${event.currentTarget},${event.target}`);
  });

  button.addEventListener('click', () => {
    console.log(`button1: ${event.currentTarget},${event.target}`);
  });

  button.addEventListener('click', () => {
    console.log(`button2: ${event.currentTarget},${event.target}`);
  });
</script>
```

---

### Event delegation

- Event delegation은 하위 요소에 각각 이벤트를 붙이지 않고 상위 요소에서 하위 요소의 이벤트들을 제어하는 방식이다

- 부모 컨테이너에서는 어떠한 자식 요소에서 이벤트가 발생하던지 버블링에 의해 이벤트를 전달 받을 수 있기 때문에 이러한 방식을 사용할 수 있다

- 아래 코드는 li 태그를 누르면 배경 색깔이 바뀌는 코드이다

```css
/* css */

.selected {
  background-color: turquoise;
}
```

```html
<!-- html -->

<body>
  <ul>
    <li>1</li>
    <li>2</li>
    <li>3</li>
    <li>4</li>
    <li>5</li>
    <li>6</li>
    <li>7</li>
    <li>8</li>
    <li>9</li>
    <li>10</li>
  </ul>

  <script>
    const lis = document.querySelectorAll('li');
    lis.forEach((li) => {
      li.addEventListener('click', () => {
        li.classList.add('selected');
      });
    });
  </script>
</body>
```

- 하지만 이렇게 모든 요소를 찾아서 일일이 이벤트를 등록하는 것은 좋은 코드가 아니다

- 자식 요소에서 발생한 이벤트를 부모 요소에서 전달받을 수 있기 때문에 for loop를 사용해서 모든 요소에 이벤트를 등록하는 것 대신에 다음과 같이 li 태그의 상위 요소인 ul 태그에 이벤트 리스너를 등록해줄 수 있다

```html
<script>
  const ul = document.querySelector('ul');
  ul.addEventListener('click', (event) => {
    if (event.target.tagName === 'LI') {
      event.target.classList.add('selected');
    }
  });
</script>
```

- 이처럼 부모 안의 자식들에게 공통적으로 무엇인가 처리해야 할 때 일일이 이벤트 리스너를 자식 노드에 추가하는 것 보다 부모에 등록하는 것이 더 좋다

---

## Reference

- [MDN docs - Event](https://developer.mozilla.org/ko/docs/Web/Events)
- [MDN docs - EvenTarget](https://developer.mozilla.org/ko/docs/Web/API/EventTarget)
- [MDN docs - Event bubbling and capture](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Building_blocks/Events#Event_bubbling_and_capture)
- [poiemaweb - Event](https://poiemaweb.com/js-event)
- [이벤트 버블링, 이벤트 캡처 그리고 이벤트 위임까지](https://joshua1988.github.io/web-development/javascript/event-propagation-delegation/)
