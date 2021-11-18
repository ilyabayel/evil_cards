@module external styles: {..} = "./ResultCard.module.css"
let cn = styles["default"]

type bodyPart =
  | Statement(string)
  | Option({id: string, text: string})

@react.component
let make = (~body: array<bodyPart>, ~heading="") => {
  <div className={cn["result-card"]}>
    <h6> {React.string(heading)} </h6>
    <br />
    <p className={cn["result-text-box"]}>
      {
        Js.Array2.map(body, part => {
        switch part {
        | Statement(s) => <span className=cn["result-text"] key=s> {React.string(s)} </span>
        | Option({id, text}) => <span className=cn["result-option-part"] key=id> {React.string(text)} </span>
        }
      })->React.array}
    </p>
  </div>
}
