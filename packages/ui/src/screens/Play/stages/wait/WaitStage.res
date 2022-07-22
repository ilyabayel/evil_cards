@module external styles: {..} = "./WaitStage.module.css"
let styles = styles["default"]

let getScore = (leaderboard, id) => {
  switch Js.Dict.get(leaderboard, id) {
  | Some(score) => score
  | None => 0
  }
}

let handleClick = _ => {
  let _ =
    RoomApi.startGame(RoomContext.roomChan.contents)->Phoenix.Push.receive(
      ~status="ok",
      ~callback=_ => Js.log("Ok"),
    )
}

@react.component
let make = () => {
  let (room, _setRoom) = RoomContext.useState()
  let (user, _setUser) = UserContext.useState()

  <div className={styles["wait-stage"]}>
    <div className={styles["room-code"]}>
      <h2> {React.string(`Код комнаты`)} </h2>
      <h1> {React.string(Int.toString(room.code))} </h1>
    </div>
    <div className={styles["connected-users"]}>
      <h3> {React.string(`Подключились`)} </h3>
      <PlayerList
        leaderboard=room.leaderboard
        players=room.players
        highlightedPlayers={Array.map(room.round.answers, answer => answer.player)}
        leader={room.round.leader}
      />
    </div>
    {switch room.host.id == user.id {
    | true => <Button label={`Начать`} onClick={handleClick} />
    | false => <> </>
    }}
  </div>
}
