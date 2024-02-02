## ARIA (Accessible Rich Internet Applications)

- Accessible Rich Internet Applications (ARIA) is a set of **roles** and **attributes** that define ways to make web content and web applications (especially those developed with JavaScript) more accessible to people with disabilities.

<br/>

## WAI-ARIA Roles

- ARIA roles provide semantic meaning to content, allowing screen readers and other tools to present and support interaction with an object in a way that is consistent with user expectations of that type of object.

- ARIA roles can be used to describe elements that don't natively exist in HTML or exist but don't yet have full browser support.

- By default, many semantic elements in HTML have a role; for example, `<input type="radio">` has the "radio" role. Non-semantic elements in HTML do not have a role; `<div>` and `<span>` without added semantics return null. The role attribute can provide semantics.

  - 즉, input 태그의 경우 type을 radio로 지정해주면 radio 라는 role이라는 role이 추가되지만, div나 span 태그의 경우에는 `type="radio"`를 추가한다고 해서 role이 추가되지 않는다.

- ARIA roles are added to HTML elements using role="role type", where role type is the name of a role in the ARIA specification. Some roles require the inclusion of associated ARIA states or properties; others are only valid in association with other roles.

- For example, `<ul role="tabpanel">` will be announced as a 'tab panel' by screen readers. However, if the tab panel doesn't have nested tabs, the element with the tabpanel role is not in fact a tab panel and accessibility has actually been negatively impacted.

- role에 대한 더 많은 정보는 [MDN - WAI-ARIA Roles](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Roles)에서 확인할 수 있다

<br/>

## ARIA states and properties (attributes)

- ARIA attributes enable modifying an element's states and properties as defined in the accessibility tree.

### aria-label

- The aria-label attribute defines a string value that labels an interactive element.

- The aria-label should be used to provide a text alternative to an element that has no visible text on the screen.

- By default, an HTML element will use its text content as the accessibility label. If an element has aria-label, the accessible name becomes the string that it's passed in the attribute.

  ```html
  <button>send</button>
  <!-- accessible name: send -->

  <button aria-label="send email">send</button>
  <!-- accessible name: send email -->
  ```

  - Reference

    - [ADITUS aria-label](https://www.aditus.io/aria/aria-label/)

### aria-describedby

- The aria-describedby attribute lists the ids of the elements that describe the object. It is used to establish a relationship between widgets or groups and the text that describes them.

- Error messages are a good example. If a user leaves a required form field blank, the HTML for the error might look like this:

  - [When ARIA makes things better](https://css-tricks.com/why-how-and-when-to-use-semantic-html-and-aria/#aa-when-aria-makes-things-better)

  ```html
  <label for="first-name">First name</label>
  <span>Enter your first name</span>
  <input type="text" name="first-name" id="first-name" />
  ```

- A sighted user will be able to see the error above the field. But when a screen reader focuses on the input, the error won’t be announced because the error message isn’t linked to the input.

- ARIA can be used to associate the error with the input like this:

  ```html
  <label for="first-name">First name</label>
  <span id="first-name-error">Enter your first name</span>
  <input
    type="text"
    name="first-name"
    id="first-name"
    aria-describedby="first-name-error"
  />
  ```

- Now the error message is announced when the input is in focus.

<br/>

## Try to avoid using ARIA to fix unsemantic HTML

- ARIA로 시맨틱 태그를 대체하기 위해서는 rol과 많은 attributes에 대한 작업을 해야한다.

- 그렇기 때문에 ARIA로 시맨틱 태그를 대체하기 보다는 시맨틱 태그로 시작을 하는 것이 좋다

- 즉, 시맨틱 태그를 먼저 사용하고 의미를 부가적으로 설명해주고자 할 때 WAI-ARIA의 role 또는 attributes를 추가해준다

  - [Try to avoid using ARIA to fix unsemantic HTML](https://css-tricks.com/why-how-and-when-to-use-semantic-html-and-aria/#aa-when-aria-makes-things-better)

---

## Reference

- [WAI-ARIA란?](https://story.pxd.co.kr/1588)

- [WAI-ARIA: role과 aria-label 사용법](https://velog.io/@a_in/WAI-ARIA-role-aria-label)

- [MDN - ARIA](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA)

- [MDN - WAI-ARIA Roles](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Roles)

- [MDN - ARIA states and properties](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Attributes)

- [Why, How, and When to Use Semantic HTML and ARIA](https://css-tricks.com/why-how-and-when-to-use-semantic-html-and-aria/)
