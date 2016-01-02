import { createStore, applyMiddleware, compose } from 'redux'
import { reduxReactRouter } from 'redux-router'
import createHistory from 'history/lib/createBrowserHistory'
import routes from '../routes'
import thunkMiddleware from 'redux-thunk'
import rootReducer from '../reducers/index'

const createStoreWithMiddleware = compose(
  applyMiddleware(thunkMiddleware),
  reduxReactRouter({ routes, createHistory }),
  window.devToolsExtension ? window.devToolsExtension() : f => f
)(createStore)

const addReducerHotReloader = (store) => {
  module.hot.accept('../reducers', () => {
    const nextRootReducer = require('../reducers')
    store.replaceReducer(nextRootReducer)
  })

  return store
}

export default function configureStore(initialState) {
  let store = createStoreWithMiddleware(rootReducer, initialState)

  if (module.hot) {
    store = addReducerHotReloader(store)
  }

  return store
}
