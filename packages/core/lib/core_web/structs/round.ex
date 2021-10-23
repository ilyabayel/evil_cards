defmodule CoreWeb.Round do
  @derive Jason.Encoder
  defstruct number: 0,
            current_stage: CoreWeb.Stages.wait,
            leader: %CoreWeb.User{},
            winner: %CoreWeb.Answer{},
            question: %CoreWeb.Question{},
            answers: []

  @type t :: %__MODULE__{
          number: integer,
          leader: CoreWeb.User.t(),
          winner: CoreWeb.Answer.t(),
          question: CoreWeb.Question.t(),
          answers: []
        }
end
