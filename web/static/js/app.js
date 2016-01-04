import React from 'react'
import ReactDOM from 'react-dom'
import { createStore, combineReducers, applyMiddleware, compose } from 'redux'
import { Provider } from 'react-redux'
import { Router, Route, IndexRoute } from 'react-router'
import { createHistory } from 'history'
import { syncReduxAndRouter } from 'redux-simple-router'
import thunk from 'redux-thunk'

import configureStore from './store/configureStore'

import rootReducer from './reducers/index'

import Main from './containers/Main'
import Companies from './containers/Companies'
import Other from './containers/Other'

const history = createHistory()
const store = configureStore(rootReducer)

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
