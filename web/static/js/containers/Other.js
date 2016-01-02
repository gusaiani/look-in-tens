import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'

class Other extends Component {
  render() {
    return <h1>Other container</h1>
  }
}

function mapStateToProps(state) {
  return {}
}

export default connect(mapStateToProps)(Other)
