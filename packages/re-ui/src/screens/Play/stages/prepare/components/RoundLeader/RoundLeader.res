@react.component
let make = (~leaderId, ~userId) => {
  if userId == leaderId {
    <h2> {React.string(`Вы ведущий раунда`)} </h2>
  } else {
    <div>
      <h2> {React.string(`Ведущий раунда`)} </h2>
      <h1> {React.string(leaderId)} </h1>
    </div>
  }
}