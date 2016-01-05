import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import Autowhatever from 'react-autowhatever'
import { searchCompany, updateInputValue, updateFocusedItem } from '../actions/companies'


const autowhateverId = '0'

const items = [{
  text: 'Apple'
}, {
  text: 'Banana'
}, {
  text: 'Cherry'
}, {
  text: 'Grapefruit'
}, {
  text: 'Lemon'
}]

// const items = []

class Companies extends Component {
  renderItem(item) {
    return (
      <span>{item.text}</span>
    )
  }

  render() {
    const { value, focusedSectionIndex, focusedItemIndex, onChange, onKeyDown } = this.props;
    const inputProps = { value, onChange, onKeyDown }

    return (
      <div>
        <h1>We’ve got companies’ view</h1>
        <Autowhatever
          id={autowhateverId}
          items={items}
          renderItem={this.renderItem}
          inputProps={inputProps}
          focusedSectionIndex={focusedSectionIndex}
          focusedItemIndex={focusedItemIndex} />
      </div>
    )
  }
}

function mapStateToProps(state) {
  const {companies} = state
  const {items} = companies

  return {
    companies
  }
}

function mapDispatchToProps(dispatch) {
  return {
    onChange: (event) => {
      // dispatch(updateInputValue(autowhateverId, event.target.value))
      dispatch(searchCompany(event.target.value))
    },

    onKeyDown: (event, { newFocusedSectionIndex, newFocusedItemIndex }) => {
      if (typeof newFocusedItemIndex !== 'undefined') {
        event.preventDefault()
        dispatch(updateFocusedItem(exampleId, newFocusedSectionIndex, newFocusedItemIndex))
      }
    }
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Companies)
