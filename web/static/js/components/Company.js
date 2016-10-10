import React, {Component, PropTypes} from 'react'

function getPEColor(pe) {
  if (pe > 20) return 'red'
  if (pe <= 10) return 'green'
  return 'blue'
}

class Company extends Component {
  render() {
    const {company} = this.props
    const {name, ticker, pe, updatedAt} = company

    return (
      <div className="company">
        <div>
          <h1>{name}</h1>
          <h4>{ticker}</h4>
        </div>
        <span>PE10</span>
        <h2 className={getPEColor(pe)}>{pe}</h2>
        <span>Last updated {updatedAt}</span>
      </div>
    )
  }
}

export default Company
