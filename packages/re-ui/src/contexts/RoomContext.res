let context = React.createContext((Room.empty, (_) => ()))

let useRoomState = () => {
  React.useContext(context)
}

module Provider = {
  let provider = React.Context.provider(context)

  @react.component
  let make = (~children) => {
    let (roomState, setRoomState) = React.useState(() => Room.empty)

    React.createElement(provider, {"value": (roomState, setRoomState), "children": children})
  }
}
