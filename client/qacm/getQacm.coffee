import acceptSolutions from './acceptSolutions/main'

export default getQacm = (qacm) ->
    switch qacm
        when "acceptSolutions" then acceptSolutions
        else throw "unknown qacm"