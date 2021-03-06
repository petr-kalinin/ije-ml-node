React = require('react')
import { Link } from 'react-router-dom'
import { withRouter } from 'react-router'

import LANG from '../lib/lang'
import getQacm from '../qacm/getQacm'

import withContestData from '../lib/withContestData'
import ConnectedComponent from '../lib/ConnectedComponent'

import styles from './MessageDetails.css'

BoldIfNeeded = (props) ->
    if props.makebold
        <b>{props.children}</b>
    else
        props.children

class MessageDetails extends React.Component
    render: () ->
        if not @props.message.id
            return null
        qacm = getQacm(@props.contestData.qacm).messages
        m = @props.message
        data =
            Time: m["time"]
            Problem: "#{m.problem}: #{@props.contestData.problems[m.problem].name}"
        if @props.me.admin
            data.Party = "#{m.party}: #{@props.contestData.parties[m.party].name}"
        qacm.addMessageDetailsTable(data, m)        
        AddMessageDetails = qacm.AddMessageDetails
        <div>
            <h1>{LANG.MessageDetails}</h1>
            <table className={styles.msgdetails}><tbody>
                {
                res = []
                a = (x) -> res.push(x)
                for key, value of data
                    console.log key, value, value.makebold
                    a <tr key={key}>
                        <td className={styles.msgleft}><BoldIfNeeded makebold={value.makebold}>{LANG[key] || key}:</BoldIfNeeded></td>
                        <td className={styles.msgright}><BoldIfNeeded makebold={value.makebold}>{value.text || value}</BoldIfNeeded></td>
                    </tr>
                res
                }
            </tbody></table>
            <AddMessageDetails message={m}/>
        </div>

options =
    urls: (props) ->
        message: "message/#{props.me.contest}/#{props.match.params.id}"
        standings: "standings/#{props.me.contest}"

export default withRouter(withContestData(ConnectedComponent(MessageDetails, options)))