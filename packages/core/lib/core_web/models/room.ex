defmodule CoreWeb.Room do
  @derive Jason.Encoder
  defstruct id: "", host_name: "", players: []

  def add_player(%CoreWeb.Room{} = room, player) do
    room
    |> Map.put(:players, room.players ++ [player])
  end
end
