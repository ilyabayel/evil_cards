type userInfo = {
  userName: string,
  userId: string,
}

let instance = Phoenix.Socket.make(
  "ws://localhost:4000/socket",
  Some(
    Phoenix.Socket.options(
      ~params={userName: "Ilya", userId: "ilya1234"},
      (),
    ),
  ),
)

let _ = Phoenix.Socket.onOpen(instance, () => {Js.log("Socket connection open.")})
let _ = Phoenix.Socket.onClose(instance, () => {Js.log("Socket was closed.")})
let _ = Phoenix.Socket.connect(instance)