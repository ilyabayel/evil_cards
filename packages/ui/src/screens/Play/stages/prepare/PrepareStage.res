@module external styles: {..} = "./PrepareStage.module.css"
let styles = styles["default"]

let getScore = (leaderboard, id) => {
  switch Js.Dict.get(leaderboard, id) {
  | Some(score) => score
  | None => 0
  }
}

let handleClick = _ => {
  let _ = RoomApi.startStage(RoomContext.roomChan.contents)
}

@react.component
let make = () => {
  let (room, _setRoom) = RoomContext.useState()
  let (user, _setUser) = UserContext.useState()

  <div className={styles["prepare-stage"]}>
    <ExitButton/>
    <div className={styles["room-code"]}>
      <h2> {React.string(`Раунд ${Int.toString(room.round.number)}`)} </h2>
      <RoundLeader leader={room.round.leader} userId={user.id} />
    </div>
    <div className={styles["connected-users"]}>
      <h3> {React.string(`Подключились`)} </h3>
      <PlayerList
        players=room.players
        leaderboard=room.leaderboard
        highlightedPlayers={Array.map(room.round.answers, answer => answer.player)}
        leader={room.round.leader}
      />
    </div>
    {switch room.round.leader.id == user.id {
    | true =>
      <div className={styles["button-wrapper"]}>
        <Button label={`Начать`} onClick={handleClick} />
      </div>
    | false => <> </>
    }}
  </div>
}
