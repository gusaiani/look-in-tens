import * as types from '../constants/actionTypes'
import {searchCompanies, resetSearchCompanies} from '../actions/companies'
import {buildAutoSuggestItems} from '../utils/companies'

const AutoSuggestId = 'companies'

function updateInputValue(exampleNumber, value) {
  return {
    type: types.UPDATE_INPUT_VALUE,
    exampleNumber,
    value
  }
}

function updateFocusedItem(exampleNumber, focusedItemIndex) {
  return {
    type: types.UPDATE_FOCUSED_ITEM,
    exampleNumber,
    focusedItemIndex
  }
}

export function onChange(event) {
  return (dispatch) => {
    dispatch(updateInputValue(AutoSuggestId, event.target.value))
    dispatch(searchCompanies(event.target.value))
  }
}

export function onKeyDown(event, { focusedItemIndex, newFocusedItemIndex }) {
  return (dispatch, getState) => {
    switch (event.key) {
      case 'ArrowDown':
      case 'ArrowUp':
        event.preventDefault();
        dispatch(updateFocusedItem(AutoSuggestId, newFocusedItemIndex));
        break;

      case 'Enter':
        const {companies} = getState()
        const {items} = companies

        const suggested = buildAutoSuggestItems(items)
        console.log(focusedItemIndex, suggested, suggested[focusedItemIndex].text)
        return
        dispatch(updateInputValue(AutoSuggestId, suggested[focusedItemIndex].text + ' selected'));
        break
    }
  }
}

export function onMouseEnter(event, { itemIndex }) {
  return (dispatch) => {
    dispatch(updateFocusedItem(AutoSuggestId, itemIndex));
  }
}

export function onMouseLeave() {
  return (dispatch) => {
    dispatch(updateFocusedItem(AutoSuggestId, null));
  }
}

export function onMouseDown(event, { itemIndex }) {
  return (dispatch, getState) => {
    const {companies} = getState()
    const {items} = companies

    const suggested = buildAutoSuggestItems(items)
    console.log(itemIndex, suggested)
    console.log('onMouseDown', suggested[itemIndex].text )
    return

    dispatch(updateInputValue(AutoSuggestId, items[itemIndex].text + ' clicked'));
  }
}

export function onBlur() {
  return (dispatch) => {
    dispatch(resetSearchCompanies())
  }
}
