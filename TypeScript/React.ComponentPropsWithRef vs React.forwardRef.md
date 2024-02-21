## React.ComponentPropsWithRef

- React.ComponentPropsWithRef is a utility type provided by React's TypeScript definitions.

- It is used to pass ref props to child component

```tsx
const Parent = () => {
  const ref = React.useRef<HTMLInputElement>(null);

  return <Child title="1" ref={ref} />;
};

export type Props = {
  title?: string;
} & React.ComponentPropsWithRef<"input">;

const Child = ({ title, ref }: Props) => {
  return <div>12</div>;
};
```

- However, when using ComponentPropsWithRef to pass a ref as props in a function component to refer DOM node, ref is undefined

- Thus, ref of ComponentPropsWithRef can not be used to refer DOM node

```tsx
const Parent = () => {
  const ref = React.useRef<HTMLInputElement>(null);

  console.log("ref", ref); // { current: undefined }

  return <Child title="1" ref={ref} />;
};

export type Props = {
  title?: string;
} & React.ComponentPropsWithRef<"input">;

const Child = ({ title, ref }: Props) => {
  return <input ref={ref} />;
};
```

- In the case of a class component, the ref passed as props is directly pointing to the button tag of the Button component, as shown below.

- However, in the case of a function component, contrary to expectations, the received ref does not point to the button tag of the Button component.

- - The reason for this is the difference in the way refs are passed as props between class components and function components.

- In class components, the ref object has the instance of the mounted component as its current attribute value. However, in function components, since there is no created instance, the

```ts

const WrappedButton = () => {
  const buttonRef = useRef();

  return (
    <div>
      <Button ref={buttonRef}>
    </div>
  )
}

type NativeButtonProps = React.DetaildHTMLProps<React.ButtonHTMLAttributes<HTMLButtonElement>, HTMLButtonElement>

// class component
class Button extends React.Component {
  constructor(ref:NativeButtonProps["ref"]){
    this.buttonRef = ref; // ref can be assigned as initial value
  }

  render(){
    return <button ref={this.buttonRef}>버튼</button>
  }
}

// Using Button Component Based Class
class WrappedButton extends React.Component {
  constructor(){
    this.buttonRef = React.createRef();
  }

  render(){
    return <Button ref={this.buttonRef}/>
  }
}


// Function Component
function Button(ref:NativeButtonProps["ref"]){
  const buttonRef = useRef(null);
  return <button ref={this.buttonRef}>버튼</button>

}

// Using Button Component Based Function
function WrappedButton(){
  const buttonRef = useRef(null); // {current: undefined}

    return <Button ref={this.buttonRef}/>

}

```

- In summary, when using ComponentPropsWithRef, you can receive the ref as props from the outside, but you cannot reference it through the ref from the outside.

- To overcome this limitation and allow receiving refs in function components, React.forwardRef can be used

<br/>

## React.forwardRef

- This issue can be addressed using forwardRef.

- React.forwardRef is a React API that allows you to forward refs through a component to one of its child components.

- This is particularly useful when you need to **access a child component's DOM node** directly for things like focus management, measurements, or triggering imperative animations.

- It is not specific to TypeScript but is widely used in conjunction with TypeScript for typing components that forward refs.

```tsx
const Parent = () => {
  const ref = React.useRef<HTMLInputElement>(null);

  console.log("ref", ref); // { current: input }

  return <Child title="1" ref={ref} />;
};

export type Props = {
  title?: string;
} & React.ComponentPropsWithRef<"input">;

const Child = React.forwardRef<HTMLInputElement, InputProps>(
  ({ title }, ref) => {
    return <input ref={ref} />;
  }
);
```
