- 다음과 같은 환경에서 진행되었습니다.

  ```bash
  "dependencies": {
    ...
    "next": "13.4.10",
    "react": "18.2.0",
    ...
  }

  ```

### 라이브러리 설치

테스팅 라이브러리로 jest와 React Testing Library를 사용하기로 결정했기 때문에 공식문서의 [Testing](https://nextjs.org/docs/pages/building-your-application/optimizing/testing) 페이지의 [Next.js with Jest and React Testing Library](https://github.com/vercel/next.js/tree/canary/examples/with-jest) 레포를 참고해서 필요한 라이브러리를 설치해주었습니다.

next 13 버전에서는 swc를 사용하고 있기 때문에 next.js 10버전을 사용하고 있는 FRONT에서 아래 과정을 진행하면서 테스팅 환경을 구축할 때는 공식문서의 \***\*[Setting up Jest (with the Rust Compiler)](https://nextjs.org/docs/pages/building-your-application/optimizing/testing#setting-up-jest-with-the-rust-compiler)** 항목을 참고해서 초기 설정을 다르게 해주어야 합니다.

```bash
npm install -D
	@testing-library/jest-dom
	@testing-library/react
	@testing-library/user-event
	@types/jest
	jest
	jest-environment-jsdom
	react-test-renderer # 스냅샷 테스트를 위한 라이브러리
```

### [next-router-mock](https://www.npmjs.com/package/next-router-mock)

테스트 하는 컴포넌트가 useRouter를 사용하는 경우에 `nextrouter was not mounted` 라는 에러 메세지가 나타나는데요, 이러한 에러를 해결하기 위해서는 router 관련된 부분을 mocking 해주어야 합니다.

공식문서의 **[`NextRouter` was not mounted](https://nextjs.org/docs/messages/next-router-not-mounted)** 항목을 보면 [next-router-mock](https://www.npmjs.com/package/next-router-mock)를 Useful Links로 걸어놓았기 때문에 해당 라이브러리를 설치해서 mocking 해주었습니다.

라이브러리 설치후 `jest.setup.js` 파일에 아래 코드를 추가해주면 됩니다.

```tsx
// jest.setup.ts

jest.mock("next/router", () => require("next-router-mock"));
```

### **[Jest Styled Components](https://github.com/styled-components/jest-styled-components#jest-styled-components)**

추가적으로 스냅샷 테스트를 할 때 유용하게 사용할 수 있는 유틸 함수를 제공하는 jest styled componenets도 함께 설치해주었습니다.

```bash
npm -i jest-styled-components
```

라이브러리 설치 후 각각의 테스트가 실행되기 전에 configuration이 적용되도록 `setupFilesAfterEnv`에 추가해줍니다

```jsx
// jest.config.js

setupFilesAfterEnv: ['<rootDir>/jest.setup.ts', 'jest-styled-components'],
```

---

### 타입스크립트로 테스트를 작성하는 방법

지금까지 과정은 테스트를 작성하는데 필요한 라이브러리를 설치하는 과정이였는데요

해당 라이브러리를 모두 설치한 다음 `"컴포넌트이름".test.tsx` 와 같이 타입스크립트 확장자를 가진 파일에서 테스트를 작성하게 되면 아래와 같이 matcher를 찾지 못한다는 에러가 나타나게 됩니다.

이러한 에러를 해결하기 위해서는 `jest.setup.ts`와 같이 확장자를 `.ts`로 수정한 다음 아래처럼 jest-dom을 추가 해주어야 합니다.

- **참고**

  - https://github.com/testing-library/jest-dom#with-typescript

  ```tsx
  // TS: Property 'toBeInTheDocument' does not exist on type 'Assertion'.

  import "@testing-library/jest-dom";
  ```

### `.env.test` 환경변수 추가하기

테스팅 환경에서 환경변수를 사용하기 위해서는 `**.env.test**` 라는 이름의 **env** 파일을 추가해주어야 합니다.

```tsx
"scripts": {
	"test": "jest --watch",
  "test:coverage": "jest --watch --coverage"
}
```

현재는 `.env.development`와 동일한 설정을 해주었습니다.

- **참고**
  - [Next.js 공식문서 - Test Environment Variable](https://nextjs.org/docs/pages/building-your-application/configuring/environment-variables#test-environment-variables)

### jest.setup.ts, jest.config.js

지금까지의 과정을 거쳐 완성된 setup과 config 파일을 다음과 같습니다

기본적으로 [Next.js with Jest and React Testing Library](https://github.com/vercel/next.js/tree/canary/examples/with-jest) 레포에 있는 설정을 참고하였고 필요한 설정을 추 가해주었습니다.

```tsx
// jest.setup.ts

// Learn more: https://github.com/testing-library/jest-dom

import "@testing-library/jest-dom";

jest.mock("next/router", () => require("next-router-mock"));
```

```jsx
// jest.config.js

const nextJest = require("next/jest");

const createJestConfig = nextJest({
  // Provide the path to your Next.js app to load next.config.js and .env files in your test environment
  dir: "./",
});

// Add any custom config to be passed to Jest
const customJestConfig = {
  setupFilesAfterEnv: ["<rootDir>/jest.setup.ts", "jest-styled-components"],
  testEnvironment: "jest-environment-jsdom",
  clearMocks: true,
  coverageDirectory: "coverage",

  moduleDirectories: ["node_modules", "src"],
  // src 추가해주어야지 절대 경로로 정의된 파일 찾을 수 있음.
};

// createJestConfig is exported this way to ensure that next/jest can load the Next.js config which is async
module.exports = createJestConfig(customJestConfig);
```

---

### Providers

테스트를 작성하다 보면 공통적으로 사용해야 하는 Provider가 있습니다.

대표적으로 styled component의 Theme Provider, 그리고 React Query의 QueryClientProvider가 있는데요, 해당하는 Provider를 필요한 테스트에서 가져다 사용할 수 있도록 추가해 놓았습니다.

```tsx
// src/domains/common/__test__/providers/themeProvider.tsx

import { ThemeProvider } from "styled-components";
import styledTheme from "theme/styledTheme";

export const TestThemeProvider = ({
  children,
}: React.PropsWithChildren<{}>) => (
  <ThemeProvider theme={styledTheme}>{children}</ThemeProvider>
);
```

```tsx
// src/domains/common/__test__/providers/reactQueryProvider.tsx

import { QueryClient, QueryClientProvider } from "@tanstack/react-query";

const testQueryClient = () => {
  return new QueryClient({
    defaultOptions: {
      queries: {
        // ✅ turns retries off
        retry: false,
      },
    },
    logger: {
      log: console.log,
      warn: console.warn,
      // ✅ no more errors on the console for tests
      error: process.env.NODE_ENV === "test" ? () => {} : console.error,
    },
  });
};

export const TestQueryClientProvider = ({
  children,
}: React.PropsWithChildren<{}>) => {
  const testClient = testQueryClient();

  return (
    <QueryClientProvider client={testClient}>{children}</QueryClientProvider>
  );
};
```

아래 코드는 위에서 정의한 Theme Provider를 적용해서 테스트 코드를 작성한 예시입니다.

```tsx
import { render } from "@testing-library/react";
import { TestThemeProvider } from "@common/__test__/providers";
import Add from "./index";

describe("List", () => {
  it("img 태그 확인", () => {
    render(
      <TestThemeProvider>
        <Add title="변동금리 프리셋" rateType="FLOATING" />)
      </TestThemeProvider>
    );
    const img = screen.getByRole("img");
    expect(img).toBeInTheDocument();
  });
});
```

만약 Theme Provider로 감싸주지 않으고 테스트를 실행하게 되면 아래의 theme을 찾을 수 없다는 에러가 나타나게 됩니다.

```tsx
export const Text = styled.p`
  font-size: 14px;
  font-weight: 400;
  color: ${({ theme }) => theme.blueGray[500]};
  text-align: center;
`;
```

### MSW와 함께 사용하기

MSW를 사용하기 위한 컴포넌트인 MockAPIBoundary를 테스트 환경에서도 사용할 수 있게 만들어 놓았기 때문에 테스트할 컴포넌트에 MockAPIBoundary를 감싸주기만 하면 `mocks/handler`에 등록된 API를 mocking해서 사용할 수 있습니다.

추가적으로 비동기 처리를 위해 React Query를 사용하고 있기 때문에 React Query의 QueryClientProvider 가 정의되어 있는 TestQueryClientProvider를 불러와서 render할 컴포넌트를 감싸줍니다

```tsx
import { screen, render } from "@testing-library/react";
import {
  TestThemeProvider,
  TestQueryClientProvider,
} from "@common/__test__/providers";
import { MockAPIBoundary } from "@mocks/MockAPIBoundary";
import CategoryContext from "@home/contexts/scroll";
import Count from "./index";

describe("Count", () => {
  it("데이터 fetching 후, 누적 이용자 수 제대로 나오는지 확인", async () => {
    render(
      <TestThemeProvider>
        <TestQueryClientProvider>
          <MockAPIBoundary>
            <CategoryContext>
              <Count />
            </CategoryContext>
          </MockAPIBoundary>
        </TestQueryClientProvider>
      </TestThemeProvider>
    );
  });
});
```
