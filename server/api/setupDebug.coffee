express = require('express')

import acmConfig, {contestConfig} from '../data/acmConfig'
import monitor from '../data/monitor'
import ijeConfig from '../data/ijeConfig'
import mlConfig from '../mlConfig'
import logger from '../log'

router = express.Router()

wrap = (fn) ->
    (args...) ->
        try
            await fn(args...)
        catch error
            args[2](error)

router.get '/forbidden', wrap (req, res) ->
    res.status(403).send('No permissions')

router.get '/acmConfig', wrap (req, res) ->
    res.json(await acmConfig())

router.get '/ijeConfig', wrap (req, res) ->
    res.json(await ijeConfig())

router.get '/contestConfig/:id', wrap (req, res) ->
    res.json(await contestConfig(+req.params.id))

router.get '/monitor/:id', wrap (req, res) ->
    res.json(await monitor(+req.params.id))

router.all /\/.*/, wrap (req, res) ->
    res.status(404).send("Not found")


export default router