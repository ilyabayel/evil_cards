type userInfo = {
  userName: string,
  userId: string,
}

let socket = Phoenix.Socket.make(
  "ws://localhost:4000/socket",
  Some(
    Phoenix.Socket.options(
      ~params={userName: "Ilya", userId: "ilya1234"},
      (),
    ),
  ),
)

let _ = Phoenix.Socket.onOpen(socket, () => {Js.log("Socket connection open.")})

let _ = Phoenix.Socket.onClose(socket, () => {Js.log("Socket was closed.")})

let _ = Phoenix.Socket.connect(socket)

let lobby = socket->Phoenix.Channel.make("lobby:main", Js.Obj.empty())

let _ = Phoenix.Channel.on(lobby, "room_update", (msg) => Js.log(msg))

let _ =
  lobby
  ->Phoenix.Channel.join(~timeout=1000, ())
  ->Phoenix.Push.receive(~status="ok", ~callback=params => {Js.log(params)})
  ->Phoenix.Push.receive(~status="error", ~callback=params => {Js.log(params)});