let emptyRoomChan = SocketApi.instance->Phoenix.Channel.make("room:empty", Js.Obj.empty())
let roomChan = ref(emptyRoomChan)
let context = React.createContext((Room.empty, _ => ()))

let useState = () => {
  React.useContext(context)
}

/**
 * Simplifies connection to room
 *
 * let connect = RoomContext.useConnect()
 * connect("room-id")
 */
let useConnect = () => {
  let (_, setRoomState) = useState()
  let (userState, _) = UserContext.useState()

  let updateRoom = room => {
    roomChan := room
    room
  }

  roomId => {
    if roomChan.contents.topic != "room:empty" && roomChan.contents.topic != `room:${roomId}` {
      Phoenix.Channel.off(roomChan.contents, "room_update", ())
      let _ = Phoenix.Channel.leave(roomChan.contents)
      roomChan := emptyRoomChan
    } else if roomChan.contents.topic != `room:${roomId}` {
      let _ =
        RoomApi.make(SocketApi.instance, ~roomId, ~userName={userState.name})
        ->RoomApi.onRoomUpdate(~onUpdate=room => {
          setRoomState(room)
        })
        ->updateRoom
        ->RoomApi.join
        ->Phoenix.Push.receive(~status="ok", ~callback=_ => {
          RescriptReactRouter.push("play")
        })
        ->Phoenix.Push.receive(~status="error", ~callback=msg => Js.log(msg))
        ->Phoenix.Push.receive(~status="timeout", ~callback=msg => Js.log(msg))
      Dom.Storage2.setItem(Dom.Storage2.localStorage, "room.id", roomId)
    }
  }
}

/**
 * Simplifies reconnection to room.
 * It will only work, if you'd set "room.id" in localStorage
 *
 * RoomContext.useReconnect()
 */
let useReconnect = () => {
  let connect = useConnect()
  let _ = switch Dom.Storage2.getItem(Dom.Storage2.localStorage, "room.id") {
  | Some(roomId) => connect(roomId)
  | None => ()
  }
}

module Provider = {
  let provider = React.Context.provider(context)

  @react.component
  let make = (~children) => {
    let (roomState, setRoomState) = React.useState(() => Room.empty)

    let setRoomState = (room: Room.t) => {
      Dom.Storage2.setItem(Dom.Storage2.localStorage, "room.id", room.id)
      setRoomState(_ => room)
    }

    React.createElement(provider, {"value": (roomState, setRoomState), "children": children})
  }
}
