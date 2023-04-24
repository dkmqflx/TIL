## Custom Hook Pattern

- ���� ������ Ŀ���� ��(Hook)���� ���޵ǰ�, ���� ����ڰ� ������ �� �ִ�.

- ���� ���� ���� ���� ����(States, Hnadlers)�� �����Ͽ� ������Ʈ�� ��� ��������, ����ڿ��� �� ���� �������� �ش�.

### ����

- ���� ����� �ο�

  - ����ڴ� �Ű� JSX ������Ʈ ���̿� ������ �߰��Ͽ� �⺻ ������Ʈ�� ������ �ٲ� �� �ִ�.

  - �Ʒ� �����ڵ带 ���ؼ� �̸� Ȯ���� �� �ִ�

```js
function Usage() {
  const { count, handleIncrement, handleDecrement } = useCounter(0); // custom hook ���
  const MAX_COUNT = 10;

  const handleClickIncrement = () => {
    // Put your custom logic
    // ���� ���ϴ� ���� �߰� �� �� �ִ�
    if (count < MAX_COUNT) {
      handleIncrement();
    }
  };

  return (
    <>
      <Counter value={count}>
        <Counter.Decrement
          icon={'minus'}
          onClick={handleDecrement}
          disabled={count === 0}
        />
        <Counter.Label>Counter</Counter.Label>
        <Counter.Count />
        <Counter.Increment
          icon={'plus'}
          onClick={handleClickIncrement}
          disabled={count === MAX_COUNT}
        />
      </Counter>
      <StyledContainer>
        <button onClick={handleClickIncrement} disabled={count === MAX_COUNT}>
          Custom increment btn 1
        </button>
      </StyledContainer>
    </>
  );
}
```

### ����

- ������ ���⼺

  - ������ ������ �ϴ� �κ��� �и� �Ǿ� �ֱ� ������, ����ڴ� ������ ������ �κ��� ������ �־�� �Ѵ�.

  - ����, ������Ʈ�� �ùٸ��� �����ϱ� ���� ������Ʈ�� ���� ��Ŀ� ���� ���� ���ذ� �ʿ��ϴ�.

---

## Reference

- [� React ������ ������ ������ ���ϱ� ?](https://youngmin.hashnode.dev/react)
- [�����ڵ�](https://github.com/alexis-regnaud/advanced-react-patterns/blob/main/src/patterns/custom-hooks/Usage.js)
