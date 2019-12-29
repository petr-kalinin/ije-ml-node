React = require('react')
import {
  BrowserRouter as Router,
  Route,
  Switch,
  Redirect
} from 'react-router-dom'

import Index from './components/Index'
import Login from './components/Login'
import ChangeContest from './components/ChangeContest'
import Submit from './components/Submit'
import Standings from './components/Standings'
import Messages from './components/Messages'
import MessageDetails from './components/MessageDetails'

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
        component: Login,
        key: "/login"
        path: "/login"
        exact: true
    },
    {
        component: ChangeContest,
        key: "/changeContest"
        path: "/changeContest"
        exact: true
    },
    {
        component: Submit,
        key: "/submit"
        path: "/submit"
        exact: true
    },
    {
        component: Standings,
        key: "/standings"
        path: "/standings"
        exact: true
    },
    {
        component: Messages,
        key: "/messages"
        path: "/messages"
        exact: true
    },
    {
        component: MessageDetails,
        key: "/messageDetails/:id"
        path: "/messageDetails/:id"
        exact: true
    },
    {
        component: NoMatch,
        key: "nomatch"
        path: "/"
    },
]
