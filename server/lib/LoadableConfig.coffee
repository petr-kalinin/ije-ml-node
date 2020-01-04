fs = require('fs')

import parseXmlFile from '../lib/parseXml'
import sleep from '../lib/sleep'
import logger from '../log'

load = (filename, ignoreCache) ->
    logger.info "Loading ", filename
    data = await parseXmlFile(filename, ignoreCache)
    for key, value of data
        if typeof value == 'string'
            data[key] = data[key].replace(/\\/g, "/")
    return data

class LoadableConfig
    constructor: (filename, postLoad) ->
        @reload = @reload.bind this
        @onFileChanged = @onFileChanged.bind this
        @filename = filename
        @postLoad = postLoad || (x) -> x
        @config = undefined
        @pending = []
        @initLoad()

    initLoad: () ->
        await @reload()
        for resolve in @pending
            resolve(@config)
        fs.watchFile(@filename, {interval: 2000}, @onFileChanged)
        console.log "Init watch for #{@filename}"

    onFileChanged: (curStat, prevStat) ->
        if curStat.mtime != prevStat.mtime
            await sleep(500)
            await @reload()

    reload: () ->
        @config = await @postLoad(await load(@filename, true))

    get: () ->
        if @config
            return @config
        else 
            promise = new Promise (resolve, reject) =>
                @pending.push resolve
            return promise

_configs = {}
export default createConfig = (filename, postLoad) ->
    if not (filename of _configs)
        _configs[filename] = new LoadableConfig(filename, postLoad)
    return _configs[filename]
