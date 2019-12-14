React = require('react')

import styles from './messages.css'
import qLANG from './lang'

getMyRow = (standings, username) ->
    for row in standings
        if row.id == username
            return row


export GlobalHeader = (props) -> 
    if props.contestData.tokenPeriod < 0
        return null
    res = null
    row = getMyRow(props.standings, props.me.username)
    res = []
    for id, t of row
        if t.tokensRemaining?
            res.push <tr key={id}><td>{id}</td><td className={styles.tokensRemaining}>{t.tokensRemaining}</td><td>{qLANG.Wait}: {t.tokenWait}</td></tr>
    if res.length
        res = <div>
        <p className={styles.tokens}>{qLANG.TokensRemaining}</p>
        <table className={styles.tokens}><tbody>
            {res}
        </tbody></table>
        </div>
    else
        res = null
    return res

export ProbHeader = (props) -> 
    row = getMyRow(props.standings, props.me.username)[props.prob.id]
    points = row.points
    attempts = row.attempts
    <h2>
        {if attempts != 0
            <font className={styles.probinfo}>
                {if row.full
                    <font className={styles.ProbFull}>{points}</font>
                else
                    points
                }
                {" (#{Math.abs(attempts)}) "}
            </font>
        else
            <span className={styles.indent}/>
        }
        {"#{props.prob.id}: #{props.prob.name}"}
        <span className={styles.separator}/>
        {props.contestData.tokenPeriod >= 0 && <span className={styles.tokensRemaining}>
            {"#{qLANG.TokensRemaining} #{row.tokensRemaining}"}
        </span>
        }
    </h2>

export AddMessage = (props) -> <td>addmessage</td>

export AddHeader = (props) -> 
    res = [
        <td className={styles.points} key="points">{qLANG.Points}</td>
    ]
    if props.contestData.showTests
        res.push <td className={styles.stests} key="stests">{qLANG.SuccessfullTests}</td>
        res.push <td className={styles.firstWA} key="firstWA">{qLANG.FirstWA}</td>
        res.push <td className={styles.comment} key="comment">{qLANG.Comment}</td>
    if props.contestData.tokenPeriod >= 0
        res.push <td className={styles.token} key="token">{qLANG.Token}</td>
    res


export hasMessageDetails = () -> true