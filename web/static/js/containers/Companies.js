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

import Company from '../components/Company'

const AutoSuggestId = 'companies'

class Companies extends Component {
  renderItem(item) {
    return (
      <span><b>{item.ticker}</b> · {item.name}</span>
    )
  }

  render() {
    const placeholder = 'Name or ticker to get PE10'

    const { selectedCompany, value, focusedItemIndex, onBlur, onChange,
            onKeyDown, onMouseEnter, onMouseLeave, onMouseDown, items } = this.props
    const inputProps = { value, onChange, onKeyDown, onBlur, placeholder }
    const itemProps = { onMouseEnter, onMouseLeave, onMouseDown }

    return (
      <div>
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
