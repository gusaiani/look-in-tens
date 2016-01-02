import React from 'react'
import ReactDOM from 'react-dom'
import { createStore, combineReducers } from 'redux'
import { Provider } from 'react-redux'
import { Router, Route, IndexRoute } from 'react-router'
import { createHistory } from 'history'
import { syncReduxAndRouter, routeReducer } from 'redux-simple-router'
import reducers from './reducers/index'

import Main from './containers/Main'
import Companies from './containers/Companies'
import Other from './containers/Other'

const reducer = combineReducers(Object.assign({}, reducers, {
  routing: routeReducer
}))
const store = createStore(reducer)
const history = createHistory()

syncReduxAndRouter(history, store)

const reactContainer = document.getElementById('app')

if (reactContainer) {
  ReactDOM.render(
    <Provider store={store}>
      <Router history={history}>
        <Route path="/" component={Main}>
          <IndexRoute component={Companies}/>
          <Route path="companies" component={Companies}/>
          <Route path="other" component={Other}/>
        </Route>
      </Router>
    </Provider>,
    document.getElementById('app')
  )
}
