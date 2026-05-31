## declare

- declare란 타입스크립트 컴파일러에게 declare 로 선언된 변수 또는 함수들을 이미 존재한다고 알려주는 키워드.

- 단순히 컴파일러에게 타입 정보를 제공하기 위한 도구이므로 declare가 붙은 코드들은 JS로 컴파일 되지 않는다.

- 자바스크립트로만 작성된 파일에 있는 변수나 함수를 타입스크립트 파일에서 불러서 사용할 때, 해당하는 변수나 함수를 찾을 수 없다는 에러가 나타난다

- 이러한 경우에 declare를 사용해서 해당하는 변수 또는 함수에 대한 정보를 타입스크립트 컴파일러에게 알려준다.

```js
// data.js

export const num = 10;
```

- 타입스크립트는 a가 정의되어있지않아 찾을 수 없다고 에러가 뜬다.

```ts
import { num } from "data.js";

conosle.log(num); // Cannot find name 'a'
```

- 아래처럼 declare를 선언해서 문제를 해결할 수 있다.

```ts
import { num } from "data.js";

declare const num: number; // declare 로 변수가 이미 존재한다는것을 알린다.

conosle.log(num);
```

<br/>

- declare global 키워드를 사용하여 전역적으로 사용할 수 있다.

- 아래처럼 리액트의 JSX도 gloal로 선언되어 있다.

```ts
declare global {
  namespace JSX {
    interface Element extends React.ReactElement<any, any> {}
    interface ElementClass extends React.Component<any> {
      render(): React.ReactNode;
    }
  }
}
```

- 따라서 import 하지 않고도 JSX를 사용할수 있다.

```tsx
const x = (props: JSX.Element) => {};
```
