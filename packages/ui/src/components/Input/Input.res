@module external styles: {..} = "./Input.module.css"

@react.component
let make = (~onChange, ~type_, ~value, ~name="", ~placeholder="") => {
  <input type_ value onChange className=styles["input"] name placeholder />
}
