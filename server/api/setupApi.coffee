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
    res.json(await monitor(+req.params.id))

api.get '/session', wrap (req, res) ->
    if not req.session?.i
        req.session.i = 0
    req.session.i++
    res.status(200).send("" + req.session.i)

api.post '/setContest', wrap (req, res) ->
    if not req.body?.id?
        res.status(400).send("No id")
        return
    id = +req.body?.id
    try
        config = await contestConfig(id)
    catch
        res.status(400).send("Unknown id")
        return
    req.session.contest = id
    res.status(200).json({set: "ok"})

api.get '/contest', wrap (req, res) ->
    res.status(200).send("" + req.session.contest)

export default api