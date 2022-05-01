@module external styles: {..} = "./VoteStage.module.css"
let styles = styles["default"]

@react.component
let make = () => {
  let (_oom, _setRoom) = RoomContext.useState()

  <div className={styles["wait-stage"]}>
    {React.string(`vote`)} <p style={ReactDOM.Style.make(~color="white", ())}> {"hello" -> React.string} </p>
  </div>
}
