import { combineReducers } from 'redux'
import { routeReducer } from 'redux-simple-router'
import companies from './companies'
import autowhatever from './autowhatever'

const rootReducer = combineReducers({
  companies,
  autowhatever,
  routing: routeReducer
})

export default rootReducer
