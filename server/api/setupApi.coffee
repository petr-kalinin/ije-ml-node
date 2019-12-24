express = require('express')

import acmConfig, {contestConfig} from '../data/acmConfig'
import monitor from '../data/monitor'
import ijeConfig from '../data/ijeConfig'
import mlConfig from '../mlConfig'
import logger from '../log'
import getQacm from '../qacm/getQacm'

api = express.Router()

wrap = (fn) ->
    (args...) ->
        try
            await fn(args...)
        catch error
            args[2](error)

api.get '/forbidden', wrap (req, res) ->
    res.status(403).send('No permissions')

api.post '/setContest', wrap (req, res) ->
    if not req.body?.contest?
        res.status(400).send("No id")
        return
    contest = +req.body?.contest
    try
        config = await contestConfig(contest)
    catch
        res.status(400).send("Unknown id")
        return
    req.session.contest = contest
    req.session.username = undefined
    res.status(200).json({set: "ok"})

api.post '/login', wrap (req, res) ->
    {contest, username, password} = req.body
    logger.info "Try to log in #{username}, #{password}, #{contest}"
    if not contest? or not username? or not password?
        res.status(400).send("No data")
        return
    contest = +contest
    try
        config = await contestConfig(contest)
    catch
        res.status(400).send("Unknown id")
        return
    if not (username of config.parties) or (password != config.parties[username].password)
        res.status(403).send("Wrong login or password")
        return
    req.session.contest = contest
    req.session.username = username
    res.status(200).json({logged: "ok"})

api.post '/logout', wrap (req, res) ->
    req.session.username = undefined
    res.status(200).json({})

api.get '/me', wrap (req, res) ->
    cc = await contestConfig(req.session.contest)
    res.status(200).json
        contest: req.session.contest
        username: req.session.username
        name: cc.parties[req.session.username]?.name
        admin: cc.parties[req.session.username]?.admin
        contestTitle: cc.title

api.get '/contests', wrap (req, res) ->
    result = {}
    ac = await acmConfig()
    for _, i in ac["acm-contest"]
        result[i] = (await contestConfig(i)).title
    res.json(result)

api.get '/contestData/:id', wrap (req, res) ->
    contestId = req.params.id
    ac = await acmConfig()
    cc = await contestConfig(+contestId)
    m = await monitor(+contestId)
    qacmDll = ac["acm-contest"][contestId]["qacm-dll"]
    qacmData = getQacm(qacmDll).contestData
    result =
        start: cc.start
        length: cc.length
        time: m.time
        status: m.status
        title: cc.title
        problemsCount: Object.keys(cc.problems).length
        partiesCount: Object.keys(cc.parties).length
        submitsCount: m.nsubmits
        dst: mlConfig.dst
        statements: cc.statements
        problems: cc.problems
        qacm: ac["acm-contest"][+contestId]["qacm-dll"]
        calculatePoints: cc["calculate-points"] == "true"
        parties: {}
    for key, party of cc.parties
        result.parties[key] = 
            name: party.name
    qResult = qacmData(cc)
    result = {result..., qResult...}
    res.json(result)

api.get '/standings/:contestId', wrap (req, res) ->
    contestId = +req.params.contestId
    if contestId != req.session.contest
        res.status(403).send("No permission")
        return
    ac = await acmConfig()
    cc = await contestConfig(contestId)
    m = await monitor(contestId)
    qacmDll = ac["acm-contest"][contestId]["qacm-dll"]
    qacm = getQacm(qacmDll).standings
    result = qacm.makeStandings(cc, m, req.session.username)
    res.json(result)

api.get '/messages/:contestId', wrap (req, res) ->
    contestId = +req.params.contestId
    if contestId != req.session.contest
        res.status(403).send("No permission")
        return
    ac = await acmConfig()
    cc = await contestConfig(contestId)
    m = await monitor(contestId)
    qacmDll = ac["acm-contest"][contestId]["qacm-dll"]
    qacm = getQacm(qacmDll).messages
    result = await qacm.makeMessages(cc, m, req.session.username)
    res.json(result)

api.get '/message/:contestId/:messageId', wrap (req, res) ->
    contestId = +req.params.contestId
    if contestId != req.session.contest
        res.status(403).send("No permission")
        return
    ac = await acmConfig()
    cc = await contestConfig(contestId)
    m = await monitor(contestId)
    qacmDll = ac["acm-contest"][contestId]["qacm-dll"]
    qacm = getQacm(qacmDll).messages
    result = await qacm.makeMessage(cc, m, req.session.username, +req.params.messageId)
    res.json(result)

api.all /\/.*/, wrap (req, res) ->
    res.status(404).send("Not found")


export default api