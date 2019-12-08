xml2js = require('xml2js')
fs = require('fs')

import logger from '../log'

extractTop = (data) ->
    keys = Object.keys(data)
    if keys.length != 1
        throw "Found XML file with several roots: #{keys}"
    return data[keys[0]]

fixNesting = (data) ->
    if not (data.constructor == Object)  # not dictionary
        return data
    newData = {}
    if '$' of data
        for key, value of data['$']
            if key of newData
                throw "Can not parse, duplicate key #{key}"
            newData[key] = fixNesting(value)
        delete data['$']
    for key, value of data
        if Array.isArray(value)
            for el in value
                el = fixNesting(el)
                id = el.id or key
                if id of newData
                    throw "Can not parse, duplicate id #{id} in key #{key}"
                newData[id] = el
        else
            newData[key] = fixNesting(value)
    return newData

correctParsedXml = (data) ->
    data = extractTop(data)
    data = fixNesting(data)

export parseXml = (xml) ->
    return new Promise (resolve, reject) ->
        xml2js.parseString xml, (err, result) ->
            if err 
                reject err
            else
                resolve correctParsedXml(result)

export loadFile = (filename) ->
    return new Promise (resolve, reject) ->
        fs.readFile filename, (err, data) ->
            if err
                reject err
            else
                resolve data

export default parseXmlFile = (filename) ->
    return await parseXml(await loadFile(filename))
