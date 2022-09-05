@module external styles: {..} = "./RoundLeader.module.css"
let styles = styles["default"]

@react.component
let make = (~leader: Room.user, ~userId) => {
  if userId == leader.id {
    <h3> {React.string(`Вы ведущий раунда`)} </h3>
  } else {
    <div className=styles["round-leader-box"]>
      <h3> {React.string(`Ведущий раунда`)} </h3>
      <h2> {React.string(leader.name)} </h2>
    </div>
  }
}