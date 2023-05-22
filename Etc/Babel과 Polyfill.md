## Babel

- **[What is Babel? - Babel is a JavaScript compiler](https://babeljs.io/docs/)**

> Babel is a toolchain that is mainly used to convert ECMAScript 2015+ code into a backwards compatible version of JavaScript in current and older browsers or environments. Here are the main things Babel can do for you:

- [바벨(Babel)](https://babeljs.io/)은 [트랜스파일러(transpiler)](https://en.wikipedia.org/wiki/Source-to-source_compiler)로, ES6 이상의 자바스크립트 코드를 구 표준을 준수하는 코드로 바꿔준다.

- 바벨을 통해서 각 브라우저 환경에 맞게 ES6를 ES5으로 다운그레이드 시켜서 ES6의 새로운 기능들을 사용할 수 있다.

<br/>

### 사용법 예시

- 아래와 같은 방법으로 바벨을 사용할 수 있다

- 예를들어 아래와 같이 화살표 함수가 있는 경우

  ```js
  const fn = () => "Babel!";
  ```

- 해당 화살표 함수를 트랜스파일링하기 위해서 세 가지가 필요하다

  - @babel/core : Babel의 핵심적인 기능을 제공

  - @babel/cli : 바벨을 터미널로 활용할 수 있는 기능 제공

  - @babel/plugin-transform-arrow-functions : 화살표 함수를 transform 하는 플러그인

- 그리고 아래처럼 명령을 입력해서 플러그인에 설치했던 플러그인을 넣어주게 되면

  ```bash

  ./node_modules/.bin/babel [변환할 파일] --out-dir [변환될 위치] --plugins=@babel/plugin-transform-arrow-functions

  ```

- 이런 식으로 화살표 함수가 일반 함수로 트랜스파일링되는 것을 확인할 수 있다.

  ```jsx
  var fn = function fn() {
    return "Babel!";
  };
  ```

- 하지만 ES6에는 굉장히 많은 기능들이 추가가 됐는데 각 기능들을 지원하기 위해서 매번 이렇게 플러그인을 하나씩 설치해야 되는 번거로움이 있다.

- 또 플러그인을 설치할 때마다 명령어 뒤쪽의 플러그인 옵션에 하나씩 추가를 해줘야 되는데 이걸 매번 명령어로 쳐야 한다.

- 그래서 보통은 바벨 설정 파일(`babel.config.json` or `.babelrc.json`)과 Preset을 활용한다.

- 프리셋은 다양한 플러그인들을 한데 모아서 만들어준 집합 관계같은 것으로 프리셋을 활용하면 매번 번거롭게 플러그인을 설치할 필요 없이 한번에 바벨 트랜스파일링을 진행할 수 있다.

## Babel

- **[What is Babel? - Babel is a JavaScript compiler](https://babeljs.io/docs/)**

> Babel is a toolchain that is mainly used to convert ECMAScript 2015+ code into a backwards compatible version of JavaScript in current and older browsers or environments. Here are the main things Babel can do for you:

- [바벨(Babel)](https://babeljs.io/)은 [트랜스파일러(transpiler)](https://en.wikipedia.org/wiki/Source-to-source_compiler)로, ES6 이상의 자바스크립트 코드를 구 표준을 준수하는 코드로 바꿔준다.

- 바벨을 통해서 각 브라우저 환경에 맞게 ES6를 ES5으로 다운그레이드 시켜서 ES6의 새로운 기능들을 사용할 수 있다.

<br/>

## Polyfill

- 폴리필은 충전 솜이라는 의미를 갖고 있다

- 인형을 오래 쓰게 되어 솜 같은 게 비게 되는 경우 이제 충전 솜으로 인형 안에 있는 솜들을 다시 채워줄 수 있는데 그런 의미로 봤을 때 부족한 것들을 채워 넣어준다라는 의미가 있다

- 이러한 점에서 볼 때 바벨에서도 부족한 부분들을 채워주는 것이 폴리필로 [공식문서](https://developer.mozilla.org/en-US/docs/Glossary/Polyfill) 에서는 다음과 같이 소개하고 있다.

> A polyfill is a piece of code (usually JavaScript on the Web) used to provide **modern functionality on older browsers that do not natively support it.**

- 즉, 구형 브라우저에서 자체적으로 지원하지 않는 최신 기능들을 지원하고자 가져오는 코드 뭉치라고 볼 수 있다

- 예를들어 아래와 같은 코드가 있을 때 어떤 것은 바벨에 의해 컴파일 되고, 어떤 것은 컴파일 되지 않는데 아래 코드를 실행시켜보면

```jsx
const arrowFunc = () => {};

const aPromise = new Promise();

const spreadOperator = [...[1, 2, 3], ...[4, 5, 6]];

const aSet = new Set(1, 2, 3);

const includesMethod = [1, 2, 3].includes("1");
```

- 다음과 같이 어떤 ES6+ 문법은 정상적으로 바벨에 의해 컴파일 되었고, 어떤 문법은 컴파일되지 않는다.

```jsx
var arrowFunc = function arrowFunc() {};

var aPromise = new Promise();

var spreadOperator = [1, 2, 3].concat([4, 5, 6]);

var aSet = new Set(1, 2, 3);

var includesMethod = [1, 2, 3].includes("1");
```

- 이렇게 되면 ES5 이하를 지원하는 브라우저에서 Promise나 Set, Array.prototype.includes 를 읽어낼 수 없는데 그 이유는 ES5로 대체할 Syntax가 없기 때문에 변환되지 않는 것이다.

- 이때 필요한 것이 바로 폴리필이다.

<br/>

## Babel과 Polyfill의 차이

- Babel 이 Javascript 의 Syntax 가 아닌 것들을 Javascript 에서 사용할 수 있게 만들어 준다면, Polyfill 은 Javascript 의 Syntax 로 읽히지만 정의되어 있지 않은 객체들을 정의해주는 개념을 말한다.

### 바벨이 컴파일 할 수 있는 없는 경우

- ES5의 global namespace(window)에 존재하지 않는 경우

  - 새로운 객체 (Promise, IntersectionObserver, Set, Map …)

  - 기존 객체의 새로운 메서드 (Array.prototype.includes, Object.entries …)

  - 새로운 함수 (fetch)

- 바벨이 window.Object, window.Array와 같이 전역 공간에 생성되는 객체가 아니거나, 기존에 존재하지 않는 메서드를 만들어줄 수는 없다.

- 여기서 전역공간이란 전역 객체를 의미한다

- 전역 객체란, 환경에 따라 window, self, this, frames, global, globalThis(ES11에서 통일된 명칭) 등이라고 불리며, 자바스크립트 코드가 실행되기 이전에 생성되는 최상위 객체를 의미한다.

- 여기에는 표준 빌트인 객체(Object, String, Number, Array...), 호스트 객체(Web API...), var 키워드로 선언된 전역 변수(NaN, Infinity...), 전역 함수(parseInt, isNaN) 등이 포함된다

### 바벨이 컴파일 할 수 있는 경우

- 새로운 객체, 메서드, 함수가 아니라 문법의 경우 바벨이 컴파일한다.

- 새로운 문법인 경우

  - const, let

  - spread operator

  - arrow function

  - class

  - destructuring

- 즉, 명세서엔 새로운 문법이나 기존에 없던 내장 함수에 대한 정의가 추가고는 하는데 새로운 문법을 사용해 코드를 작성하면 **트랜스파일러**는 이를 구 표준을 준수하는 코드로 변경해준다

- 반면, 새롭게 표준에 추가된 함수는 명세서 내 정의를 읽고 이에 맞게 직접 함수를 구현해야 사용할 수 있다.

- 개발자는 스크립트에 새로운 함수를 추가하거나 수정해서 스크립트가 최신 표준을 준수할 수 있게 작업할 수 있고 이렇게 변경된 표준을 준수할 수 있게 기존 함수의 동작 방식을 수정하거나, 새롭게 구현한 함수의 스크립트를 Polyfill이라 부른다.

- 폴리필(poly`fill`)은 말 그대로 구현이 누락된 새로운 기능을 메꿔주는(`fill in`) 역할을 한다

- 표준적으로 사용되는 Polyfill을 [core-js github](https://github.com/zloirock/core-js)에서 확인할 수 있다

<br/>

## Babel과 Polyfill 사용하기

- 바벨은 프리셋과 플러그인들을 통해서 코드를 트랜스파일링 한다

  - Preset, Plugin → 트랜스 파일링

- 이 코드들을 트랜스파일링 한다고 모든 기능들을 다 사용할 수 있는 게 아니다

- 예를 들면 Promise 같은 빌트인 객체들이나 Array에 있는 includes같은 인스턴스 메서드들은 트랜스파일링을 진행하더라도 *코드가 변하지 않고 남아 있는 경우*가 있는데 이런 경우에 문제가 발생할 수 있다

- target 환경에서 만약에 저런 빌트인 메서드들이 존재하지 않는다면 이 코드 자체가 에러를 발생하게 되는 것이고 이럴 때 필요한 것이 폴리필이다

  - Polyfill → Promise, Array.prototype.includes 추가

- 폴리필은 말 그대로 코드 뭉치로서 런타임에서 target 환경에 빌트인이나 메서드가 존재하지 않으면 이를 확인하고 ECMA 최신 환경을 맞춰주기 위해서 코드들을 삽입하게 된다

- 즉, 부족한 코드들을 채워주는 솜뭉치같은 것

<br/>

- 예전에는 @babel/polyfill라는 걸 사용했는데 Babel 7.4 버전부터는 이제 사용하지 않고 있다

- @babel/polyfill 대신에 core-js를 사용하는데, 아래는 core-js에서 Array.includes와 Array.indexOf 라는 코드를 가져오는 예시이다.

- 런타임의 target 환경에서 이런 메서드들이 만약에 존재하지 않는 걸 확인하면 아래처럼 이 코드들을 import해서 사용하게 된다

<img src='./images/Babel과 Polyfill01.png'>

<br/>

- 또 @babel/polyfill이 사라지게 되면서 useBuiltIns 옵션이 같이 들어오게 되었다.

  ```jsx
  // babel.config.json
  {
  	"presets":[
  		[
  			"@babel/preset-env",
  			{
  				"useBuiltIns": "entry",
  				"corejs": "3.22"
  			}
  		]
  	]
  }
  ```

- 위 코드처럼 useBuiltIns 옵션과 core-js의 버전명시를 같이 해주게 되면 import 할 때 좀 더 효과를 볼 수 있다

- useBuiltIns 옵션의 속성으로는 entry와 usage가 있다.

  - useBuildtins: entry

    - core-js/stable과 regenerator-runtime/runtime 모듈을 전역 스코프에 직접 삽입한 경우 이를 타겟 환경에 필요한 폴리필만 전역 스코프에 추가되도록 변경

    ```jsx
    // in
    import "core-js";

    // out
    import "core-js/modules/es.set";
    ```

  - useBuildtins: usage

    - 실제 필요한 폴리필만 삽입

    - import 자체를 삽입해줘서 따로 삽입할 필요 없음

    ```jsx
    // in
    var a = new Set();

    // out
    import "core-js/modules/es.set";
    var a = new Set();
    ```

- 간단하게 말하면 core-js에서 폴리필을 타입 해줄 때 진짜 필요한 것들만 import해서 사용할 수 있도록 도와주는 옵션으로 사용하는 것을 권장하고 있다.

- 그렇다고 core-js만 단독적으로 사용하기만 하면 전역 스코프가 오염될 수 있다는 문제가 있다

  - core-js 단독 사용

    - 전역 스코프 오염 O

    - 인스턴스 메서드 동작 O

- Array의 includes나 indexOf 같은 것들 전부 다 구현이 되어 있고 인스턴스, 메서드 전부 다 잘 동작한다

- 하지만 전역 스코프가 오염될 수 있는 단점있다.

- core-js같은 경우에는 전역에 존재하지 않는 메서드들이나 빌트인들을 바로 주입해서 사용하기 때문에 전역 스코프가 오염될 수 있는 것이다.

- 전역 스코프가 오염되면 당연히 이름 충돌도 발생할 수 있고 외부에서 사용하는 라이브러리같은 경우를 가져왔을 때 만약 거기서 전역 스코프를 오염시켜 버리면 그 개발자는 예상치 못한 에러를 마주할 수도 있다.

- 그렇기 때문에 @babel/plugin-transform-runtime라는 것을 core-js와 함께 사용해준다

  - @babel/plugin-transform-runtime + core-js

    - 전역 스코프 오염 X

    - 인스턴스 메서드 동작 O

- 아래처럼 플러그인을 설치한다음

  ```shell

  @babel/plugin-transform-runtime + core-js@3

  ```

- core-js의 버전을 명시해주면 core-js-pure 패키지에서 가져오게 된다

  ```jsx
  {
  	"presets":[[
  			"@babel/preset-env",
  		]],
  	"plugins":[
  		["@babel/plugin-transform-runtime", {
  		"core-js": 3
  		}]
  		]
  }
  ```

- 아래처럼 Promise, Symbol, includes같은 것들을 잘 가져오는 것을 확인할 수 있다

<img src='./images/Babel과 Polyfill02.png'>

- pure라는 네이밍에서 볼 수 있듯이 전역 스코프를 오염시키지 않고 잘 가져올 수 있다.

- 하지만 이것도 문제가 있는데 만약에 프로젝트 내에 존재하는 패키지들 중에서 전역 스코프에 의존하고 있는 경우가 있다.

- 예를들어 Axios 같은 거는 전역에 존재하는 프로미스를 의존하고 있기 때문에 node modules에 있는 Axios가 만약에 트랜스파일링이 되지 않으면 문제가 발생할 수 있다

- 만약에 target 환경에서 빌트인으로 프로미스가 없으면은 이 부분에 에러가 발생된다.

- 그래서 해당 패키지를 포함해서 반드시 트랜스파일링이 진행해 줘야한다.

- 이때 필요한 것이 아래와 같은 바벨 설정 파일들

  - babel.config.json

    - 여러 패키지 디렉토리를 가진 프로젝트에서 하나의 바벨 설정을 적용하고 싶을 때

    - node_modules도 적용하고 싶을 때

  - babelrc.json

    - 프로젝트 내에 서드 파티 라이브러리가 바벨에 의해 transform 되기를 바라지 않는 경우

    - 특정 부분만 적용하고 싶은 경우

- 그렇기 때문에 Axios 같은 문제들은 node modules까지 패키지를 트렌스파일링 해줘야 되는 것으로

- 그럴 경우에 여러 패키지 디렉토리를 가진 프로젝트에서 하나의 바벨 설정을 적용하고 싶을 때 babel.config 파일을 사용하면 됩니다

- 반대로 babelrc는 서드 파티는 트랜스파일링 하지 않고 특정 부분만 적용하고 싶을 때 사용할 수 있어요

- Axios 문제는 babel.config를 사용하면 좀 더 쉽게 해결할 수 있겠네요

<br/>

## Webpack에서의 babel

- 어느 정도 규모가 있는 자바스크립트 프로젝트에서는 보통 웹펙같은 모듈 번들러를 사용한다

- 각 파일의 의존성을 파악해서 각 몇 개의 압축파일로 만들어 주고 또 최적의 결과를 만들어 주기 때문에 웹펙을 많이 사용하는데 바벨과 웹팩을 연결시켜주는 것이 바벨 로더이다.

```jsx
module.exports = {
  module: {
    rules: [
      // babel-loader 설정
      {
        test: /\.m?js$/i,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader",
          options: {
            preset: ["@babel/preset-env"],
          },
        },
      },
    ],
  },
};
```

---

### Reference

- [10분 테코톡 - 나인의 Babel](https://www.youtube.com/watch?v=o-5K5Sc7L1k)
- [컴파일과 폴리필의 차이점 분석 (babel, polyfill)](https://happysisyphe.tistory.com/m/49)
- [Babel, Polyfill 그리고 Babel-Polyfill](https://songeunjung92.tistory.com/47)
- [똑똑하게 브라우저 Polyfill 관리하기](https://toss.tech/article/smart-polyfills)
- [You don't know polyfill](https://so-so.dev/web/you-dont-know-polyfill/)
- [FE개발자의 성장 스토리 02 : Babel7과 corejs3 설정으로 전역 오염 없는 폴리필 사용하기](https://tech.kakao.com/2020/12/01/frontend-growth-02/)
