import React from 'react';
import ReactDOM from 'react-dom';

import Card from './components/Card.js';


ReactDOM.render(
  <div id="container">
    <h1>Hello, world!</h1>
    <Card/>
    <Card/>
    <Card/>
  </div>,
  document.getElementById('main')
);
