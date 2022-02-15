@module external styles: {..} = "./PrepareStage.module.css"
let styles = styles["default"]

let getScore = (leaderboard, id) => {
  switch Js.Dict.get(leaderboard, id) {
  | Some(score) => score
  | None => 0
  }
}

let handleClick = _ => {
  let _ = RoomApi.startGame(RoomContext.roomChan.contents)
}

@react.component
let make = () => {
  let (room, _setRoom) = RoomContext.useState()

  <div className={styles["wait-stage"]}>
    <div className={styles["room-code"]}> <RoundLeader leaderId={"0"} userId={"0"} /> </div>
    <div className={styles["connected-users"]}>
      <h3> {React.string(`Подключились`)} </h3>
      <div className={styles["user-list"]}>
        {Js.Array2.sortInPlaceWith(room.players, (p1, p2) => {
          getScore(room.leaderboard, p2.id) - getScore(room.leaderboard, p1.id)
        })
        ->Js.Array2.map(player => {
          <UserCard
            key=player.id score={getScore(room.leaderboard, player.id)} userName=player.name
          />
        })
        ->React.array}
      </div>
    </div>
    <Button label=`Начать` onClick={handleClick} />
  </div>
}
