import {arrayOf, normalize} from 'normalizr'
import {companySchema} from '../constants/schemas'

import * as types from '../constants/actionTypes';
import { API_ROOT } from '../constants/api'

export function searchCompany(queryStr) {
  return (dispatch) => {
    if (!queryStr) return

    dispatch(requestSearchCompanies())
    return fetch(API_ROOT + 'companies/search/' + queryStr)
      .then(response => response.json())
      .then(json => {
        const normalized = normalize(json.companies, arrayOf(companySchema))
        dispatch(receiveSearchCompanies(normalized.entities))
      })
      .catch(error => {
        dispatch(failSearchCompanies())
      })
  }
}

function requestSearchCompanies() {
    return {
      type: types.COMPANY_SEARCH_REQUEST
    }
}

function receiveSearchCompanies(items) {
  return {
    type: types.COMPANY_SEARCH_SUCCESS,
    items
  }
}

function failSearchCompanies() {
    return {
      type: types.COMPANY_SEARCH_FAILURE
    }
}

export function updateInputValue(exampleNumber, value) {
  return {
    type: types.UPDATE_INPUT_VALUE,
    exampleNumber,
    value
  }
}

export function updateFocusedItem(exampleNumber, focusedSectionIndex, focusedItemIndex) {
  return {
    type: types.UPDATE_FOCUSED_ITEM,
    exampleNumber,
    focusedSectionIndex,
    focusedItemIndex
  }
}
