## Form

- The `<form>` tag inherently handles the submission event through the method and action attributes.

- **action**

  - The URL that processes the form submission.

- **method**

  - The HTTP method to submit the form with. The only allowed methods/values are (case insensitive):

  - post: The POST method; form data sent as the request body.

  - get (default): The GET; form data appended to the action URL with a ? separator. Use this method when the form has no side effects.

  - dialog: When the form is inside a `<dialog>`, closes the dialog and causes a submit event to be fired on submission, without submitting data or clearing the form.

<br/>

- However, to handle the form submission action without using method and action attributes, when a button is clicked or Enter is pressed, you need to add an onSubmit event handler.

```ts
const handleSubmit = (e) => {
  e.preventDefault(); // To prevent refresh

  // ...
};

<form onSubmit={handleSubmit}>
  <button type="submit">제출</button>
</form>;
```

- Alternatively, if you only want the form to be submitted when the button is clicked, change the button type to `button` and register an event handler with onClick.

```ts
const handleClick = (e) => {
  // ...
};

<form>
  <button type="button" onClick={handleClick}>
    제출
  </button>
</form>;
```
