xmltext =
    'OK' : 'accepted',                 
    'WA' : 'wrong-answer',             
    'PE' : 'presentation-error',       
    'TL' : 'time-limit-exceeded',      
    'ML' : 'memory-limit-exceeded',    
    'OL' : 'output-limit-exceeded',    
    'IL' : 'idleness-limit-exceeded',  
    'RE' : 'runtime-error',            
    'CR' : 'crash',                    
    'SV' : 'security-violation',       
    'NC' : 'accepted-not-counted',     
    'CE' : 'compilation-error',        
    'NS' : 'not-submitted',            
    'CP' : 'compiled-not-tested',      
    'FL' : 'fail',                     
    'NT' : 'not-tested'

for i in [1..10]
    xmltext["PC#{i}"] = "partial-correct-#{i}"

export xmltext = xmltext

xmlToOutcome = {}
for key, value of xmltext
    xmlToOutcome[value] = key

export xmlToOutcome = xmlToOutcome

textColor=
    'OK' : '#00aa00',
    'WA' : '#ff0000',
    'PE' : '#007777',
    'TL' : '#000077',
    'ML' : '#000077'
    'OL' : '#000077',
    'IL' : '#000077',
    'RE' : '#770000',
    'CR' : '#770000',
    'SV' : '#770000',
    'NC' : '#004400',
    'CE' : '#aa00aa',
    'NS' : '#000000',
    'CP' : '#004400',
    'FL' : '#ff00ff',
    'NT' : '#004400' 

for i in [1..10]
    textColor["PC#{i}"]='#777700'

export textColor = textColor

export gettaskinfo = (cfg, dp) ->
    sformat=cfg["problems-format"]
    d='';
    p='';
    if (dp.length != sformat.length)
        console.error("!!ijeconsts.php:55:$dp:$sformat")
        return
    for i in [0..sformat.length] 
        switch sformat[i]
            when '#' then d += dp[i]
            when '$' then p += dp[i]
            else 
                if dp[i] != sformat[i]
                    console.error("Wrong symbol in dp")
                    return
    return {d, p}

export subs = (s, s1, s2, s3) ->
    ss = ''
    i1 = 0
    i2 = 0
    i3 = 0
    for i in [0..s.length] 
        switch s[i]
            when '@'
                if i1 >= s1.length
                    continue
                ss = ss + s1[i1]
                i1++
            when '#'
                if i2 >= s2.length
                    continue
                ss = s + s2[i2]
                i2++
            when '$'
                if i3 >= s3.length
                    continue
                ss = ss + s3[i3]
                i3++
            else
                ss = ss + s[i]
    return ss

export makeTestFileName = (fmt, number) ->
    s = {1: "", 2: ""}
    p = 1
    nn = 0
    for i in [0..fmt.length] 
        if fmt[i] == '#'
            nn++
            if p == 1 
                p = 2
        else
            s[p] += fmt[i]
    ff = "#{s[1]}%0#{nn}d#{s[2]}"
    return sprintf(ff, number)
