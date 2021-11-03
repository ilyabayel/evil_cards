defmodule CoreWeb.Room do
  @derive Jason.Encoder
  defstruct id: "",
            host: %CoreWeb.User{},
            players: [],
            round_duration: 60,
            rounds_per_player: 2,
            current_stage: CoreWeb.Stages.wait(),
            round: %CoreWeb.Round{},
            questions: [],
            code: 0

  @typedoc """
  A room where all actions are stored
  """
  @type t :: %__MODULE__{
          id: String.t(),
          host: CoreWeb.User.t(),
          players: [CoreWeb.User.t()],
          round_duration: Integer,
          rounds_per_player: Integer,
          current_stage: String.t(),
          round: CoreWeb.Round.t(),
          questions: Enum.t(),
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
        &(Map.get(&1, :id) != player_id)
      )
    )
  end

  @doc """
    Add questions to room

    ## Examples

      iex> room = %CoreWeb.Room{}
      iex> questions = [%CoreWeb.Question{id: "1", text: "1"}]
      iex> room = CoreWeb.Room.add_questions(room, questions)
      iex> Enum.at(room.questions, 0).id
      "1"
  """
  def add_questions(%CoreWeb.Room{} = room, questions) do
    Map.put(room, :questions, questions)
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
          &(&1.player.id != answer.player.id)
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
          &(&1.player.id != player_id)
        )
      )

    Map.put(room, :round, round)
  end

  @doc """
      Set winner

      ## Examples

        iex> room = %CoreWeb.Room{
        ...> round: %CoreWeb.Round{
        ...>  answers: [
        ...>    %CoreWeb.Answer{
        ...>      player: %CoreWeb.User{id: "test"},
        ...>    }]
        ...>  }
        ...> }
        iex> room = CoreWeb.Room.set_winner(room, "test")
        iex> room.round.winner.player.id
        iex> "test"
  """
  def set_winner(%CoreWeb.Room{} = room, player_id) do
    round =
      Map.put(
        room.round,
        :winner,
        Enum.find(
          room.round.answers,
          &(&1.player.id == player_id)
        )
      )

    Map.put(room, :round, round)
  end


  @doc """
    Generate list of options

    ## Examples

      iex> room = %CoreWeb.Room{
      ...>  players: [
      ...>    %CoreWeb.User{name: "test1", id: "test1"},
      ...>    %CoreWeb.User{name: "test2", id: "test2"},
      ...>    %CoreWeb.User{name: "test3", id: "test3"},
      ...>  ],
      ...>  rounds_per_player: 3
      ...> }
      iex> CoreWeb.Room.get_options_map(room, [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18])
      %{"test1" => [1,2,3,4,5,6], "test2" => [7,8,9,10,11,12], "test3" => [13,14,15,16,17,18]}
  """
  def get_options_map(%CoreWeb.Room{} = room, options) do
    options_length = length(options)
    required = (length(room.players) + 3) * room.rounds_per_player

    options = expand_options(options, options_length, required)

    {map, _} =
      Enum.reduce(
        room.players,
        {%{}, options},
        &{
          Map.put(elem(&2, 0), &1.id, Enum.take(elem(&2, 1), room.rounds_per_player + 3)),
          Enum.drop(elem(&2, 1), room.rounds_per_player + 3)
        }
      )

    map
  end

  def next_stage(%CoreWeb.Room{} = room, current_stage) do
    CoreWeb.Room.set_stage(room, CoreWeb.Stages.get_next_stage(current_stage))
  end

  def set_stage(%CoreWeb.Room{} = room, stage) do
    round = Map.put(room.round, :stage, stage)
    Map.put(room, :round, round)
  end

  defp expand_options(opts, len, required) when len < required do
    expand_options(opts ++ opts, len * 2, required)
  end

  defp expand_options(opts, _, required) do
    Enum.take(opts, required)
  end
end
