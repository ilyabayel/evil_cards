%%raw("import './GlobalStyle.css'")

@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  let _ = Phoenix.Channel.push(Lobby.lobby, ~event="", ~payload={"body": "text"})

  switch url.path {
  | list{"play"} => <div> {React.string("play")} </div>
  | list{} => <HomeScreen />
  | _ => <p> {React.string("page not found")} </p>
  }
}
