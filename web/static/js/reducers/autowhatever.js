import * as types from '../constants/actionTypes'

const initialState = {
  "companies": {
    focusedSectionIndex: null,
    focusedItemIndex: null
  }
}

export default function autowhatever (state = initialState, action) {
  switch (action.type) {
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
