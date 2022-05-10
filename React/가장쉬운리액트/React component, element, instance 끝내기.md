- Elements Describe the Trees - 여기서 Tree는 DOM tree, Elements는 DOM tree를 묘사한다.
    - Elements -  두가지가 있다.
        - React DOM elements
        - React Components elemtns
    - Components Encapsulate Elements Tree
    - Components can be Classess of Functions
    - Top-Down Reconciliation
    
    ### ****기존 UI model(OOP)****
    
    ```jsx
    class Form extends TraditionalObjectOrientedView {
      render() {
        // Read some data passed to the view
        const { isSubmitted, buttonText } = this.attrs;
        if (!isSubmitted && !this.button) {
    
          // Form is not yet submitted. Create the button!
    	  // new Buton으로 클래스를 호출해서 새로운 인스턴스를 만든다 
          this.button = new Button({
            children: buttonText,
            color: 'blue'
          });
    			
    	  // 새롭게 만든 인스턴스를 appendChild를 호출해서 DOM에 마운트 시켜준다.
          this.el.appendChild(this.button.el);
        }
    
        if (this.button) {
          // The button is visible. Update its text!
          this.button.attrs.children = buttonText;
          this.button.render(); // 생성한 인스턴스를 렌더
        }
    
        if (isSubmitted && this.button) {
          // Form was submitted. Destroy the button!
          this.el.removeChild(this.button.el);
          this.button.destroy(); // 생성한 인스턴스를 삭제
        }
        if (isSubmitted && !this.message) {
          // Form was submitted. Show the success message!
          this.message = new Message({ text: 'Success!' });
          this.el.appendChild(this.message.el);
        }
      }
    }
    ```
    
    - Form 클래스 안에서 우리가 생성한 인스턴스를, 삭제, 렌더와 같은 작업을 하고 있다
    - 이러한 상황에서 생길 수 있는 문제점은 각 컴포넌트가 점점 더 많아지면 컴포넌트에 속한 `button`과 같은 인스턴스도 많아지게 되고
    - 각 인스턴스를 제때 `appendChild`, `removeChild` 을 해주는 코드를 일일이 써주어야 한다는 것이다.
    - 그러면 관리할 코드가 굉장히 늘어나게 된다
    - 그리고 또 다른 문제는 `Form` 이라는 부모 컴포넌트가 직접 자식 컴포넌트인  `button` 컴포넌트에 접근하고 있는데
    - 이처럼 자식 component 에게 부모 component 가 직접 접근하면 `decoupling` 하기 어렵다는 문제가 있다.
    - 리액트에서는 이러한 문제를 해결하기 위해 `element` 라는 개념을 사용했다.
    
    ---
    
    ### Elements
    
    - DOM 트리를 그리기 위해서 필요한 정보들을 describe 해준다.
    - is plain object describing component instance, DOM node and its desired properties
    - is not instance, just tell React what you want to see on the screen
    - is immutable description object with two fields(type: string | ReactClass, props: object)
        - element가 생성되면 두가지 필드를 가진다
        - type에는 언제 string이 할당될지, 또 언제  ReactClass 할당될지는 element의 종류에 따라 달라진다
    
    ### 1. **React DOM elements 인 경우**
    
    ```jsx
    {
      type: 'button', // html 태그의 이름, 즉 DOM element일 때 string이 할당된다.
      props: {
        className: 'button button-blue',
        children: {
          type: 'b',
          props: {
            children: 'OK!'
          }
        }
      }
    }
    
    <button class='button button-blue'>
      <b>
        OK!
      </b>
    </button>
    ```
    
    - type: string(tag name)
    - props: tag’s attributes
    - just objects, so lighter than DOM elements(not objects)
    - don’t need to be parsed, easy to traverse
    
    ---
    
    ### 2. **React Component elements**
    
    ```jsx
    {
      type: Button, // 컴포넌트인 경우, 즉 Button이라는 Class 컴포넌트인 경우 다음과 같이 type에 ReactClass가 할당된다 
      props: {
        color: 'blue',
        children: 'OK!' // 다른 element를 children으로 가질 수 있기 때문에 Tree구조가 되는 것 
      }
    }
    ```
    
    - type: Function Or Class(React component)
    - props: React component props
    
    - 이런식으로 DOM elements든 Component elements든 DOM Tree에게 전달할 정보를 담고 있는 객체이다.
    - 리액트에서 element를 도입함으로 인해서 우리가 직접 구현한 컴포넌트와 실제 DOM에 있는 DOM 엘리먼트가 같은 위계에서 관리될 수 있다
    
    > An element describing a component is also an element, just like an element describing the DOM node. They can be nested and mixed with each other. (element 에 의해 기존의 DOM node 와 React component 를 mixed, nested 한 구조가 가능해짐)
    > 
    
    → 그 결과, component 끼리 decoupled 가 됨(컴포넌트끼리 is-a, has-a 관계로 표현 가능해짐)
    
    - 아래를 보면 DeleteAccount라는 컴포넌트가 리턴한 엘리먼트를 보면 버튼에 대한 정보가 `type: Button` 이라는 정보 밖에 없다.
    - 버튼이 언제 업데이트 되어야 하는지, 렌더링 되어야 하는지, destroy 되어야 하는지에 대한 정보가 전혀 없다.
    - 이러한 것들은 엘리먼트를 보면서 리액트가 알아서 하는 것이다.
    - 우리가 작성한 컴포넌트는 DOM Tree에 전달할 정보만 관리하는 것
    - 컴포넌트로 인해서 Element tree가 encapsulation된 것이고 그러면 리액트는 그러한 앨리먼트를 보면서 DOM Tree에 어떠한 정보를 전달할지 알고 있기 때문에 적절한 때에 create, update, destroy 관련된 로직을 실행하는 것
    
    ```jsx
    // elements tree안에는 DOM Tree에 전달할 정보만 encapsulated 되어 있다.
    const DeleteAccount = () => ({
      type: 'div',
      props: {
        children: [{
          type: 'p',
          props: {
            children: 'Are you sure?'
          }
        }, {
          type: DangerButton, // 우리가 선언한 태그가 html tag처럼 동일한 위게에서 관리되고 있다.
          props: {
            children: 'Yep'
          }
        }, {
          type: Button,
          props: {
            color: 'blue',
            children: 'Cancel'
          }
       }]
    });
    
    // element를 return , JSX 문법
    const DeleteAccount = () => (
      <div>
        <p>Are you sure?</p>
        <DangerButton>Yep</DangerButton> 
        <Button color='blue'>Cancel</Button>
      </div>
    );
    ```
    
    - The returned element tree can contain both elements describing DOM nodes, and elements describing other components. This lets you compose independent parts of UI without relying on their internal DOM structure.
    - React element 를 활용하여, 기존에 DOM structure 을 모두 활용하지 않고(removeChilde 같은), 필요한 정보만 독립적으로 UI 를 관리할 수 있도록 리액트가 가능하게 했다.
    - element는 결국 DOM Tree에 전달할 정보를 가지고 있는 자바스크립트 객체이다.
    - 그 객체가  element tree 를 이루게 되는데 리액트가 이  element tree를 보면서 이 element 들이 DOM Tree에 언제 렌더되어야 하는지 언제 destroy(removeChild) 되어야 하는지 알고 알아서 수행한다
    
    ---
    
    ### ****Top-Down Reconciliation****
    
    - 아래와 같은 과정을 Top-Down Reconciliation 이라고 한다.
    
    ```jsx
    ReactDOM.render({
      type: Form,
      props: {
        isSubmitted: false,
        buttonText: 'OK!'
      }
    }, document.getElementById('root'));
    ```
    
    ```jsx
    // React: You told me this...
    {
      type: Form,
      props: {
        isSubmitted: false,
        buttonText: 'OK!'
      }
    }
    // React: ...And Form told me this...
    {
      type: Button,
      props: {
        children: 'OK!',
        color: 'blue'
      }
    }
    // React: ...and Button told me this! I guess I'm done.
    {
      type: 'button',
      props: {
        className: 'button button-blue',
        children: {
          type: 'b',
          props: {
            children: 'OK!'
          }
        }
      }
    }
    ```
    
    - ReactDom.render() 또는 setState() 를 호출하면 리액트는 reconcilation을 call 한다.
    - reconcilation이 끝나면 리액트는 DOM tree의 결과물을 알게된다. (React knows resulting DOM tree renderer(e.g. react-dom))
    - 즉, element tree를 알게된다.
    - 그러면 element tree를 렌더러에게 전달하면 렌더러는 element tree에 있는 정보들을 실제 DOM 업데이트에 적용한다
    - 즉, 필수적인 최소한의 변화를 DOM node 업데이트에 적용
    - 이러한 과정이 Reconciliation 이다.
    - 위와 같은 점진적 변화 덕분에 쉽게 최적화(optimization)가 가능한 것
    - 또한 props 가 immutable 이면 change 계산이 더 빨라진다. 변하지 않기 때문에
    - React 가 class component 의 Instance 를 만들어주는데 직접 호출(생성)하지는 않는다. (직접 호출한다는 것은, 가장 위의 기존 UI model(OOP)의 new Button 예시처럼)
    - 리액트에서 알아서 인스턴스를 만들어준다.
    - Parent component instance 가 child component instance 에 직접 접근 하려면 ref 를 활용하는 방법이 있지만, 위 맥락에서 렌더링 최적화를 방해하기에 필수적인 상황(form item 에 focus 를 찾아야 한다거나 등) 제외하고 안하는게 좋음
    - Instances 는 React 가 관리하므로, class component 구현시 OOP 스럽게 짜면 되는 정도(따로 instance 에 대해 신경 쓸 필요 X)
    
    ---
    
    ### **Summary**
    
    - element 는 DOM Tree 생성에 필요한 정보를 담은 object 다.
        - React DOM node element, React Component element 두 종류.
        - 돔 엘리먼트로 다 리턴할 때 까지 리액트가 컴포넌트에게 물어본다
        - 그래서 돔 엘리먼트를 구성하는 엘리먼트 트리가 만들어지면 그 트리를 가지고 실제 돔 트리에 적용을 하는 것
        - 그래서 돔 노드 트리를 완성하면 브라우저라 렌더링 되는 순서로 진행된다.
    - element 는 property 로 다른 element 를 가질 수 있다 → DOM node 와 React component 를 mixed, nested 가능하게 함
    - component 는 props → element 하는 function
        - 컴포넌트는 엘리먼트를 리턴해준다
        - 엘리먼트 트리를 encapsulation 해준다.
    - parent component 가 return 한 element 의 type 이 child component 이름일 때, props 는 해당 child component 의 input(props) 가 된다 → props 는 1 way flow
    - instance 는 class component 에서의 this
        - 인스턴스는 클래스 컴포넌트가 호출이 되면 만들어지는 것
        - this를 인스턴스라고 생각하면 된다.
    - instance 를 직접 생성할 필요 X → React 가 해줌
    - React.createElement(), JSX, React.createFactory() → return element
    
    ---
    
    ### Reference
    
    - **[React component, element, instance 끝내기](https://www.youtube.com/watch?v=QSJUTS9PScY&list=PLpq56DBY9U2CDnpw1EZoFMq1tFg2LWYLQ&index=17)**
    - ****[React Components, Elements, and Instances 번역글](https://hkc7180.medium.com/react-components-elements-and-instances-%EB%B2%88%EC%97%AD%EA%B8%80-b5744930846b)****
