@module external styles: {..} = "./WaitStage.module.css"
let styles = styles["default"]

let getScore = (leaderboard, id) => {
    switch Js.Dict.get(leaderboard, id) {
    | Some(score) => score
    | None => 0
    }
}

@react.component
let make = () => {
    let room = React.useContext(RoomContext.context)

    <div className=styles["wait-stage"]>
        <div className=styles["room-code"]>
            <h2>{React.string(`Код комнаты`)}</h2>
            <h1>{React.string(Js.Int.toString(room.code))}</h1>
        </div>
        <div className=styles["connected-users"]>
            <h3>{React.string(`Подключились`)}</h3>
            <div className=styles["user-list"]>
                {
                    Js.Array2.map(room.players, (player) => {
                        <UserCard key=player.id score={getScore(room.leaderboard, player.id)} userName=player.name/>
                    }) -> React.array
                }
            </div>
        </div>
        <Button label=`Начать` onClick={(_) => Js.log("clicked")} />
    </div>
}