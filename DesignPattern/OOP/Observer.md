## Observer Pattern

- Observer는 관찰자라는 뜻으로 어떤 상태가 변경되었을 때이 상태의 변경에 관심이 있는 관찰자들에게 알려주는 패턴이다

- 그림에서 보면 것처럼 어떤 상태가 있고, 상태의 변화에 관심을 갖고 있는 4개의 관찰자가 있다

- 상태가 변화되면 각 관찰자에게이 상태가 직접 자신이 변경되었음을 알리는데 필요에 따라서는 변경된 상태에 각도 관찰자에게 전달한다

<img src='./images/observer08.png'>

- 옵저버 패턴은 어떤 상태의 변화에 대한 처리를 위해서 사용된다

- 그리고 상태 변화가 발생하면 상태 변화에 관심을 가지고 있는 객체들

- 즉, 옵저버들에게 상태 변화를 알리고 필요하다면 변경된 상태값도 함께 전달한다

<br/>

- 상태(State)와 상태 관찰하는 관찰자(Observer)라는 개념을 통해

- **상태 변화가 있을 때 각 관찰자가 인지**하도록 하는 디자인 패턴으로 아래 그림과 같이 나타낼 수 있다

- 이러한 옵저버 패턴을 사용하면 이벤트가 일어났을 때 관찰자들이 알아차릴 수 있게 된다

- 옵저버 패턴을 사용하지 않는다면 매초, 매분, 매 시간마다 요청을 보내서(polling, 주기적으로 감지) 이벤트가 일어났는지 확인해야 한다

  - 예시로, 알람이 울렸을 때 같은 방에 있는 모든 사람이 알람을 듣고 반응하는 것과 같다

- 즉, 이벤트 기반의 기능을 구현할때 원하는 기능이 동적으로 동작이 수행되도록 해주는 역활을 한다

  - 예를들어 알림, 메세지, UI 이벤트 등록 등

  - 객체 (또는 컴포넌트) 의 상태 변화에 따라서 반응처리를 해줘야 할때 사용되기도 한다

<img src='./images/observer01.png'>

- 아래와 같은 코드로 작성할 수 있다

<img src='./images/observer02.png'>

- 왼쪽에 있는 createObserverState의 함수 내에 있는 각 코드는 아래와 같다

- state

  - 상태를 담는 곳

- listeners

  - 상태 변화를 통지 받을 리스너 함수들을 보관하는 곳

- subscribe

  - listeners에 함수를 등록할 수 있는 함수

- setState

  - 상태를 변화시키는 함수

  - 함수 코드를 보면 등록된 listeners들에게 새로운 상태를 전파하는 모습을 볼 수 있다

- 그리고 오른쪽에 있는 것 처럼 subscribe 함수를 통해 각각의 모듈에서 상태 변화를 감지할 수 있다.

- 가장 아래 있는 코드에서 볼 수 있는 것 처럼, setState를 통해서 상태 변화가 일어나면

- listeners에 등록된 각 listener를 통해 관측자들에게 상태가 변화했음을 알리는 것이다

- 즉, subscribe를 통해서 listners에 함수를 등록해 놓았기 때문에

- setState가 호출되면 `observer.observers.forEach(observer => observer(state))`를 통해서 등록한 함수가 실행되는 것

<br/>

- 또 다른 예시로 다음과 같은 코드가 있다

- 관찰 대상의 "주제 객체" (옵저버 대상)

- 관찰을 하는 "구독 객체" (옵저버)

- 구독객체는 자유롭게 주제겍체를 등록/등록 취소할 수 있고

- 한 주제 객체의 상태가 바뀌면 다른 구독 객체들에게 상태와 변경을 알림

