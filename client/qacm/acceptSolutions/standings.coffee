React = require('react')

import styles from './standings.css'
import qLANG from './lang'
import Balloon from '../../components/Balloon'

export TableHeaders = (props) -> 
    mySolved = {}
    for row in props.standings
        if row.id == props.me.username
            for key, _ of props.contestData.problems
                if row[key]?.full
                    mySolved[key] = true
    result = []
    for key, problemData of props.contestData.problems
        result.push <td className={styles.ProblemHead} key={key}>
            {mySolved[key] && <Balloon id={key}/>}
            {key}
        </td>
    if props.contestData.calculatePoints
        result.push <td className={styles.PointsHead} key="_pts">{qLANG.Pts}</td>
    else
        result.push <td className={styles.FullHead} key="_full">{qLANG.Full}</td>
    result

export AddInfo = (props) -> 
    result = []
    for key, _ of props.contestData.problems
        r = props.row[key]
        pts = r.points
        result.push <td className={if r.full then styles.ProbFull else if r.attempts then styles.ProbNotFull else styles.No} key={key}>
            {if r.attempts then pts else " "}
            <br/>
            {if r.attempts == 1 then "+" else if r.attempts < 0 then r.attempts else if r.attempts > 0 then "+#{r.attempts-1}" else "."}
        </td>
    if props.contestData.calculatePoints
        result.push <td className={styles.Points} key="_pts">{props.row.points}</td>
    else
        result.push <td className={styles.Full} key="_full">{props.row.full}</td>
    result

export canShowTime = () -> false
export TeamClass = (p) -> styles["team#{p.color}"]