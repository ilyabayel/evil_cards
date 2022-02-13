defmodule CoreWeb.LobbyChannelTest do
  use CoreWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      CoreWeb.UserSocket
      |> socket("user_id", %{user_id: "test"})
      |> subscribe_and_join(CoreWeb.LobbyChannel, "lobby:main")

    %{socket: socket}
  end

  test "should create room", %{socket: socket} do
    host = %{"id" => "1234", "name" =>  "test"}
    roomInfo = %{"round_duration" => 60, "round_per_player" => 3}
    ref = push(socket, "create_room", %{"host" => host, "roomInfo" => roomInfo})
    assert_reply(ref, :ok, "" <> _message)
  end

  test "should create room and get room by code", %{socket: socket} do
    host = %{"id" => "1234", "name" =>  "test"}
    roomInfo = %{"round_duration" => 60, "round_per_player" => 3}
    push(socket, "create_room", %{"host" => host, "roomInfo" => roomInfo})

    receive do
      %Phoenix.Socket.Reply{status: :ok} = reply ->
        {:ok, room, _} =
          socket
          |> subscribe_and_join(CoreWeb.RoomChannel, "room:" <> reply.payload, %{"userName" => "Test"})

        socket
        |> push("get_room_by_code", %{"code" => room.code})

        receive do
          reply ->
            assert reply.payload.code == room.code
            _ -> assert false
          end
      _ -> assert false
      after
        1_000 -> assert false
    end
  end
end
