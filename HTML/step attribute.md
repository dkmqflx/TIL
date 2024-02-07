## HTML attribute: step

> The step attribute is a number that specifies the granularity that the value must adhere to or the keyword any. It is valid for the numeric input types, including the date, month, week, time, datetime-local, number and range types.

input 태그의 type을 number로 정하고 나면 소수점을 입력받을 수 없게 된다

```html
<input type="number" />
```

만약 소수점을 입력하게 되면 아래와 같은 경고 메세지를 볼 수 있다.

<img width="852" alt="스크린샷 2024-02-07 오전 11 43 22" src="https://github.com/dkmqflx/TIL/assets/42763164/60302dcb-4fbb-4460-a7c7-33474e7a4c7b">

이러한 문제를 해결할 수 있는 방법이 step attributes로,

아래처럼 step을 명시해주면 소수점 두번째 자리까지 숫자를 입력받을 수 있다

```html
<input type="number" step="{0.01}" />
```

---

## Reference

- [HTML attribute: step](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/step)
