import parseXmlFile from '../lib/parseXml'
import logger from '../log'

load = (filename) ->
    logger.info "Loading ", filename
    data = await parseXmlFile(filename)
    for key, value of data
        if typeof value == 'string'
            data[key] = data[key].replace(/\\/g, "/")
    return data

export default class LoadableConfig
    constructor: (filename, postLoad, interval) ->
        @reload = @reload.bind this
        @filename = filename
        @postLoad = postLoad || (x) -> x
        @interval = interval || 10 * 1000
        @config = undefined
        @pending = []
        @initLoad()

    initLoad: () ->
        await @reload()
        for resolve in @pending
            resolve(@config)

    reload: () ->
        @config = await @postLoad(await load(@filename))
        if @interval > 0
            clearTimeout(@timeout)
            @timeout = setTimeout(@reload, @interval)

    get: () ->
        if @config
            return @config
        else 
            promise = new Promise (resolve, reject) =>
                @pending.push resolve
            return promise
