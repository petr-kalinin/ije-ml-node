React = require('react')

import styles from './messages.css'
import qLANG from './lang'
import LANG, {LTEXT} from '../../lib/lang'
import {xmlToOutcome, textColor} from '../../lib/ijeConsts'

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

export AddHeader = (props) -> 
    res = [
        <td className={styles.points} key="points">{qLANG.Points}</td>
    ]
    res.push <td className={styles.stests} key="stests">{props.contestData.showTests && qLANG.SuccessfullTests}</td>
    res.push <td className={styles.firstWA} key="firstWA">{props.contestData.showTests && qLANG.FirstWA}</td>
    res.push <td className={styles.comment} key="comment">{props.contestData.showTests && qLANG.Comment}</td>
    if props.contestData.tokenPeriod >= 0
        res.push <td className={styles.token} key="token">{qLANG.Token}</td>
    res

export class AddMessage extends React.Component
    constructor: (props) ->
        super(props)
        @useToken = @useToken.bind(this)

    useToken: () ->
        # TODO

    render: () ->
        m = @props.message
        restext = ""
        comment = ""
        outcome = ""
        if m.testres?.length
            restext = "OK"
            outcome = "OK"
            for t, n in m.testres
                if not (t.outcome in ["accepted", "accepted-not-counted"])
                    outcome = xmlToOutcome[t.outcome]
                    restext = LTEXT[outcome]
                    comment = t.comment
                    if comment.length > 50
                        comment = comment.substr(0, 50) + "..."
                    if outcome == "CE"
                        comment = ""
                    break

        points = m.points
        if m.full
            points = <font className={styles.ProbFull}>{points}</font>
        res = [
            <td className={styles.points_} key="points">{points}</td>
        ]
        res.push <td className={styles.stests_} key="stests">{if m.tests then "#{m.tests} / #{m.testsCount}" else ""}</td>
        res.push <td className={styles.firstWA_} key="firstWA"><font color={textColor[outcome]}>{restext}</font></td>
        res.push <td className={styles.comment_} key="comment">{comment}</td>
        if @props.contestData.tokenPeriod >= 0
            res.push <td className={styles.token_}  key="token">
                {m.canUseToken && <a href="#" onClick={@props.useToken}>{qLANG.UseToken}</a>}
            </td>
        res

export hasMessageDetails = () -> true

export addMessageDetailsTable = (data, m) ->
    data[qLANG.Points] = m["points"]
    if m.tests
        data[qLANG.SuccessfullTests] = m["tests"]

DataFile = (props) ->
    text = props.text
    if not text?
        text = qLANG.FileNonFoundProbablyNotCreated
    if text == ""
        text = " "
    <div className={styles.data}><pre className={styles.data}>{text}</pre></div>

export class AddMessageDetails extends React.Component
    constructor: (props) ->
        super(props)
        @useToken = @useToken.bind this

    useToken: () ->
        @TODO

    render: () ->
        m = @props.message
        <div>
            {m.canUseToken && <p><a href="#" onClick={@useToken}>{qLANG.UseToken}</a></p>}
            <p>{qLANG.ScrollToBottom}</p>
            {m.testres && <table className={styles.dtests} cellSpacing="0"><tbody>
                {m.testres.map((t)->
                    res=xmlToOutcome[t.outcome] 
                    <tr className={res} key={t.id}>
                    <td className={styles.testid}>
                        {t.id}
                    </td>
                    <td className={styles.doutcome}>
                        <font color={textColor[res]}><b><abbr title={LTEXT[res]}>{res}</abbr></b></font>
                    </td>
                    <td className={styles.dpoints}>{t.points} / {t["max-points"]}</td>
                    <td className={styles.dcomment}>
                        <div className={styles.dataNoBorder}>
                            <pre className={styles.data}>{t.comment}</pre>
                        </div>
                    </td>
                    </tr>
                )}
            </tbody></table>
            }           
            <h2>{qLANG.TestingDetails}</h2>
            <h3>{qLANG.Program}</h3>
            <DataFile text={m.source}/>
            <h3>{qLANG.CompileLog}</h3>
            <DataFile text={m.compileLog}/>
            {m.testres.map((t)->
                res=xmlToOutcome[t.outcome] 
                <div key={t.id}>
                    <h3>{"#{LANG.Test} #{t.id} | "}
                        <font color={textColor[res]}><b><abbr title={LTEXT[res]}>
                            {res}
                        </abbr></b></font>
                        {" | #{t.points} / #{t["max-points"]}"}
                    </h3>
                    {t.input && <div>
                        {qLANG.Input}
                        <DataFile text={t.input}/>
                    </div>
                    }
                    {t.output && <div>
                        {qLANG.ProgramOutput}
                        <DataFile text={t.output}/>
                    </div>
                    }
                    {t.answer && <div>
                        {qLANG.CorrectAnswer}
                        <DataFile text={t.answer}/>
                    </div>}
                    {qLANG.CheckerComment}
                    <DataFile text={t.comment}/>
                </div>
            )}
        </div>
