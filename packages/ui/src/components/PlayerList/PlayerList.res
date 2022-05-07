@module external styles: {..} = "./PlayerList.module.css"

let getScore = (leaderboard, id) => {
  switch Js.Dict.get(leaderboard, id) {
  | Some(score) => score
  | None => 0
  }
}

@react.component
let make = (~leaderboard, ~players: array<Room.user>) => {
  <div className={styles["player-list"]}>
    {Js.Array2.sortInPlaceWith(players, (u1, u2) => {
      getScore(leaderboard, u2.id) - getScore(leaderboard, u1.id)
    })
    ->Js.Array2.map(player => {
      <PlayerCard key=player.id score={getScore(leaderboard, player.id)} playerName=player.name />
    })
    ->React.array}
  </div>
}
