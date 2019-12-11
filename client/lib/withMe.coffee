import ConnectedComponent from '../lib/ConnectedComponent'

options = 
    urls: (props) ->
        me: "me"
        
    timeout: 10000

export default withMe = (component) ->
    ConnectedComponent(component, options)