defmodule Game.Answer do
  @derive Jason.Encoder
  defstruct question: %Game.Question{},
            options: [],
            player: %Game.User{}

  @type t :: %__MODULE__{
          question: Game.Question.t(),
          options: list(Game.Option.t()),
          player: Game.User.t()
        }
end
