## Discriminated Type

- Discriminated unions, also known as tagged unions are a powerful feature in TypeScript that enables more precise type-checking and type safety in complex structures.

- They involve creating types that share a common, literal property—the discriminant.

- This discriminant property is used to differentiate between the members of the union, allowing TypeScript to narrow down the specific type within the union during type-checking.

- This pattern is particularly useful in scenarios involving complex data structures, error handling, or state management, where each state or outcome might have a different structure.

<br/>

### Structure of Discriminated Unions

- A discriminated union is typically composed of three key parts:

1. **Types with a Common Literal Property:** Each type in the union has a common property (the discriminant) with literal types. This property's value is unique to each type, which TypeScript uses to distinguish between them.

2. **A Union Type:** The union of these types forms the discriminated union.

3. **Type Guards or Type Narrowing:** Using the common literal property, you can use type guards (like switch statements or if conditions) to narrow down the specific type in a context.

<br/>

### Example

```ts
type Success = {
  flag: "success";
};

type Fail = {
  flag: "fail";
  message: "error!";
};

const hanlder = (result: Success | Fail) => {
  if (result.flag === "success") {
    console.log(result.message); // error
  }
};
```
