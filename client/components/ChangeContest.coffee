React = require('react')
import { withRouter } from 'react-router'
import { connect } from 'react-redux'

import Loader from '../components/Loader'

import callApi from '../lib/callApi'
import LANG from '../lib/lang'
import ConnectedComponent from '../lib/ConnectedComponent'

import FieldGroup from './FieldGroup'

import * as actions from '../redux/actions'

class ChangeContest extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            contest: props.me.contest
        @setField = @setField.bind(this)
        @changeContest = @changeContest.bind(this)

    setField: (field, value) ->
        newState = {@state...}
        newState[field] = value
        @setState(newState)

    changeContest: (event) ->
        event.preventDefault()
        await callApi "setContest", {
            contest: @state.contest
        }
        @props.reloadMyData()
        @props.history.goBack()

    render:  () ->
        <table><tbody><tr>
            <td className="loginimg"><img src="/login.bmp"/></td>
            <td>
                <h1>{LANG.ChangeContest}</h1>
                <form onSubmit={@changeContest}>
                <table><tbody>
                    <FieldGroup
                        id="contest"
                        label="Контест"
                        type="select"
                        setField={@setField}
                        state={@state}
                        options={@props.contests}/>
                </tbody></table>
                <input type="submit" value="OK"/>
                </form>
            </td>
        </tr></tbody></table>

mapStateToProps = () ->
    {}

mapDispatchToProps = (dispatch) ->
    return
        reloadMyData: () -> dispatch(actions.invalidateAllData())

options = 
    urls: (props) ->
        contests: "contests"
        me: "me"

export default withRouter(ConnectedComponent(connect(mapStateToProps, mapDispatchToProps)(ChangeContest), options))
