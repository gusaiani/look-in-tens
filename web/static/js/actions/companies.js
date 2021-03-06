import {arrayOf, normalize} from 'normalizr'
import {companySchema} from '../constants/schemas'

import * as types from '../constants/actionTypes';
import { API_ROOT } from '../constants/api'

export function searchCompanies(queryStr) {
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

export function requestSearchCompanies() {
  return {
    type: types.COMPANY_SEARCH_REQUEST
  }
}

export function resetSearchCompanies() {
  return {
    type: types.COMPANY_SEARCH_RESET
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
