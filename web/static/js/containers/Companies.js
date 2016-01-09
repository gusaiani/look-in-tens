import React, {Component, PropTypes} from 'react'
import {connect} from 'react-redux'
import AutoSuggest from 'react-autowhatever'

import {buildAutoSuggestItems} from '../utils/companies'
import {searchCompanies, resetSearchCompanies} from '../actions/companies'
import {
  onChange,
  onKeyDown,
  onMouseEnter,
  onMouseLeave,
  onMouseDown,
  onBlur
} from '../actions/autowhatever'

import Company from '../components/company'

const AutoSuggestId = 'companies'

class Companies extends Component {
  renderItem(item) {
    return (
      <span>{item.text}</span>
    )
  }

  render() {
    const { selectedCompany, value, focusedItemIndex, onBlur, onChange,
            onKeyDown, onMouseEnter, onMouseLeave, onMouseDown, items } = this.props
    const inputProps = { value, onChange, onKeyDown, onBlur }
    const itemProps = { onMouseEnter, onMouseLeave, onMouseDown }

    return (
      <div>
        <h1>Companies</h1>
        <AutoSuggest
          id={AutoSuggestId}
          items={items}
          renderItem={this.renderItem}
          inputProps={inputProps}
          itemProps={itemProps}
          focusedItemIndex={focusedItemIndex} />
        { selectedCompany && <Company company={selectedCompany}/>}
      </div>
    )
  }
}

function mapStateToProps(state) {
  const {companies, autowhatever} = state
  const selectedCompany = companies.selected
  const {value, focusedItemIndex} = autowhatever[AutoSuggestId]
  const items = buildAutoSuggestItems(companies)

  return {
    items,
    value,
    focusedItemIndex,
    selectedCompany
  }
}

export default connect(mapStateToProps, {
  onChange,
  onKeyDown,
  onMouseEnter,
  onMouseLeave,
  onMouseDown,
  onBlur,
})(Companies)
