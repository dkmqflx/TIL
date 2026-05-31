## Set

- The Set object lets you store unique values of any type, whether primitive values or object references.

- Set objects are collections of values. A value in the set may only occur once; it is unique in the set's collection.

### Iterating

```js
const newSet = new Set(1, 2, { a: 1, b: 2 });

for (let item of newSet) {
  console.log(item);
}

for (let item of newSet.values()) {
  console.log(item);
}

newSet.forEach(function (val) {
  console.log(val);
});
```

### Set to Array, Array to Set

```js
// Set to Array
// Array.from method
const arr = Array.from(newSet);

// rest paramet
const arr = [...newSet];

// Array to Set
const arrayToSet = new Set(arr);
```

### Performance

- The has method checks if a value is in the set, using an approach that is, on average, quicker than testing most of the elements that have previously been added to the set.

- In particular, it is, on average, faster than the Array.prototype.includes method when an array has a length equal to a set's size.

### Set-like objects

- Map objects are set-like because they also have size, has(), and keys(), so they behave just like sets of keys when used in set methods:

- Arrays are not set-like because they don't have a has() method or the size property

```js
const a = new Set([1, 2, 3]);
const b = new Map([
  [1, "one"],
  [2, "two"],
  [4, "four"],
]);
console.log(a.union(b)); // Set(4) {1, 2, 3, 4}
```

---

## Reference

- [MDN - Set](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set)

- [JavaScript Set vs. Array performance](https://stackoverflow.com/questions/39007637/javascript-set-vs-array-performance)
