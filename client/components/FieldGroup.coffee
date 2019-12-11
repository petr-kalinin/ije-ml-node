React = require('react')

Control = (props) ->
    if props.type == "select"
        <select name={props.id} onChange={props.onChange} value={props.value}>
            {
            res = []
            a = (x) -> res.push x
            for key, name of props.options
                a <option value={key} key={key}>{name}</option>
            res
            }
        </select>
    else
        <input type={props.type} value={props.value} onChange={props.onChange}/>

export default FieldGroup = ({ id, label, help, setField, state, options, error, props... }) =>
    onChange = (e) =>
        setField(id, e.target.value)
    value = if "value" of props then props.value else state[id]
    <tr id={id}>
        <td>{label}</td>
        <td>{`<Control {...props} value={value} onChange={onChange} name={id} options={options}/>`}</td>
    </tr>
