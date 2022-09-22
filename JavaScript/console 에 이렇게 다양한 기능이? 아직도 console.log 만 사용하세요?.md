### 상황에 따라 색깔이나 스타일이 다른 메세지를 보여주도록 할 수 있따

```javascript
console.info('info');

console.debug('debug');

console.warn('warn');

console.error('error');
```

### console.assert

- 조건이 false 일 때만 메세지 보여준다

```js
for (let i = 0; i < 2; i++) {
  console.assert(i % 2 === 0, `${i}는 홀수이다.`);
  // Assertion failed: 1은 홀수입니다.
}
```

### console.group, groupEnd

- grouping을 위해 사용할 수 있다.
- grouping 되어서 메세지가 출력된다.

```js
console.group();
console.log('hello');
console.log('world');
console.groupEnd();

// group에 이름 지정할 수 있다
console.group('group1');
console.log('hello1');
console.log('world1');
console.groupEnd();

console.group('group2');
console.log('hello2');
console.log('world2');
console.groupEnd();
```

### console.clear

- console 창 지우는데 사용한다

```js
console.clear();
```

### console.time, timeEnd

- 시간 측정에 사용할 수 있드

```js
console.time('작업1');

for (let i = 0; i < 100000; i++) {}

console.timeEnd('작업1');

// 작업1에 걸린 시간 출력된다
```

### %s, %d, %o : 문자열 치환

- %s : 문자
- %d : 숫자
- %o : 객체

```js
const name = 'li';
const job = 'developer';
const age = 20;
const score = { html: 100, css: 90, js: 80 };

console.log('정보 %s %s, 나이 %d, 점수 %o', name, job, age, score);
```

### %c : 스타일링

- %c 뒤에 css를 작성해주면 된다

```js
console.log('hello $cworld', 'color:tomato font-weight:bold');
// world 색깔이 변경된다
```

---

## Reference

- [console 에 이렇게 다양한 기능이? 아직도 console.log 만 사용하세요?](https://www.youtube.com/watch?v=YHrRY6IaJpQ&t=34s)
