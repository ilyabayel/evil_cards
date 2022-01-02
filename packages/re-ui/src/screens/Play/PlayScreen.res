@react.component
let make = () => {
    let (room, _) = React.useContext(RoomContext.context)

    switch room.round.current_stage {
    | #wait => <WaitStage/>
    | _ => <p>{React.string("others")}</p>
    }
}