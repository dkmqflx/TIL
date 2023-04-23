## Tagged Template Literal

- Tagged Template Literals�� Template Literals�� �̿��Ͽ� �Լ��� ���ڸ� �Ľ��Ͽ� �Ѱ��ִ� ��
- �Ʒ� �ڵ带 �����غ��� ������ ���� ����� ���´�
  - string?*['before ', ' before ', '', raw: Array(3)]*
    - **0**: "before "
    - **1**: " before "
    - **2**: ""
    - **length**: 3
    - **raw**: (3)?['before ',?' before ',?'']
  - first first
  - second second

```jsx
const first = 'first';
const second = 'second';

const taggedFunc = (string, first, second) => {
  console.log('string', string);
  console.log('first', first);
  console.log('second', second);

  console.log(`${string}, ${first} ${second}}`);
};

console.log(taggedFunc`before ${first} before ${second}`);
```

- ��, tagged template�� �μ��� �迭 �Ű������� �޴� ��
- function f(strings, ��args) ���� ���ڿ��� strings�迭�� ����, �������� args�迭�� ����
- �� �� strings�� ������ �κп� ����(empty character)�� ����

- �Ʒ�ó�� string �̿��� �Ķ���� �κ��� rest �Ķ���ͷ� ó���� �� �� �ִ�

```jsx
const taggedFunc = (string, ...str) => {
  console.log('string', string);
  console.log('str', str); // ['first', 'second']

  console.log(`${string}, ${str[0]} ${str[1]}}`);
};

console.log(taggedFunc`before ${first} before ${second}`);
```

### Ȱ����

- tagged literal�� ����ϸ� ������ ���ڿ��� ���� ó���� �� �ִ�

- ������ console.log�� ���� ����� �ϴ� �Լ��̴�.
- �Ʒ�ó�� �Լ��� �����ؼ� ȣ���ϸ� console.log�� ������ ����� ������ָ�
- console.log �κп��� �߰����� ������ ���ؼ� ���ڿ��� ������ų �� �ִ�

```jsx
const first = 'first';
const second = 'second';

const consoleLog = (strs, ...vars) => {
  const string = strs.reduce(
    (prev, cur, i) => prev + strs[i] + (vars[i] || ''),
    ''
  );
  console.log('string', string); // ���⿡ ���ڿ��� �߰��ϰų� ������Ű�� ���� �� �ٸ� ������ ó���� �� �ִ�
  return string;
};

consoleLog`before f ${first} before s ${second}`;
��;
```

- ���ڿ��� �����ϴ� ���� �Ʒ� ���ø� ���ؼ� Ȯ���� �� �ִ�.
- ������ �Է��ϰ�, ������ ���� ����� ����ϴ� �Լ���, �̷��� tagged literal�� ����ϸ�

```jsx
const score = 100;
const name = 'Kim';

const tagScore = (strings, ...params) => {
  const score = params[0];
  console.log(strings);
  console.log(params);
  let grade;

  if (score > 90) {
    grade = 'A';
  } else if (score > 80) {
    grade = 'B';
  } else if (score > 70) {
    grade = 'C';
  } else if (score > 60) {
    grade = 'D';
  } else {
    grade = 'F';
  }
  return strings[0] + grade + strings[1] + params[1];
};

console.log(tagScore`your grade: ${score} your name: ${name}`);
```

- ���̷��� tagged literal�� ������� �ʰ� score�� grade�� ��ȯ���ִ� �Լ��� ����ߴٸ�, �ʿ��� �� ���� ���ڿ��� �Է��ϰ� �Լ��� import �ؿ;� ������
- �̷��� ���ڿ� ��ü�� ó���ϴ� �Լ��� ������ ���� tagged literal�� ����ϸ� �� ������ ���ؼ� ��� ó���� �� �ִ�.

---

## Reference

- [(JavaScript) Tagged Template Literals��?](https://medium.com/@su_bak/javascript-tagged-template-literals%EB%9E%80-d7dca9461a45)
- [�±׵� ���ø� ���ͷ�(Tagged Template Literals) ? �ڹٽ�ũ��Ʈ ���̵� 4](https://smoothiecoding.kr/%ED%83%9C%EA%B7%B8%EB%93%9C-%ED%85%9C%ED%94%8C%EB%A6%BF-%EB%A6%AC%ED%84%B0%EB%9F%B4-%EC%9E%90%EB%B0%94%EC%8A%A4%ED%81%AC%EB%A6%BD%ED%8A%B8/)
- [ES2015 Tagged Template Literal](https://www.zerocho.com/category/ECMAScript/post/5aa7ecc772adcb001b2ed6f3)
