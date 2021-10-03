defmodule CoreWeb.Round do
  @derive Jason.Encoder
  defstruct number: 0,
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
