defmodule CoreWeb.RoomChannel do
  use CoreWeb, :channel
  alias CoreWeb.GenServers.Room

  @impl Phoenix.Channel
  def join("room:" <> room_id, %{"userName" => user_name}, socket) do
    assign(socket, user_name: user_name)

    Room.join(
      room_id,
      %CoreWeb.User{
        id: socket.assigns.user_id,
        name: user_name
      }
    )

    room = Room.get(room_id)
    send(self(), {:after_join, room})
    {:ok, room, socket}
  end

  @impl Phoenix.Channel
  def handle_info({:after_join, room}, socket) do
    broadcast!(socket, "room_update", room)
    {:noreply, socket}
  end

  @impl Phoenix.Channel
  def handle_in("leave", _payload, socket) do
    "room:" <> room_id = socket.topic
    Room.leave(room_id, socket.assigns.user_id)

    broadcast!(socket, "room_update", Room.get(room_id))
    {:reply, :ok, socket}
  end

  @impl Phoenix.Channel
  def handle_in("start_game", _payload, socket) do
    "room:" <> room_id = socket.topic
    Room.start_game(room_id)
    room = Room.get(room_id)

    broadcast!(socket, "room_update", room)
    {:reply, :ok, socket}
  end

  def handle_in("finish_game", _payload, socket) do
    "room:" <> room_id = socket.topic
    Room.finish_game(room_id)
    room = Room.get(room_id)

    broadcast!(socket, "room_update", room)
    {:ok, socket}
  end

  def handle_in("start_round", _payload, socket) do
    "room:" <> room_id = socket.topic
    Room.start_round(room_id)
    room = Room.get(room_id)

    broadcast!(socket, "room_update", room)
    {:ok, socket}
  end

  @impl true
  def handle_in("finish_round", _payload, socket) do
    "room:" <> room_id = socket.topic
    Room.finish_round(room_id)
    room = Room.get(room_id)

    broadcast!(socket, "room_update", room)
    {:ok, socket}
  end

  def handle_in("start_stage", _payload, socket) do
    "room:" <> room_id = socket.topic
    Room.start_stage(room_id)
    room = Room.get(room_id)

    broadcast!(socket, "room_update", room)
    {:ok, socket}
  end

  def handle_in("finish_stage", _payload, socket) do
    "room:" <> room_id = socket.topic
    Room.finish_stage(room_id)
    room = Room.get(room_id)

    broadcast!(socket, "room_update", room)
    {:ok, socket}
  end

  def handle_in("add_answer", %{"id" => option_id, "text" => option_text}, socket) do
    "room:" <> room_id = socket.topic

    option = %CoreWeb.Option{
      id: option_id,
      text: option_text
    }

    player = %CoreWeb.User{
      id: socket.assigns.user_id,
      name: socket.assigns.user_name
    }

    Room.add_answer(room_id, option, player)
    room = Room.get(room_id)

    broadcast!(socket, "room_update", room)
    {:ok, socket}
  end

  def handle_in("remove_answer", _payload, socket) do
    "room:" <> room_id = socket.topic
    Room.remove_answer(room_id, socket.assigns.user_id)
    room = Room.get(room_id)

    broadcast!(socket, "room_update", room)
    {:ok, socket}
  end

  @impl true
  def handle_in("set_winner", %{"playerId" => player_id}, socket) do
    "room:" <> room_id = socket.topic
    Room.set_winner(room_id, player_id)
    room = Room.get(room_id)

    broadcast!(socket, "room_update", room)
    {:ok, socket}
  end
end
