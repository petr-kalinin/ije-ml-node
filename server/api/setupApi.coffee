express = require('express')
iconv = require("iconv-lite")
fs = require('fs-extra')
fileType = require('file-type')

import mlConfig from '../mlConfig'
import acmConfig, {contestConfig} from '../data/acmConfig'
import monitor, {reloadMonitor} from '../data/monitor'
import ijeConfig from '../data/ijeConfig'
import logger from '../log'
import getQacm from '../qacm/getQacm'
import writeFile from '../lib/writeFile'
import loadFile from '../lib/loadFile'
import {gettaskinfo, subs} from '../../client/lib/ijeConsts'
import sleep from '../lib/sleep'

api = express.Router()

wrap = (fn) ->
    (args...) ->
        try
            await fn(args...)
        catch error
            args[2](error)

api.get '/forbidden', wrap (req, res) ->
    res.status(403).send('No permissions')

api.get '/statements/:id', wrap (req, res) ->
    contest = req.session.contest
    probId = req.params.id
    if not contest?
        res.status(403).send("No current contest")
    cc = await contestConfig(contest)
    m = await monitor(contest)
    if m.time < 0
        res.status(403).send("Contest not started yet")
    if typeof cc.statements == "string"
        filename = cc.statements
    else
        filename = cc.statements[probId]
    if not filename
        res.status(400).send("No statements")
    text = await loadFile("#{mlConfig.ije_dir}/#{filename}", "raw")
    mimeType = fileType(Buffer.from(text))?.mime || "text/plain"
    res.status(200).contentType(mimeType).send(text)


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
    ic = await ijeConfig()
    ac = await acmConfig()
    cc = await contestConfig(+contestId)
    m = await monitor(+contestId)
    qacmDll = ac["acm-contest"][contestId]["qacm-dll"]
    qacmData = getQacm(qacmDll).contestData
    result =
        start: +cc.start
        length: +cc.length
        time: +m.time
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
        languages: {}
    for key, party of cc.parties
        result.parties[key] = 
            name: party.name
    for key, lang of ic.languages
        result.languages[key] = lang.name
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

api.post '/submit', wrap (req, res) ->
    contestId = +req.body.contest
    problem = req.body.problem
    lang = req.body.language
    code = req.body.code
    if contestId != req.session.contest
        res.status(403).send("No permission")
        return
    ic = await ijeConfig()
    ac = await acmConfig()
    cc = await contestConfig(contestId)
    mlcfg = mlConfig
    if not (problem of cc.problems) or not (lang of ic.languages)
        res.status(403).send("No permission2")
        return
    {d: nd, p: np} = gettaskinfo(ic, problem)
    fnew = subs(ic["solutions-format"], req.session.username, nd, np)
    fpath = "#{mlcfg["ije_dir"]}/#{ic["acm-register-solutions-path"]}#{fnew}.#{lang}"
    code = iconv.decode(new Buffer(code), "latin1")
    logger.info "Submit #{req.session.username} #{problem} #{lang} -> will save solution to #{fpath}"
    await writeFile(fpath, code)
    reppath = "#{mlcfg["ije_dir"]}/#{ac["reports-path"]}#{fnew}.xml";
    logger.info "Will expect report at ", reppath
    attempts = 0
    while (not await fs.pathExists(reppath)) and attempts < 10
        await sleep(500)
        attempts++
    if not await fs.pathExists(reppath)
        logger.error "No report created"
        await fs.remove(fpath)
        res.json({error: "no_response"})
        return
    await sleep(500)
    await fs.remove(reppath)
    await reloadMonitor(contestId)
    logger.info "Successful submit"
    res.json({submit: true})

api.post '/useToken/:contestId/:id', wrap (req, res) ->
    contestId = +req.params.contestId
    id = +req.params.id
    if contestId != req.session.contest
        res.status(403).send("No permission")
        return
    cc = await contestConfig(contestId)
    m = await monitor(contestId)
    fname = null
    for _, problemRow of m.parties[req.session.username]
        if not problemRow.id
            continue
        for _, submitRow of problemRow
            if +submitRow.id == id
                fname = submitRow.filename
    if not fname
        res.status(403).send("No permission")
        return
    fpath = "#{mlConfig['ije_dir']}/#{cc["token-request-path"]}#{fname}.token"
    await writeFile(fpath, '')
    res.json({used: true})

api.all /\/.*/, wrap (req, res) ->
    res.status(404).send("Not found")

export default api