```js
// 옵저버 대상
class Subject {
  constructor() {
    this.observers = [];
  }

  getObserverList() {
    return this.observers;
  }

  // 옵저버 등록
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

// 옵저버
class Observer {
  constructor(name) {
    this.name = name;
  }
  update(subj) {
    console.log(`${this.name}: notified from ${subj} class!`);
  }
}

const subj = new Subject();

// 옵저버 인스턴스 생성
const a = new Observer('A');
const b = new Observer('B');
const c = new Observer('C');

// 구독 시작
subj.subscribe(a);
subj.subscribe(b);
subj.subscribe(c);

console.log(sub.getObserverList());
// 세가지 인스턴스가 출력된다

sub.notifyAll();
// `A: notified from Subject class!`
// `B: notified from Subject class!`
// `C: notified from Subject class!`

// 해지
subj.unsubscribe(b);

// 해지된 것 빼고 출력된다
sub.notifyAll();
// `A: notified from Subject class!`
// `C: notified from Subject class!`
```

### 클래스 다이어그램

- 아래는 옵저버 패턴에 대한 클래스 다이어그램에 한 가지 예시이다

<img src='./images/observer09.png'>

- DiceGame 클래스는 주사위 게임을 나타내는 추상 클래스이다

- DiceGame 클래스는 주사위 게임에 참가하는 Player 클래스 객체를 여러개 추가할 수 있는데

- addPlayer 메서드를 통해서 추가할 수 있다

- DiceGame과 Player 사이의 선을 보면 `*`을 확인할 수 있는데

- 이것을 통해 여러 개의 Player 객체를 DiceGame 객체가 가질 수 있음을 나타낸다

- DiceGame은 주사위를 던지면 즉, play 메서드를 호출하면 주사위의 번호를 게임에 참가한 Player 객체들에게 알린다

- 주사위를 던져서 나온 수가 바로 형태 변화에 대한 값이다

- DiceGame은 추상 클래스인데 파일을 던져서 나온 수를 결정하는 방법을 다양하게 구현하기 위해서 이렇게 추상 클래스로 정의했다

- FairDiceGame 은 DiceGame 클래스를 상속 받는데, FairDiceGame은 주사위를 1부터 6까지 공평하게 나오도록 구현한다

- 그리고 이 UnfairDiceGame 클래스는 공평하게 주사위 번호가 결정되지 않고 특정한 번호가 더 많이 나오는 불공정한 주사위 게임으로 할 수 있다

  - 다만 UnfairDiceGame 클래스는 구현하지 않는다

- Player 클래스 역시 추상 클래스인데 던져서 나온 주사위의 수에 따라서 처리하는 코드를 다양하게 구현하기 위해서 추상 클래스로 정의했다

- Player 클래스를 상속받는 클래스는 OddBettingPlayer, EvenBettingPlayer, NBettingPlayer 클래스이다

- OddBettingPlayer 클래스는 주사위의 수가 홀수가 나왔을 때 반응을 하고

- EvenBettingPlayer 클래스는 주사위의 수가 짝수가 나왔을 때 반응을 하고

- NBettingPlayer 클래스는 지정된 수에 반응을 한다

### 클래스 다이어그램 구현

- 먼저 Player 추상 클래스를 추가한다

```ts
// Player.ts

export default abstract class Player {
  // Player를 구현하는 자식 클래스에서 접근할 수 있도록 protected로 설정
  protected _winning: boolean = false;
  // 주사위를 던진 수를 플레이어가 맞추었을 때 true, 틀렸을 때 false가 된다

  // player의 이름에 대한 필드를 가진다
  constructor(private _name: string) {}

  // 이름을 얻기 위한 프로퍼티
  get name() {
    return this._name;
  }

  // _winning 값을 얻기 위한 프로퍼티
  get winning() {
    return this._winning;
  }

  // 주사위의 값, 즉, 상태 변화에 대해서 플레이어가 어떻게 처리할지에 대한 추상 메소드
  // diceNumber : 던져서 나온 주사위의 수
  abstract update(diceNumber: number): void;
}
```

- 다음은 DiceGame 추상 클래스이다

```js
// DiceGame.ts

import Player from './Player'

export default abstract class DiceGame{
  // 게임이 참가하는 플레이어들을 저장할 수 있는 필드
  // protected 접근자로 지정해서 자식 클래스에서도 해당 필드에 접근할 수 있도록 했다
  protected players = new Array<Player>()

  // 플레이어를 추가할 수 있는 메소드
  addPlayer(player:Player):void{
    this.players.push(player)
  }

  // 주사위를 던지는 추상 메서드
  abstract play():number
}

```

