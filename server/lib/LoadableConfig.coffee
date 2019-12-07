export default class LoadableConfig
    constructor: (load) ->
        @load = load
        @config = undefined
        @pending = []
        @initLoad()

    initLoad: () ->
        @config = await @load()
        for resolve in @pending
            resolve(@config)

    get: () ->
        if @config
            return @config
        else 
            promise = new Promise (resolve, reject) =>
                @pending.push resolve
            return promise
