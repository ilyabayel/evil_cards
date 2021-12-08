@react.component
let make = () => {
    let room = React.useContext(RoomContext.context)

    Js.log(room)

    switch room.round.current_stage {
    | #wait => <WaitStage/>
    | _ => <p>{React.string("others")}</p>
    }
}