- 다음은 DiceGame 을 상속받는 FairDiceGame 클래스이다

```js
// FairDiceGame.ts

import DiceGame from './DiceGame';

export default class FairDiceGame extends DiceGame {
  // 부모 클래스 정의되어 있는 할 추상 메서드를 구현
  play(): number {
    const n = Math.floor(Math.random() * 6) + 1; // 1부터 6까지 변수 얻는다

    // players 필드에 추가된 플레이어 객체들을 하나씩 순회하면서 player의 update 메서드를 호출해주는데
    // 던져서 나온 주사위의 수 n을 update 메서드의 인자로 넘기고 있다

    this.players.forEach((player) => {
      player.update(n);
    });

    // 그리고 마지막으로 주사위의 수를 반환한다

    return n;
  }
}
```

- 이제 Player 추상클래스를 상속받는 OddBettingPlyer 클래스를 추가한다

```ts
// OddBettingPlayer.ts

import Player from './Player';

export default class OddBettingPlayer extends Player {
  constructor(name: string) {
    super(name);
  }
  // 부모 클래스에 추상 메서드인인 update 메서드를 추가한다
  // 홀수 일 때 자신이 이겼으므로 _winning 값을 업데이트 한다
  update(diceNumber: number): void {
    this._winning = dicenumber % 2 === 1;
  }
}
```

- 그리고 다음은 EvenettingPlyer 클래스를 추가한다

```ts
// EvenBettingPlayer.ts

import Player from './Player';

export default class EvenBettingPlayer extends Player {
  constructor(name: string) {
    super(name);
  }
  // 부모 클래스에 추상 메서드인인 update 메서드를 추가한다
  // 짝수 일 때 자신이 이겼으므로 _winning 값을 업데이트 한다
  update(diceNumber: number): void {
    this._winning = dicenumber % 2 === 0;
  }
}
```

- 다음은 NBettingPlayer 클래스이다

```ts
// NBettingPlayer.ts

import Player from './Player';

export default class NBettingPlayer extends Player {
  // ns는 플레이어가 맞출 주사위 번호들
  constructor(name: string, private ns: Array<number>) {
    super(name);
  }
  // 부모 클래스에 추상 메서드인인 update 메서드를 추가한다
  // 주사위의 수인 diceNumber가 포함되면 _winning을 true로 한다
  update(diceNumber: number): void {
    this._winning = this.ns.includes(diceNumber);
  }
}
```

- 지금까지 작성된 코드를 아래와 같이 사용할 수 있다

```js
import FairDiceGame from './FairDiceGame';
import OddBettingPlayer from './OddBettingPlayer';
import EvenBettingPlayer from './EvenBettingPlayer';
import NBettingPlayer from './NBettingPlayer';

const diceGame = new FairDiceGame(); // 게임 생성

// 세명의 플레이어 객체 생성

const players = [
  new OddBettingPlayer('홀수'),
  new EvenBettingPlayer('짝수'),
  new NBettingPlayer('직접', [2, 3, 5]),
];

// 세 플레이어를 diceGame의 참여 플레이어로 추가한다
players.forEach((player) => diceGame.addPlayer(player));

// 게임이 참여한 플레이어를이 화면에 표시하는 함수
const updateBoard = () => {
  const domPlayers = document.querySelector('.players');
  domPlayers.innerHTML = '';

  players.forEach((player) => {
    const domPlayer = document.createElement('div');
    domPlayer.innerText = player.name;

    if (player.winning) domPlayer.classList.add('win');

    domPlayer.append(domPlayer);
  });
};

updateBoard(); // 함수 호출해준다

// 주사위 굴리는 이벤트 추가

document.querySelector('button').addEventListener('click', () => {
  const diceNumber = diceGame.play(); // 주사위 굴린 결과에 해당 하는 수

  const domDice = document.querySelector('.dice') as HTMLElement
  domDice.innerText = diceNumber.toString()

  updateBoard(); // 화면 업데이트
});
```

### Pub/Sub 모델

