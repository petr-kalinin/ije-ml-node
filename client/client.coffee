import "babel-polyfill"

React = require('react')

import { BrowserRouter, Route, Link, Switch } from 'react-router-dom'

ReactDOM = require('react-dom')

import { Provider } from 'react-redux'

import createStore from './redux/store'

import Routes from './routes'
import GotoProvider from './components/GotoProvider'
import ScrollToTop from './components/ScrollToTop'
import DefaultHelmet from './components/DefaultHelmet'
import Sceleton from './components/Sceleton'

preloadedState = window.__PRELOADED_STATE__
delete window.__PRELOADED_STATE__
window.store = createStore(preloadedState)

ReactDOM.hydrate(
    <Provider store={window.store}>
        <div>
            <DefaultHelmet/>
            <BrowserRouter>
                <div>
                    <ScrollToTop>
                        <GotoProvider>
                            <Switch>
                                {Routes.map((route) => 
                                    route.component = Sceleton(route.component)
                                    `<Route {...route} data={window.__INITIAL_STATE__}/>`)
                                }
                            </Switch>
                        </GotoProvider>
                    </ScrollToTop>
                </div>
            </BrowserRouter>
        </div>
    </Provider>,
    document.getElementById('main')
)
