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
    "room:" <> room_id = socket.topic

    case CoreWeb.RoomsState.get(room_id) do
      nil ->
        {:reply, {:error, %{reason: "Room not found"}}, socket}

      %CoreWeb.Room{} = room ->
        {:reply, {:ok, handle_leave(room, socket.assigns.user_id)}, socket}
    end
  end

  def handle_in("start_game", _payload, socket) do
    # Start game
    # Round number 1
    # start_round
    # broadcast game info
    "room:" <> room_id = socket.topic

    case CoreWeb.RoomsState.get(room_id) do
      nil ->
        {:reply, {:error, %{reason: "Room not found"}}, socket}

      %CoreWeb.Room{} = room ->
        {:reply, handle_start_game(room, socket), socket}
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
  def handle_in("choose_winner", %{"playerId" => player_id}, socket) do
    "room:" <> room_id = socket.topic

    case CoreWeb.RoomsState.get(room_id) do
      nil ->
        {:reply, {:error, %{reason: "Room not found"}}, socket}

      %CoreWeb.Room{} = room ->
        choose_winner(room, player_id, socket)
    end
  end

  @impl true
  def handle_in("finish_round", _payload, socket) do
    "room:" <> room_id = socket.topic

    case CoreWeb.RoomsState.get(room_id) do
      nil ->
        {:reply, {:error, %{reason: "Room not found"}}, socket}

      %CoreWeb.Room{} = room ->
        finish_round(room, socket)
    end
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

  defp add_answer(room, %{"id" => option_id, "text" => option_text}, socket) do
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

    {:reply, {:ok, "ok"}, socket}
  end

  defp choose_winner(room, player_id, socket) do
    room = CoreWeb.Room.set_winner(room, player_id)

    broadcast!(socket, "room_update", room)

    case room.round.winner do
      nil -> {:reply, {:error, "Player not found"}, socket}
      %CoreWeb.Room{} -> {:reply, {:ok, "ok"}, socket}
    end
  end

  defp finish_round(room, socket) do
    # room = CoreWeb.Room.finish_round(room)

    broadcast!(socket, "room_update", room)

    case room.round.winner do
      nil -> {:reply, {:error, "Player not found"}, socket}
      %CoreWeb.Room{} -> {:reply, {:ok, "ok"}, socket}
    end
  end

  defp handle_start_game(room, socket) do
    {:ok, questionnaire} = CoreWeb.Questionnaire.create_from_file("lib/core/questionnaire.json")

    IO.inspect(questionnaire)

    room =
      room
      |> CoreWeb.Room.add_questions(questionnaire.questions)
      |> CoreWeb.Room.new_round()

    options = CoreWeb.Room.get_options_map(room, questionnaire.options)

    broadcast!(socket, "game_options", options)
    broadcast!(socket, "room_update", room)

    :ok
  end
end
