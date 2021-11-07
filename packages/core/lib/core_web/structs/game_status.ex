defmodule CoreWeb.GameStatus do
  def play, do: "play"
  def finished, do: "finished"

  @type t :: String.t()
end
