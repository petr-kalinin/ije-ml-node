fs = require('fs')
iconv = require('iconv-lite')

import logger from '../log'

export default loadFile = (filename, encoding) ->
    return new Promise (resolve, reject) ->
        start = new Date()
        fs.readFile filename, (err, data) ->
            if err
                reject err
            else
                logger.info "Loaded file ", filename, " time=", ((new Date()) - start) / 1000
                if encoding != "raw"
                    data = iconv.decode(data, encoding || "windows-1251")
                resolve data
