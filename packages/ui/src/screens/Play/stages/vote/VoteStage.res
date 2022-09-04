@module external styles: {..} = "./VoteStage.module.css"
let styles = styles["default"]

@react.component
let make = () => {
  let (room, _setRoom) = RoomContext.useState()
  let (user, _setUser) = UserContext.useState()
  let isLeader = room.round.leader.id == user.id
  let (selectedAnswerPlayerId, setSelectedAnswerPlayerId) = React.useState(() => "")
  let handleNext = (_) => {
    let _ = RoomApi.setWinner(RoomContext.roomChan.contents, ~playerId=selectedAnswerPlayerId)
    ()
  }

  <div className={styles["vote-stage"]}>
    <div className={styles["heading"]}>
      <h2> {React.string(`Раунд ${Int.toString(room.round.number)}`)} </h2>
    </div>
    <div className={styles["answers"]}>
      {Array.map(room.round.answers, answer => {
        <VariantCard
          body={VoteStageHooks.initAnswer(answer)}
          key=answer.question.id
          title={answer.question.title}
          isSelected={selectedAnswerPlayerId == answer.player.id}
          onClick={_ => setSelectedAnswerPlayerId((_) => answer.player.id)}
          disabled={!isLeader}
        />
      })->React.array}
    </div>
    {if isLeader {
      <div className={styles["button-wrapper"]}>
        <Button label=`Продолжить` onClick={handleNext} disabled={selectedAnswerPlayerId==""}/>
      </div>
    } else {
      <></>
    }}
  </div>
}
