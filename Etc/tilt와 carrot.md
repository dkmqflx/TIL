## Tilt(~)�� Carrot(^)

- ƿƮ�� ĳ���� ������ �����ϱ� ���� ����Ѵ�

### ƿƮ

- ƿ��� ������ ���ϸ� ���� ������ ������ ������ �ڸ� ���� ���������� �ڵ����� ������Ʈ�Ѵ�.

  - `~0.0.1`?:?`>=0.0.1 <0.1.0`
  - `~0.1.1`?:?`>=0.1.1 <0.2.0`
  - `~0.1`?:?`>=0.1.0 <0.2.0`
  - `~0`?:?`>=0.0 <1.0`

### ĳ��

- ĳ���� �����ϱ� ���� �켱 [Semantic Versioning](http://semver.org/)�� ���ؼ� �����ϰ� �־�� �Ѵ�

- Node.js�� �׷��� npm�� ����� ��� SemVer�� ������ �ִµ� Semantic Versioning�̶� `MAJOR.MINOR.PATCH`
  �� �������� �����µ� �� �ǹ̴� ������ ����. 1. MAJOR version when you make incompatible API changes, 2. MINOR version when you add functionality in a backwards-compatible manner, and 3. PATCH version when you make backwards-compatible bug fixes.

- ��, MAJOR ������ API�� ȣȯ���� �������� ��������� �ǹ��ϰ�

- MINOR ������ ����ȣȯ���� ��Ű�鼭 ����� �߰��� ���� �ǹ��ϰ�

- PATCH ������ ����ȣȯ���� ��Ű�� ���������� ���װ� ������ ���� �ǹ��Ѵ�.

- ��, ĳ�� ����� `[major, minor, patch]` ���� ���� ���ʿ� �ִ� 0�� �ƴ� ��Ҹ� �������� �ʴ� ���� ���

- 1.0.0 �����̶�� minor�� patch ������ ������Ʈ�� ���

- 0.X �����̶�� patch ������Ʈ ���

- 0.X.X �����̶�� ������Ʈ�� ������� �ʴ´�.

- **`^1.2.3`:** `>=1.2.3 < 2.0.0`

  - ���ʿ��� �� ó�� 0�� �ƴ� ��Ҵ� major �̱� ������ minor, patch ������Ʈ�� ���

- **`^0.2.3`:** `>=0.2.3 <0.3.0`

  - ���ʿ��� �� ó�� 0�� �ƴ� ��Ұ� minor �̱� ������ patch ������Ʈ�� ���

- **`^0.0.3`**

  - ���ʿ��� �� ó�� 0�� �ƴ� ��Ұ� patch�̱� ������ ������Ʈ�� ������� ����

---

### Reference

- [npm package.json���� ƿ��(~) ��� ĳ��(^) ����ϱ�](https://blog.outsider.ne.kr/1041)
- [npm semver - ƿƮ ����(~)�� ĳ�� ����(^)](https://velog.io/@slaslaya/npm-semver-%ED%8B%B8%ED%8A%B8-%EB%B2%94%EC%9C%84%EC%99%80-%EC%BA%90%EB%9F%BF-%EB%B2%94%EC%9C%84)
