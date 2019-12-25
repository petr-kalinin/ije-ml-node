React = require('react')
import LANG from '../lib/lang'
import getQacm from '../qacm/getQacm'

import withContestData from '../lib/withContestData'
import ConnectedComponent from '../lib/ConnectedComponent'

import styles from './Standings.css'


class Standings extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            showTime: false
        @showTime = @showTime.bind this

    showTime: (show) ->
        (e) =>
            e.preventDefault()
            @setState
                showTime: show
            return false
    
    render: () ->
        qacm = getQacm(@props.contestData.qacm).standings
        TableHeaders = qacm.TableHeaders
        AddInfo = qacm.AddInfo
        <div>
            <h1>{LANG.CurrentStandings}</h1>
            {
            qacm.canShowTime() && <div className={styles.timeq}>
                <a href="#" onClick={@showTime(not @state.showTime)}>{if @state.showTime then LANG.HideSuccessTimes else LANG.ShowSuccessTimes}</a>
            </div>
            }
            <table width="100%" cellSpacing="0" cellPadding="0" className={styles.monitor}>
            <tbody>
            <tr className={styles.head}>
                <td className={styles.IdHead}>{LANG.Id}</td>
                <td className={styles.PartyHead}>{LANG.Party}</td>
                <TableHeaders standings={@props.standings} me={@props.me} contestData={@props.contestData}/>
            </tr>

            {
            @props.standings.map((p) =>
                <tr className={if p.id == @props.me.username then styles.my else qacm.TeamClass(p)} key={p.id}>
                    <td className={styles.Id}>{p.id}</td>
                    <td className={styles.Party}>{p.name}</td>
                    <AddInfo row={p} contestData={@props.contestData}/>
                </tr>
            )
            }
            </tbody></table>
        </div>

options =
    urls: (props) ->
        standings: "standings/#{props.me.contest}"
    timeout: 10000

export default withContestData(ConnectedComponent(Standings, options))