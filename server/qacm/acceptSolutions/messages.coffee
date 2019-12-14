hasTests = (s) ->
  return not (s[1]["outcome"] in ["compilation-error","not-tested"])

formMessage = (cc, m, problemRow, s, isAdmin) ->
    result = {}
    tokenused = s["token-used-time"] >= 0 or +cc["token-period"] < 0 or s[1]["outcome"] == "compilation-error" or cc["show-full-results"]=="true" or isAdmin
    result.id = s.id
    result.time = s.time
    result.tokenUsed = tokenused;
    result.canUseToken = not tokenused and problemRow["token-wait-time"] == 0 and hasTests(s)
    result.points= if tokenused then s.points else "?"
    result.full = result.points == s["max-points"]
    if s[1]["outcome"] == "not-tested"
       result.points = "NT"  # todo: $ltext["NT"];
    result.problem = s.problem
    result["filename"] = s["filename"]
    result["language-id"] = s["language-id"]
    if cc["showtests"]
        nn = 0
        result["testres"] = []
        if (tokenused)
            for id, test of s
                if not test.id?
                    continue
                if cc["showcomments"] != "true"
                    test["comment"] = undefined
                    test["eval-comment"] = undefined
                nn++
                result["testres"].push(test)
            if (hasTests(s))
                result.tests = 0
                result.testsCount = 0
                for id, test of s
                    if not test.id?
                        continue
                    if test["outcome"] == "accepted"
                        result.tests++;
                    result.testsCount++;
            if (s[1]["outcome"]=="not-tested")
                result.tests = null
        else
            result.tests = null
    result

export makeMessages = (cc, m, currentUser) ->
    showFull = (cc["show-full-results"] == "true")
    result = []
    isAdmin = cc.parties[currentUser]?.admin == "true"
    for id, problemRow of m.parties
        if (id != currentUser) and (not isAdmin)
            continue
        for problemId, _ of m.problems
            for _, row of problemRow[problemId]
                if not (row.id?) 
                    continue
                result.push formMessage(cc, m, problemRow, row, isAdmin)

    result.sort (a, b) -> +a.id - b.id
    return result

