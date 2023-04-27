## onChange �Լ����� Ŀ�� ����ϱ�

- ����Ʈ���� �Ʒ�ó�� onChange �� ����ؼ� event value�� ó���ϴ� ��찡 ����

- �� �� event �� �ƴ϶� �ٸ� �Ķ���Ͱ� ������ �Ʒ�ó�� ó���ϴµ� �̷��� �ۼ��� �ڵ带 �� �����ϰ� ó���� �� �ִ� ����� �ֵ�

```js
export default function Home() {
  const handleChange = (e, value) => {
    console.log(e, value);
  };

  return (
    <>
      <input type='text' onChange={(e) => handleChange(e, 1)} />
      <input type='text' onChange={(e) => handleChange(e, 2)} />
      <input type='text' onChange={(e) => handleChange(e, 3)} />
    </>
  );
}
```

- �ٷ� Ŀ��(Currying) ����̴�

- Ŀ���� �ϳ� �̻��� �Ű�����(Parameter)�� ���� �Լ��� �κ������� ������ ���� ���� �Ű������� ���� �Լ��� �����ϴ� �������

  - f(a, b, c) -> f(a)(b)(c)

- ��, �Լ��� �Ϻ� ���ڸ� ������Ű�� ���ο� �Լ��� ����� ����̴�.

- �Ʒ��� ���� event�� �޴� �Լ��� return �ϴ� �Լ��� ������ָ� �ڵ带 �� �����ϰ� �ۼ��� �� �ִ�

```js
export default function Home() {
  const [state, setState] = useState();

  const handleChange = (value) => {
    return (e) => console.log(e, value);
  };

  // �Ʒ��� handleChange(1)�� ���������ν� value�� 1�� ������ �Ǿ� �ִ�.
  return (
    <>
      <input type='text' onChange={handleChange(1)} />
      <input type='text' onChange={handleChange(2)} />
      <input type='text' onChange={handleChange(3)} />
    </>
  );
}
```

---

## Reference

- [10 React Antipatterns to Avoid - Code This, Not That!](https://www.youtube.com/watch?v=b0IZo2Aho9Y&list=PLGk6-UFPJT2WTTo0UhJILIvnpKyRkk2TW&index=9)
