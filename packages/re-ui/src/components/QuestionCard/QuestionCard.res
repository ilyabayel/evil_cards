@module external styles: {..} = "./QuestionCard.module.css"

let cn = styles["default"]
let cond = ClassName.cond

type bodyPart =
  | Statement(string)
  | Option({id: string, text: string})

@react.component
let make = (~heading, ~body, ~roundLeader, ~selectedOption, ~onSelect) => {
  let isSelectable = Js.String2.length(selectedOption) > 0

  let optionPartClassName =
    cn["option-text"]->cond(cn["selectable"], isSelectable)

  let onClick = (e, option) => {
    ReactEvent.Mouse.preventDefault(e)
    onSelect(option)
  }

  <div className={cn["question-card"]}>
    <h6> {React.string(heading)} </h6>
    <br />
    <p className={cn["question-text-box"]}>
      {Js.Array2.map(body, part => {
        switch part {
        | Statement(s) => <span className={cn["question-text"]}> {React.string(s)} </span>
        | Option({id, text}) =>
          <button className=optionPartClassName onClick={(e) => onClick(e, Option({id, text}))} key=id disabled={!isSelectable}>
            {React.string(text)}
          </button>
        }
      })->React.array}
    </p>
    <span className={cn["round-leader"]}> {React.string(roundLeader)} </span>
  </div>
}
