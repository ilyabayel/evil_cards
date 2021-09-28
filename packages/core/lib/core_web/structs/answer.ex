defmodule CoreWeb.Answer do
  @derive Jason.Encoder
  defstruct question: %CoreWeb.Question{},
            option: %CoreWeb.Option{},
            player: %CoreWeb.User{}
end
