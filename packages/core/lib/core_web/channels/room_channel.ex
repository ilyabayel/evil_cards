defmodule CoreWeb.RoomChannel do
  use CoreWeb, :channel
  alias Game.Services.Session

  @impl Phoenix.Channel
  def join("room:" <> room_id, %{"userName" => user_name}, socket) do
    assign(socket, user_name: user_name)

    Session.join(
      room_id,
      %Game.User{
        id: socket.assigns.user_id,
        name: user_name
      }
    )

    room = Session.get(room_id)
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
    Session.leave(room_id, socket.assigns.user_id)

    broadcast!(socket, "room_update", Session.get(room_id))
    {:reply, :ok, socket}
  end

  @impl Phoenix.Channel
  def handle_in("start_game", _payload, socket) do
    "room:" <> room_id = socket.topic
    :ok = Session.start_game(room_id)
    room = Session.get(room_id)

    broadcast!(socket, "room_update", room)
    {:reply, :ok, socket}
  end

  def handle_in("finish_game", _payload, socket) do
    "room:" <> room_id = socket.topic
    Session.finish_game(room_id)
    room = Session.get(room_id)

    broadcast!(socket, "room_update", room)
    {:ok, socket}
  end

  def handle_in("start_round", _payload, socket) do
    "room:" <> room_id = socket.topic
    Session.start_round(room_id)
    room = Session.get(room_id)

    broadcast!(socket, "room_update", room)
    {:ok, socket}
  end

  @impl true
  def handle_in("finish_round", _payload, socket) do
    "room:" <> room_id = socket.topic
    Session.finish_round(room_id)
    room = Session.get(room_id)

    broadcast!(socket, "room_update", room)
    {:ok, socket}
  end

  def handle_in("start_stage", _payload, socket) do
    "room:" <> room_id = socket.topic
    Session.start_stage(room_id)
    room = Session.get(room_id)

    broadcast!(socket, "room_update", room)
    {:ok, socket}
  end

  def handle_in("finish_stage", _payload, socket) do
    "room:" <> room_id = socket.topic
    Session.finish_stage(room_id)
    room = Session.get(room_id)

    broadcast!(socket, "room_update", room)
    {:ok, socket}
  end

  def handle_in("add_answer", %{"id" => option_id, "text" => option_text}, socket) do
    "room:" <> room_id = socket.topic

    option = %Game.Option{
      id: option_id,
      text: option_text
    }

    player = %Game.User{
      id: socket.assigns.user_id,
      name: socket.assigns.user_name
    }

    Session.add_answer(room_id, option, player)
    room = Session.get(room_id)

    broadcast!(socket, "room_update", room)
    {:ok, socket}
  end

  def handle_in("remove_answer", _payload, socket) do
    "room:" <> room_id = socket.topic
    Session.remove_answer(room_id, socket.assigns.user_id)
    room = Session.get(room_id)

    broadcast!(socket, "room_update", room)
    {:ok, socket}
  end

  @impl true
  def handle_in("set_winner", %{"playerId" => player_id}, socket) do
    "room:" <> room_id = socket.topic
    Session.set_winner(room_id, player_id)
    room = Session.get(room_id)

    broadcast!(socket, "room_update", room)
    {:ok, socket}
  end
end
