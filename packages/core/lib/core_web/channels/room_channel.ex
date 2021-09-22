defmodule CoreWeb.RoomChannel do
  use CoreWeb, :channel

  @impl true
  def join("room:lobby", _payload, socket) do
    {:ok, "Joined lobby", socket}
  end

  @impl true
  def join("room:" <> room_id, payload, socket) do
    %{"player" => player} = payload

    case CoreWeb.RoomsState.get(room_id) do
      nil ->
        {:error, %{reason: "Room not found"}}

      %CoreWeb.Room{} = room ->
        {:ok, handle_join(room, player), socket}
    end
  end

  defp handle_join(room, player) do
    room = CoreWeb.Room.add_player(room, player)

    CoreWeb.RoomsState.put(room)

    room
  end

  @impl true
  def handle_in("create", %{"host" => host}, socket) do
    host = struct(CoreWeb.User, host)

    room = %CoreWeb.Room{
      id: UUID.uuid4(),
      host: host,
      players: [],
      round_duration: 60,
      current_stage: "wait",
      round: %CoreWeb.Round{},
      questionnaire_id: "id"
    }

    CoreWeb.RoomsState.put(room)

    {:reply, {:ok, room}, socket}
  end

  @impl true
  def handle_in("get_rooms", _payload, socket) do
    {:reply, {:ok, CoreWeb.RoomsState.get_all()}, socket}
  end
end
