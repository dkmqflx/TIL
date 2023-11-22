- type을 import 해서 기존의 export default 하는 객체에 추가하니 아래와 같은 에러가 발생했다

```tsx
import { typeObj } from "./types";

export default {
  obj1,
  obj2,
  obj3,
  typeObj,
};

/*
error 발생

'typeObj' only refers to a type, but is being used as a value here

*/
```

- 이러한 에러가 발생하는 이유는 타입스크립트에서 **`export default`**는 타입 선언에 사용할 수 없기 때문이다. 즉, **`export default`**는 default 모듈을 export 하기 위한 용도로 사용되는데, 런타임에는 존재하지 않는 타입을 추가하니 에러가 발생한 것이다.

- 이러한 문제는 export type을 사용해서 해결할 수 있다.

```tsx
import { typeObj } from "./types";

export type { typeObj };

export default {
  obj1,
  obj2,
  obj3,
};
```

- 이처럼 타입 선언에서 **`export default`**를 허용하지 않음으로써 TypeScript는 값과 타입 간의 명확한 구분을 유지하여 언어가 일관되고 개발자가 런타임 값과 컴파일 타입 간의 혼란을 피할 수 있도록 도와준다.

---

## Reference

- [export default type #41409](https://github.com/microsoft/TypeScript/issues/41409)
- [Nodejs typescript: export default for type does not work](https://stackoverflow.com/questions/75850028/nodejs-typescript-export-default-for-type-does-not-work)
- [MDN - export](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/export)
