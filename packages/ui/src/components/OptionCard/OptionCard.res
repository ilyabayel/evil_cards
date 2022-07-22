@module external styles: {..} = "./OptionCard.module.css"
open ClassName

let styles = styles["default"]

@react.component
let make = (~onClick, ~option: Room.answerOption, ~isSelected) => {
  let handleClick = e => {
    ReactEvent.Mouse.preventDefault(e)
    onClick(option)
  }

  let className = 
    styles["option-card"]
    -> cond(styles["selected"], isSelected)

  <button className onClick={handleClick}>
    <p> {React.string(option.text)} </p>
  </button>
}
