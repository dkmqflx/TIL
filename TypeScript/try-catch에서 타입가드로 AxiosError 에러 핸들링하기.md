## Try - Catch 에서 Axios 에러핸들링하기

try-catch에서 에러 핸들링을 하려고 할 때 error 객체의 타입은 unknown이다.

따라서 axios를 사용해서 비동기 처리를 하는 경우, catch 문에서 axios의 에러 객체인 AxiosError를 사용해서 에러 핸들링을 하면 에러가 발생한다

```tsx
export class AxiosError<T = unknown, D = any> extends Error {
  constructor(
    message?: string,
    code?: string,
    config?: AxiosRequestConfig<D>,
    request?: any,
    response?: AxiosResponse<T, D>
  );

  config: AxiosRequestConfig<D>;
  code?: string;
  request?: any;
  response?: AxiosResponse<T, D>;
  isAxiosError: boolean;
  status?: string;
  toJSON: () => object;

	...
}
```

즉, 아래와 같이 catch 에 전달되는 error 객체에서 AxiosError 객체에 있는 response에 접근하려고 하면 에러가 발생한다

```tsx
const initData = async () => {
      try {
        const { data } = await getData();

				setData(data);
      } catch (error) {
				// 에러 발생 - 'error' is of type 'unknown'
				handleError(error.response);

        }
      }
    };
```

이러한 문제를 타입 가드를 통해 해결할 수 있다

아래처럼 instanceof를 사용거나,

```tsx
const initData = async () => {
  try {
    const { data } = await getData();

    setData(data);
  } catch (error) {
    if (error instanceof AxiosError) {
      handleError(error); // error: AxiosError<any, any>
    }
  }
};
```

또는 isAxiosError 함수를 사용할 수 도 있다.

```tsx
const initData = async () => {
  try {
    const { data } = await getData();

    setData(data);
  } catch (error) {
    if (axios.isAxiosError(error)) {
      handleError(error); // error: AxiosError<unknown, any>
    }
  }
};
```

## AxiosError 객체의 response data 타입 추론하기

axios error 객체를 처리할 때 reponse를 가져와서 처리해야할 때가 있다.

AxiosError 타입 정보를 보면 아래와 같이 response라는 필드가 있고, 이 필드의 타입이 AxiosReponse인 것을 확인할 수 있다.

```tsx
export class AxiosError<T = unknown, D = any> extends Error {
  constructor(
      message?: string,
      code?: string,
      config?: InternalAxiosRequestConfig<D>,
      request?: any,
      response?: AxiosResponse<T, D>
  );

  config?: InternalAxiosRequestConfig<D>;
  code?: string;
  request?: any;
  response?: AxiosResponse<T, D>;
  isAxiosError: boolean;
  status?: number;
  toJSON: () => object;
  cause?: Error;

	...

}

export interface AxiosResponse<T = any, D = any> {
  data: T;
  status: number;
  statusText: string;
  headers: RawAxiosResponseHeaders | AxiosResponseHeaders;
  config: InternalAxiosRequestConfig<D>;
  request?: any;
}
```

이러한 특징을 이용해서 아래와 같은 코드를 실행해서 message 필드를 출력하려고 하면, response의 data 필드의 타입이 any으로 추론되는 것을 확인할 수 있는데, 원래 타입인 {message: string} 으로 제대로 추론되지 않는 것을 확인할 수 있다.

```tsx
const handleAxios = () => {
  try {
    throw new AxiosError(
      "message error",
      "",
      {},
      {},
      {
        data: {
          message: "this is error",
        },
      }
    );
  } catch (error) {
    if (isAxiosError(error)) {
      console.log("axios error", error.response?.data.message);
      // (property) AxiosResponse<any, any>.data: any
    }
  }
};
```

이처럼 추론이 되지 않는 이유는 아래 isAxiosError `payload is AxiosError` 부분에서 따로 제네릭을 넣어줄 수 없기 때문에 타입이 제대로 추론이 되지 않는 것이다

```tsx
isAxiosError(payload: any): payload is AxiosError;
```

이러한 문제를 해결하기 위해서 이전에는 아래처럼 AxiosResponse에 제네릭으로 타입을 넣어주고 형 변환을 해주는 방식으로 처리했다.

```tsx
const handleAxios = () => {
  try {
    throw new AxiosError(
      "message error",
      "",
      {},
      {},
      {
        data: {
          message: "this is error",
        },
      }
    );
  } catch (error) {
    if (isAxiosError(error)) {
      const { message } = (error.response as AxiosResponse<{ message: string }>)
        .data;
      /*
					 (property) AxiosResponse<{ message: string; }, any>.data: {
					    message: string;
						}
				*/
    }
  }
};
```

하지만 버전 바뀌면서 axios.isAxiosError도 제네릭을 지원하기 때문에 제네릭에 타입을 넣어주는 방식으로 타입 추론 문제를 해결할 수 있다

```tsx
export function isAxiosError<T = any, D = any>(
  payload: any
): payload is AxiosError<T, D>;
```

따라서 아래처럼 as를 사용해서 제네릭을 사용해준다

```tsx
const message = (error.response as AxiosResponse<{ message: string }>).data
  .message;
console.log(message);
```

즉, 아래처럼 isAxiosError 함수에 제네릭에 타입을 명시해줌으로써 타입이 제대로 추론되는 것을 확인할 수 있다.

```
const handleAxios = () => {
    try {
      throw new AxiosError(
        'message error',
        '',
        {},
        {},
        {
          data: {
            message: 'this is error',
          },
        },
      );
    } catch (error) {

      if (isAxiosError<{ message: string }>(error)) {
        console.log('axios error', error.response?.data.message);
				/*
					 (property) AxiosResponse<{ message: string; }, any>.data: {
				     message: string;
						}
				*/
      }


    }
  };
```

---

## Reference

- [Expand isAxiosError types](https://github.com/axios/axios/pull/4344)
