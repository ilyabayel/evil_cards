@module external styles: {..} = "./VoteStage.module.css"
let styles = styles["default"]




@react.component
let make = () => {
  let (_oom, _setRoom) = RoomContext.useState()

  <div className={styles["wait-stage"]}>
    {React.string(`vote`)}
  </div>
}
