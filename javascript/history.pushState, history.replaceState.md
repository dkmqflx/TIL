## history.pushState

- The pushState() method of the History interface adds an entry to the browser's session history stack.

### Syntax

```js
history.pushState(state, unused);
history.pushState(state, unused, url);
```

### Parameters

- **state**

  - The state object is a JavaScript object which is associated with the new history entry created by pushState().

  - Whenever the user navigates to the new state, a popstate event is fired, and the state property of the event contains a copy of the history entry's state object.

  - However, after navigating to a new page and refreshing, the state gets reset. Therefore, even if the popstate event occurs, the state passed to the pushState function cannot be found.

- **unused**

  - This parameter exists for historical reasons, and cannot be omitted; passing an empty string is safe against future changes to the method.

- **url**

  - The new history entry's URL. Note that the browser won't attempt to load this URL after a call to pushState(), but it may attempt to load the URL later, for instance, after the user restarts the browser. The new URL does not need to be absolute

### Examples

```js
const state = { page_id: 1, user_id: 5 };
const url = "hello-world.html";

history.pushState(state, "", url);
```

- When history.pushState is executed, the address changes, and the back button becomes active.

- In other words, the page is not refreshed, but only the effect of changing the address occurs.

- And whtn the [popstate](https://developer.mozilla.org/en-US/docs/Web/API/Window/popstate_event) event is triggered, you can access the state through the event object.

<br/>

## history.replaceState

- The **`History.replaceState()`** method modifies the current history entry, replacing it with the state object and URL passed in the method parameters.

- This method is particularly useful when you want to update the state object or URL of the current history entry in response to some user action.

- When using history.replaceState, the URL is changed, but the URL change is not detectable, so the corresponding page itself is not rendered.

- The difference with history.pushState is that the back button is not activated

```js
const stateObj = { foo: "bar" };
history.pushState(stateObj, "", "bar.html");
```

---

## Reference

- [MDN - History: pushState() method](https://developer.mozilla.org/en-US/docs/Web/API/History/pushState#parameters)

- [MDN - History: replaceState() method](https://developer.mozilla.org/en-US/docs/Web/API/History/replaceState)

- [History API](https://www.zerocho.com/category/HTML&DOM/post/599d2fb635814200189fe1a7)
