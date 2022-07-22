@module external styles: {..} = "./PlayerCard.module.css"
open ClassName

@react.component
let make = (~playerName="", ~avatar="", ~score=0, ~highlighted=false, ~isLeader=false) => {
  let className =
    styles["default"]["player-card"]
    ->cond(styles["default"]["highlighted"], highlighted)
    ->cond(styles["default"]["is-leader"], isLeader)

  <div className={className}>
    <div className={styles["default"]["avatar-box"]}>
      {if Js.String2.length(avatar) > 0 {
        <img src=avatar alt="Avatar" className={styles["default"]["avatar"]} />
      } else {
        <div className={styles["default"]["avatar"]}>
          <p> {UserUtils.getInitials(playerName)->React.string} </p>
        </div>
      }}
    </div>
    <div className={styles["default"]["info-box"]}>
      <h5> {React.string(playerName)} </h5> <p> {React.string(j`$score`)} </p>
    </div>
  </div>
}
