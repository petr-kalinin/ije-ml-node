React = require('react')
import { CometSpinLoader } from 'react-css-loaders';

Loader = (props) ->
    <div>
        <CometSpinLoader {...props}/>
    </div>

export default Loader