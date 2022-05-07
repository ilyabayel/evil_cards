let make = (socket, ~roomId, ~userName) => {
  Phoenix.Channel.make(socket, `room:${roomId}`, {"userName": userName})
}

let onRoomUpdate = (channel, ~onUpdate) => {
  let _ = Phoenix.Channel.on(channel, "room_update", (room: Room.t) => onUpdate(room))
  channel
}

let join = channel => {
  Phoenix.Channel.join(channel, ~timeout=1000, ())
}

let leave = channel => {
  let _ = Phoenix.Channel.push(channel, ~event="leave", ~timeout=1000, ())
  Phoenix.Channel.leave(channel, ~timeout=1000, ())
}

let startGame = (channel) => {
  Phoenix.Channel.push(channel, ~event="start_game", ~payload=None, ())
}

let finishGame = (channel) => {
  Phoenix.Channel.push(channel, ~event="finish_game", ~payload=None, ())
}

let startRound = (channel) => {
  Phoenix.Channel.push(channel, ~event="start_round", ~payload=None, ())
}

let finishRound = (channel) => {
  Phoenix.Channel.push(channel, ~event="finish_round", ~payload=None, ())
}

let startStage = (channel) => {
  Phoenix.Channel.push(channel, ~event="start_stage", ~payload=None, ())
}

let finishStage = (channel) => {
  Phoenix.Channel.push(channel, ~event="finish_stage", ~payload=None, ())
}

let addAnswer = (channel, ~id: string, ~text: string) => {
  Phoenix.Channel.push(
    channel,
    ~event="add_answer",
    ~payload={"id": id, "text": text},
    (),
  )
}

let removeAnswer = (channel) => {
  Phoenix.Channel.push(channel, ~event="remove_answer", ())
}

let setWinner = (channel, ~playerId) => {
  Phoenix.Channel.push(channel, ~event="set_winner", ~payload={"playerId": playerId}, ())
}
