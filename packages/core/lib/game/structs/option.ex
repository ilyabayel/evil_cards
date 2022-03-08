defmodule Game.Option do
  @derive Jason.Encoder
  defstruct id: "",
            text: ""

  @type t :: %__MODULE__{
    id: String.t(),
    text: String.t()
  }
end
