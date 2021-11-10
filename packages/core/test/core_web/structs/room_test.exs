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
        },
        %CoreWeb.Option{
          id: "o3",
          text: "option 3"
        },
        %CoreWeb.Option{
          id: "o4",
          text: "option 4"
        },
        %CoreWeb.Option{
          id: "o6",
          text: "option 6"
        },
        %CoreWeb.Option{
          id: "o7",
          text: "option 7"
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
    leaderboard = %{
      "test" => 0
    }

    round =
      Map.put(state.room.round, :winner, %CoreWeb.Answer{
        question: %CoreWeb.Question{},
        option: %CoreWeb.Option{},
        player: %CoreWeb.User{
          id: "test",
          name: "test_name"
        }
      })

    room =
      state.room
      |> Map.put(:leaderboard, leaderboard)
      |> Map.put(:round, round)
      |> CoreWeb.Room.finish_round()

    assert room.leaderboard["test"] == 1
  end

  test "should change status to finished on finish_game", state do
    room = CoreWeb.Room.finish_game(state.room)
    assert room.status == CoreWeb.GameStatus.finished()
  end

  test "should init all-zeros score table", state do
    room = CoreWeb.Room.init_leaderboard(state.room)

    expected_table = %{
      "test1" => 0,
      "test2" => 0,
      "test3" => 0
    }

    assert room.leaderboard == expected_table
  end

  test "should add score to winner on add_score_to_winner", state do
    room =
      state.room
      |> Map.put(:leaderboard, %{"test1" => 0})
      |> CoreWeb.Room.add_score_to_winner(%CoreWeb.User{id: "test1", name: "test_name"})

    assert room.leaderboard["test1"] == 1
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

  test "game process", state do

    # Init room
    room =
      %CoreWeb.Room{
        id: "test",
        host: %CoreWeb.User{id: "test1", name: "test1"}
      }
      |> CoreWeb.Room.add_player(%CoreWeb.User{id: "test1", name: "test1"})
      |> CoreWeb.Room.add_player(%CoreWeb.User{id: "test2", name: "test2"})
      |> CoreWeb.Room.add_player(%CoreWeb.User{id: "test3", name: "test3"})
      |> CoreWeb.Room.start_game(state.questionnaire)

    assert room.round.current_stage == CoreWeb.Stages.prepare()
    assert room.round.leader == Enum.at(room.players, 0)

    # Start play stage, add answers to question and finish stage
    room =
      room
      |> CoreWeb.Room.start_stage()
      |> CoreWeb.Room.add_answer(%CoreWeb.Answer{
        question: room.round.question,
        option: Enum.at(state.questionnaire.options, 0),
        player: Enum.at(room.players, 0)
      })
      |> CoreWeb.Room.add_answer(%CoreWeb.Answer{
        question: room.round.question,
        option: Enum.at(state.questionnaire.options, 1),
        player: Enum.at(room.players, 1)
      })
      |> CoreWeb.Room.add_answer(%CoreWeb.Answer{
        question: room.round.question,
        option: Enum.at(state.questionnaire.options, 2),
        player: Enum.at(room.players, 2)
      })
      |> CoreWeb.Room.finish_stage()

    assert length(room.round.answers) == 3
    assert room.round.current_stage == CoreWeb.Stages.play()

    # Start vote stage, set winner and finish stage
    room =
      room
      |> CoreWeb.Room.start_stage()
      |> CoreWeb.Room.set_winner(Enum.at(room.round.answers, 0).player.id)
      |> CoreWeb.Room.finish_stage()

    assert room.round.winner == Enum.at(room.round.answers, 0)
    assert room.round.current_stage == CoreWeb.Stages.vote()

    # Start result stage, finish stage, finish round
    # Check score table
    room =
      room
      |> CoreWeb.Room.start_stage()
      |> CoreWeb.Room.finish_stage()
      |> CoreWeb.Room.finish_round()

    assert room.leaderboard[Enum.at(room.round.answers, 0).player.id] == 1
    assert room.leaderboard[Enum.at(room.round.answers, 1).player.id] == 0
    assert room.leaderboard[Enum.at(room.round.answers, 2).player.id] == 0

    # Start round, check that round leader is player #2

    room =
      room
      |> CoreWeb.Room.start_round()

    assert room.round.leader == Enum.at(room.players, 1)
  end
end
