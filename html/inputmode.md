## inputmode

- The inputmode global attribute is an enumerated attribute that hints at the type of data that might be entered by the user while editing the element or its contents.

- This allows a browser to **display an appropriate virtual keyboard.**

- It is used primarily on `<input>` elements, but is usable on any element in contenteditable mode.

<br/>

- The method to input numbers through a keypad is as follows:

### numeric

- Numeric input keyboard, but only requires the digits 0–9. Devices may or may not show a minus key.

```js
<input type="number" inputmode="numeric" />
```

- In the case of Android (aos), simply specifying `<input type="number"/>` will display the numeric keyboard.

- However, for iOS, if inputmode is not specified, the numeric keyboard will not appear.

<br/>

### decimal

- Fractional numeric input keyboard containing the digits and decimal separator for the user's locale (typically `.` or `,`).

- Devices may or may not show a minus key (`-`).

```js
<input type="number" inputmode="decimal" />
```

- When specified as numeric, the iOS keyboard does not allow input of decimal points or negative numbers.

- Therefore, to input decimal points or negative numbers, you need to specify the inputmode as decimal.

---

## Reference

- [inputmode](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/inputmode)
