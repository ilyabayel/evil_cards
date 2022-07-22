@module external styles: {..} = "./PlayStageOptionList.module.css"
let styles = styles["default"]

@react.component
let make = (~options, ~selectedOption: Room.answerOption, ~setSelectedOption) => {
  <div className={styles["options"]}>
    {<>
      {Array.map(options, option => {
        <OptionCard
          key=option.id
          isSelected={selectedOption.id == option.id}
          onClick={ans => setSelectedOption(_ => ans)}
          option
        />
      })->React.array}
    </>}
  </div>
}
