@module external styles: {..} = "./PlayStage.module.css"
let styles = styles["default"]

let handleClick = _ => {
  let _ = RoomApi.startGame()
}


@react.component
let make = () => {
  let (_room, _setRoom) = RoomContext.useState()

  <div className={styles["wait-stage"]}>
    {React.string(`result`)}
  </div>
}
