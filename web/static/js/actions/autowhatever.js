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
        event.preventDefault()
        dispatch(updateFocusedItem(AutoSuggestId, newFocusedItemIndex))
        break

      case 'Enter':
        const company = getCompanyFromIndex(getState, focusedItemIndex)
        dispatch(updateSelectedCompany(company))
        break
    }
  }
}

export function onMouseEnter(event, { itemIndex }) {
  return (dispatch) => {
    dispatch(updateFocusedItem(AutoSuggestId, itemIndex))
  }
}

export function onMouseLeave() {
  return (dispatch) => {
    dispatch(updateFocusedItem(AutoSuggestId, null))
  }
}

export function onMouseDown(event, { itemIndex }) {
  return (dispatch, getState) => {
    const company = getCompanyFromIndex(getState, itemIndex)
    dispatch(updateSelectedCompany(company))
  }
}

export function onBlur() {
  return (dispatch) => {
    dispatch(resetSearchCompanies())
  }
}

function getCompanyFromIndex(getState, index) {
  const {companies} = getState()
  const items = buildAutoSuggestItems(companies)
  const companyId = items[index].id
  const company = companies.items[companyId]

  return company
}

function updateSelectedCompany(company) {
  return {
    type: types.COMPANY_SHOW,
    company: company
  }
}
