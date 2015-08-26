import {Socket} from "phoenix"

// let socket = new Socket("/ws")
// socket.connect()
// let chan = socket.chan("topic:subtopic", {})
// chan.join().receive("ok", chan => {
//   console.log("Success!")
// })

let App = {
}

export default App

var HelloWorld = React.createClass({
  render() {
    return <h1>Habemus React.js</h1>
  }
})

React.render(<HelloWorld />, document.getElementById('app'))
