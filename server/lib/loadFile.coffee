fs = require('fs')
iconv = require('iconv-lite')

export default loadFile = (filename) ->
    return new Promise (resolve, reject) ->
        start = new Date()
        fs.readFile filename, (err, data) ->
            if err
                reject err
            else
                console.log "Loaded file ", filename, " time=", ((new Date()) - start) / 1000
                data = iconv.decode(data, "windows-1251")
                resolve data
