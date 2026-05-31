## HTMLInputElement: setSelectionRange() method

- The HTMLInputElement.setSelectionRange() method sets the start and end positions of the current text selection in an `<input>` or `<textarea>` element.

- This method updates the HTMLInputElement.selectionStart, selectionEnd, and selectionDirection properties in one call.

- There is a similar method for HTMLInputElement called [select](https://developer.mozilla.org/en-US/docs/Web/API/HTMLInputElement/select) , which is used when selecting the entire content rather than a specific area.

### Syntax

- selectionStart

  - The 0-based index of the first selected character. An index greater than the length of the element's value is treated as pointing to the end of the value.

- selectionEnd 

  - The 0-based index of the character after the last selected character. An index greater than the length of the element's value is treated as pointing to the end of the value.

- selectionDirection(Optional)

  - A string indicating the direction in which the selection is considered to have been performed. Possible values:

    - "forward"

    - "backward"

    - "none" if the direction is unknown or irrelevant. Default value.

```js

<input type="text" id="text-box" size="20" value="Mozilla" />
<button onclick="selectText()">Select text</button>


function selectText() {
  const input = document.getElementById("text-box");
  input.focus();
  input.setSelectionRange(2, 5);
}

// When you click the button, only that zil  will be selected

```

- By the way, the setSelectionRange method can only be used with input types such as text, search, URL, tel, and password. If used with other types (e.g., number), an error will occur.

<br/>

- Using the setSelectionRange method, you can move the cursor to the end of the input when the input is clicked.

```js
<input type="search" id="search" maxlength="50" />;

const searchInput = document.getElementById("search");
const maxLength = 50;

searchInput.addEventListener("focus", (e) => {
  const el = e.target;
  setTimeout(() => {
    el.setSelectionRange(maxLength, maxLength);
    el.scrollLeft = maxLength * 30;
    // To move not only the cursor but also visually on the screen, it scrolls by the specified number of pixels.
  }, 0);
});
```

- The reason for using setTimeout without writing the code as shown below is that the callback function registered through the addEventListener for the focus event is executed before the default browser behavior,

- Therefore, by registering the callback function in the task queue through setTimeout, the callback function can be executed when the call stack is empty.

```js
const searchInput = document.getElementById("search");
const maxLength = 50;

searchInput.addEventListener("focus", (e) => {
  const el = e.target;
  el.setSelectionRange(maxLength, maxLength);
  el.scrollLeft = maxLength * 30;
});
```

---

## Reference

- [MDN - HTMLInputElement: setSelectionRange() method](https://developer.mozilla.org/en-US/docs/Web/API/HTMLInputElement/setSelectionRange)

- [MDN - HTMLInputElement: select() method](https://developer.mozilla.org/en-US/docs/Web/API/HTMLInputElement/select)

- [setSelectionRange로 검색창 커서 옮기기](https://fe-developers.kakaoent.com/2021/211104-setselectionrange/)
