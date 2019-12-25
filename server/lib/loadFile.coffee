fs = require('fs')
iconv = require('iconv-lite')

export default loadFile = (filename) ->
    return new Promise (resolve, reject) ->
        fs.readFile filename, (err, data) ->
            if err
                reject err
            else
                data = iconv.decode(data, "windows-1251")
                resolve data
