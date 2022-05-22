let lobby = SocketApi.instance->Phoenix.Channel.make("lobby:main", Js.Obj.empty())

let _ =
  lobby
  ->Phoenix.Channel.join(~timeout=1000, ())
  ->Phoenix.Push.receive(~status="ok", ~callback=params => {Js.log(params)})
  ->Phoenix.Push.receive(~status="error", ~callback=params => {Js.log(params)})

let createRoom = (
  ~host: Room.user,
  ~roomInfo: {"rounds_per_player": int, "round_duration": int},
  ~onRecieve,
) => {
  lobby
  ->Phoenix.Channel.push(
    ~event="create_room",
    ~payload={"host": host, "roomInfo": roomInfo},
    ~timeout=1000,
    (),
  )
  ->Phoenix.Push.receive(~status="ok", ~callback=(s: string) => onRecieve(s))
  ->Phoenix.Push.receive(~status="error", ~callback=s => Js.log(s))
  ->Phoenix.Push.receive(~status="timeout", ~callback=s => Js.log(s))
}

let getRoomByCode = (~code: string, ~onRecieve) => {
  lobby
  ->Phoenix.Channel.push(
    ~event="get_room_by_code",
    ~payload={"code": Belt.Int.fromString(code)},
    ~timeout=1000,
    (),
  )
  ->Phoenix.Push.receive(~status="ok", ~callback=(s: string) => onRecieve(s))
  ->Phoenix.Push.receive(~status="error", ~callback=s => Js.log(s))
  ->Phoenix.Push.receive(~status="timeout", ~callback=s => Js.log(s))
}

let onRoomUpdate = callback => {
  lobby->Phoenix.Channel.on("room_update", (room: Room.t) => callback(room))
}
