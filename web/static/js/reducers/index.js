import { combineReducers } from 'redux'
import { routeReducer } from 'redux-simple-router'
import companies from './companies'

const rootReducer = combineReducers({
  companies,
  routing: routeReducer
})

export default rootReducer
