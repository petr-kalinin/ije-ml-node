import ConnectedComponent from '../lib/ConnectedComponent'

meOptions = 
    urls: (props) ->
        me: "me"
    timeout: 10000


export default withMe = (component) ->
    ConnectedComponent(component, meOptions)