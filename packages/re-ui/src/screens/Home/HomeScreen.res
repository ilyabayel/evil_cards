@module external styles: {..} = "./HomeScreen.module.css"

let styles = styles["default"]

@react.component
let make = () => {
  let (isCreateFormVisible, setIsCreateFormVisible) = React.useState(() => false)
  let (isJoinFormVisible, setIsJoinFormVisible) = React.useState(() => false)

  let showCreateForm = _ => {
    setIsCreateFormVisible(_ => false)
    setIsJoinFormVisible(_ => true)
  }

  let showJoinForm = _ => {
    // setIsCreateFormVisible((_) => false)
    // setIsJoinFormVisible((_) => true)
    ()
  }

  <Frame>
    <div className=styles["home-screen"]>
      <div className={styles["title"]}>
        <h1> {React.string(`Злобные карты`)} </h1>
        <h3> {React.string(`Хорошая игра для плохих людей`)} </h3>
      </div>
      <div className="buttons">
        <Button label=`Создать игру` onClick={showCreateForm} />
        <Button label=`Подключится к игре` onClick={showJoinForm} />
      </div>
      <BottomModal visible={isCreateFormVisible} onClose={_ => setIsCreateFormVisible(_ => false)}>
        <div> {React.string("create form")} </div>
      </BottomModal>
      <BottomModal visible={isJoinFormVisible} onClose={_ => setIsJoinFormVisible(_ => false)}>
        <div> {React.string("join form")} </div>
      </BottomModal>
    </div>
  </Frame>
}
