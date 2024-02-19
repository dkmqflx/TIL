## abbr

- The `<abbr>` HTML element represents an abbreviation or acronym.

- When including an abbreviation or acronym, provide a full expansion of the term in plain text on first use, along with the `<abbr>`to mark up the abbreviation. This informs the user what the abbreviation or acronym means.

- The optional [title](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes#title) attribute can provide an expansion for the abbreviation or acronym when a full expansion is not present. This provides a hint to user agents on how to announce/display the content while informing all users what the abbreviation means. If present, title must contain this full description and nothing else.

### Usage

```html
<p>
  You can use <abbr>CSS</abbr> (Cascading Style Sheets) to style your
  <abbr>HTML</abbr> (HyperText Markup Language). Using style sheets, you can
  keep your <abbr>CSS</abbr> presentation layer and <abbr>HTML</abbr> content
  layer separate. This is called "separation of concerns."
</p>

<p>Using <abbr>CSS</abbr>, you can style your abbreviations!</p>
```

```css
abbr {
  font-variant: all-small-caps;
}
```

### title

- The title attribute specifies extra information about an element.

- The information is most often shown as a tooltip text when the mouse moves over the element.

- The title attribute can be used on any HTML element (it will validate on any HTML element. However, it is not necessarily useful).

```html
<p><abbr title="World Health Organization">WHO</abbr> was founded in 1948.</p>
```

---

## Reference

- [MDN - <abbr>: The Abbreviation element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/abbr)
