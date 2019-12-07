express = require('express')

import ijeConfig from '../data/ijeConfig'

api = express.Router()

wrap = (fn) ->
    (args...) ->
        try
            await fn(args...)
        catch error
            args[2](error)

api.get '/forbidden', wrap (req, res) ->
    res.status(403).send('No permissions')

api.get '/ijeConfig', wrap (req, res) ->
    res.json(await ijeConfig())


export default api