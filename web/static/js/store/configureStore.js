import { createStore, applyMiddleware, compose } from 'redux'
import { reduxReactRouter } from 'redux-router'
import createHistory from 'history/lib/createBrowserHistory'
import thunk from 'redux-thunk'

const createStoreWithMiddleware = compose(
  applyMiddleware(thunk),
  window.devToolsExtension ? window.devToolsExtension() : f => f
)(createStore)

const addReducerHotReloader = (store) => {
  module.hot.accept('../reducers', () => {
    const nextRootReducer = require('../reducers')
    store.replaceReducer(nextRootReducer)
  })

  return store
}

export default function configureStore(reducer) {
  let store = createStoreWithMiddleware(reducer)

  if (module.hot) {
    store = addReducerHotReloader(store)
  }

  return store
}
