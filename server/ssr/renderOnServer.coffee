React = require('react')

import { StaticRouter } from 'react-router'
import { renderToString } from 'react-dom/server';
import { matchPath, Switch, Route } from 'react-router-dom'

import { Provider } from 'react-redux'

import { Helmet } from "react-helmet"

import Routes from '../../client/routes'
import DefaultHelmet from '../../client/components/DefaultHelmet'
import Sceleton from '../../client/components/Sceleton'

import createStore from '../../client/redux/store'
import awaitAll from '../../client/lib/awaitAll'

import logger from '../log'

import Cookies from 'universal-cookie'

renderFullPage = (html, data, helmet) ->
    return '
        <html>
        <head>
            <meta charset="UTF-8" />
            ' + helmet.title + '
            <link rel="stylesheet" href="/bundle.css"/>
            <link rel="stylesheet" href="/main.css"/>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <script>
                window.__PRELOADED_STATE__ = ' + JSON.stringify(data) + ';
            </script>
        </head>
        <body>
            <div id="main" style="min-width: 100%; min-height: 100%">' + html + '</div>
            <script src="/bundle.js" type="text/javascript"></script>
        </body>
        </html>'

export default renderOnServer = (req, res, next) =>
    try
        initialState = 
            data: [
                {data: req.user
                success: true
                updateTime: new Date()
                url: "me"}
            ],
            clientCookie: req.headers.cookie,
        store = createStore(initialState)

        component = undefined
        foundMatch = undefined
        Routes.some((route) ->
            match = matchPath(req.path, route)
            if (match)
                foundMatch = match
                component = route.component
            return match
        )
        if not component
            res.set('Content-Type', 'text/html').status(404).end('404 Not found')
            return
        element = React.createElement(Sceleton(component), {match: foundMatch})
        context = {}

        # We have already identified the element,
        # but we need StaticRouter for Link to work
        wrappedElement = <Provider store={store}>
                <div>
                    <DefaultHelmet/>
                    <StaticRouter context={context}>
                        {element}
                    </StaticRouter>
                </div>
            </Provider>

        html = renderToString(wrappedElement)
        await awaitAll(store.getState().dataPromises)

        wrappedElement = <Provider store={store}>
                <div>
                    <DefaultHelmet/>
                    <StaticRouter context={context}>
                        <div>
                            {element}
                        </div>
                    </StaticRouter>
                </div>
            </Provider>
        html = renderToString(wrappedElement)

    catch error
        logger.error(error)
        res.status(500).send('Error 500')
        return
    finally
        helmet = Helmet.renderStatic();

    state = store.getState()
    delete state.dataPromises
    delete state.clientCookie

    res.set('Content-Type', 'text/html').status(200).end(renderFullPage(html, state, helmet))
