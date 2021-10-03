defmodule CoreWeb.Answer do
  @derive Jason.Encoder
  defstruct question: %CoreWeb.Question{},
            option: %CoreWeb.Option{},
            player: %CoreWeb.User{}

  @type t :: %__MODULE__{
    question: CoreWeb.Question.t(),
    option: CoreWeb.Option.t(),
    player: CoreWeb.User.t()
  }
end
