import { UPDATE_INPUT_VALUE, UPDATE_FOCUSED_ITEM } from '../constants/actionTypes';

export function searchCompany(queryStr) {
  return (dispatch) => {
    console.log('Nesta bosta', queryStr)
  }
}

export function updateInputValue(exampleNumber, value) {
  return {
    type: UPDATE_INPUT_VALUE,
    exampleNumber,
    value
  }
}

export function updateFocusedItem(exampleNumber, focusedSectionIndex, focusedItemIndex) {
  return {
    type: UPDATE_FOCUSED_ITEM,
    exampleNumber,
    focusedSectionIndex,
    focusedItemIndex
  }
}
