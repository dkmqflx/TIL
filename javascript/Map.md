## Map

- The Map object holds key-value pairs and remembers the original insertion order of the keys.

- Any value (both objects and primitive values) may be used as either a key or a value.

```js
const map1 = new Map();

map1.set("a", 1);
map1.set("b", 2);
map1.set("c", 3);

console.log(map1.get("a"));
// Expected output: 1

map1.set("a", 97);

console.log(map1.get("a"));
// Expected output: 97

console.log(map1.size);
// Expected output: 3

map1.delete("b");

console.log(map1.size);
// Expected output: 2
```

- [Objects vs Maps, differences](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map#objects_vs._maps)

### [When You Should Prefer Map Over Object In JavaScript](https://www.zhenghao.io/posts/object-vs-map#map-for-hash-map)

- Use Object for records where you have a fixed and finite number of properties/fields known at author time, such as a config object. And anything that is for one-time use in general.

- Use Map for dictionaries or hash maps where you have a variable number of entries, with frequent updates, whose keys might not be known at author time, such as an event emitter.

---

## Reference

- [When You Should Prefer Map Over Object In JavaScript](https://www.zhenghao.io/posts/object-vs-map#map-for-hash-map)
