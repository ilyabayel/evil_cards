@module external styles: {..} = "./button.module.css"

@react.component
let make = (~label, ~onClick, ~className, ~disabled) => {
  let className = className ++ styles["button"]
  <button className onClick disabled> {React.string(label)} </button>
}
