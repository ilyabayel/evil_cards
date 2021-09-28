defmodule CoreWeb.Room do
  @derive Jason.Encoder
  defstruct id: "",
            host: %CoreWeb.User{},
            players: [],
            round_duration: 60,
            current_stage: "wait",
            round: %CoreWeb.Round{},
            questionnaire_id: "",
            code: 0

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
          questionnaire_id: String.t(),
          code: integer
        }

  @doc """
    Add player to room

    ## Examples

      iex> room = %CoreWeb.Room{}
      iex> room = CoreWeb.Room.add_player(room, %CoreWeb.User{id: "1"})
      iex> room = CoreWeb.Room.add_player(room, %CoreWeb.User{id: "2"})
      iex> Map.get(room, :players)
      [%CoreWeb.User{id: "1"}, %CoreWeb.User{id: "2"}]

  """
  def add_player(%CoreWeb.Room{} = room, %CoreWeb.User{} = player) do
    room
    |> Map.put(
      :players,
      Enum.filter(room.players, fn p ->
        p.id != player.id
      end) ++ [player]
    )
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
      [%CoreWeb.User{id: "1"}, %CoreWeb.User{id: "4"}]

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

  @doc """
      Add answer

      ## Examples

        iex> room = %CoreWeb.Room{}
        iex> room = CoreWeb.Room.add_answer(room, %CoreWeb.Answer{
        ...>    question: %CoreWeb.Question{id: "test"},
        ...> })
        iex> Map.get(room, :round)
        ...> |> Map.get(:answers)
        ...> |> Enum.at(0)
        ...> |> Map.get(:question)
        ...> |> Map.get(:id)
        "test"
  """
  def add_answer(%CoreWeb.Room{} = room, %CoreWeb.Answer{} = answer) do
    round =
      Map.put(
        room.round,
        :answers,
        Enum.filter(
          room.round.answers,
          fn ans ->
            ans.player.id != answer.player.id
          end
        ) ++ [answer]
      )

    Map.put(room, :round, round)
  end

  @doc """
      Remove answer

      ## Examples

        iex> room = %CoreWeb.Room{
        ...> round: %CoreWeb.Round{
        ...>  answers: [
        ...>    %CoreWeb.Answer{
        ...>      player: %CoreWeb.User{id: "test"},
        ...>    }]
        ...>  }
        ...> }
        iex> room = CoreWeb.Room.remove_answer(room, "test")
        iex> Map.get(room, :round)
        ...> |> Map.get(:answers)
        []
  """
  def remove_answer(%CoreWeb.Room{} = room, player_id) do
    round =
      Map.put(
        room.round,
        :answers,
        Enum.filter(
          room.round.answers,
          fn answer ->
            answer.player.id != player_id
          end
        )
      )

    Map.put(room, :round, round)
  end
end
