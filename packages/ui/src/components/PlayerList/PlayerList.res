@module external styles: {..} = "./PlayerList.module.css"

let styles = styles["default"]

let getScore = (leaderboard, id) => {
  switch Map.String.get(leaderboard, id) {
  | Some(score) => score
  | None => 0
  }
}

@react.component
let make = (~leaderboard, ~players: array<Room.user>) => {
  <div className={styles["player-list"]}>
    {SortArray.stableSortBy(players, (u1, u2) => {
      getScore(leaderboard, u2.id) - getScore(leaderboard, u1.id)
    })
    ->Array.map(player => {
      <PlayerCard key=player.id score={getScore(leaderboard, player.id)} playerName=player.name />
    })
    ->React.array}
  </div>
}
