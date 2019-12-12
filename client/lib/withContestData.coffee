import ConnectedComponent from '../lib/ConnectedComponent'
import withMe from './withMe'

contestOptions = 
    urls: (props) ->
        contestData: "contestData/#{props.me.contest}"
    timeout: 10000

export default withContestData = (component) ->
    withMe(ConnectedComponent(component, contestOptions))