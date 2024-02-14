## Transition Event

- The TransitionEvent interface represents events providing information related to transitions.

- The transitio event is fired when a CSS transition has changed

<br/>

### transitionend

- The transitionend event is fired when a CSS transition has completed.

- In the case where a transition is removed before completion, such as if the transition-property is removed or display is set to none, then the event will not be generated.

```js
const transition = document.querySelector(".transition");

transition.addEventListener("transitionend", () => {
  console.log("Transition ended");
});
```

<br/>

### transitionstart

- The transitionstart event is fired when a CSS transition has actually started, i.e., after any transition-delay has ended.

```js
element.addEventListener("transitionstart", () => {
  console.log("Started transitioning");
});
```

<br/>

### transitionrun

- The transitionrun event is fired when a CSS transition is first created, i.e. before any transition-delay has begun.

```js
el.addEventListener("transitionrun", () => {
  console.log(
    "Transition is running but hasn't necessarily started transitioning yet"
  );
});
```

---

## Reference

- [TransitionEvent](https://developer.mozilla.org/en-US/docs/Web/API/TransitionEvent)
