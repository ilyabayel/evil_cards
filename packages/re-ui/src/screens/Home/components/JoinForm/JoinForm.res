@module external styles: {..} = "./JoinForm.module.css"

let styles = styles["default"]

type joinForm = {
  name: string,
  room_code: string
}

let defaultValue = {
  name: "",
  room_code: ""
}

@react.component
let make = (~onChange, ~value: joinForm, ~onSubmit) => {
  let onNameChange = React.useCallback1(e => {
    let val = ReactEvent.Form.target(e)["value"]
    onChange({...value, name: val})
  }, [onChange])
  let onRoomCodeChange = e => {
    let val = ReactEvent.Form.target(e)["value"]
    onChange({...value, room_code: val})
  }
  let handleSubmit = e => {
    ReactEvent.Form.preventDefault(e)
    onSubmit(e)
  }
  <form onSubmit={handleSubmit} className={styles["join-form"]}>
    <h3> {React.string(`Присоединиться к игре`)} </h3>
    <Input
      type_="text"
      value={value.name}
      onChange={onNameChange}
      name="name"
      placeholder=`Ваше имя`
    />
    <Input
      type_="text"
      value={value.room_code}
      onChange={onRoomCodeChange}
      name="room_code"
      placeholder=`Код комнаты`
    />
    <Button type_="submit" onClick={_ => ()} label=`Присоединиться` /> 
  </form>
}
