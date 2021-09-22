defmodule CoreWeb.Round do
  @derive Jason.Encoder
  defstruct number: 0,
            leader: %CoreWeb.User{},
            question: %CoreWeb.Question{},
            answers: []

  @type t :: %__MODULE__{
          number: integer,
          leader: CoreWeb.User.t(),
          question: CoreWeb.Question.t(),
          answers: []
        }
end
