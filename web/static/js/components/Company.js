import React, {Component, PropTypes} from 'react'

class Company extends Component {
  render() {
    const {company} = this.props
    const {name, ticker, pe} = company

    return (
      <div>
        <h1>{name}</h1>
        <h4>{ticker}</h4>
        <h2>{pe}</h2>
      </div>
    )
  }
}

export default Company
