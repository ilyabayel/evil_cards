defmodule CoreWeb.RoomTest do
  use ExUnit.Case, async: true
  doctest Game.Room

  setup_all do
    room = %Game.Room{
      id: "test",
      host: %Game.User{
        id: "test",
        name: "test"
      },
      players: [
        %Game.User{
          id: "test1",
          name: "test1"
        },
        %Game.User{
          id: "test2",
          name: "test2"
        },
        %Game.User{
          id: "test3",
          name: "test3"
        }
      ],
      round_duration: 60,
      rounds_per_player: 2,
      round: %Game.Round{},
      questions: [],
      code: 1000
    }

    questionnaire = %Game.Questionnaire{
      id: "id",
      name: "name",
      author: "author",
      questions: [
        %Game.Question{
          id: "q1",
          text: "quest 1"
        },
        %Game.Question{
          id: "q2",
          text: "quest 2"
        },
        %Game.Question{
          id: "q3",
          text: "quest 3"
        }
      ],
      options: [
        %Game.Option{
          id: "o1",
          text: "option 1"
        },
        %Game.Option{
          id: "o2",
          text: "option 2"
        },
        %Game.Option{
          id: "o3",
          text: "option 3"
        },
        %Game.Option{
          id: "o4",
          text: "option 4"
        },
        %Game.Option{
          id: "o6",
          text: "option 6"
        },
        %Game.Option{
          id: "o7",
          text: "option 7"
        }
      ]
    }

    {:ok, room: room, questionnaire: questionnaire}
  end

  test "should generate right round on start_game", state do
    room = Game.Room.start_game(state.room, state.questionnaire)

    assert length(room.questions) == 2
    assert room.round.number == 1
    assert room.round.current_stage == Game.Stages.prepare()
    assert room.round.leader == Enum.at(state.room.players, 0)
    assert room.round.winner == %Game.Answer{}
    assert room.round.answers == []
    assert room.status == Game.Status.play()
  end

  test "should end game if no question left", state do
    room = Game.Room.start_round(state.room)
    assert room.status == Game.Status.finished()
  end

  test "should add score to winner on round finish", state do
    leaderboard = %{
      "test" => 0
    }

    round =
      Map.put(state.room.round, :winner, %Game.Answer{
        question: %Game.Question{},
        options: [%Game.Option{}],
        player: %Game.User{
          id: "test",
          name: "test_name"
        }
      })

    room =
      state.room
      |> Map.put(:leaderboard, leaderboard)
      |> Map.put(:round, round)
      |> Game.Room.finish_round()

    assert room.leaderboard["test"] == 1
  end

  test "should change status to finished on finish_game", state do
    room = Game.Room.finish_game(state.room)
    assert room.status == Game.Status.finished()
  end

  test "should init all-zeros score table", state do
    room = Game.Room.init_leaderboard(state.room)

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
      |> Game.Room.add_score_to_winner(%Game.User{id: "test1", name: "test_name"})

    assert room.leaderboard["test1"] == 1
  end

  test "start_stage should correctly set stages", state do
    assert state.room.round.current_stage == Game.Stages.wait()

    room = Game.Room.start_stage(state.room)
    assert room.round.current_stage == Game.Stages.prepare()

    room = Game.Room.start_stage(room)
    assert room.round.current_stage == Game.Stages.play()

    room = Game.Room.start_stage(room)
    assert room.round.current_stage == Game.Stages.vote()

    room = Game.Room.start_stage(room)
    assert room.round.current_stage == Game.Stages.result()

    room = Game.Room.start_stage(room)
    assert room.round.current_stage == Game.Stages.prepare()
  end

  test "game process", state do

    # Init room
    room =
      %Game.Room{
        id: "test",
        host: %Game.User{id: "test1", name: "test1"}
      }
      |> Game.Room.add_player(%Game.User{id: "test1", name: "test1"})
      |> Game.Room.add_player(%Game.User{id: "test2", name: "test2"})
      |> Game.Room.add_player(%Game.User{id: "test3", name: "test3"})
      |> Game.Room.start_game(state.questionnaire)

    assert room.round.current_stage == Game.Stages.prepare()
    assert room.round.leader == Enum.at(room.players, 0)

    # Start play stage, add answers to question and finish stage
    room =
      room
      |> Game.Room.start_stage()
      |> Game.Room.add_answer(%Game.Answer{
        question: room.round.question,
        options: [Enum.at(state.questionnaire.options, 0)],
        player: Enum.at(room.players, 0)
      })
      |> Game.Room.add_answer(%Game.Answer{
        question: room.round.question,
        options: [Enum.at(state.questionnaire.options, 1)],
        player: Enum.at(room.players, 1)
      })
      |> Game.Room.add_answer(%Game.Answer{
        question: room.round.question,
        options: [Enum.at(state.questionnaire.options, 2)],
        player: Enum.at(room.players, 2)
      })
      |> Game.Room.finish_stage()

    assert length(room.round.answers) == 3
    assert room.round.current_stage == Game.Stages.play()

    # Start vote stage, set winner and finish stage
    room =
      room
      |> Game.Room.start_stage()
      |> Game.Room.set_winner(Enum.at(room.round.answers, 0).player.id)
      |> Game.Room.finish_stage()

    assert room.round.winner == Enum.at(room.round.answers, 0)
    assert room.round.current_stage == Game.Stages.vote()

    # Start result stage, finish stage, finish round
    # Check score table
    room =
      room
      |> Game.Room.start_stage()
      |> Game.Room.finish_stage()
      |> Game.Room.finish_round()

    assert room.leaderboard[Enum.at(room.round.answers, 0).player.id] == 1
    assert room.leaderboard[Enum.at(room.round.answers, 1).player.id] == 0
    assert room.leaderboard[Enum.at(room.round.answers, 2).player.id] == 0

    # Start round, check that round leader is player #2

    room =
      room
      |> Game.Room.start_round()

    assert room.round.leader == Enum.at(room.players, 1)
  end
end
