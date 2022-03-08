defmodule Game.Round do
  @derive Jason.Encoder
  defstruct number: 0,
            current_stage: Game.Stages.wait(),
            leader: %Game.User{},
            winner: %Game.Answer{},
            question: %Game.Question{},
            answers: []

  @type t :: %__MODULE__{
          number: integer,
          leader: Game.User.t(),
          current_stage: String.t(),
          winner: Game.Answer.t(),
          question: Game.Question.t(),
          answers: [Game.Answer.t()]
        }
end
