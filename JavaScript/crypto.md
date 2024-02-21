## Crypto

- The Crypto interface represents basic cryptography features available in the current context.

- It allows access to a cryptographically strong random number generator and to cryptographic primitives.

<br/>

### Crypto: randomUUID() method

- The randomUUID() method of the Crypto interface is used to generate a v4 UUID using a cryptographically secure random number generator.

```js
/* Assuming that self.crypto.randomUUID() is available */

let uuid = self.crypto.randomUUID();
console.log(uuid); // for example "36b8f84d-df4e-4d49-b662-bcde71a8764f"
```

<br/>

### Crypto: getRandomValues() method

- The Crypto.getRandomValues() method lets you get cryptographically strong random values.

- The array given as the parameter is filled with random numbers (random in its cryptographic meaning).

```js
const array = new Uint32Array(10);
self.crypto.getRandomValues(array);

console.log("Your lucky numbers:");
for (const num of array) {
  console.log(num);
}
```

<br/>

### uuid

- uuid library use crypto internally

```js
// src/native-browser.js

const randomUUID =
  typeof crypto !== "undefined" &&
  crypto.randomUUID &&
  crypto.randomUUID.bind(crypto);

export default { randomUUID };
```

---

## Reference

- [Crypto](https://developer.mozilla.org/en-US/docs/Web/API/Crypto)
