import {LTEXT} from '../../../client/lib/lang'
import {xmlToOutcome, makeTestFileName} from '../../../client/lib/ijeConsts'
import LoadableConfig from '../../lib/LoadableConfig'
import mlConfig from '../../mlConfig'
import ijeConfig from '../../data/ijeConfig'
import problemConfig from '../../data/problemConfig'
import loadFile from '../../lib/loadFile'
import logger from '../../log'
import awaitAll from '../../../client/lib/awaitAll'

hasTests = (s) ->
  return not (s[1]["outcome"] in ["compilation-error","not-tested"])

makeFileData = (problem, filename) ->
    mlcfg = mlConfig
    cfg = await ijeConfig()
    path="#{mlcfg['ije_dir']}/#{cfg['outputs-path']}/#{problem}/#{filename}"
    probCfg = await problemConfig(problem)
    probdata = probCfg.judging.script.testset
    return {path, probdata}

loadAndTrimFile = (filename, maxlen) ->
    try
        text = await loadFile(filename)
    catch e
        logger.error "Can not find file #{filename}"
        return null
    if len(text) > maxlen
        text = text.substr(maxlen) + "\n<...>"
    text

addSourceAndCompileLog = (result, fileData) ->
    {path, probdata} = fileData
    result.source = await loadAndTrimFile("#{path}/#{result.filename}.#{result['language-id']}", 1024*1024)
    result.compileLog = await loadAndTrimFile("#{path}/compile.log")

addFiles = (test, fileData) ->
    {path, probdata} = fileData
    id = test.id
    inf = makeTestFileName(probdata["input-href"], id)
    test.input = await loadAndTrimFile("#{path}/#{inf}")
    test.output = await loadAndTrimFile("#{path}/#{inf}.out")
    ans = makeTestFileName(probdata["answer-href"], id)
    test.answer = await loadAndTrimFile("#{path}/#{ans}")

formMessage = (cc, m, problemRow, s, isAdmin, shouldAddFiles) ->
    shouldAddFiles = shouldAddFiles and (cc["showcomments"] == "true")
    result = {}
    tokenused = s["token-used-time"] >= 0 or +cc["token-period"] < 0 or s[1]["outcome"] == "compilation-error" or cc["show-full-results"]=="true" or isAdmin
    result.id = s.id
    result.time = s.time
    result.party = s.party
    result.tokenUsed = tokenused
    result.canUseToken = not tokenused and +(problemRow["token-wait-time"]) == 0 and hasTests(s)
    result.points= if tokenused then s.points else "?"
    result.full = result.points == s["max-points"]
    if s[1]["outcome"] == "not-tested"
       result.points = "NT"  # todo: $ltext["NT"];
    result.problem = s.problem
    result["filename"] = s["filename"]
    result["language-id"] = s["language-id"]

    if shouldAddFiles
        fileData = await makeFileData(s.problem, s.filename)
        await addSourceAndCompileLog(result, fileData)

    if cc["showtests"] == "true"
        nn = 0
        result["testres"] = []
        if (tokenused)
            for id, test of s
                if not test.id?
                    continue
                if cc["showcomments"] != "true"
                    outcome = xmlToOutcome[test.outcome]
                    test["comment"] = LTEXT[outcome]
                    test["eval-comment"] = undefined
                else if shouldAddFiles
                    await addFiles(test, fileData)
                nn++
                result["testres"].push(test)
            if (hasTests(s))
                result.tests = 0
                result.testsCount = 0
                for id, test of s
                    if not test.id?
                        continue
                    if test["outcome"] == "accepted"
                        result.tests++;
                    result.testsCount++;
            if (s[1]["outcome"]=="not-tested")
                result.tests = null
        else
            result.tests = null
    result

export makeMessages = (cc, m, currentUser) ->
    showFull = (cc["show-full-results"] == "true")
    result = []
    isAdmin = cc.parties[currentUser]?.admin == "true"
    for id, partyRow of m.parties
        if (id != currentUser) and (not isAdmin)
            continue
        for problemId, _ of m.problems
            for _, row of partyRow[problemId]
                if not (row.id?) 
                    continue
                result.push formMessage(cc, m, partyRow[problemId], row, isAdmin)

    result = await awaitAll result
    result.sort (a, b) -> +a.id - b.id
    return result

export makeMessage = (cc, m, currentUser, messageId) ->
    showFull = (cc["show-full-results"] == "true")
    result = []
    isAdmin = cc.parties[currentUser]?.admin == "true"
    for id,partyRow of m.parties
        if (id != currentUser) and (not isAdmin)
            continue
        for problemId, _ of m.problems
            for _, row of partyRow[problemId]
                if +row.id == messageId
                    return await formMessage(cc, m, partyRow[problemId], row, isAdmin, true)
    return {}

