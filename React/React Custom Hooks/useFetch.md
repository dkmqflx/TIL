## useFetch

- API 요청을 통해 데이터를 받아올 때 사용할 수 있는 hook

```js
// useFetch.js

const useFetch = (url = '', options = null) => {
  const [data, setData] = useState(null);
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(false);

  useEffect(async () => {
    setLoading(true);

    fetch(url, options)
      .then((res) => res.json())
      .then((data) => {
        setData(data);
        setError(null);
      })
      .catch((error) => {
        setError(error);
        setData(null);
      })
      .finally(() => setLoading(false));
  }, [url, options]);

  return { loading, error, data };
};

export default useFetch;
```

### Usage

```js
import useFetch from './useFetch';

const App = () => {
  const { loading, error, data = [] } = useFetch('url');

  if (error) return <p>Error!</p>;
  if (loading) return <p>Loading...</p>;

  return (
    <div>
      <ul>
        {data?.map((item) => (
          <li key={item.id}>
            <a href={item.url}>{item.title}</a>
          </li>
        ))}
      </ul>
    </div>
  );
};
```
