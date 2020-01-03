export default class LoadableConfig
    constructor: (load, interval) ->
        @reload = @reload.bind this
        @load = load
        @interval = interval || 10 * 1000
        @config = undefined
        @pending = []
        @initLoad()

    initLoad: () ->
        await @reload()
        for resolve in @pending
            resolve(@config)

    reload: () ->
        @config = await @load()
        if @interval > 0
            @timeout = setTimeout(@reload, @interval)

    get: () ->
        if @config
            return @config
        else 
            promise = new Promise (resolve, reject) =>
                @pending.push resolve
            return promise
