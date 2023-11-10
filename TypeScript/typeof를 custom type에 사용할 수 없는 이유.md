- typeof 연산자는 런타임에 타입스크립트의 interface, type으로 선언된 타입의 타입 체크를 하는데 사용할 수 없다.

- 그 이유는 타입스크립트가 자바스크립트로 컴파일 된 이후에는 타입스크립트의 typeof 연산자가 사라지기 때문이다.

- 아래 예시의 bar라는 객체를 선언하고 typeof로 타입을 추론하게 되면 “object”로 추론이 되지만, 아래 있는 typeofBar 라는 타입은 런타임에 사라져버리게 된다.

- 따라서 custom type은 typeof로 타입 체크를 할 수 없는데 그 이유는 런타임에 type 키워드로 선언된 custom type은 사라져 있기 때문이다.

```jsx
const bar = { a: 0 };
const TypeofBar = typeof bar; // type : "object"
type TypeofBar = typeof bar; // type: {a: number}
```

- 이러한 경우에는 [type predicates](https://www.typescriptlang.org/docs/handbook/2/narrowing.html#using-type-predicates) 같은 함수로 타입 가드를 해서 타입을 좁힐 수 있다.

- 아래처럼 Generic과 is 연산자를 사용해서 함수를 선언하면, 컴파일 된 이후에 Generic과 is 연산자는 사라지지만 함수는 사라지지 않기 때문이다.

```tsx
const predicateFn = <T,>(key: any, value: any): key is T => {
  if (value.includes(key)) {
    return true;
  }
  return false;
};

console.log(predicateFn<LNMT>(query.loan, ["LNMT001"])); // true
console.log(predicateFn<LNMT>(query.loan, ["RAAC001"])); // false
```

---

## why 'generic' and `is` operator keyword of typescript works in javascript runtime ?

- In TypeScript, the `generic` and `is` operator keywords are part of TypeScript's static type checking and type system, and they are not part of JavaScript itself. When you write TypeScript code, you use these keywords to provide type information, perform type checking at compile time, and make your code safer and more maintainable. However, when TypeScript code is transpiled (compiled) into JavaScript, these TypeScript-specific constructs are typically removed, and the resulting JavaScript code does not contain them.

- Here's a brief explanation of these two keywords in TypeScript:

### 1. Generics:

- Generics are a TypeScript feature that allows you to write functions and classes that work with a range of data types, rather than being tied to a specific data type. Generics provide type safety at compile time. When TypeScript code is transpiled to JavaScript, the generic type parameters are typically erased, and the resulting JavaScript code works with any data type without type checking because JavaScript is dynamically typed.

For example, in TypeScript, you can write a generic function like this:

```tsx
function identity<T>(arg: T): T {
  return arg;
}
```

- But in JavaScript, the equivalent code would simply be:

```jsx
function identity(arg) {
  return arg;
}
```

### 2. `is` Operator:

- The `is` operator is often used in TypeScript for type narrowing and type guarding. It is used to check if a value is of a specific type, and if the check succeeds, TypeScript can narrow down the type of the variable. It's a TypeScript-specific construct used for type checking during development.

For example, in TypeScript, you can use the `is` operator to check if an object is of a certain class:

```tsx
function isCar(vehicle: any): vehicle is Car {
  return vehicle instanceof Car;
}
```

- In JavaScript, you would typically use `instanceof` directly without the `is` operator for the same check:

```jsx
function isCar(vehicle) {
  return vehicle instanceof Car;
}
```

- In summary, while TypeScript introduces these features for static type checking, they are not part of JavaScript itself. Once your TypeScript code is transpiled to JavaScript, the resulting code is plain JavaScript that does not contain these TypeScript-specific constructs, and the runtime behavior is governed by JavaScript's dynamic typing and the absence of TypeScript type checks.

## Reference

- [Typescript: Check "typeof" against custom type](https://stackoverflow.com/questions/51528780/typescript-check-typeof-against-custom-type)
- **[What is type erasure?](https://github.com/Microsoft/TypeScript/wiki/FAQ#what-is-type-erasure)**
- [Using type predicates](https://www.typescriptlang.org/docs/handbook/2/narrowing.html#using-type-predicates)
- [Typeof Type Operator](https://www.typescriptlang.org/ko/docs/handbook/2/typeof-types.html)
- [How to use TS type as a value](https://stackoverflow.com/questions/62028427/how-to-use-ts-type-as-a-value)
