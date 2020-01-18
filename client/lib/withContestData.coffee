import ConnectedComponent from '../lib/ConnectedComponent'
import withMe from './withMe'

contestOptions = 
    urls: (props) ->
        contestData: "contestData/#{props.me.contest}"

export default withContestData = (component) ->
    withMe(ConnectedComponent(component, contestOptions))