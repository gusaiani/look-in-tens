import React, {Component, PropTypes} from 'react'
import Header from '../components/Header.js'

class Main extends Component {
  render() {
    return (
      <div className="main">
        <Header/>
        <div className="content">
          {this.props.children}
        </div>
      </div>
    )
  }
}

export default Main
