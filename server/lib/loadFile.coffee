fs = require('fs')
iconv = require('iconv-lite')
LRU = require("lru-cache")

import logger from '../log'

_cache = new LRU(1000)

export default loadFile = (filename, encoding, ignoreCache) ->
    return new Promise (resolve, reject) ->
        if not ignoreCache
            cached = _cache.get(filename)
            if cached?
                logger.info "Loaded file ", filename, " from cache"
                resolve cached
                return
        start = new Date()
        fs.readFile filename, (err, data) ->
            if err
                reject err
            else
                logger.info "Loaded file ", filename, " time=", ((new Date()) - start) / 1000
                if encoding != "raw"
                    data = iconv.decode(data, encoding || "windows-1251")
                if not ignoreCache
                    _cache.set(filename, data)
                resolve data
