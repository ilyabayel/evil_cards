defmodule CoreWeb.Answer do
  @derive Jason.Encoder
  defstruct option: %CoreWeb.Option{},
            player: %CoreWeb.User{}
end
