import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import Autowhatever from 'react-autowhatever'
import { updateInputValue } from '../actions/index'

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
            id="0"
            items={items}
            renderItem={this.renderItem}
            inputProps={inputProps}
            focusedSectionIndex={focusedSectionIndex}
            focusedItemIndex={focusedItemIndex} />
      </div>
    )
  }
}

function mapDispatchToProps(dispatch) {
  return {
    onChange: event => dispatch(updateInputValue(exampleId, event.target.value)),
    onKeyDown: (event, { newFocusedSectionIndex, newFocusedItemIndex }) => {
      if (typeof newFocusedItemIndex !== 'undefined') {
        event.preventDefault()
        dispatch(updateFocusedItem(exampleId, newFocusedSectionIndex, newFocusedItemIndex))
      }
    }
  }
}

function mapStateToProps(state) {
  return {}
}

export default connect(mapStateToProps, mapDispatchToProps)(Companies)
