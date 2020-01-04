import mlConfig from '../mlConfig'
import sleep from '../lib/sleep'
import parseXmlFile from '../lib/parseXml'
import createConfig from '../lib/LoadableConfig'

import logger from '../log'

_filename = mlConfig.ije_dir + "/acm.xml"
postLoad = (data) ->
    if not Array.isArray(data["acm-contest"])
        data["acm-contest"] = [data["acm-contest"]]
    return data

makeContestConfig = (c) ->
    filename = mlConfig.ije_dir + "/" + c.settings
    return createConfig(filename, undefined, -1)

_acmConfig = createConfig(_filename, postLoad)
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