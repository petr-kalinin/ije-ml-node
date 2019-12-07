xml2js = require('xml2js')
fs = require('fs')

export parseXml = (xml) ->
    return new Promise (resolve, reject) ->
        xml2js.parseString xml, (err, result) ->
            if err 
                reject err
            else
                resolve result

export loadFile = (filename) ->
    return new Promise (resolve, reject) ->
        fs.readFile filename, (err, data) ->
            if err
                reject err
            else
                resolve data

export default parseXmlFile = (filename) ->
    return await parseXml(await loadFile(filename))
