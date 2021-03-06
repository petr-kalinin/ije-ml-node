React = require('react')

import LANG from '../lib/lang'
import checkMonitorTime from '../lib/checkMonitorTime'

import ConnectedComponent from '../lib/ConnectedComponent'
import withMe from '../lib/withMe'
import withContestData from '../lib/withContestData'

showstat = (name, stat) ->
    <div key={name}>
        <h1>{LANG[name]}</h1>
        <table><tbody>
        {
        res = []
        a = (x) -> res.push x
        for key, value of stat
            a <tr key={key}>
                <td>{LANG[key] || key}:</td><td>{value}</td>
            </tr>
        res
        }
        </tbody></table>
    </div>

Index = (props) ->
    cstat =
        ContestName: props.contestData.title
        MonitorMessagesTime: (if checkMonitorTime(props.contestData) then "" else "*") + props.contestData.time
        ContestLength: props.contestData.length
        ContestStatus: if checkMonitorTime(props.contestData) then props.contestData.status else <span><b>{LANG.StrangeMonitorTime}</b> ({LANG.monitorStatus}: {props.contestData.status})</span>
        NumberOfProblems: props.contestData.problemsCount
        NumberOfTeams: props.contestData.partiesCount

    res = []
    res.push showstat("Contest", cstat);

    statements = {}
    if typeof props.contestData.statements == "string"
        statements[props.contestData.title] = <a href='/api/statements/0' target="_blank">{LANG.Statements}</a>
    else if props.contestData.statements
        for key, value of props.contestData.statements
            statements[key] = <a href="/api/statements/#{key}" target="_blank">{props.contestData.problems[key].name}</a>

    if Object.keys(statements).length
        res.push showstat("Statements", statements)

    res

export default withContestData(Index)
