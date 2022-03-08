defmodule Game.Answer do
  @derive Jason.Encoder
  defstruct question: %Game.Question{},
            option: %Game.Option{},
            player: %Game.User{}

  @type t :: %__MODULE__{
    question: Game.Question.t(),
    option: Game.Option.t(),
    player: Game.User.t()
  }
end
