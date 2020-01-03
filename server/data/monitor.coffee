import mlConfig from '../mlConfig'
import ijeConfig from './ijeConfig'
import acmConfig, {contestConfig} from './acmConfig'
import parseXmlFile from '../lib/parseXml'
import LoadableConfig from '../lib/LoadableConfig'

import logger from '../log'

makeMonitor = (id) ->
    filename = mlConfig.ije_dir + "/" + (await ijeConfig())["results-path"] + (await contestConfig(id)).monitor
    load = () ->
        logger.info "Loading ", filename
        await parseXmlFile(filename)
    return new LoadableConfig(load)

monitors = undefined

export default monitor = (id) ->
    ac = await acmConfig()
    if id < 0 or id >= ac["acm-contest"].length
        throw "Wrong contest id #{id}"
    if not monitors
        monitors = ((await makeMonitor(i)) for _, i in ac["acm-contest"])
    await monitors[id].get()

export reloadMonitor = (id) ->
    if id < 0 or id >= monitors.length
        throw "Wrong contest id #{id}"
    await monitors[id].reload()
