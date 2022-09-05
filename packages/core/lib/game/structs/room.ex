defmodule Game.Room do
  @derive Jason.Encoder
  defstruct id: "",
            host: %Game.User{},
            players: [],
            round_duration: 60,
            rounds_per_player: 2,
            round: %Game.Round{},
            questions: [],
            options: %{},
            status: Game.Status.play(),
            code: 0,
            leaderboard: %{}

  @typedoc """
  A room where all actions are stored
  """
  @type t :: %__MODULE__{
          id: String.t(),
          host: Game.User.t(),
          players: [Game.User.t()],
          round_duration: integer(),
          rounds_per_player: integer(),
          round: Game.Round.t(),
          questions: [Game.Question.t()],
          options: map(),
          status: Game.Status.t(),
          leaderboard: %{String.t() => integer()},
          code: integer()
        }

  @spec add_player(t(), Game.User.t()) :: t()
  @spec remove_player(t(), String.t()) :: t()
  @spec set_questions(t(), [Game.Question.t()]) :: t()
  @spec set_options(t(), list(Game.Option.t())) :: t()
  @spec add_answer(t(), Game.Answer.t()) :: t()
  @spec remove_answer(t(), String.t()) :: t()
  @spec remove_options(t(), String.t(), list(String.t())) :: t()
  @spec start_game(t(), Game.Questionnaire.t()) :: t()
  @spec finish_game(t()) :: t()
  @spec start_round(t()) :: t()
  @spec finish_round(t()) :: t()
  @spec start_stage(t()) :: t()
  @spec finish_stage(t()) :: t()
  @spec set_winner(t(), Game.User.t()) :: t()
  @spec init_leaderboard(t()) :: t()
  @spec add_score_to_winner(t(), Game.User.t()) :: t()

  @doc """
    Add player to room

    ## Examples

      iex> room = %Game.Room{}
      iex> room = Game.Room.add_player(room, %Game.User{id: "1"})
      iex> room = Game.Room.add_player(room, %Game.User{id: "2"})
      iex> Map.get(room, :players)
      [%Game.User{id: "1"}, %Game.User{id: "2"}]

  """
  def add_player(%Game.Room{} = room, %Game.User{} = player) do
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

      iex> room = %Game.Room{
      ...>  players: [%Game.User{id: "1"}, %Game.User{id: "2"}, %Game.User{id: "3"}, %Game.User{id: "4"}]
      ...> }
      iex> room = Game.Room.remove_player(room, "2")
      iex> room = Game.Room.remove_player(room, "3")
      iex> Map.get(room, :players)
      [%Game.User{id: "1"}, %Game.User{id: "4"}]

  """
  def remove_player(%Game.Room{} = room, player_id) do
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

      iex> room = %Game.Room{}
      iex> questions = [%Game.Question{id: "1", text: "1"}]
      iex> room = Game.Room.set_questions(room, questions)
      iex> Enum.at(room.questions, 0).id
      "1"
  """
  def set_questions(%Game.Room{} = room, questions) do
    Map.put(room, :questions, questions)
  end

  @doc """
    Add questions to room

    ## Examples

      iex> room = %Game.Room{players: [%Game.User{id: "u1"}]}
      iex> options = [%Game.Option{id: "1", text: "1"}]
      iex> room = Game.Room.set_options(room, options)
      iex> Enum.at(room.options["u1"], 0).id
      "1"

  """
  def set_options(%Game.Room{} = room, options) do
    options_map =
      CoreWeb.QuestionnaireHelper.get_options_map(
        Enum.shuffle(options),
        room.players,
        room.rounds_per_player
      )

    Map.put(room, :options, options_map)
  end

  @doc """
      Add answer

      ## Examples

        iex> room = %Game.Room{}
        iex> room = Game.Room.add_answer(room, %Game.Answer{
        ...>    question: %Game.Question{id: "test"},
        ...> })
        iex> Map.get(room, :round)
        ...> |> Map.get(:answers)
        ...> |> Enum.at(0)
        ...> |> Map.get(:question)
        ...> |> Map.get(:id)
        "test"
  """
  def add_answer(%Game.Room{} = room, %Game.Answer{} = answer) do
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

        iex> room = %Game.Room{
        ...> round: %Game.Round{
        ...>  answers: [
        ...>    %Game.Answer{
        ...>      player: %Game.User{id: "test"},
        ...>    }]
        ...>  }
        ...> }
        iex> room = Game.Room.remove_answer(room, "test")
        iex> Map.get(room, :round)
        ...> |> Map.get(:answers)
        []
  """
  def remove_answer(%Game.Room{} = room, player_id) do
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
      Remove option after giving answer

      ## Examples

        iex> room = %Game.Room{
        ...>   options: %{
        ...>     "user" => [%{id: "option_id", text: "text"}, %{id: "option_id_2", text: "text"}]
        ...>   }
        ...> }
        iex> room = Game.Room.remove_options(room, "user", ["option_id"])
        iex> room.options["user"]
        [%{id: "option_id_2", text: "text"}]
  """
  def remove_options(%Game.Room{} = room, player_id, used_options_ids) do
    not_used_option? = fn %{id: available_option_id} ->
      used_options_ids
      |> Enum.map(fn used_option_id -> available_option_id == used_option_id end)
      |> Enum.any?
      |> Kernel.not
    end

    unused_options = Enum.filter(Map.get(room.options, player_id, []), not_used_option?)

    put_in(room.options[player_id], unused_options)
  end

  @doc """
      Set winner

      ## Examples

        iex> room = %Game.Room{
        ...> round: %Game.Round{
        ...>  answers: [
        ...>    %Game.Answer{
        ...>      player: %Game.User{id: "test"},
        ...>    }]
        ...>  }
        ...> }
        iex> room = Game.Room.set_winner(room, "test")
        iex> room.round.winner.player.id
        iex> "test"
  """
  def set_winner(%Game.Room{} = room, player_id) do
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
    Start game

    ## Examples

      iex> host = %Game.User{id: "1", name: "host"}
      iex> player = %Game.User{id: "2", name: "player"}
      iex> room = %Game.Room{host: host, players: [host, player]}
      iex> questionnaire = %Game.Questionnaire{
      ...>    questions: [
      ...>      %Game.Question{id: "1"},
      ...>      %Game.Question{id: "2"},
      ...>      %Game.Question{id: "3"},
      ...>      %Game.Question{id: "4"},
      ...>    ],
      ...>    options: [
      ...>      %Game.Option{id: "1"},
      ...>      %Game.Option{id: "2"},
      ...>      %Game.Option{id: "3"},
      ...>      %Game.Option{id: "4"},
      ...>    ]
      ...> }
      iex> room = Game.Room.start_game(room, questionnaire)
      iex> room.round.current_stage
      "prepare"
  """
  def start_game(%Game.Room{} = room, %Game.Questionnaire{} = questionnaire) do
    room
    |> Game.Room.set_questions(Enum.shuffle(questionnaire.questions))
    |> Game.Room.set_options(questionnaire.options)
    |> Game.Room.init_leaderboard()
    |> Game.Room.start_round()
  end

  def finish_game(%Game.Room{} = room) do
    Map.put(room, :status, Game.Status.finished())
  end

  @doc """
      Finish round

      ## Examples

        iex> room = %Game.Room{
        ...>  players: [
        ...>  %Game.User{
        ...>    id: "test",
        ...>    name: "test"
        ...>  },
        ...>  %Game.User{
        ...>     id: "test2",
        ...>     name: "test2"
        ...>  }],
        ...>  round: %Game.Round{
        ...>    leader: %Game.User{
        ...>      id: "test",
        ...>      name: "test"
        ...>    }
        ...>  }
        ...> }
        iex> room = Game.Room.start_round(room)
        iex> room.round.leader.id
        iex> "test2"
  """
  def start_round(%Game.Room{} = room) do
    case room.questions do
      [question | remaining] ->
        room
        |> Map.put(
          :round,
          %Game.Round{
            number: room.round.number + 1,
            leader: get_leader(room),
            winner: %Game.Answer{},
            question: question,
            current_stage: Game.Stages.prepare(),
            answers: []
          }
        )
        |> Map.put(:questions, remaining)

      _ ->
        Game.Room.finish_game(room)
    end
  end

  def finish_round(%Game.Room{} = room) do
    room
    |> Game.Room.add_score_to_winner(room.round.winner.player)
  end

  def start_stage(%Game.Room{} = room) do
    set_stage(room, Game.Stages.get_next_stage(room.round.current_stage))
  end

  @doc """
  Does nothing for now, but I assume that it will be helpful in future
  """
  def finish_stage(%Game.Room{} = room) do
    room
  end

  def init_leaderboard(%Game.Room{} = room) do
    leaderboard =
      Enum.reduce(
        room.players,
        %{},
        &Map.put(&2, &1.id, 0)
      )

    Map.put(room, :leaderboard, leaderboard)
  end

  def add_score_to_winner(%Game.Room{} = room, %Game.User{} = winner) do
    Map.put(
      room,
      :leaderboard,
      Map.put(room.leaderboard, winner.id, room.leaderboard[winner.id] + 1)
    )
  end

  # Helper functions

  defp set_stage(%Game.Room{} = room, stage) do
    round = Map.put(room.round, :current_stage, stage)
    Map.put(room, :round, round)
  end

  defp get_leader(%Game.Room{} = room) do
    count = length(room.players)

    currentLeaderIdx =
      Enum.find_index(
        room.players,
        &(&1.id == room.round.leader.id)
      )

    Enum.at(
      room.players,
      get_next_leader_idx(count, currentLeaderIdx),
      %Game.User{}
    )
  end

  defp get_next_leader_idx(total, currentIdx) when currentIdx + 1 < total, do: currentIdx + 1
  defp get_next_leader_idx(_, _), do: 0
end
