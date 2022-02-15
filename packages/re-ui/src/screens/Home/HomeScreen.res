@module external styles: {..} = "./HomeScreen.module.css"

let styles = styles["default"]

module Response = {
  type t<'data>
  @send external json: t<'data> => Promise.t<'data> = "json"
}

@val @scope("globalThis")
external fetch: (string, 'params) => Promise.t<Response.t<{"data": Js.Nullable.t<array<int>>}>> =
  "fetch"

@react.component
let make = () => {
  let (isCreateFormVisible, setIsCreateFormVisible) = React.useState(() => false)
  let (isJoinFormVisible, setIsJoinFormVisible) = React.useState(() => false)
  let (createFormValue, setCreateFormValue) = React.useState(() => CreateForm.defaultValue)
  let (joinFormValue, setJoinFormValue) = React.useState(() => JoinForm.defaultValue)
  let (_roomState, _setRoomState) = RoomContext.useState()
  let (userState, setUserState) = UserContext.useState()

  let showCreateForm = _ => {
    setIsCreateFormVisible(_ => true)
    setIsJoinFormVisible(_ => false)
  }

  let showJoinForm = _ => {
    setIsCreateFormVisible(_ => false)
    setIsJoinFormVisible(_ => true)
  }

  let connect = RoomContext.useConnect()

  let handleCreateForm = _ => {
    let _ = LobbyApi.createRoom(
      ~host={id: SocketApi.userId, name: createFormValue.name},
      ~roomInfo={
        "rounds_per_player": createFormValue.rounds_per_player,
        "round_duration": createFormValue.round_duration,
      },
      ~onRecieve=roomId => {
        connect(roomId)
      },
    )
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
          value={createFormValue}
          onChange={v => {
            setUserState({id: userState.id, name: v.name})
            setCreateFormValue(_ => v)
          }}
          onSubmit={handleCreateForm}
        />
      </BottomModal>
      <BottomModal visible={isJoinFormVisible} onClose={_ => setIsJoinFormVisible(_ => false)}>
        <JoinForm
          onChange={v => setJoinFormValue(_ => v)}
          onSubmit={_ => {
            let _ = LobbyApi.getRoomByCode(~code=joinFormValue.room_code, ~onRecieve=id => {
              connect(id)
            })
          }}
          value={joinFormValue}
        />
      </BottomModal>
    </div>
  </Frame>
}
