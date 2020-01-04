import mlConfig from '../mlConfig'
import sleep from '../lib/sleep'
import parseXmlFile from '../lib/parseXml'
import createConfig from '../lib/LoadableConfig'

import logger from '../log'

_filename = mlConfig.ije_dir + "/ije_cfg.xml"

_ijeConfig = createConfig(_filename, undefined)

ijeConfig = () ->
    _ijeConfig.get()

export default ijeConfig