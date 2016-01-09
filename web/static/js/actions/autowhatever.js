import * as types from '../constants/actionTypes';

export function updateInputValue(exampleNumber, value) {
  return {
    type: types.UPDATE_INPUT_VALUE,
    exampleNumber,
    value
  }
}

export function updateFocusedItem(exampleNumber, focusedItemIndex) {
  return {
    type: types.UPDATE_FOCUSED_ITEM,
    exampleNumber,
    focusedItemIndex
  }
}
