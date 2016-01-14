import React, {Component, PropTypes} from 'react'
import {Link, Router} from 'react-router'

class Header extends Component {
  render() {
    return (
      <div className="header">
        <span className="logo">
          <Link to="/">Look in Tens</Link>
        </span>
        <nav>
          <Link to="/about">About</Link>
        </nav>
      </div>
    )
  }
}

export default Header
