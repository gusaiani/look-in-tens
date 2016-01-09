import React, {Component, PropTypes} from 'react'
import {connect} from 'react-redux'
import AutoSuggest from 'react-autowhatever'
import values from 'lodash/object/values'

import {searchCompanies, resetSearchCompanies} from '../actions/companies'
import {updateInputValue, updateFocusedItem} from '../actions/autowhatever'

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

function buildAutoSuggestItems(items) {
  return values(items).map(item => {
    return {
      id: item.id,
      text: `${item.ticker} · ${item.name}`
    }
  })
}

function mapStateToProps(state) {
  const {companies, autowhatever} = state
  const {items} = companies
  const {value, focusedItemIndex} = autowhatever[AutoSuggestId]

  return {
    items: buildAutoSuggestItems(items),
    value,
    focusedItemIndex
  }
}

function mapDispatchToProps(dispatch) {
  return {
    onChange: (event) => {
      dispatch(updateInputValue(AutoSuggestId, event.target.value))
      dispatch(searchCompanies(event.target.value))
    },

    onKeyDown: (event, { focusedItemIndex, newFocusedItemIndex }) => {
      switch (event.key) {
        case 'ArrowDown':
        case 'ArrowUp':
          event.preventDefault();
          dispatch(updateFocusedItem(AutoSuggestId, newFocusedItemIndex));
          break;

        case 'Enter':
          console.log('Em Enter')
          dispatch(updateInputValue(AutoSuggestId, items[focusedItemIndex].text + ' selected'));
          break
      }
    },

    onMouseEnter: (event, { itemIndex }) => {
      dispatch(updateFocusedItem(AutoSuggestId, itemIndex));
    },

    onMouseLeave: () => {
      dispatch(updateFocusedItem(AutoSuggestId, null));
    },

    onMouseDown: (event, { itemIndex }) => {
      console.log('onMouseDown', items[itemIndex].text )
      dispatch(updateInputValue(AutoSuggestId, items[itemIndex].text + ' clicked'));
    },

    onBlur: () => {
      dispatch(resetSearchCompanies())
    }
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Companies)
