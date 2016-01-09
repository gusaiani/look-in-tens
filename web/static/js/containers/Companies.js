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

const AutoSuggestId = 'companies'

class Companies extends Component {
  renderItem(item) {
    return (
      <span>{item.text}</span>
    )
  }

  render() {
    const { value, focusedItemIndex, onBlur, onChange, onKeyDown, onMouseEnter, onMouseLeave, onMouseDown, items } = this.props
    const inputProps = { value, onChange, onKeyDown, onBlur }
    const itemProps = { onMouseEnter, onMouseLeave, onMouseDown };

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
      </div>
    )
  }
}

function mapStateToProps(state) {
  const {companies, autowhatever} = state
  const {value, focusedItemIndex} = autowhatever[AutoSuggestId]

  return {
    items: buildAutoSuggestItems(companies),
    value,
    focusedItemIndex
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
