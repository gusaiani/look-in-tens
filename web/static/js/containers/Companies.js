import React, { Component, PropTypes } from 'react'
import { ReduxRouter } from 'redux-router'
import { connect } from 'react-redux'

class Root extends Component {
  render() {
    return <h1>We’ve got companies’ view</h1>
  }
}

function mapStateToProps(state) {
  return {}
}

Root.propTypes = {
  dispatch: PropTypes.func.isRequired
};

export default connect(mapStateToProps)(Root)
