defmodule Game.GenServers.Session do
  use GenServer
  alias Game.Room
  alias Game.SessionRegistry

  # Client
  def start_link(%Room{} = room) do
    GenServer.start_link(__MODULE__, room, name: SessionRegistry.via(room.id))
  end

  def get(room_id) do
    GenServer.call(SessionRegistry.via(room_id), :get)
  end

  def join(room_id, %Game.User{} = player) do
    GenServer.cast(SessionRegistry.via(room_id), {:join, player})
  end

  def leave(room_id, player_id) do
    GenServer.cast(SessionRegistry.via(room_id), {:leave, player_id})
  end

  def start_game(room_id) do
    GenServer.cast(SessionRegistry.via(room_id), :start_game)
  end

  def finish_game(room_id) do
    GenServer.cast(SessionRegistry.via(room_id), :finish_game)
  end

  def start_round(room_id) do
    GenServer.cast(SessionRegistry.via(room_id), :start_round)
  end

  def finish_round(room_id) do
    GenServer.cast(SessionRegistry.via(room_id), :finish_round)
  end

  def start_stage(room_id) do
    GenServer.cast(SessionRegistry.via(room_id), :start_stage)
  end

  def finish_stage(room_id) do
    GenServer.cast(SessionRegistry.via(room_id), :finish_stage)
  end

  def add_answer(room_id, option, player) do
    GenServer.cast(SessionRegistry.via(room_id), {:add_answer, option, player})
  end

  def remove_answer(room_id, player_id) do
    GenServer.cast(SessionRegistry.via(room_id), {:remove_answer, player_id})
  end

  def set_winner(room_id, player_id) do
    GenServer.cast(SessionRegistry.via(room_id), {:set_winner, player_id})
  end

  # Server

  @impl GenServer
  def init(%Room{} = state) do
    {:ok, state}
  end

  @impl GenServer
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  @impl GenServer
  def handle_cast({:join, player}, room) do
    {:noreply, Room.add_player(room, player)}
  end

  @impl GenServer
  def handle_cast({:leave, player_id}, room) do
    {:noreply, Room.remove_player(room, player_id)}
  end

  @impl GenServer
  def handle_cast(:start_game, room) do
    {:ok, questionnaire} = Game.Questionnaire.create_from_file("lib/core/questionnaire.json")
    room = Room.start_game(room, questionnaire)
    {:noreply, room}
  end

  @impl GenServer
  def handle_cast(:finish_game, room) do
    {:noreply, Room.finish_game(room)}
  end

  @impl GenServer
  def handle_cast(:start_round, room) do
    {:noreply, Room.start_round(room)}
  end

  @impl GenServer
  def handle_cast(:finish_round, room) do
    {:noreply, Room.finish_round(room)}
  end

  @impl GenServer
  def handle_cast(:start_stage, room) do
    {:noreply, Room.start_stage(room)}
  end

  @impl GenServer
  def handle_cast(:finish_stage, room) do
    {:noreply, Room.finish_stage(room)}
  end

  @impl GenServer
  def handle_cast({:add_answer, option, player}, room) do
    answer = %Game.Answer{
      question: room.round.question,
      option: option,
      player: player
    }
    {:noreply, Room.add_answer(room, answer)}
  end

  @impl GenServer
  def handle_cast({:remove_answer, player_id}, room) do
    {:noreply, Room.remove_answer(room, player_id)}
  end

  @impl GenServer
  def handle_cast({:set_winner, player_id}, room) do
    {:noreply, Room.set_winner(room, player_id)}
  end
end
