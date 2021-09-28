defmodule CoreWeb.RoomChannel do
  use CoreWeb, :channel

  @impl true
  def join("room:" <> room_id, _payload, socket) do
    player = %CoreWeb.User{
      id: socket.assigns.user_id,
      name: socket.assigns.user_name
    }

    case CoreWeb.RoomsState.get(room_id) do
      nil ->
        {:error, %{reason: "Room not found"}}

      %CoreWeb.Room{} = room ->
        {:ok, handle_join(room, player), socket}
    end
  end

  @impl true
  def handle_in("leave", payload, socket) do
    IO.puts("====================")
    IO.inspect(payload)
    IO.inspect(socket)

    "room:" <> room_id = socket.topic

    case CoreWeb.RoomsState.get(room_id) do
      nil ->
        {:reply, {:error, %{reason: "Room not found"}}, socket}

      %CoreWeb.Room{} = room ->
        {:reply, {:ok, handle_leave(room, socket.assigns.user_id)}, socket}
    end
  end

  @impl true
  def handle_in("answer", payload, socket) do
    "room:" <> room_id = socket.topic

    case CoreWeb.RoomsState.get(room_id) do
      nil ->
        {:reply, {:error, %{reason: "Room not found"}}, socket}

      %CoreWeb.Room{} = room ->
        add_answer(room, payload, socket)
    end
  end

  @impl true
  def handle_in("choose_winner", payload, socket) do
    # Add answer logic
    {:reply, {:ok, %{}}, socket}
  end

  @impl true
  def handle_in("finish_round", payload, socket) do
    # Add answer logic
    {:reply, {:ok, %{}}, socket}
  end

  defp handle_join(room, player) do
    room = CoreWeb.Room.add_player(room, player)

    CoreWeb.RoomsState.put(room)

    room
  end

  defp handle_leave(room, player_id) do
    room = CoreWeb.Room.remove_player(room, player_id)

    CoreWeb.RoomsState.put(room)

    room
  end

  defp add_answer(room, %{"question" => question, "option" => option}, socket) do
    %{"id" => question_id, "text" => question_text} = question
    %{"id" => option_id, "text" => option_text} = option

    question = %CoreWeb.Question{
      id: question_id,
      text: question_text
    }

    option = %CoreWeb.Option{
      id: option_id,
      text: option_text
    }

    player = %CoreWeb.User{
      id: socket.assigns.user_id,
      name: socket.assigns.user_name
    }

    answer = %CoreWeb.Answer{
      question: question,
      option: option,
      player: player
    }

    room = CoreWeb.Room.add_answer(room, answer)

    CoreWeb.RoomsState.put(room)

    broadcast!(socket, "room_update", room)

    {:reply, {:ok, "ok"}, socket}
  end
end
