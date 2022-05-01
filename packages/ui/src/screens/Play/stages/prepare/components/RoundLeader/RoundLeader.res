@react.component
let make = (~leader: Room.user, ~userId) => {
  if userId == leader.id {
    <h2> {React.string(`Вы ведущий раунда`)} </h2>
  } else {
    <div>
      <h2> {React.string(`Ведущий раунда`)} </h2>
      <h1> {React.string(leader.name)} </h1>
    </div>
  }
}