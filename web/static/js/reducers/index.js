import { combineReducers } from 'redux'
import { companies } from './companies'
import { routeReducer } from 'redux-simple-router'

const rootReducer = combineReducers({
  companies,
  routing: routeReducer
})

export default rootReducer
