defmodule CoreWeb.Room do
  @derive Jason.Encoder
  defstruct id: "",
            host: %CoreWeb.User{},
            players: [],
            round_duration: 60,
            rounds_per_player: 2,
            round: %CoreWeb.Round{},
            questions: [],
            options: [],
            status: CoreWeb.GameStatus.play(),
            code: 0,
            leaderboard: %{}

  @typedoc """
  A room where all actions are stored
  """
  @type t :: %__MODULE__{
          id: String.t(),
          host: CoreWeb.User.t(),
          players: [CoreWeb.User.t()],
          round_duration: Integer,
          rounds_per_player: Integer,
          round: CoreWeb.Round.t(),
          questions: [CoreWeb.Question.t()],
          options: map,
          status: CoreWeb.GameStatus.t(),
          leaderboard: %{String.t() => Integer},
          code: integer
        }

  @spec add_player(CoreWeb.Room.t(), CoreWeb.User.t()) :: CoreWeb.Room.t()
  @spec remove_player(CoreWeb.Room.t(), String.t()) :: CoreWeb.Room.t()
  @spec set_questions(CoreWeb.Room.t(), [CoreWeb.Question.t()]) :: CoreWeb.Room.t()
  @spec set_options(CoreWeb.Room.t(), [CoreWeb.Option.t()]) :: CoreWeb.Room.t()
  @spec add_answer(CoreWeb.Room.t(), CoreWeb.Answer.t()) :: CoreWeb.Room.t()
  @spec remove_answer(CoreWeb.Room.t(), String.t()) :: CoreWeb.Room.t()
  @spec start_game(CoreWeb.Room.t(), CoreWeb.Questionnaire.t()) :: CoreWeb.Room.t()
  @spec finish_game(CoreWeb.Room.t()) :: CoreWeb.Room.t()
  @spec start_round(CoreWeb.Room.t()) :: CoreWeb.Room.t()
  @spec finish_round(CoreWeb.Room.t()) :: CoreWeb.Room.t()
  @spec start_stage(CoreWeb.Room.t()) :: CoreWeb.Room.t()
  @spec finish_stage(CoreWeb.Room.t()) :: CoreWeb.Room.t()
  @spec set_winner(CoreWeb.Room.t(), CoreWeb.User.t()) :: CoreWeb.Room.t()
  @spec init_leaderboard(CoreWeb.Room.t()) :: CoreWeb.Room.t()
  @spec add_score_to_winner(CoreWeb.Room.t(), CoreWeb.User.t()) :: CoreWeb.Room.t()

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
      iex> room = CoreWeb.Room.set_questions(room, questions)
      iex> Enum.at(room.questions, 0).id
      "1"
  """
  def set_questions(%CoreWeb.Room{} = room, questions) do
    Map.put(room, :questions, questions)
  end

  @doc """
    Add questions to room

    ## Examples

      iex> room = %CoreWeb.Room{players: [%CoreWeb.User{id: "u1"}]}
      iex> options = [%CoreWeb.Option{id: "1", text: "1"}]
      iex> room = CoreWeb.Room.set_options(room, options)
      iex> Enum.at(room.options["u1"], 0).id
      "1"

  """
  def set_options(%CoreWeb.Room{} = room, options) do
    options_map = CoreWeb.QuestionnaireHelper.get_options_map(
      Enum.shuffle(options),
      room.players,
      room.rounds_per_player
    )

    Map.put(room, :options, options_map)
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
    |> CoreWeb.Room.set_options(questionnaire.options)
    |> CoreWeb.Room.init_leaderboard()
    |> CoreWeb.Room.start_round()
  end

  def finish_game(%CoreWeb.Room{} = room) do
    Map.put(room, :status, CoreWeb.GameStatus.finished())
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
        CoreWeb.Room.finish_game(room)
    end
  end

  def finish_round(%CoreWeb.Room{} = room) do
    room
    |> CoreWeb.Room.add_score_to_winner(room.round.winner.player)
  end

  def start_stage(%CoreWeb.Room{} = room) do
    set_stage(room, CoreWeb.Stages.get_next_stage(room.round.current_stage))
  end

  def finish_stage(%CoreWeb.Room{} = room) do
    room
  end

  def init_leaderboard(%CoreWeb.Room{} = room) do
    leaderboard =
      Enum.reduce(
        room.players,
        %{},
        &Map.put(&2, &1.id, 0)
      )

    Map.put(room, :leaderboard, leaderboard)
  end

  def add_score_to_winner(%CoreWeb.Room{} = room, %CoreWeb.User{} = winner) do
    Map.put(
      room,
      :leaderboard,
      Map.put(room.leaderboard, winner.id, room.leaderboard[winner.id] + 1)
    )
  end

  # Helper functions

  defp set_stage(%CoreWeb.Room{} = room, stage) do
    round = Map.put(room.round, :current_stage, stage)
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
