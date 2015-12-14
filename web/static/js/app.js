import React, {Component, PropTypes} from 'react'
import {render} from 'react-dom';

class HelloWorld extends Component {
  render() {
    return <h1>Habemus React.js</h1>
  }
}

render(<HelloWorld />, document.getElementById('app'))