- 옵저버 패턴을 이야기할 때 빠지지 않고 등장하는 것으로 발행/구독 (**Pub**lish/**Sub**Scribe) 모델이 있다

- 하나의 상태를 감지하는 디자인을 넘어서 broker라고도 불리는 중개자라는 개념을 통해

- 불특정 다수의 관찰자들에게 그들이 구독하는 관심사에 대한 메세지를 전달하는 디자인이다

  - 유튜브의 구독과 같은 개념

- 아래 코드를 통해서 보면 다음과 같다

<img src='./images/observer03.png'>

- broker는 특정 key로 구분되는 listener 집합에게 메세지를 발행하는 publish 함수와

- 특정 key로 발행되는 메세지를 구독할 리스너를 등록하는 subscribe로 구성할 수 있다.

- 이제 관측자는 아래처럼 브로커에 리스너를 등록해둠으로써 누군가 특정 메세지를 발행했을때, 그 메세지를 수신할 수 있다.

<img src='./images/observer04.png'>

- 이러한 역할을 수행하는 공식 api로는 브라우저의 [message channel](https://developer.mozilla.org/en-US/docs/Web/API/MessageChannel), [event target](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/EventTarget)등이 있다.

- 발행/구독 디자인을 사용하면 발행자와 구독자 간 관계를 브로커가 대행하고,

- 이들은 서로의 존재를 모른채 인터페이스 혹은 메세지에만 의존하기 때문에 스템 간 상호 의존성을 줄여줄 수 있다.

<img src='./images/observer05.png'>

- 프론트엔드 세계에서 벌어지는 다양한 의존성 문제들에도 적용해볼 수 있다.

- 예를들어 react를 사용하는 프로젝트에서 axios 요청에 대한 에러 응답이 도착했을때 toast를 띄우고싶은 경우라면

- 각 요청마다 catch를 하는건 비효율적일것같고 막연하게는 axios interceptor에 무슨짓을 해야될 것 같은데

- react 컴포넌트에 에러를 어떻게 전달할지 감이 잘 오지 않는다.

- 여기에 발행/구독 디자인을 사용 해볼 수 있다.

<img src='./images/observer06.png'>

- 가장 왼쪽에서 볼 수 있듯이 errorBroker처럼 간단하게 에러 관련 메세지들을 중개할 broker를 만들고

- Toast 함수를 정의해서 toast 노출을 담당하는 react 컴포넌트에서 구독을 걸어두면

- axios interceptor에서 broker에게 에러 메세지를 publish하는 것으로 react 컴포넌트에게 일을 시킬 수 있게된다.

- 이는 아래처럼 react toastify라는 라이브러리가 별도의 컴포넌트 설정을 하지않아도 react lifecycle을 갖는 toast 컴포넌트를 노출할 수 있는것과 비슷한 원리

<img src='./images/observer07.png'>

- 물론 이런 구현은 간단한 수준의 옵저버 패턴만으로도 가능하겠지만 다양한 에러를 특정 형태로 처리할 계획이 있다면 발행/구독 모델도 좋은 선택이 될 수 있을 것

---

## Reference

- [프론트엔드에 디자인패턴 끼얹기2 - 관찰자 패턴, 발행 구독(observer pattern, pub sub)](https://www.youtube.com/watch?v=aH4U6bfi_Ds&t=20)
- [디자인패턴, Observer Pattern, 옵저버 패턴](https://www.youtube.com/watch?v=1dwx3REUo34&t=30)
- [개발자가 알아야할 디자인패턴 | ep3. Observer Pattern | 자바스크립트 옵저버 패턴](https://www.youtube.com/watch?v=1UxRkggQwbs&t=29)
- [TypeScript로 보는 GoF의 디자인 패턴: 13. Observer](https://www.youtube.com/watch?v=aAA2t9VT-A0&list=PLe6NQuuFBu7H3sFnErshsfgNPE9dOZZrx&index=13)
- [Observer 패턴](https://patterns-dev-kr.github.io/design-patterns/observer-pattern/)
- [Observer 패턴 알아보기 (hooks와 observables)](https://www.howdy-mj.me/javascript/observer-pattern)
