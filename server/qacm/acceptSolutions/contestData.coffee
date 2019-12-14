export default contestData = (cc) ->
    return
        tokenPeriod: cc["token-period"]
        maxTokens: cc["max-tokens"]
        showTests: cc["showtests"] == "true"
        showComments: cc["showcomments"] == "true"