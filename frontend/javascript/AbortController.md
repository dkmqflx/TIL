## AbortController

- The AbortController interface represents a controller object that allows you to abort one or more Web requests as and when desired.

- AbortController instance has AbortController.signal

- AbortController.signal returns an AbortSignal object instance, which can be used to communicate with, or to abort, an asynchronous operation.

<br/>

- Below code is that request is initiated, we pass in the AbortSignal as an option inside the request's options object (the {signal} below).

- This associates the signal and controller with the fetch request and allows us to abort it by calling AbortController.abort(), as seen below in the second event listener.

```js
const controller = new AbortController();
const signal = controller.signal;

const abortBtn = document.querySelector(".abort");
const downloadBtn = document.querySelector(".download");

downloadBtn.addEventListener("click", fetchVideo);

abortBtn.addEventListener("click", () => {
  controller.abort();
  console.log("Download aborted");
});

function fetchVideo() {
  fetch(url, { signal })
    .then((response) => {
      console.log("Download complete", response);
    })
    .catch((err) => {
      console.error(`Download error: ${err.message}`);
    });
}
```

<br/>

- AbortController can be used in cancellation in axios

```js
const controller = new AbortController();

axios
  .get("/foo/bar", {
    signal: controller.signal,
  })
  .then(function (response) {
    //...
  });
// cancel the request
controller.abort();
```

--

## Reference

- [MDN - AbortController](https://developer.mozilla.org/en-US/docs/Web/API/AbortController)

- [Axios - Cancellation](https://axios-http.com/docs/cancellation)
