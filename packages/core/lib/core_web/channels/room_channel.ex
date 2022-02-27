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
    with "room:" <> room_id <- socket.topic,
         %CoreWeb.Room{} = room <- CoreWeb.RoomsState.get(room_id) do
      room = CoreWeb.Room.finish_game(room)

      CoreWeb.RoomsState.put(room)

      broadcast!(socket, "room_update", room)

      {:ok, socket}
    else
      err -> {:error, %{reason: err}, socket}
    end
  end

  def handle_in("start_round", _payload, socket) do
    with "room:" <> room_id <- socket.topic,
         %CoreWeb.Room{} = room <- CoreWeb.RoomsState.get(room_id) do
      room = CoreWeb.Room.start_round(room)

      CoreWeb.RoomsState.put(room)

      broadcast!(socket, "room_update", room)
      {:reply, :ok, socket}
    else
      err -> {:error, %{reason: err}, socket}
    end
  end

  @impl true
  def handle_in("finish_round", _payload, socket) do
    with "room:" <> room_id <- socket.topic,
         %CoreWeb.Room{} = room <- CoreWeb.RoomsState.get(room_id) do
      room = CoreWeb.Room.finish_round(room)
      CoreWeb.RoomsState.put(room)
      broadcast!(socket, "room_update", room)
      {:reply, :ok, socket}
    else
      err -> {:error, %{reason: err}, socket}
    end
  end

  def handle_in("start_stage", _payload, socket) do
    with "room:" <> room_id <- socket.topic,
         %CoreWeb.Room{} = room <- CoreWeb.RoomsState.get(room_id) do
      room = CoreWeb.Room.start_stage(room)
      CoreWeb.RoomsState.put(room)
      broadcast!(socket, "room_update", room)
      {:reply, :ok, socket}
    else
      err -> {:error, %{reason: err}, socket}
    end
  end

  def handle_in("finish_stage", _payload, socket) do
    with "room:" <> room_id <- socket.topic,
         %CoreWeb.Room{} = room <- CoreWeb.RoomsState.get(room_id) do
      room = CoreWeb.Room.finish_stage(room)
      CoreWeb.RoomsState.put(room)
      broadcast!(socket, "room_update", room)
      {:reply, :ok, socket}
    else
      err -> {:error, %{reason: err}, socket}
    end
  end

  def handle_in("add_answer", %{"id" => option_id, "text" => option_text}, socket) do
    with "room:" <> room_id <- socket.topic,
         %CoreWeb.Room{} = room <- CoreWeb.RoomsState.get(room_id) do
      option = %CoreWeb.Option{
        id: option_id,
        text: option_text
      }

      player = %CoreWeb.User{
        id: socket.assigns.user_id,
        name: socket.assigns.user_name
      }

      answer = %CoreWeb.Answer{
        question: room.round.question,
        option: option,
        player: player
      }

      room = CoreWeb.Room.add_answer(room, answer)

      CoreWeb.RoomsState.put(room)

      broadcast!(socket, "room_update", room)

      {:reply, :ok, socket}
    else
      err -> {:error, %{reason: err}, socket}
    end
  end

  def handle_in("remove_answer", _payload, socket) do
    with "room:" <> room_id <- socket.topic,
         %CoreWeb.Room{} = room <- CoreWeb.RoomsState.get(room_id) do
      room = CoreWeb.Room.remove_answer(room, socket.assigns.user_id)

      CoreWeb.RoomsState.put(room)

      broadcast!(socket, "room_update", room)

      {:reply, :ok, socket}
    else
      err -> {:error, %{reason: err}, socket}
    end
  end

  @impl true
  def handle_in("set_winner", %{"playerId" => player_id}, socket) do
    with "room:" <> room_id <- socket.topic,
         %CoreWeb.Room{} = room <- CoreWeb.RoomsState.get(room_id) do
      room = CoreWeb.Room.set_winner(room, player_id)

      broadcast!(socket, "room_update", room)

      {:reply, {:ok, "ok"}, socket}
    else
      err -> {:error, %{reason: err}, socket}
    end
  end
end
