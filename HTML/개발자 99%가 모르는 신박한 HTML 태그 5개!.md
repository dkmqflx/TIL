### progress

- 딱 1줄로 진행률 표시줄을 제공해준다
- 현재 진행상태를 알려주기 좋은 태그

```html
<progress value="50" min="0" max="100"></progress>
```

- meter 태그와 유사하기도 한데, meter 태그는 값에 따라서 bar의 색깔이 변경된다
- 그리고 진행 상태를 보여주는 것이 아니라 값이 어느 정도인지를 표현하기 위해 사용한다
- 예를들어 meter 태그를 사용해서 미세먼지 상태를 나타낼 수 있다

```html
<meter min="0" max="1000" value="350"></meter>
```

### details, summary

- 유저의 클릭으로 정보를 보여주고. 숨기는 패턴

```html
<details id="details">
  <summary>클릭 전 보여질 내용</summary>
  <span>클릭 후 보여질 내용</span>
</details>
```

- 그리고 details 태그에는 open 속성이 있어서 유저의 클릭 여부에 따라서 스탙일을 변경하는데 사용할 수 있다

```css
#details[open] {
  background-color: #cdedfd;
}
```

### input

```html
<input type="date" />

<input type="month" />

<input type="week" />
<!-- 주를 선택할 수 있따 -->

<input type="time" />
<!-- 시간을 선택할 수 있다. -->
```

- 브라우저 환경에 따라 위젯의 형태는 달라짐

### picture

- 각기 다른 버전의 이미지를 표시가능
- 예를들어, PC에서는 그림이 고화질로 웹에서 보여지나, 모바일에서는 빠른 실행
  속도를 위해 저사양으로 보여지도록 설정가능

- 그리고 picture 태그는 img 태그 그리고 source 태그와 함께 사용됨

```html
<picture>
  <!-- 화질이 다른 각기 다른 이미지 -->
  <source srcset="src/01.jpeg" media="(min-width:1200px)" />
  <source srcset="src/02.jpeg" media="(min-width:900px)" />
  <source srcset="src/03.jpeg" media="(min-width:500px)" />

  <img src="src/04.jpeg" />
  <!-- 
   img 태그는 디폴트 값으로 사용되는데
   브라우저가 picture, source 태그 지원하지 않거나 
   또는 명시된 <source> 요소가 모두 조건을 만족하지 못 할 경우 사용됨  -->
</picture>
```

- 만약 모바일처럼 브라우저의 크기가 작다면 화면이 큰 브라우저에 사용되는 이미지를 다운받지 않기 때문에 페이지 로딩 속도를 높혀준다
- 3개 이미지를 받아서 하나를 보여주는 것이 아니라 유저가 보게될 하나의 이미지를 다운받는 것

### datalist

- JS작성 없이 Auto complete(자동완성)을 가능하게함
- datalist를 사용하기 위해서는 input에서 list를 지정하고 그 다음 datalist를 만들고 id를 부여한다
- 아래처럼 코드를 작성하고 나면 input을 클릭하는 순간 option 값들이 auto complete 옵션으로 자동으로 보인다
- 그리고 유저가 타이핑을 하는 순간 입력한 값들을 포함한 값들이 결과 값으로 자동으로 필터가 된다

```html
<label for="movie">What is your favorite movie ? </label>
<input type="text" list="movie-options" />

<datalist id="movie-options">
  <option value="Iron Man"></option>
  <option value="Matrix"></option>
</datalist>
```

---

## Reference

- [개발자 99%가 모르는 신박한 HTML 태그 5개!](https://www.youtube.com/watch?v=EMOlLLTAZMs&list=PLGk6-UFPJT2US9QlHmZtHrk0zbnv4l9OY&index=5)
