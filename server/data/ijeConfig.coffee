import mlConfig from '../mlConfig'
import sleep from '../lib/sleep'
import parseXmlFile from '../lib/parseXml'
import LoadableConfig from '../lib/LoadableConfig'

import logger from '../log'

_filename = mlConfig.ije_dir + "/ije_cfg.xml"

_ijeConfig = new LoadableConfig(_filename, undefined, -1)

ijeConfig = () ->
    _ijeConfig.get()

export default ijeConfig