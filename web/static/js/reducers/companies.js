import * as types from '../constants/actionTypes';

const initialState = {
  isFetching: false,
  items: []
}

export default function companies (state = initialState, action) {
  switch (action.type) {
    case types.COMPANY_SEARCH_REQUEST:
      return Object.assign({}, state, {
        isFetching: true,
        error: null
      })

    case types.COMPANY_SEARCH_SUCCESS:
      return Object.assign({}, state, {
        isFetching: false,
        items: action.items.companies
      })

    case types.COMPANY_SEARCH_FAILURE:
      return Object.assign({}, state, {
        isFetching: false,
        error: true
      })

    case types.UPDATE_INPUT_VALUE:
      return {
        ...state,
        [action.exampleNumber]: {
          ...state[action.exampleNumber],
          value: action.value
        }
      }

    case types.UPDATE_FOCUSED_ITEM:
      return {
        ...state,
        [action.exampleNumber]: {
          ...state[action.exampleNumber],
          focusedSectionIndex: action.focusedSectionIndex,
          focusedItemIndex: action.focusedItemIndex
        }
      }

    default:
      return state
  }
}
