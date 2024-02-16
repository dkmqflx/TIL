- When passing window.document as domNode in Next.js while using createPortal, the following error occurs.

```tsx
return createPortal(<div>container</div>, window.document.body);
```

<blockquote>

Server Error

ReferenceError: window is not defined

This error happened while generating the page. Any console logs will be displayed in the terminal window.

</blockquote>

- The reason for this error is that by default, Next.js generates pages on the server through pre-rendering, and in the server environment, the window object cannot be found.

- To resolve this issue, update the window object as a state value in useEffect and ensure that createPortal is executed only when that value is present.

```tsx
const Toast = () => {
  const [domNode, setDomNode] = React.useState<HTMLElement | null>(null);

  React.useEffect(() => {
    setDomNode(window.document.body);
  }, []);

  return domNode && createPortal(<div>container</div>, domNode);
};
```

---

## Reference

- [Text content does not match server-rendered HTML - Solution 1: Using useEffect to run on the client only](https://nextjs.org/docs/messages/react-hydration-error#solution-1-using-useeffect-to-run-on-the-client-only)
