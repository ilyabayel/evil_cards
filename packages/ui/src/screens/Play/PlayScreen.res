@react.component
let make = () => {
  let (room, _) = RoomContext.useState()
  RoomContext.useReconnect()

  switch room.round.current_stage {
  | #wait => <WaitStage />
  | #prepare => <PrepareStage />
  | #play => <PlayStage />
  | #vote => <VoteStage />
  | #result => <ResultStage />
  }
}
