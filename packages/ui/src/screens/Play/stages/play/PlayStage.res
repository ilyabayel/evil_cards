@module external styles: {..} = "./PlayStage.module.css"
let styles = styles["default"]

let handleClick = _ => {
  let _ = RoomApi.startGame(RoomContext.roomChan.contents)
}

@react.component
let make = () => {
  let (room, _setRoom) = RoomContext.useState()

  <div className={styles["play-stage"]}>
    <div className={styles["room-code"]}>
      <h3> {React.string(`Раунд 1`)} </h3>
      <QuestionCard
        title={room.round.question.title}
        body={[]}
        roundLeader={room.round.leader.name}
        selectedOption={""}
        onSelect={_ => ()}
      />
    </div>
    <div className={styles["connected-users"]}>
      <h4> {React.string(`Ждем ответов`)} </h4>
      <PlayerList players=room.players leaderboard=room.leaderboard />
    </div>
    <Button label={`Продолжить`} onClick={_ => ()} />
  </div>
}
