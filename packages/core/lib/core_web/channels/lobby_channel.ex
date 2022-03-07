defmodule CoreWeb.LobbyChannel do
  use CoreWeb, :channel

  @impl true
  def join("lobby:main", _payload, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_in("create_room", %{"host" => host, "roomInfo" => roomInfo}, socket) do
    host = CoreWeb.User.from_string_map(host)

    room = %CoreWeb.Room{
      id: UUID.uuid4(),
      host: host,
      players: [],
      round_duration: roomInfo["round_duration"],
      rounds_per_player: roomInfo["rounds_per_player"],
      round: %CoreWeb.Round{},
      questions: [],
      code: CoreWeb.Counter.get()
    }

    _ = CoreWeb.RoomSupervisor.start_child(room)
    _ = CoreWeb.GenServers.Codes.put(CoreWeb.Counter.get(), room.id)

    {:reply, {:ok, room.id}, socket}
  end

  def handle_in("get_room_by_code", %{"code" => code}, socket) do
    case CoreWeb.GenServers.Codes.get_room_id_by_code(code) do
      nil -> {:reply, {:error, "Room not found"}, socket}
      room -> {:reply, {:ok, room.id}, socket}
    end
  end
end
