import { combineReducers } from 'redux'
import { routerReducer } from 'react-router-redux'
import companies from './companies'
import autowhatever from './autowhatever'

const rootReducer = combineReducers({
  companies,
  autowhatever,
  routing: routerReducer
})

export default rootReducer
