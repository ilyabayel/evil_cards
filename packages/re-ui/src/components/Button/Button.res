@module external styles: {..} = "./Button.module.css"

@react.component
let make = (~label, ~onClick, ~className, ~disabled) => {
  let className = 
    className
    -> ClassName.add(styles["button"])

  <button className onClick disabled> {React.string(label)} </button>
}
