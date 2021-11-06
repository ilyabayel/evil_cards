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

  # Public
  @spec add_player(CoreWeb.Room.t(), CoreWeb.User.t()) :: CoreWeb.Room.t()
  @spec remove_player(CoreWeb.Room.t(), String.t()) :: CoreWeb.Room.t()
  @spec set_questions(CoreWeb.Room.t(), [CoreWeb.Question.t()]) :: CoreWeb.Room.t()
  @spec add_answer(CoreWeb.Room.t(), CoreWeb.Answer.t()) :: CoreWeb.Room.t()
  @spec remove_answer(CoreWeb.Room.t(), String.t()) :: CoreWeb.Room.t()
  @spec start_game(CoreWeb.Room.t(), CoreWeb.Questionnaire.t()) :: CoreWeb.Room.t()
  @spec finish_game(CoreWeb.Room.t()) :: CoreWeb.Room.t()
  @spec start_round(CoreWeb.Room.t()) :: CoreWeb.Room.t()
  @spec finish_round(CoreWeb.Room.t()) :: CoreWeb.Room.t()
  @spec start_stage(CoreWeb.Room.t()) :: CoreWeb.Room.t()
  @spec finish_stage(CoreWeb.Room.t()) :: CoreWeb.Room.t()
  @spec set_winner(CoreWeb.Room.t(), CoreWeb.User.t()) :: CoreWeb.Room.t()

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
  def set_questions(%CoreWeb.Room{} = room, questions) do
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

  def start_game(%CoreWeb.Room{} = room, %CoreWeb.Questionnaire{} = questionnaire) do
    room
    |> CoreWeb.Room.set_questions(Enum.shuffle(questionnaire.questions))
    |> CoreWeb.Room.start_round()
  end

  def finish_game(%CoreWeb.Room{} = room) do
    room
  end

  @doc """
      Finish round

      ## Examples

        iex> room = %CoreWeb.Room{
        ...>  players: [
        ...>  %CoreWeb.User{
        ...>    id: "test",
        ...>    name: "test"
        ...>  },
        ...>  %CoreWeb.User{
        ...>     id: "test2",
        ...>     name: "test2"
        ...>  }],
        ...>  round: %CoreWeb.Round{
        ...>    leader: %CoreWeb.User{
        ...>      id: "test",
        ...>      name: "test"
        ...>    }
        ...>  }
        ...> }
        iex> room = CoreWeb.Room.start_round(room)
        iex> room.round.leader.id
        iex> "test2"
  """
  def start_round(%CoreWeb.Room{} = room) do
    case room.questions do
      [question | remaining] ->
        room
        |> Map.put(
          :round,
          %CoreWeb.Round{
            number: room.round.number + 1,
            leader: get_leader(room),
            winner: %CoreWeb.Answer{},
            question: question,
            current_stage: CoreWeb.Stages.prepare(),
            answers: []
          }
        )
        |> Map.put(:questions, remaining)

      _ ->
        room
    end
  end

  def finish_round(%CoreWeb.Room{} = room) do
    # add score to winner
    room
  end

  def start_stage(%CoreWeb.Room{} = room) do
    set_stage(room, CoreWeb.Stages.get_next_stage(room.round.stage))
  end

  def finish_stage(%CoreWeb.Room{} = room) do
    room
  end

  # Helper functions

  defp set_stage(%CoreWeb.Room{} = room, stage) do
    round = Map.put(room.round, :stage, stage)
    Map.put(room, :round, round)
  end

  defp get_leader(%CoreWeb.Room{} = room) do
    count = length(room.players)

    currentLeaderIdx =
      Enum.find_index(
        room.players,
        &(&1.id == room.round.leader.id)
      )

    Enum.at(
      room.players,
      get_next_leader_idx(count, currentLeaderIdx)
    )
  end

  defp get_next_leader_idx(total, currentIdx) when currentIdx < total, do: currentIdx + 1
  defp get_next_leader_idx(_, _), do: 0
end
