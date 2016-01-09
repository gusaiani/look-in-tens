import expect from 'expect'
import * as actions from '../../actions/companies'
import * as types from '../../constants/actionTypes'

describe('actions', () => {
  it('should request search companies', () => {
    const expectedAction = {
      type: types.COMPANY_SEARCH_REQUEST
    }

    expect(actions.requestSearchCompanies()).toEqual(expectedAction)
  })
})
