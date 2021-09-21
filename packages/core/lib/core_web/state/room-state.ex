defmodule CoreWeb.RoomsState do
  use GenServer

  # Client

  def start_link(_default) do
    GenServer.start_link({:global, "Rooms"}, %{})
  end

  def get_all() do
    GenServer.call({:global, "Rooms"}, :get_all)
  end

  def get(element) do
    GenServer.call({:global, "Rooms"}, {:get, String.to_atom(element)})
  end

  def put(%CoreWeb.Room{} = room) do
    GenServer.cast({:global, "Rooms"}, {:put, room})
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
  def handle_call({:get, element}, _from, state) do
    {:reply, state[element], state}
  end

  @impl true
  def handle_cast({:put, %CoreWeb.Room{} = room}, state) do
    {:noreply, Map.put(state, String.to_atom(room.id), room)}
  end
end
