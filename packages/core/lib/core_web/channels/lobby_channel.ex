defmodule CoreWeb.LobbyChannel do
  use CoreWeb, :channel

  @impl true
  def join("lobby:main", _payload, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_in("create_room", %{"host" => host, "roomInfo" => roomInfo}, socket) do
    host = Game.User.from_string_map(host)

    room = %Game.Room{
      id: UUID.uuid4(),
      host: host,
      players: [],
      round_duration: roomInfo["round_duration"],
      rounds_per_player: roomInfo["rounds_per_player"],
      round: %Game.Round{},
      questions: [],
      code: Game.Services.Counter.generate()
    }

    _ = Game.SessionSupervisor.start_child(room)
    true = Game.Services.RoomCodes.insert(room.code, room.id)

    {:reply, {:ok, room.id}, socket}
  end

  def handle_in("get_room_by_code", %{"code" => code}, socket) do
    case Game.Services.RoomCodes.get_room_id_by_code(code) do
      nil -> {:reply, {:error, "Room not found"}, socket}
      room_id -> {:reply, {:ok, room_id}, socket}
    end
  end
end
