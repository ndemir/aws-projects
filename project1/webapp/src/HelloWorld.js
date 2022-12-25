import React from 'react';

const HelloWorld = () => {
  
  function helloworld() {
    alert('Hello World!');
  }
  
  return (
    <button onClick={helloworld}>Click me!</button>
  );
};

export default HelloWorld;