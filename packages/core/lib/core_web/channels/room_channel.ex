defmodule CoreWeb.RoomChannel do
  use CoreWeb, :channel

  @impl true
  def join("room:" <> room_id, _payload, socket) do
    with %CoreWeb.Room{} = room <- CoreWeb.RoomsState.get(room_id) do
      player = %CoreWeb.User{
        id: socket.assigns.user_id,
        name: socket.assigns.user_name
      }

      room = CoreWeb.Room.add_player(room, player)
      CoreWeb.RoomsState.put(room)
      {:ok, room, socket}
    else
      err -> {:error, %{reason: err}, socket}
    end
  end

  @impl true
  def handle_in("leave", _payload, socket) do
    with "room:" <> room_id <- socket.topic,
         %CoreWeb.Room{} = room <- CoreWeb.RoomsState.get(room_id) do
      room = CoreWeb.Room.remove_player(room, socket.assigns.user_id)
      CoreWeb.RoomsState.put(room)

      broadcast!(socket, "room_update", room)

      {:reply, :ok, socket}
    else
      err -> {:error, %{reason: err}, socket}
    end
  end

  def handle_in("start_game", _payload, socket) do
    with "room:" <> room_id <- socket.topic,
         %CoreWeb.Room{} = room <- CoreWeb.RoomsState.get(room_id),
         {:ok, questionnaire} <-
           CoreWeb.Questionnaire.create_from_file("lib/core/questionnaire.json") do
      options_map =
        CoreWeb.QuestionnaireHelper.get_options_map(
          Enum.shuffle(questionnaire.options),
          room.players,
          room.rounds_per_player
        )

      room = CoreWeb.Room.start_game(room, questionnaire)

      broadcast!(socket, "options_map", options_map)
      broadcast!(socket, "room_update", room)

      {:ok, socket}
    else
      err -> {:error, %{reason: err}, socket}
    end
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
