@module external styles: {..} = "./CreateForm.module.css"

let styles = styles["default"]

type createForm = {
  name: string,
  round_duration: int,
  rounds_per_player: int,
}

let defaultValue = {
  name: "",
  round_duration: 60,
  rounds_per_player: 3,
}

@react.component
let make = (~onChange, ~value: createForm, ~onSubmit) => {
  let onNameChange = React.useCallback1(e => {
    let val = ReactEvent.Form.target(e)["value"]
    onChange({...value, name: val})
  }, [onChange])

  let onRoundDurationChange = e => {
    let val = ReactEvent.Form.target(e)["value"]
    onChange({...value, round_duration: int_of_string(val)})
  }

  let onRoundsPerPlayerChange = e => {
    let val = ReactEvent.Form.target(e)["value"]
    onChange({...value, rounds_per_player: int_of_string(val)})
  }

  let handleSubmit = e => {
    ReactEvent.Form.preventDefault(e)
    onSubmit(e)
  }

  <form onSubmit={handleSubmit} className={styles["create-form"]}>
    <div>
      <h3> {React.string(`Новая игра`)} </h3>
      <br/>
      <Input
        type_="text"
        value={value.name}
        onChange={onNameChange}
        name="Name"
        placeholder=`Введите ваше имя`
      />
    </div>
    <div>
      <h4> {React.string(`Настройка раундов`)} </h4>
      <br/>
      <div className={styles["round-settings"]}>
        <Input
          type_="number"
          value={Js.Int.toString(value.round_duration)}
          onChange={onRoundDurationChange}
          name="Round Duration"
          placeholder=`Длительность раунда (60 сек)`
        />
        <Input
          type_="number"
          value={Js.Int.toString(value.rounds_per_player)}
          onChange={onRoundsPerPlayerChange}
          name="Rounds per Player"
          placeholder=`Раундов на игрока (3)`
        />
      </div>
    </div>
    <Button type_="submit" label=`Создать игру` onClick={_ => ()} />
  </form>
}
