let initAnswer = (answer: Room.answer) => {
  let optionCounter = ref(0)

  Js.String2.replace(answer.question.text, "{?}", " {?} ")
  ->Js.String2.split(" ")
  ->Array.keep(el => el != "")
  ->Array.map(part => {
    switch part {
    | "{?}" => {
        let optionalOption = answer.options[optionCounter.contents]
        optionCounter := optionCounter.contents + 1
        switch optionalOption {
        | Some(ansOption) => VariantCard.Option(ansOption)
        | None => VariantCard.Option({id: "", text: "______"})
        }
      }
    | statement => VariantCard.Statement(statement ++ " ")
    }
  })
}
