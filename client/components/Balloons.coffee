React = require('react')

import Balloon from './Balloon'

export default Balloons = (props) -> 
    for baseColor in [0..63]
        <span key={baseColor}>
            <Balloon baseColor={baseColor}/>
            {baseColor}
        </span>
