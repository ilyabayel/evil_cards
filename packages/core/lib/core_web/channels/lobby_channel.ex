defmodule CoreWeb.LobbyChannel do
  use CoreWeb, :channel

  @impl true
  def join("lobby:main", _payload, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_in("create_room", %{"host" => host}, socket) do
    host = CoreWeb.User.from_string_map(host)

    room = %CoreWeb.Room{
      id: UUID.uuid4(),
      host: host,
      players: [],
      round_duration: 60,
      current_stage: "wait",
      round: %CoreWeb.Round{},
      questionnaire_id: "id",
      code: CoreWeb.Counter.get()
    }

    CoreWeb.RoomsState.put(room)

    {:reply, {:ok, room.id}, socket}
  end

  def handle_in("get_room_by_code", %{"code" => code}, socket) do
    case CoreWeb.RoomsState.get_by_code(code) do
      nil -> {:reply, {:error, "Room not found"}, socket}
      room -> {:reply, {:ok, room.id}, socket}
    end
  end
end
