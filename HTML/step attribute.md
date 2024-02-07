## HTML attribute: step

> The step attribute is a number that specifies the granularity that the value must adhere to or the keyword any. It is valid for the numeric input types, including the date, month, week, time, datetime-local, number and range types.

input 태그의 type을 number로 정하고 나면 소수점을 입력받을 수 없게 된다

```html
<input type="number" />
```

만약 소수점을 입력하게 되면 아래와 같은 경고 메세지를 볼 수 있다.

![스크린샷 2024-02-07 오전 11.43.22.png](https://github.com/dkmqflx/TIL/76784541-cf1f-47f0-9111-f8451ff8eafe/aeb0a74e-1f40-4ca5-b939-b6a2a8bca354/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2024-02-07_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_11.43.22.png)

이러한 문제를 해결할 수 있는 방법이 step attributes로,

아래처럼 step을 명시해주면 소수점 두번째 자리까지 숫자를 입력받을 수 있다

```html
<input type="number" step="{0.01}" />
```

---

## Reference

- [HTML attribute: step](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/step)
