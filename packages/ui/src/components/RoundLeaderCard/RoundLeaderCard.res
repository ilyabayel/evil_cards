@module external styles: {..} = "./RoundLeaderCard.module.css"
let styles = styles["default"]

@react.component
let make = (~playerName="", ~avatar="", ~score=0) => {
  <div className={styles["round-leader-card"]}>
    <PlayerCard playerName avatar score highlighted=true/>
  </div>
}
