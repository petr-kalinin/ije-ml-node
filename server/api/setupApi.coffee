express = require('express')

import acmConfig, {contestConfig} from '../data/acmConfig'
import monitor from '../data/monitor'
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

api.get '/acmConfig', wrap (req, res) ->
    res.json(await acmConfig())

api.get '/ijeConfig', wrap (req, res) ->
    res.json(await ijeConfig())

api.get '/contestConfig/:id', wrap (req, res) ->
    res.json(await contestConfig(+req.params.id))

api.get '/monitor/:id', wrap (req, res) ->
    console.log "id=", req.params.id
    res.json(await monitor(+req.params.id))


export default api