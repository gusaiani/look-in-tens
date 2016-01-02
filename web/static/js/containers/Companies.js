import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'

class Companies extends Component {
  render() {
    return <h1>We’ve got companies’ view</h1>
  }
}

function mapStateToProps(state) {
  return {}
}

export default connect(mapStateToProps)(Companies)
