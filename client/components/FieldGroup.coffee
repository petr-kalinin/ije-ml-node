React = require('react')

Control = ({type, id, onChange, value, options, props...}) ->
    if type == "select"
        <select name={id} onChange={onChange} value={value}>
            {
            res = []
            a = (x) -> res.push x
            for key, name of options
                a <option value={key} key={key}>{name}</option>
            res
            }
        </select>
    else if type == "textarea"
        `<textarea id={id} type={type} value={value} onChange={onChange} {...props}/>`
    else
        `<input id={id} type={type} value={value} onChange={onChange} {...props}/>`

export SimpleField = ({ id, label, help, setField, state, options, error, props... }) =>
    onChange = (e) =>
        setField(id, e.target.value)
    value = if "value" of props then props.value else state[id]
    `<Control {...props} value={value} onChange={onChange} id={id} options={options}/>`

export default FieldGroup = (props) =>
    <tr key={props.id}>
        <td>{props.label}</td>
        <td>{`<SimpleField {...props}/>`}</td>
    </tr>
