@module external styles: {..} = "./Button.module.css"

@react.component
let make = (~label, ~onClick, ~className="primary", ~disabled=false, ~type_="") => {
  let className = 
    className
    -> ClassName.add(styles["button"])

  <button className onClick disabled type_> {React.string(label)} </button>
}
