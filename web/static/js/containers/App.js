import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'

// import CompanyContainer from './CompanyContainer'

class App extends Component {
  render() {
    return <h1>Printing App container</h1>
  }
}

App.propTypes = {}

function mapStateToProps(state) {
  return {}
}

export default connect(mapStateToProps)(App)
