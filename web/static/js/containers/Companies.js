import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import AutoSuggest from 'react-autowhatever'
import values from 'lodash/object/values'

import { searchCompany, updateInputValue, updateFocusedItem } from '../actions/companies'

const AutoSuggestId = '0'

class Companies extends Component {
  renderItem(item) {
    return (
      <span>{item.text}</span>
    )
  }

  render() {
    const { value, focusedSectionIndex, focusedItemIndex, onChange, onKeyDown, items } = this.props
    const inputProps = { value, onChange, onKeyDown }

    return (
      <div>
        <h1>Companies</h1>
        <AutoSuggest
          id={AutoSuggestId}
          items={buildAutoSuggestItems(items)}
          renderItem={this.renderItem}
          inputProps={inputProps}
          focusedSectionIndex={focusedSectionIndex}
          focusedItemIndex={focusedItemIndex} />
      </div>
    )
  }
}

function buildAutoSuggestItems(items) {
  return values(items).map(item => {
    return {text: `${item.ticker} · ${item.name}`}
  })
}

function mapStateToProps(state) {
  const {companies, autowhatever} = state
  const {items} = companies

  console.log(autowhatever)

  return {
    items,
    value: autowhatever[AutoSuggestId].value,
    focusedSectionIndex: autowhatever[AutoSuggestId].focusedSectionIndex,
    focusedItemIndex: autowhatever[AutoSuggestId].focusedItemIndex
  }
}

function mapDispatchToProps(dispatch) {
  return {
    onChange: (event) => {
      dispatch(updateInputValue(AutoSuggestId, event.target.value))
      dispatch(searchCompany(event.target.value))
    },

    onKeyDown: (event, { newFocusedSectionIndex, newFocusedItemIndex }) => {
      if (typeof newFocusedItemIndex !== 'undefined') {
        event.preventDefault()
        dispatch(updateFocusedItem(AutoSuggestId, newFocusedSectionIndex, newFocusedItemIndex))
      }
    }
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Companies)
