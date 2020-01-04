export makeStandings = (cc, m, currentUser) ->
    showFull = (cc["show-full-results"] == "true")
    result = []
    position = -1
    isAdmin = cc.parties[currentUser]?.admin == "true"
    for id, r of m.parties
        hidden = cc.parties[id].hidden == "true"
        if (id != currentUser) and (hidden or (not showFull and not isAdmin))
            continue
        partyResult = 
            id: id
            name: r.name
            full: 0
            points: 0
        for problemId, _ of m.problems
            thisResult = r[problemId]
            partyResult[problemId] =
                points: +thisResult[if showFull then "real-points" else "points"]
                attempts: +thisResult.attempts
            if cc["token-period"] >= 0
                partyResult[problemId].tokenWait = +thisResult["token-wait-time"]
                partyResult[problemId].tokensRemaining = cc["max-tokens"] - thisResult["tokens-used"]
            partyResult[problemId].full = +thisResult["real-points"] == +thisResult["max-points"] and +thisResult["max-points"] > 0
            if partyResult[problemId].full
                partyResult.full++
            partyResult.points += partyResult[problemId].points
        result.push partyResult

    result.sort (a, b) -> b.points - a.points

    for el, i in result
        el.color = i % 2

    return result

