type userInfo = {
  userId: string
}

let userId = switch Dom.Storage2.getItem(Dom.Storage2.localStorage, "user.id") {
| None => {
  let newUuid = Uuid.V4.make()
  Dom.Storage2.setItem(Dom.Storage2.localStorage, "user.id", newUuid)
  newUuid
}
| Some(v) => v
}



let instance = Phoenix.Socket.make(
  `ws://${Window.hostname}:4000/socket`,
  Some(
    Phoenix.Socket.options(
      ~params={"userId": userId},
      (),
    ),
  ),
)

let _ = Phoenix.Socket.onOpen(instance, () => {Js.log("Socket connection open.")})
let _ = Phoenix.Socket.onClose(instance, () => {Js.log("Socket was closed.")})
let _ = Phoenix.Socket.connect(instance)