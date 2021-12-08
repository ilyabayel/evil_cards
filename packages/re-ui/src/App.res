%%raw("import './GlobalStyle.css'")

@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  <RoomContext.Provider value=RoomContext.value>
    {
      switch url.path {
      | list{"play"} => <PlayScreen/>
      | list{} => <HomeScreen />
      | _ => <p> {React.string("page not found")} </p>
      }
    }
  </RoomContext.Provider>
}
