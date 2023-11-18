## innerHTML

- The Element property innerHTML gets or sets the HTML or XML markup contained within the element.

### usage

```html
<ul id="list">
  <li><a href="#">Item 1</a></li>
  <li><a href="#">Item 2</a></li>
  <li><a href="#">Item 3</a></li>
</ul>
```

- 아래처럼 stirng에 html 태그를 선언해서 전달해주면 string 내부에 선언된 HTML을 파싱하고 생성된 노드로 대체한다

```js
const list = document.getElementById("list");

list.innerHTML += `<li><a href="#">Item ${list.children.length + 1}</a></li>`;
```

### XSS

- innerHTML은 XSS(Cross Site Scripting)에 취약하다는 단점이 있다.

- 아래와 같이 script 태그를 직접 innerHTML에 넣는 경우에는 문제가 되지 않는데 HTML5에서는 script 태그를 실행시키지 않기 때문이다.

```js
const name = "John";

// assuming 'el' is an HTML DOM element

el.innerHTML = name; // harmless in this case

name = "<script>alert('I am John in an annoying alert!')</script>";
el.innerHTML = name; // harmless in this case, script 부분 실행되지 않는다
```

- 그러나 `<script>` 요소를 사용하지 않고, JavaScript를 실행하는 방법이 있으므로 innerHTML 을 사용하여 제어할 수 없는 문자열을 설정할 때 마다 여전히 보안위험이 있다.

- 예를들어 아래 코드와 같이 img태그에 onerror 속성에 함수를 등록해 놓으면, alert가 실행되는 것을 확인할 수 있다.

```js
const name = "<img src='x' onerror='alert(1)'>";
el.innerHTML = name; // shows the alert
/**
 * 이미지를 불러오는데 실패하거나
 * src 속성이 비었거나 null인 경우에 onerror 에 등록된 함수가 실행된다
 * /

```

- 그렇기 때문에 공식문서에서는 아래와 같은 방법을 권장하고 있다.

<blockquote>

- For that reason, it is recommended that instead of innerHTML you use:

  - `Element.setHTML()` to sanitize the text before it is inserted into the DOM.

  - `Node.textContent` when inserting plain text, as this inserts it as raw text rather than parsing it as HTML.

</blockquote>

- 다만 여기서 setHTML 같은 경우에는 아직 실험적 기능이므로 단순 텍스트를 삽입할 때는 textContent를 사용하는 것이 좋다

<br/>

- HTML을 삽입하는 경우에는 공식문서에서 insertAdjacentHTML을 사용할 것을 권장하고 있다

> To insert the HTML into the document rather than replace the contents of an element, use the method insertAdjacentHTML().

## insertAdjacentHTML

### innerHTML

- 아래와 같은 코드에 innerHTML을 사용하면 아래와 같이 동작한다

1. element 요소의 자식 요소 파싱

2. innerHTML에 추가 되는 newElement 요소 파싱

3. element에 파싱된 객체 타입

```js
const newElement = "<div>new Element</div>";

element.innerHTML = newDOMString;
```

- 즉, 코드가 실행되면 element가 기존에 가지고 있던 자식 요소를 파싱하고, 새 값으로 들어온 newDOMString 또한 파싱하여 DocumentFragment 객체를 생성한다.

- 이렇게 파싱된 객체를 element의 innerHTML에 넣어줌으로써 element의 DOM 요소가 새로운 모습으로 변하게 된다.

- 그렇기 때문에 기존 요소를 한번 더 파싱하게 되는 작업을 하는데 이러한 단점을 insertAdjacentHTML을 사용해서 해결할 수 있다.

<br/>

### insertAdjacentHTML

- 아래와 같은 코드에 insertAdjacentHTML을 사용하면 아래와 같이 동작한다

1. innerHTML에 추가 되는 newElement 요소 파싱

2. element에 파싱된 객체 타입

```js
const newElement = "<div>new Element</div>";

element.insertAdjacentHTML("beforeend", newElement);
```

- insertAdjacentHTML은 innerHTML과 다르게 element의 자식 요소를 파싱하는 동작이 없고, 추가되는 요소를 파싱하여 특정 위치의 DOM 트리 안에 대입한다.

- 그렇기 때문에 insertAdjacentHTML을 사용하게 되면 기존 요소를 파싱하지 않고 새로운 요소를 추가할 수 있다

- 공식문서에서 이러한 내용을 확인할 수 있다.

> The insertAdjacentHTML() method does not reparse the element it is being used on, and thus it does not corrupt the existing elements inside that element. This avoids the extra step of serialization, making it much faster than direct innerHTML manipulation.

