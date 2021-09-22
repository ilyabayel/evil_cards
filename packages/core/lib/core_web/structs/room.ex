defmodule CoreWeb.Room do
  @derive Jason.Encoder
  defstruct id: "",
            host: %CoreWeb.User{},
            players: [],
            round_duration: 60,
            current_stage: "wait",
            round: %CoreWeb.Round{},
            questionnaire_id: ""

  @typedoc """
  A room where all actions are stored
  """
  @type t :: %__MODULE__{
          id: String.t(),
          host: CoreWeb.User.t(),
          players: [CoreWeb.User.t()],
          round_duration: 60,
          current_stage: String.t(),
          round: CoreWeb.Round.t(),
          questionnaire_id: String.t()
        }

  @spec add_player(CoreWeb.Room.t(), CoreWeb.User.t()) :: CoreWeb.Room.t()
  @doc """
    Add player to room

    ## Examples

      iex> room = %CoreWeb.Room{}
      iex> room = CoreWeb.Room.add_player(room, %CoreWeb.User{id: "1"})
      iex> room = CoreWeb.Room.add_player(room, %CoreWeb.User{id: "2"})
      iex> Map.get(room, :players)
      [%CoreWeb.User{id: "1", name: ""}, %CoreWeb.User{id: "2", name: ""}]

  """
  def add_player(%CoreWeb.Room{} = room, %CoreWeb.User{} = player) do
    room
    |> Map.put(:players, room.players ++ [player])
  end

  @spec remove_player(CoreWeb.Room.t(), String.t()) :: CoreWeb.Room.t()
  @doc """
    Remove players from the room

    ## Examples

      iex> room = %CoreWeb.Room{
      ...>  players: [%CoreWeb.User{id: "1"}, %CoreWeb.User{id: "2"}, %CoreWeb.User{id: "3"}, %CoreWeb.User{id: "4"}]
      ...> }
      iex> room = CoreWeb.Room.remove_player(room, "2")
      iex> room = CoreWeb.Room.remove_player(room, "3")
      iex> Map.get(room, :players)
      [%CoreWeb.User{id: "1", name: ""}, %CoreWeb.User{id: "4", name: ""}]

  """
  def remove_player(%CoreWeb.Room{} = room, player_id) do
    room
    |> Map.put(
      :players,
      Enum.filter(
        room.players,
        fn p ->
          Map.get(p, :id) != player_id
        end
      )
    )
  end
end
