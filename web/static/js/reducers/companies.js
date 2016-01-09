import * as types from '../constants/actionTypes'

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

    case types.COMPANY_SEARCH_RESET:
      return Object.assign({}, state, {
        isFetching: false,
        items: []
      })

    case types.COMPANY_SHOW:
      return Object.assign({}, state, {
        selected: action.company
      })

    default:
      return state
  }
}
