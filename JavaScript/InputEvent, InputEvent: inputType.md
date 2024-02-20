## InputEvent

- The InputEvent interface represents an event notifying the user of editable content changes.

## InputEvent: inputType property

- The inputType read-only property of the InputEvent interface returns the type of change made to editable content. Possible changes include for example inserting, deleting, and formatting text.

- A string containing the type of input that was made. There are many possible values, such as insertText, deleteContentBackward, insertFromPaste, and formatBold. For a complete list of the available input types, see the [Attributes section of the Input Events Level 2 spec](https://w3c.github.io/input-events/#interface-InputEvent-Attributes).

```js

const handleChange = (e) => {
  if(e.inputType === 'deleteContentBackward'){
    ...
  }
}
```

---

## Reference

- [MDN - InputEvent](https://developer.mozilla.org/en-US/docs/Web/API/InputEvent)
