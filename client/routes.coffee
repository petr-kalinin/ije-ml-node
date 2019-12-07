React = require('react')
import {
  BrowserRouter as Router,
  Route,
  Switch,
  Redirect
} from 'react-router-dom'

import Index from './components/Index'

class NoMatch extends React.Component
    render: () ->
        return <h2>404 Not found</h2>

export default [
    {
        component: Index,
        key: "/"
        path: "/"
        exact: true
    },
    {
        component: NoMatch,
        key: "nomatch"
        path: "/"
    },
]
