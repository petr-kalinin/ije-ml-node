React = require('react')
import { withRouter } from 'react-router'
import { connect } from 'react-redux'

import Loader from '../components/Loader'

import callApi from '../lib/callApi'
import LANG from '../lib/lang'
import ConnectedComponent from '../lib/ConnectedComponent'

import FieldGroup from './FieldGroup'

import * as actions from '../redux/actions'

class Login extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            username: ""
            password: ""
            contest: props.me.contest
        @setField = @setField.bind(this)
        @tryLogin = @tryLogin.bind(this)

    setField: (field, value) ->
        newState = {@state...}
        newState[field] = value
        @setState(newState)

    tryLogin: (event) ->
        event.preventDefault()
        newState = {
            @state...
            loading: true
        }
        @setState(newState)
        try
            data = await callApi "login", {
                username: @state.username,
                password: @state.password,
                contest: @state.contest
            }
            if not data.logged
                throw "Error"
            @props.reloadMyData()
            @props.history.goBack()
        catch
            data =
                error: true
                message: "Неверный логин или пароль"
            newState = {
                @state...,
                loading: false,
                data...
            }
            @setState(newState)


    render:  () ->
        canSubmit = @state.username && @state.password && !@state.loading

        <table><tbody><tr>
            <td className="loginimg"><img src="/login.bmp"/></td>
            <td>
                <h1>{LANG.LogIn}</h1>
                <form onSubmit={@tryLogin}>
                {
                if not @state.loading
                    <table><tbody>
                        <FieldGroup
                            id="username"
                            label="Логин"
                            type="text"
                            setField={@setField}
                            state={@state}/>
                        <FieldGroup
                            id="password"
                            label="Пароль"
                            type="password"
                            setField={@setField}
                            state={@state}/>
                        <FieldGroup
                            id="contest"
                            label="Контест"
                            type="select"
                            setField={@setField}
                            state={@state}
                            options={@props.contests}/>
                    </tbody></table>
                else
                    <Loader/>
                }
                {
                    @state.message && <p><b>{@state.message}</b></p>
                }
                <input type="submit" disabled={!canSubmit} value="OK"/>
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

export default withRouter(ConnectedComponent(connect(mapStateToProps, mapDispatchToProps)(Login), options))
