%%raw("import './GlobalStyle.css'")

@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  <RoomContext.Provider>
    {
      switch url.path {
      | list{"play"} => <PlayScreen/>
      | list{} => <HomeScreen />
      | _ => <p> {React.string("page not found")} </p>
      }
    }
  </RoomContext.Provider>
}
