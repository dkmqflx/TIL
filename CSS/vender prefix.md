## Vender Prefix

- 벤더 프리픽스(vendor prefix)란 크롬, 파이어폭스, 사파리 등과 같이 주요 웹 브라우저 공급자가 새로운 실험적인 기능을 제공할 때 이전 버전의 웹 브라우저에 그 사실을 알려주기 위해 사용하는 접두사(prefix)를 의미한다.

- 즉 아직 CSS 권고안에 포함되지 못한 기능이나, CSS 권고안에는 포함되어 있지만 아직 완벽하게 제정된 상태가 아닌 기능을 사용하고자 할 때 벤더 프리픽스를 사용하게 된다.

- 그렇게 하면 해당 기능이 포함되어 있지 않은 이전 버전의 웹 브라우저에서도 그 기능을 사용할 수 있게 된다.

- 이러한 벤더 프리픽스는 실험적인 해당 기능들이 CSS 표준 권고안에 포함되거나, 완벽하게 제정된 상태가 되면 더는 사용할 필요가 없어진다.

- 그러나 구형 브라우저를 지원하기 위하여 벤더 프리픽스를 사용하여야 할 필요가 있다.

### [CSS prefixes - MDN](https://developer.mozilla.org/en-US/docs/Glossary/Vendor_Prefix#css_prefixes)

- The most common browser CSS prefixes you will see in older code bases include:

- `webkit-` (Chrome, Safari, newer versions of Opera and Edge, almost all iOS browsers including Firefox for iOS; basically, any WebKit or Chromium-based browser)

- `moz-` (Firefox)

- `o-` (old pre-WebKit versions of Opera)

- `ms-` (Internet Explorer and Microsoft Edge, before Chromium)

### Sample Usage

```css
-webkit-transition: all 4s ease;

-moz-transition: all 4s ease;

-ms-transition: all 4s ease;

-o-transition: all 4s ease;

transition: all 4s ease;
```

- vender prefix를 사용해야 하는지는 [Can I Use](https://caniuse.com/)에서 검색 후 브라우저 버전 별로 hover를 해서 확인할 수 있다

---

## Reference

- [MDN - Vendor Prefix](https://developer.mozilla.org/en-US/docs/Glossary/Vendor_Prefix)
- [2.11 CSS3 Vendor Prefix - 벤더 프리픽스](https://poiemaweb.com/css3-vendor-prefix)
- [TCP SCHOOK - 벤더 프리픽스(Vendor Prefix)](https://www.tcpschool.com/css/css3_module_vendorPrefix)
