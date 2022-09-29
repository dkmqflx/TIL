### CSS (Cascading Style Sheet)

- Cascading : Selector에 적용된 여러 스타일 중에서 가장 높은 우선순위를 가지는 스타일을 적용한다

- 웹사이트를 스타일링하는 방법

  - Author style : 우리가 작성하는 css파일, 가장 높은 우선 순위를 가진다
  - User style : 사용자가 스타일링 하는 것, 브라우저에서 스타일을 바꿀 수 있다. 글자 크기, 다크모드 등
  - Browser style: 브라우저에서 기본적으로 기정된 스타일

- Author style 찾고, 없으면 User style 그리고 없으면 Browser style을 찾는 순서대로 한다

- !important: 위의 모든 순서를 무시하고 !important로 지정한 스타일을 가장 높은 우선순위로 두는데 보통 !important 속성은 쓰지 않는 것 좋다

- selectores

  - Universal : `*`
  - type : `Tag`
    - 태그 이름 사용하면 해당 태그에 모두 스타일 적용된다
  - ID : `#id`
  - Class : `.class`
  - State : `:`

    ```css
    button:hover {
      color: red;
    }
    ```

  - Attribute: `[]`

    - 해당하는 속성값들만 선택할 수 있다.

    ```css
    a[href$='.com'] {
      <!-- .com으로 끝나는 것들만 아래 스타일 적용 -->
      color: purple;
    }
    ```

- content : width, height가 차지하는 공간
- padding : Box와 content사이의 거리
- border : 테두리
- margin: 태그와 태그 사이의 거리
  - 30 30 30 30 (top -> right ->bottom -> left)
  - 30 50 (top, bottm -> left, right)
- div : block level
- span : inline level

---

## Reference

- [CSS 셀렉터, 기초 이론 정리. 포트폴리오 만드는 날까지! | 프론트엔드 개발자 입문편: HTML, CSS, Javascript
  ](https://www.youtube.com/watch?v=gGebK7lWnCk)
- [MDN docs - CSS reference](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference)
- [can i use](https://caniuse.com/)
- [https://flukeout.github.io/](https://flukeout.github.io/)
