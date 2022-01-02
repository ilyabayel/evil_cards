let channel = ref(Phoenix.Channel.make(SocketApi.instance, ``, ()))

let join = (~roomId, ~userName, ~onUpdate) => {
  channel := Phoenix.Channel.make(SocketApi.instance, `room:${roomId}`, {"userName": userName})
  let _ = Phoenix.Channel.on(channel.contents, "room_update", onUpdate)

  channel.contents->Phoenix.Channel.join(~timeout=1000, ())
}

let startGame = () => {
  Phoenix.Channel.push(channel.contents, ~event="start_game", ())
}

let finishGame = () => {
  Phoenix.Channel.push(channel.contents, ~event="finish_game", ())
}

let startRound = () => {
  Phoenix.Channel.push(channel.contents, ~event="start_round", ())
}

let finishRound = () => {
  Phoenix.Channel.push(channel.contents, ~event="finish_round", ())
}

let startStage = () => {
  Phoenix.Channel.push(channel.contents, ~event="start_stage", ())
}

let finishStage = () => {
  Phoenix.Channel.push(channel.contents, ~event="finish_stage", ())
}

let addAnswer = (~id: string, ~text: string) => {
  Phoenix.Channel.push(channel.contents, ~event="add_answer", ~payload={"id": id, "text": text}, ())
}

let removeAnswer = () => {
  Phoenix.Channel.push(channel.contents, ~event="remove_answer", ())
}

let setWinner = (~playerId) => {
  Phoenix.Channel.push(channel.contents, ~event="set_winner", ~payload={"playerId": playerId}, ())
}
