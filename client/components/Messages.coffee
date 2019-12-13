React = require('react')
import { Link } from 'react-router-dom'

import LANG from '../lib/lang'
import getQacm from '../qacm/getQacm'


import withContestData from '../lib/withContestData'
import ConnectedComponent from '../lib/ConnectedComponent'

import styles from './Messages.css'

MessageLine = (props) ->
    m = props.message
    time = m.time
    if props.qacm.hasMessageDetails()
        time=<Link to="/messageDetails/#{m[id]}">{time}</Link>
    AddMessage = m.qacm.AddMessage
    <tr>
        {props.me.admin && <td class={styles.party_}>{m.party}</td>}
        <td class={styles.time_}>{m.time}</td>
        <td class={styles.prob_}>{m.prob}</td>
        <AddMessage/>
    </tr>

class Messages extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            sortByTime: true
        @setSort = @setSort.bind this

    setSort: (sort) ->
        (e) =>
            e.preventDefault()
            @setState
                sortByTime: sort
            return false
    
    render: () ->
        qacm = getQacm(@props.contestData.qacm).messages
        GlobalHeader = qacm.GlobalHeader
        columns = qacm.columns()
        if @props.me.admin
            columns++            
        AddHeader = qacm.AddHeader
        colspan = 3  # TODO
        <div>
            <h1>{LANG.Messages}</h1>
            <GlobalHeader/>
            {qacm.hasMessageDetails() && <font className={styles.msgdetails}>LANG.ClickOnMessageTime</font>}
            <div className={styles.sort}>
                {LANG.SortBy}
                {@state.sortByTime && <b>LANG.time</b> || <a href="#" onClick={@setSort(true)}>LANG.time</a>}
                / 
                {not @state.sortByTime && <b>LANG.problem</b> || <a href="#" onClick={@setSort(false)}>LANG.problem</a>}
            </div>
            {if @state.sortByTime
                <table className={styles.tests} cellSpacing="0"><tbody>
                <tr>
                    {@props.me.admin && <td className={styles.party}>&nbsp;</td>}
                    <td className={styles.time}>{LANG.Time}</td><td class={styles.prob}>{LANG.Problem}</td>
                    <AddHeader/>
                </tr>
                {@props.messages.map((m) => <Message message={m} me={@props.me} qacm={qacm} key={m.id}/>)}
                {m.length == 0 && <tr><td colSpan={colspan} className={styles.nosubmissions}>{LANG.NoSubmissions}</td></tr>}
                </tbody></table>
            else        
                <div>    
                <table className={styles.tests_} cellSpacing="0"><tbody>
                <tr>
                    {@props.me.admin && <td className={styles.party}>&nbsp;</td>}
                    <td className={styles.time}>{LANG.Time}</td><td class={styles.prob}>{LANG.Problem}</td>
                    <AddHeader/>
                </tr>
                </tbody></table>
                {
                    res = []
                    a = res.push
                    for id, prob of @props.contestData.problems
                        a <div key={id}>
                            <ProbHeader prob={prob}/>
                            <table className={styles.tests} cellSpacing="0">
                            {
                                rr = []
                                aa = rr.push
                                was = false
                                for m in @props.messages
                                    if m.prob == prob.id
                                        was = true
                                        aa <Message message={m} me={@props.me} qacm={qacm} key={m.id}/>
                                if not was
                                    aa <tr><td colSpan={colspan} className={styles.nosubmissions}>{LANG.NoSubmissions}</td></tr>
                                rr
                            }
                            </table>
                        </div>
                    res
                }
                </div>
            }
        </div>

options =
    urls: (props) ->
        messages: "messages/#{props.me.contest}"

export default withContestData(ConnectedComponent(Messages, options))