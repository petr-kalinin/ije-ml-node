React = require('react')
PromiseFileReader = require('promise-file-reader')

import { Link } from 'react-router-dom'

import FieldGroup, {SimpleField} from './FieldGroup'
import Loader from './Loader'

import callApi, {callApiWithBody} from '../lib/callApi'
import ConnectedComponent from '../lib/ConnectedComponent'
import LANG from '../lib/lang'
import withContestData from '../lib/withContestData'

class SubmitForm extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            lang_id: '_no'
            prob_id: '_no'
            code: ''
        @setField = @setField.bind(this)
        @submit = @submit.bind(this)

    setField: (field, value) ->
        newState = {@state...}
        if field == "file"
            newState.wasFile = true
            if @state.lang_id == "_no"
                for key, _ of @props.contestData.languages 
                    if value.endsWith(".#{key}")
                        newState["lang_id"] = key
        else  # file input is not controlled
            newState[field] = value
        @setState(newState)

    submit: (event) ->
        event.preventDefault()
        newState = {
            @state...
            submit:
                loading: true
        }
        @setState(newState)
        try
            if @state.code 
                code = Array.from(@state.code)
            else
                fileName = document.getElementById("file").files[0]
                fileText = await PromiseFileReader.readAsArrayBuffer(fileName)
                code = Array.from(new Uint8Array(fileText))
            dataToSend =
                language: @state.lang_id
                problem: @state.prob_id
                code: code 
            url = "submit"
            data = await callApi url, dataToSend

            if data.submit
                data =
                    submit:
                        result: true
                @props.reloadSubmitList()
            else if data.error == "no_response"
                data = 
                    submit:
                        error: true
                        message: LANG.NoResponseFromIJE
            else
                throw ""
        catch
            data =
                submit:
                    error: true
                    message: "Неопознанная ошибка"
        newState = {
            @state...
            submit: data.submit
        }
        @setState(newState)

    render: () ->
        canSubmit = (not @state.submit?.loading) and (@state.wasFile or @state.code.length) and (@state.lang_id != "_no") and (@state.prob_id != "_no")
        problems = {'_no': ''}
        for key, value of @props.contestData.problems
            problems[key] = "#{key}: #{value.name}"
        langs = {'_no': ''}
        for key, value of @props.contestData.languages
            langs[key] = "#{key}: #{value}"

        <div>
        {@state.submit? || <form onSubmit={@submit}>
            <h1>{LANG.Submit}</h1>
                <div>
                    <table><tbody>
                        <FieldGroup
                            id="prob_id"
                            label={LANG.Problem}
                            type="select"
                            setField={@setField}
                            state={@state}
                            options={problems}/>
                        <FieldGroup
                            id="lang_id"
                            label={LANG.Language}
                            type="select"
                            setField={@setField}
                            state={@state}
                            options={langs}/>
                    </tbody></table>
                    {LANG.ProgramText}<br/>
                    <SimpleField
                        id="code"
                        type="textarea"
                        cols="80"
                        rows="15"
                        wrap="off"
                        setField={@setField}
                        state={@state} />
                    <br/><b>{LANG.OR}</b><br/>
                    {LANG.FileWithSolution}<br/>
                    <SimpleField
                        id="file"
                        label=""
                        type="file"
                        setField={@setField}
                        state={@state}/>
                    <p>
                    <input type="submit" disabled={!canSubmit} value="Submit!"/>
                    </p>
                </div>
        </form>}
        {@state.submit?.loading && <Loader />}
        {
        if @state.submit?.result
            <div>
            <h1>LANG.SubmitSuccessfull</h1>
            {LANG.YourSolutionHasBeen}<br/>;
            {LANG.YouCanSee(<Link to="/messages">{LANG.Messages}</Link>)}
            </div>
        }
        {
        if @state.submit?.error
            <div>
            <h1>{LANG.SubmitFailed}</h1>
            {@state.submit.message}
            </div>
        }
        </div>

export default withContestData(SubmitForm)
