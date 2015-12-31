import React from 'react'
import { IndexRoute, Route } from 'react-router'
import { Main } from './containers/Main'
import { Companies } from './containers/Companies'

export default (
  <Route path="/" component={Main}>
    <IndexRoute component={Companies}/>
    <Route path="companies" component={Companies}/>
  </Route>
)
