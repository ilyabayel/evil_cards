@module external styles: {..} = "./VariantCard.module.css"

let styles = styles["default"]
let cond = ClassName.cond

type bodyPart =
  | Statement(string)
  | Option(Room.answerOption)

@react.component
let make = (~title, ~body, ~isSelected, ~onClick, ~disabled) => {
  let variantStyles = styles["variant-card"]->cond(styles["selected"], isSelected)

  <button className={variantStyles} onClick={onClick} disabled>
    {switch title {
    | "" => <> </>
    | title => <> <h6> {React.string(title)} </h6> <br /> </>
    }}
    <p className={styles["variant-text-box"]}>
      {Array.map(body, part => {
        switch part {
        | Statement(s) => <span key=s className={styles["variant-text"]}> {React.string(s)} </span>
        | Option({id, text}) =>
          <span className={styles["option-text"]} key=id> {React.string(text)} </span>
        }
      })->React.array}
    </p>
  </button>
}
