defmodule CoreWeb.GameProcess do
  @spec start_game(CoreWeb.Room.t(), CoreWeb.Questionnaire.t()) :: CoreWeb.Room.t()
  @spec end_game(CoreWeb.Room.t()) :: CoreWeb.Room.t()
  @spec start_round(CoreWeb.Room.t()) :: CoreWeb.Room.t()
  @spec end_round(CoreWeb.Room.t()) :: CoreWeb.Room.t()
  @spec start_stage(CoreWeb.Room.t()) :: CoreWeb.Room.t()
  @spec end_stage(CoreWeb.Room.t()) :: CoreWeb.Room.t()

  def start_game(%CoreWeb.Room{} = room, %CoreWeb.Questionnaire{} = questionnaire) do
    room
    |> CoreWeb.Room.add_questions(Enum.shuffle(questionnaire.questions))
    |> CoreWeb.GameProcess.start_round()
  end

  def end_game(%CoreWeb.Room{} = room) do
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
        iex> room = CoreWeb.GameProcess.start_round(room)
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

  def end_round(%CoreWeb.Room{} = room) do
    room
  end

  def start_stage(%CoreWeb.Room{} = room) do
    room
  end

  def end_stage(%CoreWeb.Room{} = room) do
    room
  end

  # Helper functions

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
