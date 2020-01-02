import mlConfig from '../mlConfig'
import sleep from '../lib/sleep'
import parseXmlFile from '../lib/parseXml'
import LoadableConfig from '../lib/LoadableConfig'

import logger from '../log'

load = () ->
    filename = mlConfig.ije_dir + "/acm.xml"
    logger.info "Loading ", filename
    data = await parseXmlFile(filename)
    for key, value of data
        if typeof value == 'string'
            data[key] = data[key].replace(/\\/g, "/")
    return data

makeContestConfig = (c) ->
    filename = mlConfig.ije_dir + "/" + c.settings
    load = () ->
        logger.info "Loading ", filename
        data = await parseXmlFile(filename)
        for key, value of data
            if typeof value == 'string'
                data[key] = data[key].replace(/\\/g, "/")
        return data
    return new LoadableConfig(load)

_acmConfig = new LoadableConfig(load)
contestConfigs = undefined

acmConfig = () ->
    _acmConfig.get()

export contestConfig = (id) ->
    ac = await acmConfig()
    if id < 0 or id >= ac["acm-contest"].length
        throw "Wrong contest id #{id}"
    if not contestConfigs
        contestConfigs = (makeContestConfig(c) for c in ac["acm-contest"])
    await contestConfigs[id].get()


export default acmConfig