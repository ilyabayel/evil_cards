@module("uuid") external uuid: unit => string = "v4"

let userId = Dom_storage2.getItem(Dom_storage2.localStorage, "user.id")
let userName = Dom_storage2.getItem(Dom_storage2.localStorage, "user.name")

let user: Room.user = switch (userId, userName) {
| (Some(id), Some(name)) => {id: id, name: name}
| (Some(id), None) => {id: id, name: ""}
| (None, Some(name)) => {id: uuid(), name: name}
| (None, None) => {id: uuid(), name: ""}
}

let context = React.createContext((user, _ => ()))

let useState = () => {
  React.useContext(context)
}

module Provider = {
  let provider = React.Context.provider(context)

  @react.component
  let make = (~children) => {
    let (userState, setUserState) = React.useState(_ => user)
    let setUser = React.useCallback0(user => {
      setUserState(_ => user)
      Dom_storage2.setItem(Dom_storage2.localStorage, "user.id", user.id)
      Dom_storage2.setItem(Dom_storage2.localStorage, "user.name", user.name)
    })

    React.createElement(provider, {"value": (userState, setUser), "children": children})
  }
}
