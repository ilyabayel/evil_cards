let instance = ref(Phoenix.Channel.make(SocketApi.instance, ``, ()))
let isConnected = ref(false)

let make = (socket, ~roomId, ~userName) => {
  if isConnected.contents {
    instance.contents
  } else {
    instance := Phoenix.Channel.make(socket, `room:${roomId}`, {"userName": userName})
    isConnected := true
    instance.contents
  }
}

let onRoomUpdate = (channel, ~onUpdate) => {
  let _ = Phoenix.Channel.on(channel, "room_update", (room: Room.t) => onUpdate(room))
  channel
}

let join = channel => {
  Js.log(channel)
  Phoenix.Channel.join(channel, ~timeout=1000, ())
}

let leave = channel => {
  let _ = Phoenix.Channel.push(channel, ~event="leave", ~timeout=1000, ())
  Phoenix.Channel.leave(channel, ~timeout=1000, ())
}

let startGame = () => {
  Phoenix.Channel.push(instance.contents, ~event="start_game", ())
}

let finishGame = () => {
  Phoenix.Channel.push(instance.contents, ~event="finish_game", ())
}

let startRound = () => {
  Phoenix.Channel.push(instance.contents, ~event="start_round", ())
}

let finishRound = () => {
  Phoenix.Channel.push(instance.contents, ~event="finish_round", ())
}

let startStage = () => {
  Phoenix.Channel.push(instance.contents, ~event="start_stage", ())
}

let finishStage = () => {
  Phoenix.Channel.push(instance.contents, ~event="finish_stage", ())
}

let addAnswer = (~id: string, ~text: string) => {
  Phoenix.Channel.push(
    instance.contents,
    ~event="add_answer",
    ~payload={"id": id, "text": text},
    (),
  )
}

let removeAnswer = () => {
  Phoenix.Channel.push(instance.contents, ~event="remove_answer", ())
}

let setWinner = (~playerId) => {
  Phoenix.Channel.push(instance.contents, ~event="set_winner", ~payload={"playerId": playerId}, ())
}
