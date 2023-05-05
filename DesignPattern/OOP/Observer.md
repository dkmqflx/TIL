## Observer Pattern

- ����(State)�� ���� �����ϴ� ������(Observer)��� ������ ����

- **���� ��ȭ�� ���� �� �� �����ڰ� ����**�ϵ��� �ϴ� ������ �������� �Ʒ� �׸��� ���� ��Ÿ�� �� �ִ�

- �̷��� ������ ������ ����ϸ� �̺�Ʈ�� �Ͼ�� �� �����ڵ��� �˾����� �� �ְ� �ȴ�

- ������ ������ ������� �ʴ´ٸ� ����, �ź�, �� �ð����� ��û�� ������(polling, �ֱ������� ����) �̺�Ʈ�� �Ͼ���� Ȯ���ؾ� �Ѵ�

  - ���÷�, �˶��� ����� �� ���� �濡 �ִ� ��� ����� �˶��� ��� �����ϴ� �Ͱ� ����

- ��, �̺�Ʈ ����� ����� �����Ҷ� ���ϴ� ����� �������� ������ ����ǵ��� ���ִ� ��Ȱ�� �Ѵ�

  - ������� �˸�, �޼���, UI �̺�Ʈ ��� ��

  - ��ü (�Ǵ� ������Ʈ) �� ���� ��ȭ�� ���� ����ó���� ����� �Ҷ� ���Ǳ⵵ �Ѵ�

<img src='./images/observer01.png'>

- �Ʒ��� ���� �ڵ�� �ۼ��� �� �ִ�

<img src='./images/observer02.png'>

- ���ʿ� �ִ� createObserverState�� �Լ� ���� �ִ� �� �ڵ�� �Ʒ��� ����

- state

  - ���¸� ��� ��

- listeners

  - ���� ��ȭ�� ���� ���� ������ �Լ����� �����ϴ� ��

- subscribe

  - listeners�� �Լ��� ����� �� �ִ� �Լ�

- setState

  - ���¸� ��ȭ��Ű�� �Լ�

  - �Լ� �ڵ带 ���� ��ϵ� listeners�鿡�� ���ο� ���¸� �����ϴ� ����� �� �� �ִ�

- �׸��� �����ʿ� �ִ� �� ó�� subscribe �Լ��� ���� ������ ��⿡�� ���� ��ȭ�� ������ �� �ִ�.

- ���� �Ʒ� �ִ� �ڵ忡�� �� �� �ִ� �� ó��, setState�� ���ؼ� ���� ��ȭ�� �Ͼ��

- listeners�� ��ϵ� �� listener�� ���� �����ڵ鿡�� ���°� ��ȭ������ �˸��� ���̴�

- ��, subscribe�� ���ؼ� listners�� �Լ��� ����� ���ұ� ������

- setState�� ȣ��Ǹ� `observer.observers.forEach(observer => observer(state))`�� ���ؼ� ����� �Լ��� ����Ǵ� ��

<br/>

- �� �ٸ� ���÷� ������ ���� �ڵ尡 �ִ�

- ���� ����� "���� ��ü" (������ ���)

- ������ �ϴ� "���� ��ü" (������)

- ������ü�� �����Ӱ� ������ü�� ���/��� ����� �� �ְ�

- �� ���� ��ü�� ���°� �ٲ�� �ٸ� ���� ��ü�鿡�� ���¿� ������ �˸�

```js
// ������ ���
class Subject {
  constructor() {
    this.observers = [];
  }

  getObserverList() {
    return this.observers;
  }

  // ������ ���
  subscribe(observer) {
    this.observers.push(observer);
  }

  unsubscribe(observer) {
    this.observers = this.observers.filter((obs) => obs !== observer);
  }

  notifyAll() {
    this.observers.forEach((subscriber) => {
      try {
        subscriber.update(this.constructor.name);
      } catch (err) {
        console.error('error', error);
      }
    });
  }
}

// ������
class Observer {
  constructor(name) {
    this.name = name;
  }
  update(subj) {
    console.log(`${this.name}: notified from ${subj} class!`);
  }
}

const subj = new Subject();

// ������ �ν��Ͻ� ����
const a = new Observer('A');
const b = new Observer('B');
const c = new Observer('C');

// ���� ����
subj.subscribe(a);
subj.subscribe(b);
subj.subscribe(c);

console.log(sub.getObserverList());
// ������ �ν��Ͻ��� ��µȴ�

sub.notifyAll();
// `A: notified from Subject class!`
// `B: notified from Subject class!`
// `C: notified from Subject class!`

// ����
subj.unsubscribe(b);

// ������ �� ���� ��µȴ�
sub.notifyAll();
// `A: notified from Subject class!`
// `C: notified from Subject class!`
```

