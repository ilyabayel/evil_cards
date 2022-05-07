defmodule Game.Question do
  @derive Jason.Encoder
  defstruct id: "",
            title: "",
            text: ""

  @type t :: %__MODULE__{
          id: String.t(),
          text: String.t()
        }
end
