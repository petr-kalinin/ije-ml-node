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
        {props.me.admin && <td className={styles.party_}>{m.party}</td>}
        <td className={styles.time_}>{m.time}</td>
        <td className={styles.prob_}>{m.prob}</td>
        <AddMessage/>
    </tr>

TableHeader = (props) ->
    AddHeader = props.qacm.AddHeader
    <tr>
        {props.me.admin && <td className={styles.party}>&nbsp;</td>}
        <td className={styles.time}>{LANG.Time}</td>
        <td className={styles.prob}>{LANG.Problem}</td>
        <AddHeader/>
    </tr>

NoSubmissions = (props) ->
    <tr><td colSpan={props.columns} className={styles.nosubmissions}>{LANG.NoSubmissions}</td></tr>

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
        columns += 2
        ProbHeader = qacm.ProbHeader
        <div>
            <h1>{LANG.Messages}</h1>
            <GlobalHeader/>
            {qacm.hasMessageDetails() && <font className={styles.msgdetails}>{LANG.ClickOnMessageTime}</font>}
            <div className={styles.sort}>
                {LANG.SortBy} {" "}
                {@state.sortByTime && <b>{LANG.time}</b> || <a href="#" onClick={@setSort(true)}>{LANG.time}</a>}
                {" / "}
                {not @state.sortByTime && <b>{LANG.problem}</b> || <a href="#" onClick={@setSort(false)}>{LANG.problem}</a>}
            </div>
            {if @state.sortByTime
                <table className={styles.tests} cellSpacing="0"><tbody>
                <TableHeader me={@props.me} qacm={qacm}/>
                {@props.messages.map((m) => <Message message={m} me={@props.me} qacm={qacm} key={m.id}/>)}
                {@props.messages.length == 0 && <NoSubmissions columns={columns}/>}
                </tbody></table>
            else        
                <div>    
                <table className={styles.tests_} cellSpacing="0"><tbody>
                <TableHeader me={@props.me} qacm={qacm}/>
                </tbody></table>
                {
                    res = []
                    a = (x) -> res.push x
                    for id, prob of @props.contestData.problems
                        a <div key={id}>
                            <ProbHeader prob={prob}/>
                            <table className={styles.tests} cellSpacing="0"><tbody>
                            {
                                rr = []
                                aa = (x) -> rr.push x
                                was = false
                                for m in @props.messages
                                    if m.prob == prob.id
                                        was = true
                                        aa <Message message={m} me={@props.me} qacm={qacm} key={m.id}/>
                                if not was
                                    aa <NoSubmissions columns={columns} key="_no"/>
                                rr
                            }
                            </tbody></table>
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