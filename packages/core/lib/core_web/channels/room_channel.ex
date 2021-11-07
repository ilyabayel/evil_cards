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
  def handle_in("leave", _payload, socket) do
    "room:" <> room_id = socket.topic

    case CoreWeb.RoomsState.get(room_id) do
      nil ->
        {:reply, {:error, %{reason: "Room not found"}}, socket}

      %CoreWeb.Room{} = room ->
        {:reply, {:ok, handle_leave(room, socket.assigns.user_id)}, socket}
    end
  end

  def handle_in("start_game", _payload, socket) do
    with "room:" <> room_id <- socket.topic,
         %CoreWeb.Room{} = room <- CoreWeb.RoomsState.get(room_id),
         {:ok, questionnaire} <-
           CoreWeb.Questionnaire.create_from_file("lib/core/questionnaire.json") do
      options_map = CoreWeb.QuestionnaireHelper.get_options_map(Enum.shuffle(questionnaire.options), room.players, room.rounds_per_player)

      room = CoreWeb.Room.start_game(room, questionnaire)

      broadcast!(socket, "game_options", options_map)
      broadcast!(socket, "room_update", room)

      {:noreply, socket}
    else
      err -> {:reply, {:error, %{reason: err}}, socket}
    end
  end

  def handle_in("next_stage", _payload, socket) do
    with "room:" <> room_id <- socket.topic,
         %CoreWeb.Room{} = room <- CoreWeb.RoomsState.get(room_id) do
      round = Map.put(room.round, :current_stage, CoreWeb.Stages.get_next_stage(room.round.current_stage))
      room = Map.put(room, :round, round)
      broadcast!(socket, "room_update", room)
      {:noreply, socket}
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
    with "room:" <> room_id <- socket.topic,
         %CoreWeb.Room{} = room <- CoreWeb.RoomsState.get(room_id) do
      room = CoreWeb.Room.set_winner(room, player_id)

      broadcast!(socket, "room_update", room)

      {:reply, {:ok, "ok"}, socket}
    else
      err -> {:reply, {:error, %{reason: err}}, socket}
    end
  end

  @impl true
  def handle_in("finish_round", _payload, socket) do
    "room:" <> room_id = socket.topic

    case CoreWeb.RoomsState.get(room_id) do
      nil ->
        {:reply, {:error, %{reason: "Room not found"}}, socket}

      %CoreWeb.Room{} = room ->
        room = CoreWeb.Room.finish_round(room)
        broadcast!(socket, "room_update", room)
        {:reply, :ok, socket}
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
end
