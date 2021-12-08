let context = React.createContext(Room.empty)

module Provider = {
  let provider = React.Context.provider(context)

  @react.component
  let make = (~value, ~children) => {
    React.createElement(provider, {"value": value, "children": children})
  }
}

let refValue = ref(Room.empty)
let value = refValue.contents

let useRoomState = () => (value, (newValue) => refValue := newValue)