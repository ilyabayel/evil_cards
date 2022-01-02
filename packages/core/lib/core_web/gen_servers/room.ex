defmodule CoreWeb.RoomsState do
  use GenServer

  # Client

  def start_server() do
    GenServer.start_link(CoreWeb.RoomsState, %{}, name: {:global, :Rooms})
  end

  def get_all() do
    GenServer.call({:global, :Rooms}, :get_all)
  end

  def get(room_id) do
    GenServer.call({:global, :Rooms}, {:get, String.to_atom(room_id)})
  end

  def get_by_code(code) do
    GenServer.call({:global, :Rooms}, {:get_by_code, code})
  end

  def put(%CoreWeb.Room{} = room) do
    GenServer.cast({:global, :Rooms}, {:put, room})
  end

  # Server

  @impl true
  def init(_state) do
    {:ok, %{}}
  end

  @impl true
  def handle_call(:get_all, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:get, room_id}, _from, state) do
    {:reply, state[room_id], state}
  end

  @impl true
  def handle_call({:get_by_code, code}, _from, state) do
    {_id, room} =
      state
      |> Map.to_list()
      |> Enum.find({nil, nil}, fn {_id, r} -> r.code == code end)

    {:reply, room, state}
  end

  @impl true
  def handle_cast({:put, %CoreWeb.Room{} = room}, state) do
    {:noreply, Map.put(state, String.to_atom(room.id), room)}
  end
end
