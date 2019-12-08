import mlConfig from '../mlConfig'
import sleep from '../lib/sleep'
import parseXmlFile from '../lib/parseXml'
import LoadableConfig from '../lib/LoadableConfig'

import logger from '../log'

load = () ->
    filename = mlConfig.ije_dir + "/ije_cfg.xml"
    logger.info "Loading ", filename
    data = await parseXmlFile(filename)
    for key, value of data
        if typeof value == 'string'
            data[key] = data[key].replace("\\", "/")
    return data

_ijeConfig = new LoadableConfig(load)

ijeConfig = () ->
    _ijeConfig.get()

export default ijeConfig