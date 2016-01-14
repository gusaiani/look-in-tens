import React  from 'react'
import Header from '../components/Header.js'

export default React.createClass({
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
})
