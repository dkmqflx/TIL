# Suspense

- Suspense는 비동기 처리를 할 때 로딩 상태를 선언적으로 처리할 수 있는 컴포넌트

- `<Suspense>` lets you display a fallback until its children have finished loading.

## Usage

- Displaying a fallback while content is loading You can wrap any part of your application with a Suspense boundary:

```tsx
<Suspense fallback={<Loading />}>
  <Albums />
</Suspense>
```

- React will display your loading fallback until all the code and data needed by the children has been loaded.

- Suspense를 사용해서 선언적으로 로딩 처리를 할 수 있는 경우는 총 두가지가 있다.

  1. Data Fetching

  2. Lazy Loading

<br/>

## 1. Data Fetching (w. React Query)

- React Query에서 Suspense를 사용하기 위해서는 `{suspense: true}` 옵션을 추가해주면 된다.

  - **[Suspense](https://tanstack.com/query/v4/docs/react/guides/suspense)**

```tsx
// Configure for all queries
import {
  QueryClient,
  QueryClientProvider,
  useQuery,
} from "@tanstack/react-query";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      suspense: true,
    },
  },
});

function Root() {
  return (
    <QueryClientProvider client={queryClient}>
      <App />
    </QueryClientProvider>
  );
}

// Enable for an individual query
useQuery({ queryKey, queryFn, suspense: true });
```

- 아래처럼 사용하면 된다.

```tsx
import React, { Suspense } from "react";
import Layout from "@common/Layout";
import Select from "domains/application/components/Select";
import Tabs from "domains/application/components/Tabs";
import List from "domains/application/components/List";
import CategoryContext from "domains/application/contexts/application";

const Application = () => {
  return (
    <CategoryContext>
      <Layout navigation>
        <Tabs />
        <Select />
        <Suspense fallback={<div>LOADING...!</div>}>
          {/* 데이터를 불러올 때 LOADING...! 텍스트가 화면에 보인다 */}
          <List />
        </Suspense>
      </Layout>
    </CategoryContext>
  );
};

export default Application;
```

## 2. Lazy Loading

- Next.js에서는 [lazy loading](<(https://nextjs.org/docs/pages/building-your-application/optimizing/lazy-loading)>)을 두가지 방식으로 구현할 수 있다.

  1.  Using Dynamic Imports with next/dynamic

  2.  Using React.lazy() with Suspense

### 1. Dynamic Imports with next/dynamic

- next/dynamic은 React.lazy()와 Suspense 조합으로, 이를 동시에 구현할 수 있다.

> next/dynamic is a composite of React.lazy() and Suspense. It behaves the same way in the app and pages directories to allow for incremental migration.

```tsx
import dynamic from "next/dynamic";

const DynamicHeader = dynamic(() => import("../components/header"), {
  loading: () => <p>Loading...</p>,
});

export default function Home() {
  return <DynamicHeader />;
}
```

### 2. React,lazy() with Suspense

```tsx
import { lazy } from "react";
import MarkdownPreview from "./MarkdownPreview.js";

const MarkdownPreview = lazy(() => import("./MarkdownPreview.js"));

<Suspense fallback={<Loading />}>
  <h2>Preview</h2>
  <MarkdownPreview />
</Suspense>;
```

---

## Reference

- [React Query와 함께 Concurrent UI Pattern을 도입하는 방법](https://tech.kakaopay.com/post/react-query-2/)
