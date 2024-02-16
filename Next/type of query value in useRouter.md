- The query key of the router object in Next.js can have values of type string or string[].

- This can be confirmed through the following type, where the type of the query is ParsedUrlQuery, allowing the values to be either string or string[].

```ts
const router = useRouter();
```

```ts
export type BaseRouter = {
  route: string;
  pathname: string;
  query: ParsedUrlQuery;
  asPath: string;
  basePath: string;
  locale?: string | undefined;
  locales?: string[] | undefined;
  defaultLocale?: string | undefined;
  domainLocales?: DomainLocale[] | undefined;
  isLocaleDomain: boolean;
};

interface ParsedUrlQuery extends NodeJS.Dict<string | string[]> {}

interface Dict<T> {
  [key: string]: T | undefined;
}
```

- The reason the query key's value becomes a string array is due to Next.js catch-all segments in dynamic routes.

- When specifying the path as `pages/blog/[slug].js`, accessing the URL `/blog/a` will result in the value inside router.query being `{ slug: 'a' }`.

- However, when specifying the path as `pages/shop/[...slug].js`, accessing the URL `/shop/a/b/c` will result in the following value inside router.query `{ slug: ['a', 'b', 'c'] }`.

<br/>

- Therefore, attempting to retrieve values by using them as keys in the router.query object will result in an error.

```ts
// url: ?key=test
const router = useRouter();

// string, string[], undefined 타입을 string에 전달할 수 없다는 에러 발생
const handleQuery = (key: string) => {
  console.log("key", key);
};

handleQuery(router.query.key);
```
