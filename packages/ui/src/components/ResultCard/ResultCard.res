@module external styles: {..} = "./ResultCard.module.css"
let styles = styles["default"]

type bodyPart =
  | Statement(string)
  | Option({id: string, text: string})

@react.component
let make = (~body: array<bodyPart>, ~heading="") => {
  <div className={styles["result-card"]}>
    <h6> {React.string(heading)} </h6>
    <br />
    <p className={styles["result-text-box"]}>
      {
        Array.mapU(body, (. part) => {
        switch part {
        | Statement(s) => <span className=styles["result-text"] key=s> {React.string(s)} </span>
        | Option({id, text}) => <span className=styles["result-option-part"] key=id> {React.string(text)} </span>
        }
      })->React.array}
    </p>
  </div>
}
