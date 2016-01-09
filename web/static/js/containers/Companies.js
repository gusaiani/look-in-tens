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
    const { value, focusedSectionIndex, focusedItemIndex, onBlur, onChange, onKeyDown, onMouseEnter, onMouseLeave, onMouseDown, items } = this.props
    const inputProps = { value, onChange, onKeyDown, onBlur }
    const itemProps = { onMouseEnter, onMouseLeave, onMouseDown };

    return (
      <div>
        <h1>Companies</h1>
        <AutoSuggest
          id={AutoSuggestId}
          items={buildAutoSuggestItems(items)}
          renderItem={this.renderItem}
          inputProps={inputProps}
          itemProps={itemProps}
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

    onKeyDown: (event, { focusedSectionIndex, focusedItemIndex, newFocusedSectionIndex, newFocusedItemIndex }) => {
      switch (event.key) {
        case 'ArrowDown':
        case 'ArrowUp':
          event.preventDefault();
          dispatch(updateFocusedItem(AutoSuggestId, newFocusedSectionIndex, newFocusedItemIndex));
          break

        case 'Enter':
          console.log('Em Enter')
          // dispatch(updateInputValue(AutoSuggestId, items[focusedSectionIndex].items[focusedItemIndex].text + ' selected'));
          break
      }
    },

    onMouseEnter: (event, { sectionIndex, itemIndex }) => {
      console.log('Em onMouseEnter')
      // dispatch(updateFocusedItem(exampleId, sectionIndex, itemIndex));
    },

    onMouseLeave: () => {
      console.log('Em onMouseLeave')
      // dispatch(updateFocusedItem(exampleId, null, null));
    },

    onMouseDown: (event, { itemIndex }) => {
      console.log('Em onMouseDown')
      // dispatch(updateInputValue(exampleId, items[itemIndex].text + ' clicked'));
    },

    onBlur: () => {
      console.log('Em onBlur')
    }
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Companies)
