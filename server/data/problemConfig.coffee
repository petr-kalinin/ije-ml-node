import mlConfig from '../mlConfig'
import ijeConfig from './ijeConfig'
import sleep from '../lib/sleep'
import parseXmlFile from '../lib/parseXml'
import LoadableConfig from '../lib/LoadableConfig'

import logger from '../log'

makeProblemConfig = (problem) ->
    cfg = await ijeConfig()
    mlcfg = mlConfig
    filename = "#{mlcfg['ije_dir']}/#{cfg['problems-path']}#{problem}/problem.xml"
    return new LoadableConfig(filename, undefined, -1)

configs = {}

export default problemConfig = (id) ->
    if not (id of configs)
        config = await makeProblemConfig(id)
        configs[id] = config
    return await configs[id].get()
