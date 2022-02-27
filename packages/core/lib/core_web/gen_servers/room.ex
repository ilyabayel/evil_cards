defmodule CoreWeb.GenServers.Room do
  use GenServer
  alias CoreWeb.Room

  # Client
  def start_link(room_id) do
    GenServer.start_link(__MODULE__, %CoreWeb.Room{id: room_id}, name: via(room_id))
  end

  def get(room_id) do
    GenServer.call(via(room_id), :get)
  end

  def join(room_id, %CoreWeb.User{} = player) do
    GenServer.cast(via(room_id), {:join, player})
  end

  def leave(room_id, player_id) do
    GenServer.cast(via(room_id), {:leave, player_id})
  end

  def start_game(room_id) do
    GenServer.cast(via(room_id), :start_game)
  end

  # Server

  @impl GenServer
  def init(_state) do
    {:ok, %{}}
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
    {:ok, questionnaire} = CoreWeb.Questionnaire.create_from_file("lib/core/questionnaire.json")
    room = CoreWeb.Room.start_game(room, questionnaire)
    {:noreply, room}
  end

  # Private
  defp via(room_id) when is_binary(room_id) do
    {:via, Registry, {:game_registry, room_id}}
  end
end