- 다만 XSS 공격에는 innerHTML과 동일하게 취약하다는 단점이 있고, 아래와 같이 코드를 작성하면 alert 창이 나타난다

```js
const el = document.querySelector("div");

const name = "<img src='x' onerror='alert(1)'>";
el.insertAdjacentHTML("beforeend", name);
```

<br/>

### insertAdjacentText

- 공식문서를 보면 문자열을 전달할 때는 insertAdjacentHTML이 아닌 insertAdjacentText 또는 textContent를 사용하라고 되어 있다.

<blockquote>
When inserting HTML into a page by using insertAdjacentHTML(), be careful not to use user input that hasn't been escaped.

You should not use insertAdjacentHTML() when inserting plain text. Instead, use the Node.textContent property or the Element.insertAdjacentText() method. This doesn't interpret the passed content as HTML, but instead inserts it as raw text.

</blockquote>

- 그 이유는 이스케이프 되지 않은 문자열의 경우 element로 인식되기 때문이다

- 즉, 아래와 같이 이스케이프 되지 않은 문자열 실행하게 되면, 단순히 `"<div>new Element</div>"` 라는 문자열을 elemenet에 추가하고 싶더라도 html 요소로 인식해서 html 요소가 추가가 된다.

```js
const newElement = "<div>new Element</div>";

element.insertAdjacentHTML("beforeend", newElement);
// element = new Element
```

- 하지만, 아래와 같이 insertAdjacentText을 사용하면 문자열을 이스케이프 하지 않더라도 string을 HTML로 해석하지 않고 raw text로 인식하고 요소를 추가하게 된다

```js
const newElement = "<div>new Element</div>";

element.insertAdjacentText("beforeend", newElement);
// elelent = "<div>new Element</div>"
```

<br/>

### insertAdjacentElement

- insertAdjacentElement라는 API도 있는데,insertAdjacentHTML가 두번째 인자로 string이 들어가는 것과 달리 해당 API는 두번째 인자로 element가 전달된다

```js
element.insertAdjacentHTML("beforeend", <div>new Element</div>);
```

## innerHTML in React

- 리액트에서는 `dangerouslySetInnerHTML` 속성을 사용해서 html을 string으로 요소로 전달할 수 있다.

- 하지만 이러한 방식은 innerHTMl과 동일하게 XSS 공격에 취약하다는 단점이 있다.

- 아래와 같은 코드를 실행하면 alert 창이 나타나는 것을 확인할 수 있다.

```jsx
const post = {
  // Imagine this content is stored in the database.
  content: `<img src="" onerror='alert("you were hacked")'>`,
};

export default function MarkdownPreview() {
  // 🔴 SECURITY HOLE: passing untrusted input to dangerouslySetInnerHTML
  const markup = { __html: post.content };
  return <div dangerouslySetInnerHTML={markup} />;
}
```

- 이러한 문제를 해결하기 위한 방법으로 DOMPurify를 사용할 수 있다

- [DOMPurify 공식문서](https://github.com/cure53/DOMPurify)를 보면 DOMPurify가 어떠한 라이브러리에 대한 설명이 있는데, XSS 공격을 방지하는 역할을 한다고 나와있다.

<blockquote>

DOMPurify sanitizes HTML and prevents XSS attacks. You can feed DOMPurify with string full of dirty HTML and it will return a string (unless configured otherwise) with clean HTML.

DOMPurify will strip out everything that contains dangerous HTML and thereby prevent XSS attacks and other nastiness. It's also damn bloody fast. We use the technologies the browser provides and turn them into an XSS filter. The faster your browser, the faster DOMPurify will be.

</blockquote>

- 앞서 img 태그에 onerror가 있는 코드를 아래처럼 DOMPurify의 sanitize 함수를 사용하게 되면 clean한 HTML string을 반환하게 된다.

- 따라서 코드를 실행해보면 onerror에 등록된 alert가 실행되지 않는 것을 확인할 수 있다

```jsx
const sanitizedElement = (element: string): string =>
  DOMPurify.sanitize(element);

const Form = () => {
  return (
    <div>
      <div
        dangerouslySetInnerHTML={{
          __html: sanitizedElement(`<img src='x' onerror='alert(1)'>"`),
        }}
      ></div>
    </div>
  );
};
```

---

## Reference

- [MDN - innerHTML](https://developer.mozilla.org/en-US/docs/Web/API/Element/insertAdjacentHTML)

- [MDN - insertAdjacentHTML](https://developer.mozilla.org/en-US/docs/Web/API/Element/insertAdjacentHTML)

- [React - Dangerously setting the inner HTML](https://react.dev/reference/react-dom/components/common#dangerously-setting-the-inner-html)

- [DOM Purify](https://github.com/cure53/DOMPurify)
