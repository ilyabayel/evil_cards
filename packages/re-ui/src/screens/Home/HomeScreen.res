@module external styles: {..} = "./HomeScreen.module.css"

let styles = styles["default"]

@react.component
let make = () => {
  let (isCreateFormVisible, setIsCreateFormVisible) = React.useState(() => false)
  let (isJoinFormVisible, setIsJoinFormVisible) = React.useState(() => false)
  let (createFormValue, setCreateFormValue) = React.useState(() => CreateForm.defaultValue)
  let (joinFormValue, setJoinFormValue) = React.useState(() => JoinForm.defaultValue)

  let showCreateForm = _ => {
    setIsCreateFormVisible(_ => true)
    setIsJoinFormVisible(_ => false)
  }

  let showJoinForm = _ => {
    setIsCreateFormVisible((_) => false)
    setIsJoinFormVisible((_) => true)
  }

  let handleCreateForm = formValue => {
    ()
  }

  <Frame>
    <div className={styles["home-screen"]}>
      <div className={styles["title"]}>
        <h1> {React.string(`Злобные карты`)} </h1>
        <h3> {React.string(`Хорошая игра для плохих людей`)} </h3>
      </div>
      <div className={styles["buttons"]}>
        <Button label=`Создать игру` onClick={showCreateForm} />
        <Button label=`Подключится к игре` onClick={showJoinForm} />
      </div>
      <BottomModal visible={isCreateFormVisible} onClose={_ => setIsCreateFormVisible(_ => false)}>
        <CreateForm
          value={createFormValue} onChange={v => setCreateFormValue(_ => v)} onSubmit={_ => Js.log("submit")}
        />
      </BottomModal>
      <BottomModal visible={isJoinFormVisible} onClose={_ => setIsJoinFormVisible(_ => false)}>
        <JoinForm onChange={(v) => setJoinFormValue((_) => v)} onSubmit={_ => Js.log("submit")} value={joinFormValue}/>
      </BottomModal>
    </div>
  </Frame>
}
