let initAnswer = questionText => {
  Js.String2.replace(questionText, "{?}", " {?} ")
  ->Js.String2.split(" ")
  ->Array.keep(el => el != "")
  ->Array.mapWithIndex((idx, part) => {
    switch part {
    | "{?}" => QuestionCard.Option((idx, {id: Int.toString(idx), text: "______"}))
    | statement => QuestionCard.Statement(statement ++ " ")
    }
  })
}

let useAnswer = questionText => {
  let initialAnswer = initAnswer(questionText)
  let (answer, setAnswer) = React.useState(() => initialAnswer)

  (answer, setAnswer)
}
