@module external styles: {..} = "./QuestionCard.module.css"

let styles = styles["default"]
let cond = ClassName.cond

type bodyPart =
  | Statement(string)
  | Option((int, Room.answerOption))

@react.component
let make = (~title, ~body, ~roundLeader, ~selectedOption, ~onSelect) => {
  let isSelectable = Js.String2.length(selectedOption) > 0

  let optionPartClassName = styles["option-text"]->cond(styles["selectable"], isSelectable)

  let onClick = (e, idx) => {
    ReactEvent.Mouse.preventDefault(e)
    onSelect(idx)
  }

  <div className={styles["question-card"]}>
    <h6> {React.string(title)} </h6>
    <br />
    <p className={styles["question-text-box"]}>
      {Array.map(body, part => {
        switch part {
        | Statement(s) => <span key=s className={styles["question-text"]}> {React.string(s)} </span>
        | Option((idx, {id, text})) =>
          <button
            className=optionPartClassName
            onClick={e => onClick(e, idx)}
            key=id
            disabled={!isSelectable}>
            {React.string(text)}
          </button>
        }
      })->React.array}
    </p>
    <span className={styles["round-leader"]}> {React.string(roundLeader)} </span>
  </div>
}
