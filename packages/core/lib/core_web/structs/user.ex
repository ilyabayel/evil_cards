defmodule CoreWeb.User do
  @derive Jason.Encoder
  @derive Phoenix.Param
  defstruct id: "", name: ""

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t()
        }

  @spec from_string_map(%{String.t() => String.t()}) :: CoreWeb.User.t()

  def from_string_map(%{"id" => id, "name" => name}) do
    %__MODULE__{
      id: id,
      name: name
    }
  end
end
