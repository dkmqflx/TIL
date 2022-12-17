- 자바스크립트를 사용했을 때 처럼 string으로 key 값을 설정 후 객체에 접근하니 다음과 같은 에러가 발생했다.

```tsx
import { useLocation } from 'react-router-dom';

const NAVIGATION_TITLE = {
  '/project': '프로젝트 관리',
};

const Header = () => {
  const { pathname } = useLocation(); // pathname은 string type
  return <div>{NAVIGATION_TITLE[pathname]}</div>;
};

export default Header;
```

- `A URL pathname, beginning with a /. Element implicitly has an 'any' type because expression of type 'string' can't be used to index type '{ '/project': string; }'. No index signature with a parameter of type 'string' was found on type '{ '/project': string; }'`
- 그 이유는 에러 매세지에서 알 수 있듯이 string type이 index type 에 사용될 수 없기 때문이다

- 즉, 타입스크립트에서는 객체의 string type의 key를 허용하지 않기 때문에 이러한 에러가 발생하게 된 것이다.

- 타입스크립트에는 string type과 string literal type이 있다.

```tsx
const str1 = 'hello';
// str1은 다른 문자열이 할당 될 수 없다
// 따라서 컴파일러는 str1을 string 타입이 아닌 실제 값 자체를 타입으로 정할 수 있는 sting literal type 즉,  'hello' 타입으로 타입을 정하게 된다

let str2 = 'hello';
// 반면 str2는 'hello'이외에 또 다른 문자열을 할당할 수 있기 때문에, string type이 된다.
```

```tsx
// String Literal Types
// 실제 값 자체를 타입으로 정할 수 있다

type Name = 'name';
let sdfName: Name;
// sdfName = 'named' error 발생
sdfName = 'name'; // 동일한 name이라는 문자열만 가능

type JSON = 'json';
const json: JSON = 'json';

type Boal = true;
const isCat: Boal = true;
```

- 따라서 해당 객체에 접근할 때는 string이 아닌 sting literal type로 접근하거나 또는 객체를 선언할 때 index signature를 선언해주는 방식으로 문제를 해결할 수 있다.

- 아래처럼 ‘/project’ 이라는 string literal type으로 NAVIGATION_TITLE 객체의 ‘/project’ key에 접근할 수 있다.

```tsx
import { useLocation } from 'react-router-dom';

const NAVIGATION_TITLE = {
  '/project': '프로젝트 관리',
};

const Header = () => {
  const { pathname } = useLocation();
  return <div>{NAVIGATION_TITLE['/project']}</div>;
};

export default Header;
```

- 또 다른 방법으로는 앞서 언 급한 index signature를 사용해서 해결할 수 있다
- 아래 코드처럼 객체의 key로 index signature를 선언해주면, string literal type 뿐 아니라 string type으로도 객체에 접근할 수 있다

```bash
import { useLocation } from 'react-router-dom';

type titleType = {
  [index: string]: string;
};

const NAVIGATION_TITLE: titleType = {
  '/project': '프로젝트 관리',
};

const Header = () => {
  const { pathname } = useLocation();
  return (
      <div>{NAVIGATION_TITLE[pathname]}</div>
      <div>{NAVIGATION_TITLE['/project']}</div>

  );
};

export default Header;
```

---

## Reference

- [TypeScript에서 string key로 객체에 접근하기](https://soopdop.github.io/2020/12/01/index-signatures-in-typescript/)
- [TypeScript | Index Signature - string key로 객체에 접근하기](https://velog.io/@yyeonjju/TypeScript-Index-Signature-string-key%EB%A1%9C-%EA%B0%9D%EC%B2%B4%EC%97%90-%EC%A0%91%EA%B7%BC%ED%95%98%EA%B8%B0)
- [Indexed Access Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Index Signatures in TypeScript](https://dmitripavlutin.com/typescript-index-signatures/)
