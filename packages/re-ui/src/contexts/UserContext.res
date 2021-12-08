@module("uuid") external uuid: () => string = "v4"

let emptyUser: Room.user = {id: uuid(), name: ""}

let context = React.createContext(emptyUser)

module Provider = {
  let provider = React.Context.provider(context)

  @react.component
  let make = (~value, ~children) => {
    React.createElement(provider, {"value": value, "children": children})
  }
}

let refValue = ref(emptyUser)
let value = refValue.contents

let useState = () => (value, (newValue) => refValue := newValue)