### Pub/Sub ��

- ������ ������ �̾߱��� �� ������ �ʰ� �����ϴ� ������ ����/���� (**Pub**lish/**Sub**Scribe) ���� �ִ�

- �ϳ��� ���¸� �����ϴ� �������� �Ѿ broker��� �Ҹ��� �߰��ڶ�� ������ ����

- ��Ư�� �ټ��� �����ڵ鿡�� �׵��� �����ϴ� ���ɻ翡 ���� �޼����� �����ϴ� �������̴�

  - ��Ʃ���� ������ ���� ����

- �Ʒ� �ڵ带 ���ؼ� ���� ������ ����

<img src='./images/observer03.png'>

- broker�� Ư�� key�� ���еǴ� listener ���տ��� �޼����� �����ϴ� publish �Լ���

- Ư�� key�� ����Ǵ� �޼����� ������ �����ʸ� ����ϴ� subscribe�� ������ �� �ִ�.

- ���� �����ڴ� �Ʒ�ó�� ���Ŀ�� �����ʸ� ����ص����ν� ������ Ư�� �޼����� ����������, �� �޼����� ������ �� �ִ�.

<img src='./images/observer04.png'>

- �̷��� ������ �����ϴ� ���� api�δ� �������� [message channel](https://developer.mozilla.org/en-US/docs/Web/API/MessageChannel), [event target](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/EventTarget)���� �ִ�.

- ����/���� �������� ����ϸ� �����ڿ� ������ �� ���踦 ���Ŀ�� �����ϰ�,

- �̵��� ������ ���縦 ��ä �������̽� Ȥ�� �޼������� �����ϱ� ������ ���� �� ��ȣ �������� �ٿ��� �� �ִ�.

<img src='./images/observer05.png'>

- ����Ʈ���� ���迡�� �������� �پ��� ������ �����鿡�� �����غ� �� �ִ�.

- ������� react�� ����ϴ� ������Ʈ���� axios ��û�� ���� ���� ������ ���������� toast�� ������� �����

- �� ��û���� catch�� �ϴ°� ��ȿ�����ϰͰ��� �����ϰԴ� axios interceptor�� �������� �ؾߵ� �� ������

- react ������Ʈ�� ������ ��� �������� ���� �� ���� �ʴ´�.

- ���⿡ ����/���� �������� ��� �غ� �� �ִ�.

<img src='./images/observer06.png'>

- ���� ���ʿ��� �� �� �ֵ��� errorBrokeró�� �����ϰ� ���� ���� �޼������� �߰��� broker�� �����

- Toast �Լ��� �����ؼ� toast ������ ����ϴ� react ������Ʈ���� ������ �ɾ�θ�

- axios interceptor���� broker���� ���� �޼����� publish�ϴ� ������ react ������Ʈ���� ���� ��ų �� �ְԵȴ�.

- �̴� �Ʒ�ó�� react toastify��� ���̺귯���� ������ ������Ʈ ������ �����ʾƵ� react lifecycle�� ���� toast ������Ʈ�� ������ �� �ִ°Ͱ� ����� ����

<img src='./images/observer07.png'>

- ���� �̷� ������ ������ ������ ������ ���ϸ����ε� �����ϰ����� �پ��� ������ Ư�� ���·� ó���� ��ȹ�� �ִٸ� ����/���� �𵨵� ���� ������ �� �� ���� ��

---

## Reference

- [����Ʈ���忡 ���������� �����2 - ������ ����, ���� ����(observer pattern, pub sub)](https://www.youtube.com/watch?v=aH4U6bfi_Ds&t=20)
- [����������, Observer Pattern, ������ ����](https://www.youtube.com/watch?v=1dwx3REUo34&t=30)
- [�����ڰ� �˾ƾ��� ���������� | ep3. Observer Pattern | �ڹٽ�ũ��Ʈ ������ ����](https://www.youtube.com/watch?v=1UxRkggQwbs&t=29)
- [Observer ����](https://patterns-dev-kr.github.io/design-patterns/observer-pattern/)
- [Observer ���� �˾ƺ��� (hooks�� observables)](https://www.howdy-mj.me/javascript/observer-pattern)
