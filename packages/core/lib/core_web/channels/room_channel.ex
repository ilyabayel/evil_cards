defmodule CoreWeb.RoomChannel do
  use CoreWeb, :channel
  alias Game.Services.Session

  @impl Phoenix.Channel
  def join("room:" <> room_id, %{"userName" => user_name}, socket) do
    Session.join(
      room_id,
      %Game.User{
        id: socket.assigns.user_id,
        name: user_name
      }
    )

    room = Session.get(room_id)
    send(self(), {:after_join, room})
    {:ok, room, assign(socket, user_name: user_name)}
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
    {:noreply, socket}
  end

  @impl Phoenix.Channel
  def handle_in("start_game", _payload, socket) do
    "room:" <> room_id = socket.topic
    :ok = Session.start_game(room_id)
    room = Session.get(room_id)
    true = Game.Services.RoomCodes.delete(room.code)

    broadcast!(socket, "room_update", room)
    {:noreply, socket}
  end

  @impl Phoenix.Channel
  def handle_in("finish_game", _payload, socket) do
    "room:" <> room_id = socket.topic
    Session.finish_game(room_id)
    room = Session.get(room_id)

    broadcast!(socket, "room_update", room)
    {:noreply, socket}
  end

  @impl Phoenix.Channel
  def handle_in("start_round", _payload, socket) do
    "room:" <> room_id = socket.topic
    Session.start_round(room_id)
    room = Session.get(room_id)

    broadcast!(socket, "room_update", room)
    {:noreply, socket}
  end

  @impl Phoenix.Channel
  def handle_in("finish_round", _payload, socket) do
    "room:" <> room_id = socket.topic
    Session.finish_round(room_id)
    room = Session.get(room_id)

    broadcast!(socket, "room_update", room)
    {:noreply, socket}
  end

  @impl Phoenix.Channel
  def handle_in("start_stage", _payload, socket) do
    "room:" <> room_id = socket.topic
    Session.start_stage(room_id)
    room = Session.get(room_id)

    broadcast!(socket, "room_update", room)
    {:noreply, socket}
  end

  @impl Phoenix.Channel
  def handle_in("finish_stage", _payload, socket) do
    "room:" <> room_id = socket.topic
    Session.finish_stage(room_id)
    room = Session.get(room_id)

    broadcast!(socket, "room_update", room)
    {:noreply, socket}
  end

  @impl Phoenix.Channel
  def handle_in("add_answer", %{"options" => options}, socket) do
    "room:" <> room_id = socket.topic

    options =
      options
      |> Enum.map(fn option ->
        %Game.Option{
          id: option["id"],
          text: option["text"]
        }
      end)

    player = %Game.User{
      id: socket.assigns.user_id,
      name: socket.assigns.user_name
    }

    Session.add_answer(room_id, options, player)
    room = Session.get(room_id)

    broadcast!(socket, "room_update", room)
    {:noreply, socket}
  end

  @impl Phoenix.Channel
  def handle_in("remove_answer", _payload, socket) do
    "room:" <> room_id = socket.topic
    Session.remove_answer(room_id, socket.assigns.user_id)
    room = Session.get(room_id)

    broadcast!(socket, "room_update", room)
    {:noreply, socket}
  end

  @impl Phoenix.Channel
  def handle_in("set_winner", %{"playerId" => player_id}, socket) do
    "room:" <> room_id = socket.topic
    Session.set_winner(room_id, player_id)
    Session.finish_stage(room_id)
    Session.start_stage(room_id)
    room = Session.get(room_id)

    broadcast!(socket, "room_update", room)
    {:noreply, socket}
  end
end
