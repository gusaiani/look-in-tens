import { UPDATE_INPUT_VALUE, UPDATE_FOCUSED_ITEM } from '../constants/actionTypes';
import { API_ROOT } from '../constants/api'

export function searchCompany(queryStr) {
  return (dispatch) => {
    console.log(queryStr)
    return fetch(API_ROOT + 'companies/search/' + queryStr)
      .then(response => response.json())
      .then(json => {
        // debugger
        // dispatch(handleLoginSuccess(json))
      })
      .catch(error => {
        // dispatch(handleLoginFailure())
      })
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
