%%raw("import './GlobalStyle.css'")

@react.component
let make = () => {
    let url = RescriptReactRouter.useUrl()

    switch url.path {
    | list{"play"} => <div>{React.string("play")}</div>
    | list{} => <HomeScreen/>
    | _ => <p>{React.string("page not found")}</p>
    }
}