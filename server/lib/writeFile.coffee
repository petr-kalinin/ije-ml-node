fs = require('fs')

export default writeFile = (filename, data) ->
    return new Promise (resolve, reject) ->
        fs.writeFile filename, data, (err) ->
            if err
                reject err
            else
                resolve()
