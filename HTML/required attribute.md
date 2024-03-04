## HTML attribute: required

- The Boolean required attribute, if present, indicates that the user must specify a value for the input before the owning form can be submitted.

- The required attribute is supported by text, search, url, tel, email, password, date, month, week, time, datetime-local, number, checkbox, radio, file, `<input>` types along with the `<select>` and `<textarea>` form control elements.

- When including the required attribute, provide a visible indication near the control informing the user that the `<input>,` `<select>` or `<textarea>` is required.

- In addition, target required form controls with the :required pseudo-class, styling them in a way to indicate they are required. This improves usability for sighted users.

### Example

```html
<form>
  <div class="group">
    <input type="text" />
    <label>Normal</label>
  </div>

  <div class="group">
    <input type="text" required />
    <!-- A value is required or must be checked for the form to be submittable -->
    <label>Required</label>
  </div>

  <input type="submit" />
</form>
```

---

## Reference

- [HTML attribute: required](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/required)
