import ConnectedComponent from '../lib/ConnectedComponent'

meOptions = 
    urls: (props) ->
        me: "me"


export default withMe = (component) ->
    ConnectedComponent(component, meOptions)