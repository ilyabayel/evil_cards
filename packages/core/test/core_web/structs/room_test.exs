defmodule CoreWeb.RoomTest do
  use ExUnit.Case, async: true
  doctest CoreWeb.Room

  setup_all do
    room = %CoreWeb.Room{
      id: "test",
      host: %CoreWeb.User{
        id: "test",
        name: "test"
      },
      players: [
        %CoreWeb.User{
          id: "test1",
          name: "test1"
        },
        %CoreWeb.User{
          id: "test2",
          name: "test2"
        },
        %CoreWeb.User{
          id: "test3",
          name: "test3"
        }
      ],
      round_duration: 60,
      rounds_per_player: 2,
      round: %CoreWeb.Round{},
      questions: [],
      code: 1000
    }

    questionnaire = %CoreWeb.Questionnaire{
      id: "id",
      name: "name",
      author: "author",
      questions: [
        %CoreWeb.Question{
          id: "q1",
          text: "quest 1"
        },
        %CoreWeb.Question{
          id: "q2",
          text: "quest 2"
        },
        %CoreWeb.Question{
          id: "q3",
          text: "quest 3"
        }
      ],
      options: [
        %CoreWeb.Option{
          id: "o1",
          text: "option 1"
        },
        %CoreWeb.Option{
          id: "o2",
          text: "option 2"
        }
      ]
    }

    {:ok, room: room, questionnaire: questionnaire}
  end

  test "should generate right round on start_game", state do
    room = CoreWeb.Room.start_game(state.room, state.questionnaire)

    assert length(room.questions) == 2
    assert room.round.number == 1
    assert room.round.current_stage == CoreWeb.Stages.prepare()
    assert room.round.leader == Enum.at(state.room.players, 0)
    assert room.round.winner == %CoreWeb.Answer{}
    assert room.round.answers == []
    assert room.status == CoreWeb.GameStatus.play()
  end

  test "should end game if no question left", state do
    room = CoreWeb.Room.start_round(state.room)
    assert room.status == CoreWeb.GameStatus.finished()
  end

  test "should add score to winner on round finish", state do
    score_table = %{
      "test" => 0
    }
    round = Map.put(state.room.round, :winner, %CoreWeb.Answer{
      question: %CoreWeb.Question{},
      option: %CoreWeb.Option{},
      player: %CoreWeb.User{
        id: "test",
        name: "test_name"
      },
    })

    room =
      state.room
      |> Map.put(:score_table, score_table)
      |> Map.put(:round, round)
      |> CoreWeb.Room.finish_round()

    assert room.score_table["test"] == 1
  end

  test "should change status to finished on finish_game", state do
    room = CoreWeb.Room.finish_game(state.room)
    assert room.status == CoreWeb.GameStatus.finished()
  end

  test "should init all-zeros score table", state do
    room = CoreWeb.Room.init_score_table(state.room)

    expected_table = %{
      "test1" => 0,
      "test2" => 0,
      "test3" => 0
    }

    assert room.score_table == expected_table
  end

  test "should add score to winner on add_score_to_winner", state do
    room =
      state.room
      |> Map.put(:score_table, %{"test1" => 0})
      |> CoreWeb.Room.add_score_to_winner(%CoreWeb.User{id: "test1", name: "test_name"})

    assert room.score_table["test1"] == 1
  end

  test "start_stage should correctly set stages", state do
    assert state.room.round.current_stage == CoreWeb.Stages.wait()

    room = CoreWeb.Room.start_stage(state.room)
    assert room.round.current_stage == CoreWeb.Stages.prepare()

    room = CoreWeb.Room.start_stage(room)
    assert room.round.current_stage == CoreWeb.Stages.play()

    room = CoreWeb.Room.start_stage(room)
    assert room.round.current_stage == CoreWeb.Stages.vote()

    room = CoreWeb.Room.start_stage(room)
    assert room.round.current_stage == CoreWeb.Stages.result()

    room = CoreWeb.Room.start_stage(room)
    assert room.round.current_stage == CoreWeb.Stages.prepare()
  end
end
