defmodule Game.Services.RoomCodes do
  @moduledoc """
  Service that allows to find roomId by room.code
  """
  use GenServer

  # Client
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def get_room_id_by_code(code) do
    GenServer.call(__MODULE__, {:get_room_id_by_code, code})
  end

  def put(code, roomId) do
    GenServer.cast(__MODULE__, {:put, code, roomId})
  end

  # Server
  @impl GenServer
  def init(_state) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:get_room_id_by_code, code}, _from, state) do
    room_id = Map.get(state, code, nil)

    {:reply, room_id, state}
  end

  @impl GenServer
  def handle_cast({:put, code, room_id}, state) do
    {:noreply, Map.put(state, code, room_id)}
  end
end
