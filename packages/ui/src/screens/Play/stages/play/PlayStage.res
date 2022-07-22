@module external styles: {..} = "./PlayStage.module.css"
let styles = styles["default"]

let handleClick = _ => {
  let _ = RoomApi.finishRound(RoomContext.roomChan.contents)
}

let initOption = _ => {
  let initialOption: Room.answerOption = {id: "", text: ""}
  initialOption
}

let sendAnswer = (answer, _) => {
  let options = Array.reduce(answer, [], (acc, bodyPart) => {
    switch bodyPart {
    | QuestionCard.Option((_, option)) => Array.concat(acc, [option])
    | QuestionCard.Statement(_) => acc
    }
  })
  let _ = RoomApi.addAnswer(RoomContext.roomChan.contents, options)
}

let finishStage = (_) => {
  let _ = RoomApi.finishStage(RoomContext.roomChan.contents)
}

module LeaderView = {
  @react.component
  let make = () => {
    let (room, _) = RoomContext.useState()
    let (questionBody, setQuestionBody) = PlayStageHooks.useAnswer(room.round.question.text)
    let (selectedOption, setSelectedOption) = React.useState(initOption)
    let allPlayersAnswered =
      room.players
      ->Array.keep(player => player.id != room.round.leader.id)
      ->Array.every(player =>
        Array.some(room.round.answers, answer => answer.player.id == player.id)
      )

    let isButtonEnabled = allPlayersAnswered

    <div className={styles["play-stage"]}>
      <div className={styles["room-code"]}>
        <h3> {React.string(`Раунд 1`)} </h3>
        <QuestionCard
          title={room.round.question.title}
          body={questionBody}
          roundLeader={room.round.leader.name}
          selectedOption={selectedOption.id}
          onSelect={idx => {
            setQuestionBody(answer => {
              let start = Array.slice(answer, ~len=idx, ~offset=0)
              let end = Array.sliceToEnd(answer, idx + 1)
              Array.concatMany([start, [QuestionCard.Option((idx, selectedOption))], end])
            })
            setSelectedOption(initOption)
          }}
        />
      </div>
      <div className={styles["connected-users"]}>
        <h4> {React.string(`Ждем ответов`)} </h4>
        <PlayerList
          players=room.players
          leaderboard=room.leaderboard
          highlightedPlayers={Array.map(room.round.answers, answer => answer.player)}
          leader={room.round.leader}
        />
      </div>
      <Button
        label={`Продолжить`}
        onClick={finishStage}
        disabled={!isButtonEnabled}
      />
    </div>
  }
}

module PlayerView = {
  @react.component
  let make = () => {
    let (room, _) = RoomContext.useState()
    let (user, _) = UserContext.useState()
    let (questionBody, setQuestionBody) = PlayStageHooks.useAnswer(room.round.question.text)
    let (selectedOption, setSelectedOption) = React.useState(initOption)

    let options = switch Js.Dict.get(room.options, user.id) {
    | Some(options) => options
    | None => []
    }

    let didPlayerSendAnswer = Array.some(room.round.answers, answer => answer.player.id == user.id)

    let didPlayerChooseAnswer = !Array.some(questionBody, questionPart =>
      switch questionPart {
      | QuestionCard.Statement(_) => false
      | QuestionCard.Option((_, option)) => option.text == "______"
      }
    )

    <div className={styles["play-stage"]}>
      <div className={styles["room-code"]}>
        <h3> {React.string(`Раунд 1`)} </h3>
        <QuestionCard
          title={room.round.question.title}
          body={questionBody}
          roundLeader={room.round.leader.name}
          selectedOption={selectedOption.id}
          onSelect={idx => {
            setQuestionBody(answer => {
              let start = Array.slice(answer, ~len=idx, ~offset=0)
              let end = Array.sliceToEnd(answer, idx + 1)
              Array.concatMany([start, [QuestionCard.Option((idx, selectedOption))], end])
            })
            setSelectedOption(initOption)
          }}
        />
      </div>
      {if !didPlayerSendAnswer {
        <>
          <PlayStageOptionList selectedOption setSelectedOption options />
          <Button
            label={`Продолжить`}
            onClick={sendAnswer(questionBody)}
            disabled={!didPlayerChooseAnswer}
          />
        </>
      } else {
        <>
          <div className={styles["connected-users"]}>
            <h4> {React.string(`Ждем ответов`)} </h4>
            <PlayerList
              players=room.players
              leaderboard=room.leaderboard
              highlightedPlayers={Array.map(room.round.answers, answer => answer.player)}
              leader=room.round.leader
            />
          </div>
          <h4 className={styles["wait-for-answeres"]}> {React.string(`Ожидаем участников...`)} </h4>
        </>
      }}
    </div>
  }
}

@react.component
let make = () => {
  let (room, _) = RoomContext.useState()
  let (user, _) = UserContext.useState()

  let isUserRoundLeader = user.id == room.round.leader.id

  switch isUserRoundLeader {
  | true => <LeaderView />
  | false => <PlayerView />
  }
}
