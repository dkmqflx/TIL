## useStateWithValidation

- validation을 위한 hook

```js
import { useState, useCallback } from 'react';

export default function useStateWithValidation(validationFunc, initialValue) {
  const [state, setState] = useState(initialValue);
  const [isValid, setIsValid] = useState(() => validationFunc(state)); // true or false

  const onChange = useCallback(
    (nextState) => {
      const value =
        typeof nextState === 'function' ? nextState(state) : nextState; //  사용자가 입력한 값
      setState(value); // 입력한 값이 state가 된다
      setIsValid(validationFunc(value)); // 입 state
    },
    [validationFunc]
  );

  return [state, onChange, isValid];
}
```

### Usage

```js
import useStateWithValidation from './useStateWithValidation';

export default function StateWithValidationComponent() {
  const [username, setUsername, isValid] = useStateWithValidation(
    (name) => name.length > 5,
    ''
  );

  return (
    <>
      <div>Valid: {isValid.toString()}</div>
      <input
        type='text'
        value={username}
        onChange={(e) => setUsername(e.target.value)}
      />
    </>
  );
}
```
