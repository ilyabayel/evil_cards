@module external styles: {..} = "./ResultStage.module.css"
let styles = styles["default"]

let finishRound = _ => {
  let _ = RoomApi.finishRound(RoomContext.roomChan.contents)
  let _ = RoomApi.startRound(RoomContext.roomChan.contents)
}

let addOptionsToRightPlaces = (questionBody: array<QuestionCard.bodyPart>, options: array<Room.answerOption>) => {
  let counter = ref(0)
  Array.map(questionBody, bodyPart => switch bodyPart {
  | QuestionCard.Option((i, _)) => {
    QuestionCard.Option((i, switch Array.get(options, counter.contents) {
    | Some(answerOption) => {
      counter := counter.contents + 1
      answerOption
    }
    | None => {id: "", text: "_____"}
    }))}
  | default => default
  })
}

@react.component
  let make = () => {
    let (room, _) = RoomContext.useState()
    let (user, _) = UserContext.useState()
    let (questionBody, setQuestionBody) = PlayStageHooks.useAnswer(room.round.winner.question.text)

    React.useEffect0(() => {
      setQuestionBody(_ => {
        addOptionsToRightPlaces(questionBody, room.round.winner.options)
      })
      None
    })

    let isUserRoundLeader = user.id == room.round.leader.id

    <div className={styles["result-stage"]}>
      <div className={styles["answer-wrapper"]}>
        <h3> {React.string(`Раунд ${Int.toString(room.round.number)}`)} </h3>
        <QuestionCard
          title={room.round.question.title}
          body={questionBody}
          roundLeader={room.round.leader.name}
          selectedOption=""
          onSelect={_ => ()}
        />
      </div>
      <div className={styles["players"]}>
        <h4> {React.string(`Ждем ответов`)} </h4>
        <PlayerList
          players=room.players
          leaderboard=room.leaderboard
          highlightedPlayers=Array.map(room.round.answers, answer => answer.player)
          leader=room.round.leader
        />
      </div>
      <Button
        label=`Продолжить`
        onClick=finishRound
        disabled={!isUserRoundLeader}
      />
    </div>
  }