```js
// App.js

import './App.css';
import { useForm } from 'react-hook-form';
import { useRef } from 'react';

function App() {
  const {
    register,
    handleSubmit,
    watch,
    formState: { errors },
  } = useForm();
  const password = useRef();
  password.current = watch('password');

  // console.log(watch('email')); // 어떠한 값이 입력되는지 알 수 있다.

  const onSubmit = (data) => console.log(data);

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <label>Email</label>
      <input type="email" {...register('email', { required: 'this is require', pattern: /^\S+@\S+$/i })} />
      {errors.email && <p>This email field is required</p>}

      <label>Name</label>
      <input {...register('name', { required: true, maxLength: 10 })} />
      {/* 유효성 검사 두개 하기 때문에 각각의 유효셩 검사 걸렸을 때 다른 메시지 보여주도록 한다 */}
      {errors.name && errors.name.type === 'required' && <p> This name field is required</p>}
      {errors.name && errors.name.type === 'maxLength' && <p> Your input exceed maximum length</p>}

      <label>Password</label>
      <input type="password" {...register('password', { required: true, minLength: 6 })} />

      {errors.password && errors.password.type === 'required' && <p> This password field is required</p>}
      {errors.password && errors.password.type === 'minLength' && <p> Password must have at least 6 characters</p>}

      <label>Password Confirm</label>
      <input
        type="password"
        {...register('password_confirm', { required: true, validate: (value) => value === password.current })}
      />
      {errors.password_confirm && errors.password_confirm.type === 'required' && (
        <p> This password confirm field is required</p>
      )}
      {errors.password_confirm && errors.password_confirm.type === 'validate' && <p>The passwords do not match</p>}

      <input type="submit" style={{ marginTop: '40px' }} />
    </form>
  );
}

export default App;
```
```css
/* App.css */



body {
  background: #0e101c;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans',
    'Droid Sans', 'Helvetica Neue', sans-serif;
}

form {
  max-width: 500px;
  margin: 0 auto;
}

h1 {
  font-weight: 100;
  color: white;
  text-align: center;
  padding-bottom: 10px;
  border-bottom: 1px solid rgb(79, 98, 148);
}

.form {
  background: #0e101c;
  max-width: 400px;
  margin: 0 auto;
}

p {
  color: #bf1650;
}

p::before {
  display: inline;
  content: '⚠ ';
}

input {
  display: block;
  box-sizing: border-box;
  width: 100%;
  border-radius: 4px;
  border: 1px solid white;
  padding: 10px 15px;
  margin-bottom: 10px;
  font-size: 14px;
}

label {
  line-height: 2;
  text-align: left;
  display: block;
  margin-bottom: 13px;
  margin-top: 20px;
  color: white;
  font-size: 14px;
  font-weight: 200;
}

button[type='submit'],
input[type='submit'] {
  background: #ec5990;
  color: white;
  text-transform: uppercase;
  border: none;
  margin-top: 40px;
  padding: 20px;
  font-size: 16px;
  font-weight: 100;
  letter-spacing: 10px;
}

button[type='submit']:hover,
input[type='submit']:hover {
  background: #bf1650;
}

button[type='submit']:active,
input[type='button']:active,
input[type='submit']:active {
  transition: 0.3s all;
  transform: translateY(3px);
  border: 1px solid transparent;
  opacity: 0.8;
}

input:disabled {
  opacity: 0.4;
}

input[type='button']:hover {
  transition: 0.3s all;
}

button[type='submit'],
input[type='button'],
input[type='submit'] {
  -webkit-appearance: none;
}

.App {
  max-width: 600px;
  margin: 0 auto;
}

button[type='button'] {
  display: block;
  appearance: none;
  background: #333;
  color: white;
  border: none;
  text-transform: uppercase;
  padding: 10px 20px;
  border-radius: 4px;
}

hr {
  margin-top: 30px;
}

button {
  display: block;
  appearance: none;
  margin-top: 40px;
  border: 1px solid #333;
  margin-bottom: 20px;
  text-transform: uppercase;
  padding: 10px 20px;
  border-radius: 4px;
}


```

---

## Reference
- [React Hook Form 을 이용한 유효성 체크](https://www.youtube.com/watch?v=tWOn7g_3wKU&t=28)
- [React Hook Form](https://react-hook-form.com/get-started)