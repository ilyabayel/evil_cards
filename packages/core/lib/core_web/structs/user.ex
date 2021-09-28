defmodule CoreWeb.User do
  @derive Jason.Encoder
  @derive Phoenix.Param
  defstruct id: "", name: ""

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t()
        }

  def from_string_map(%{"id" => id, "name" => name}) do
    %__MODULE__{
      id: id,
      name: name
    }
  end
end
