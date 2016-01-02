import { UPDATE_INPUT_VALUE, UPDATE_FOCUSED_ITEM } from '../constants/actionTypes';

export default function companies (state = initialState, action) {
  switch (action.type) {
    case UPDATE_INPUT_VALUE:
      return {
        ...state,
        [action.exampleNumber]: {
          ...state[action.exampleNumber],
          value: action.value
        }
      }

    case UPDATE_FOCUSED_ITEM:
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
